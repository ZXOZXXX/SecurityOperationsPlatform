package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AlertDAO {

    public boolean createAlert(Alert alert) {

        String sql = """
                INSERT INTO alerts
                (title, description, severity, source_ip, status)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, alert.getTitle());
            statement.setString(2, alert.getDescription());
            statement.setString(3, alert.getSeverity());
            statement.setString(4, alert.getSourceIp());
            statement.setString(5, alert.getStatus());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public boolean hasOpenBruteForceAlert(String sourceIp) {

        String sql = """
                SELECT COUNT(*)
                FROM alerts
                WHERE title = 'Possible Brute Force Attack'
                AND source_ip = ?
                AND status = 'OPEN'
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, sourceIp);

            ResultSet result = statement.executeQuery();

            if (result.next()) {
                return result.getInt(1) > 0;
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }

    public Alert findById(int alertId) {

        String sql = """
                SELECT *
                FROM alerts
                WHERE id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, alertId);

            ResultSet result = statement.executeQuery();

            if (result.next()) {

                Alert alert = new Alert();

                alert.setId(result.getInt("id"));
                alert.setTitle(result.getString("title"));
                alert.setDescription(result.getString("description"));
                alert.setSeverity(result.getString("severity"));
                alert.setSourceIp(result.getString("source_ip"));
                alert.setStatus(result.getString("status"));

                return alert;
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }

    public List<Alert> getAllAlerts() {

        List<Alert> alerts = new ArrayList<>();

        String sql = """
                SELECT *
                FROM alerts
                ORDER BY id DESC
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {

                Alert alert = new Alert();

                alert.setId(result.getInt("id"));
                alert.setTitle(result.getString("title"));
                alert.setDescription(result.getString("description"));
                alert.setSeverity(result.getString("severity"));
                alert.setSourceIp(result.getString("source_ip"));
                alert.setStatus(result.getString("status"));

                alerts.add(alert);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return alerts;
    }

    public boolean updateStatus(int alertId, String status) {

        String sql = """
                UPDATE alerts
                SET status = ?
                WHERE id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, status);
            statement.setInt(2, alertId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }
    public boolean hasOpenIOCAlert(String sourceIp) {

    String sql = """
            SELECT COUNT(*)
            FROM alerts
            WHERE title = 'Known IOC Detected'
            AND source_ip = ?
            AND status = 'OPEN'
            """;

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setString(1, sourceIp);

        ResultSet result = statement.executeQuery();

        if (result.next()) {
            return result.getInt(1) > 0;
        }

    } catch (SQLException e) {

        e.printStackTrace();
    }

    return false;
}
    public boolean hasOpenDifferentIpAlert(
        String username,
        String sourceIp) {

    String sql = """
            SELECT COUNT(*)
            FROM alerts
            WHERE title = 'Suspicious Login IP Change'
            AND source_ip = ?
            AND status = 'OPEN'
            AND description LIKE ?
            """;

    try (Connection connection =
                 DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setString(1, sourceIp);

        statement.setString(
                2,
                "User " + username + " logged in%"
        );

        ResultSet result =
                statement.executeQuery();

        if (result.next()) {

            return result.getInt(1) > 0;
        }

    } catch (SQLException e) {

        e.printStackTrace();
    }

    return false;
}
}