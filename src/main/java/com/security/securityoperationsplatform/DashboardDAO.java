package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DashboardDAO {

    public int getTotalAlerts() {

        String sql = "SELECT COUNT(*) FROM alerts";

        return getCount(sql);
    }

    public int getOpenAlerts() {

        String sql = """
                SELECT COUNT(*)
                FROM alerts
                WHERE status = 'OPEN'
                """;

        return getCount(sql);
    }

    public int getTotalIncidents() {

        String sql = "SELECT COUNT(*) FROM incidents";

        return getCount(sql);
    }

    public int getOpenIncidents() {

        String sql = """
                SELECT COUNT(*)
                FROM incidents
                WHERE status = 'OPEN'
                """;

        return getCount(sql);
    }

    public int getHighCriticalAlerts() {

        String sql = """
                SELECT COUNT(*)
                FROM alerts
                WHERE severity IN ('HIGH', 'CRITICAL')
                """;

        return getCount(sql);
    }

    private int getCount(String sql) {

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result =
                     statement.executeQuery()) {

            if (result.next()) {
                return result.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}