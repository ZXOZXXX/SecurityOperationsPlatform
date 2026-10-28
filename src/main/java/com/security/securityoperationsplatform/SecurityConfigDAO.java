package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SecurityConfigDAO {

    public String getConfigValue(String configKey) {

        String sql = """
                SELECT config_value
                FROM security_config
                WHERE config_key = ?
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, configKey);

            try (ResultSet result =
                         statement.executeQuery()) {

                if (result.next()) {
                    return result.getString("config_value");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateConfig(
            String configKey,
            String configValue,
            String updatedBy) {

        String sql = """
                UPDATE security_config
                SET config_value = ?,
                    updated_by = ?
                WHERE config_key = ?
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, configValue);
            statement.setString(2, updatedBy);
            statement.setString(3, configKey);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}