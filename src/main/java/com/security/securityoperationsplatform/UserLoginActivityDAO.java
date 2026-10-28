package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserLoginActivityDAO {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // Add a login activity record
    public boolean addActivity(int userId,
                               String username,
                               String action,
                               String description,
                               String sourceIp) {

        String sql = "INSERT INTO user_login_activity "
                + "(user_id, username, action, description, source_ip) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, username);
            ps.setString(3, action);
            ps.setString(4, description);
            ps.setString(5, sourceIp);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get only the logged-in user's activities
    public List<UserLoginActivity> getActivitiesByUserId(int userId) {

        List<UserLoginActivity> activities = new ArrayList<>();

        String sql = "SELECT * FROM user_login_activity "
                + "WHERE user_id = ? "
                + "ORDER BY created_at DESC";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    UserLoginActivity activity =
                            new UserLoginActivity();

                    activity.setId(rs.getInt("id"));
                    activity.setUserId(rs.getInt("user_id"));
                    activity.setUsername(rs.getString("username"));
                    activity.setAction(rs.getString("action"));
                    activity.setDescription(rs.getString("description"));
                    activity.setSourceIp(rs.getString("source_ip"));
                    activity.setCreatedAt(rs.getString("created_at"));

                    activities.add(activity);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return activities;
    }
}