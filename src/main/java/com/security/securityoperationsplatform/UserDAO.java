
package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public boolean createUser(User user) {

        String sql = """
                INSERT INTO users
                (username, email, password, role, enabled)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, user.getUsername());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword());
            statement.setString(4, user.getRole());
            statement.setBoolean(5, user.isEnabled());

            int rows = statement.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            throw new RuntimeException(
                    "Database error: " + e.getMessage(), e
            );
        }
    }

    public User findByUsername(String username) {

        String sql = "SELECT * FROM users WHERE username = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, username);

            ResultSet result = statement.executeQuery();

            if (result.next()) {

                User user = new User();

                user.setId(result.getInt("id"));
                user.setUsername(result.getString("username"));
                user.setEmail(result.getString("email"));
                user.setPassword(result.getString("password"));
                user.setRole(result.getString("role"));
                user.setEnabled(result.getBoolean("enabled"));

                user.setFailedAttempts(
                        result.getInt("failed_attempts")
                );

                user.setLocked(
                        result.getBoolean("locked")
                );

                return user;
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }

    public boolean incrementFailedAttempts(int userId) {

        String sql = """
                UPDATE users
                SET failed_attempts = failed_attempts + 1
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

    public boolean resetFailedAttempts(int userId) {

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
    public boolean updatePassword(int userId, String hashedPassword) {

    String sql = """
            UPDATE users
            SET password = ?
            WHERE id = ?
            """;

    try (Connection connection =
                 DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setString(1, hashedPassword);
        statement.setInt(2, userId);

        return statement.executeUpdate() > 0;

    } catch (SQLException e) {

        e.printStackTrace();
        return false;
    }
}
}
