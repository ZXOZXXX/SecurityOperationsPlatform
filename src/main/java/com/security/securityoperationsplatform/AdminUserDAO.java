package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdminUserDAO {

    public List<User> getAllUsers() {

        List<User> users = new ArrayList<>();

        String sql = """
                SELECT id, username, email, role, enabled,
                       failed_attempts, locked
                FROM users
                ORDER BY id DESC
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result =
                     statement.executeQuery()) {

            while (result.next()) {

                User user = new User();

                user.setId(
                        result.getInt("id")
                );

                user.setUsername(
                        result.getString("username")
                );

                user.setEmail(
                        result.getString("email")
                );

                user.setRole(
                        result.getString("role")
                );

                user.setEnabled(
                        result.getBoolean("enabled")
                );

                user.setFailedAttempts(
                        result.getInt("failed_attempts")
                );

                user.setLocked(
                        result.getBoolean("locked")
                );

                users.add(user);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return users;
    }

    public boolean updateRole(int userId, String role) {

        String sql = """
                UPDATE users
                SET role = ?
                WHERE id = ?
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, role);
            statement.setInt(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(int userId, boolean enabled) {

        String sql = """
                UPDATE users
                SET enabled = ?
                WHERE id = ?
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setBoolean(1, enabled);
            statement.setInt(2, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public boolean unlockUser(int userId) {

        String sql = """
                UPDATE users
                SET failed_attempts = 0,
                    locked = FALSE
                WHERE id = ?
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }
    public boolean lockUser(int userId) {

    String sql = """
            UPDATE users
            SET locked = TRUE
            WHERE id = ?
            """;

    try (Connection connection =
                 DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setInt(1, userId);

        return statement.executeUpdate() > 0;

    } catch (SQLException e) {

        e.printStackTrace();
        return false;
    }
}
}