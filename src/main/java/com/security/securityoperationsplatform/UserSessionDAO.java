
package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserSessionDAO {

    public boolean createSession(
            String sessionId,
            int userId,
            String username,
            String role,
            String sourceIp) {

        String sql = """
                INSERT INTO user_sessions
                (session_id, user_id, username, role, source_ip, status)
                VALUES (?, ?, ?, ?, ?, 'ACTIVE')
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, sessionId);
            statement.setInt(2, userId);
            statement.setString(3, username);
            statement.setString(4, role);
            statement.setString(5, sourceIp);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public boolean endSession(String sessionId) {

        String sql = """
                UPDATE user_sessions
                SET logout_time = CURRENT_TIMESTAMP,
                    status = 'ENDED'
                WHERE session_id = ?
                AND status = 'ACTIVE'
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, sessionId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public boolean expireSession(String sessionId) {

        String sql = """
                UPDATE user_sessions
                SET logout_time = CURRENT_TIMESTAMP,
                    status = 'EXPIRED'
                WHERE session_id = ?
                AND status = 'ACTIVE'
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, sessionId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public List<UserSession> getAllSessions() {

        List<UserSession> sessions =
                new ArrayList<>();

        String sql = """
                SELECT *
                FROM user_sessions
                ORDER BY login_time DESC
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result =
                     statement.executeQuery()) {

            while (result.next()) {

                UserSession session =
                        new UserSession();

                session.setId(
                        result.getInt("id")
                );

                session.setSessionId(
                        result.getString("session_id")
                );

                session.setUserId(
                        result.getInt("user_id")
                );

                session.setUsername(
                        result.getString("username")
                );

                session.setRole(
                        result.getString("role")
                );

                session.setSourceIp(
                        result.getString("source_ip")
                );

                session.setLoginTime(
                        result.getString("login_time")
                );

                session.setLogoutTime(
                        result.getString("logout_time")
                );

                session.setStatus(
                        result.getString("status")
                );

                sessions.add(session);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return sessions;
    }
    public String getPreviousIp(
        int userId,
        String currentSessionId) {

    String sql = """
            SELECT source_ip
            FROM user_sessions
            WHERE user_id = ?
            AND session_id <> ?
            ORDER BY login_time DESC
            LIMIT 1
            """;

    try (Connection connection =
                 DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setInt(1, userId);
        statement.setString(2, currentSessionId);

        try (ResultSet result =
                     statement.executeQuery()) {

            if (result.next()) {

                return result.getString("source_ip");
            }
        }

    } catch (SQLException e) {

        e.printStackTrace();
    }

    return null;
}
}
