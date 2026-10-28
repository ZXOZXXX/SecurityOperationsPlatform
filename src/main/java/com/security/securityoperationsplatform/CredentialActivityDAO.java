package com.security.securityoperationsplatform;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CredentialActivityDAO {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // =========================================================
    // ADD ACTIVITY LOG
    // =========================================================

    public boolean addActivity(int credentialId,
                               int userId,
                               String username,
                               String action,
                               String description,
                               String sourceIp,
                               String status) {

        String sql = "INSERT INTO credential_activity_logs "
                + "(credential_id, user_id, username, action, description, source_ip, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, credentialId);
            ps.setInt(2, userId);
            ps.setString(3, username);
            ps.setString(4, action);
            ps.setString(5, description);
            ps.setString(6, sourceIp);
            ps.setString(7, status);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // GET ACTIVITY FOR A USER
    // =========================================================

    public List<CredentialActivity> getActivitiesByUserId(
            int userId) {

        List<CredentialActivity> activities =
                new ArrayList<>();

        String sql = "SELECT * FROM credential_activity_logs "
                + "WHERE user_id = ? "
                + "ORDER BY created_at DESC";

        try (Connection con = getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    CredentialActivity activity =
                            new CredentialActivity();

                    activity.setId(
                            rs.getInt("id")
                    );

                    activity.setCredentialId(
                            rs.getInt("credential_id")
                    );

                    activity.setUserId(
                            rs.getInt("user_id")
                    );

                    activity.setUsername(
                            rs.getString("username")
                    );

                    activity.setAction(
                            rs.getString("action")
                    );

                    activity.setDescription(
                            rs.getString("description")
                    );

                    activity.setSourceIp(
                            rs.getString("source_ip")
                    );

                    activity.setStatus(
                            rs.getString("status")
                    );

                    activity.setCreatedAt(
                            rs.getString("created_at")
                    );

                    activities.add(activity);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return activities;
    }

    // =========================================================
    // GET ALL CREDENTIAL ACTIVITY
    // FOR ANALYST / ADMIN MONITORING
    // =========================================================

    public List<CredentialActivity> getAllActivities() {

        List<CredentialActivity> activities =
                new ArrayList<>();

        String sql = "SELECT * "
                + "FROM credential_activity_logs "
                + "ORDER BY created_at DESC";

        try (Connection con = getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                CredentialActivity activity =
                        new CredentialActivity();

                activity.setId(
                        rs.getInt("id")
                );

                activity.setCredentialId(
                        rs.getInt("credential_id")
                );

                activity.setUserId(
                        rs.getInt("user_id")
                );

                activity.setUsername(
                        rs.getString("username")
                );

                activity.setAction(
                        rs.getString("action")
                );

                activity.setDescription(
                        rs.getString("description")
                );

                activity.setSourceIp(
                        rs.getString("source_ip")
                );

                activity.setStatus(
                        rs.getString("status")
                );

                activity.setCreatedAt(
                        rs.getString("created_at")
                );

                activities.add(activity);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return activities;
    }
}