package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class SystemMaintenanceDAO {

    public boolean clearTestSecurityData() {

        String[] sqlStatements = {
            "DELETE FROM incidents",
            "DELETE FROM alerts",
            "DELETE FROM security_events",
            "DELETE FROM audit_logs"
        };

        try (Connection connection =
                     DBConnection.getConnection();
             Statement statement =
                     connection.createStatement()) {

            /*
             * Disable foreign key checks temporarily
             * so related test records can be cleared safely.
             */

            statement.execute("SET FOREIGN_KEY_CHECKS = 0");

            for (String sql : sqlStatements) {
                statement.executeUpdate(sql);
            }

            /*
             * Enable foreign key checks again.
             */

            statement.execute("SET FOREIGN_KEY_CHECKS = 1");

            return true;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }
    public boolean clearSessionHistory() {

    String sql = "DELETE FROM user_sessions";

    try (Connection connection =
                 DBConnection.getConnection();
         Statement statement =
                 connection.createStatement()) {

        statement.executeUpdate(sql);

        return true;

    } catch (SQLException e) {

        e.printStackTrace();
        return false;
    }
}
}