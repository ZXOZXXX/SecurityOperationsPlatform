package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AuditLogDAO {

    private SecurityConfigDAO securityConfigDAO;

    public AuditLogDAO() {

        securityConfigDAO =
                new SecurityConfigDAO();
    }

    public boolean createLog(AuditLog log) {

        String auditEnabled =
                securityConfigDAO.getConfigValue(
                        "AUDIT_LOGGING_ENABLED"
                );

        if (auditEnabled != null
                && !Boolean.parseBoolean(auditEnabled)) {

            return false;
        }

        String sql = """
                INSERT INTO audit_logs
                (username, action, description, source_ip)
                VALUES (?, ?, ?, ?)
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(
                    1,
                    log.getUsername()
            );

            statement.setString(
                    2,
                    log.getAction()
            );

            statement.setString(
                    3,
                    log.getDescription()
            );

            statement.setString(
                    4,
                    log.getSourceIp()
            );

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public List<AuditLog> getAllLogs() {

        List<AuditLog> logs =
                new ArrayList<>();

        String sql = """
                SELECT *
                FROM audit_logs
                ORDER BY id DESC
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result =
                     statement.executeQuery()) {

            while (result.next()) {

                AuditLog log =
                        new AuditLog();

                log.setId(
                        result.getInt("id")
                );

                log.setUsername(
                        result.getString("username")
                );

                log.setAction(
                        result.getString("action")
                );

                log.setDescription(
                        result.getString("description")
                );

                log.setSourceIp(
                        result.getString("source_ip")
                );

                log.setCreatedAt(
                        result.getString("created_at")
                );

                logs.add(log);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return logs;
    }
}