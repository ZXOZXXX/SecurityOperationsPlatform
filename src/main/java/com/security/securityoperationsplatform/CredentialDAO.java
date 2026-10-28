package com.security.securityoperationsplatform;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CredentialDAO {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // Add a new credential
   public int addCredential(Credential credential) {

    String sql = "INSERT INTO credentials "
            + "(user_id, credential_name, credential_type, description, file_name, file_path) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(
                 sql,
                 Statement.RETURN_GENERATED_KEYS)) {

        ps.setInt(1, credential.getUserId());
        ps.setString(2, credential.getCredentialName());
        ps.setString(3, credential.getCredentialType());
        ps.setString(4, credential.getDescription());
        ps.setString(5, credential.getFileName());
        ps.setString(6, credential.getFilePath());

        int rows = ps.executeUpdate();

        if (rows == 0) {
            return -1;
        }

        try (ResultSet rs = ps.getGeneratedKeys()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return -1;
}

    // Get all credentials belonging to one user
    public List<Credential> getCredentialsByUserId(int userId) {

        List<Credential> credentials = new ArrayList<>();

        String sql = "SELECT * FROM credentials "
                + "WHERE user_id = ? "
                + "ORDER BY uploaded_at DESC";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Credential credential = new Credential();

                    credential.setId(rs.getInt("id"));
                    credential.setUserId(rs.getInt("user_id"));
                    credential.setCredentialName(
                            rs.getString("credential_name"));
                    credential.setCredentialType(
                            rs.getString("credential_type"));
                    credential.setDescription(
                            rs.getString("description"));
                    credential.setFileName(
                            rs.getString("file_name"));
                    credential.setFilePath(
                            rs.getString("file_path"));
                    credential.setUploadedAt(
                            rs.getString("uploaded_at"));
                    credential.setStatus(
                            rs.getString("status"));

                    credentials.add(credential);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return credentials;
    }

    // Find a credential by its ID
    public Credential getCredentialById(int id) {

        String sql = "SELECT * FROM credentials WHERE id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Credential credential = new Credential();

                    credential.setId(rs.getInt("id"));
                    credential.setUserId(rs.getInt("user_id"));
                    credential.setCredentialName(
                            rs.getString("credential_name"));
                    credential.setCredentialType(
                            rs.getString("credential_type"));
                    credential.setDescription(
                            rs.getString("description"));
                    credential.setFileName(
                            rs.getString("file_name"));
                    credential.setFilePath(
                            rs.getString("file_path"));
                    credential.setUploadedAt(
                            rs.getString("uploaded_at"));
                    credential.setStatus(
                            rs.getString("status"));

                    return credential;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Revoke a credential
    public boolean revokeCredential(int id, int userId) {

        String sql = "UPDATE credentials "
                + "SET status = 'REVOKED' "
                + "WHERE id = ? AND user_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update credential details
    public boolean updateCredential(int id,
                                    int userId,
                                    String credentialName,
                                    String credentialType,
                                    String description) {

        String sql = "UPDATE credentials "
                + "SET credential_name = ?, "
                + "credential_type = ?, "
                + "description = ? "
                + "WHERE id = ? AND user_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, credentialName);
            ps.setString(2, credentialType);
            ps.setString(3, description);
            ps.setInt(4, id);
            ps.setInt(5, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a credential record
    public boolean deleteCredential(int id, int userId) {

        String sql = "DELETE FROM credentials "
                + "WHERE id = ? AND user_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}