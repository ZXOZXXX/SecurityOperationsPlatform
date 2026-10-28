package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SecurityEventDAO {

    public boolean createEvent(SecurityEvent event) {

        String sql = """
                INSERT INTO security_events
                (event_type, username, source_ip, description)
                VALUES (?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, event.getEventType());
            statement.setString(2, event.getUsername());
            statement.setString(3, event.getSourceIp());
            statement.setString(4, event.getDescription());

            int rows = statement.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }

    public int countRecentFailedLogins(
            String sourceIp,
            int timeWindowMinutes) {

        String sql = """
                SELECT COUNT(*)
                FROM security_events
                WHERE event_type = 'LOGIN_FAILURE'
                AND source_ip = ?
                AND event_time >= NOW() - INTERVAL ? MINUTE
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, sourceIp);
            statement.setInt(2, timeWindowMinutes);

            try (ResultSet result =
                         statement.executeQuery()) {

                if (result.next()) {
                    return result.getInt(1);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }

    public List<SecurityEvent> getAllEvents() {

        List<SecurityEvent> events =
                new ArrayList<>();

        String sql = """
                SELECT *
                FROM security_events
                ORDER BY id DESC
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result =
                     statement.executeQuery()) {

            while (result.next()) {

                SecurityEvent event =
                        new SecurityEvent();

                event.setId(
                        result.getInt("id")
                );

                event.setEventType(
                        result.getString("event_type")
                );

                event.setUsername(
                        result.getString("username")
                );

                event.setSourceIp(
                        result.getString("source_ip")
                );

                event.setEventTime(
                        result.getString("event_time")
                );

                event.setDescription(
                        result.getString("description")
                );

                events.add(event);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return events;
    }
}