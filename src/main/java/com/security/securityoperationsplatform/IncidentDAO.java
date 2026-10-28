package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class IncidentDAO {

    public boolean createIncident(Incident incident) {

        String sql = """
                INSERT INTO incidents
                (alert_id, title, description, severity, assigned_to,
                 status, investigation_notes)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, incident.getAlertId());
            statement.setString(2, incident.getTitle());
            statement.setString(3, incident.getDescription());
            statement.setString(4, incident.getSeverity());
            statement.setString(5, incident.getAssignedTo());
            statement.setString(6, incident.getStatus());
            statement.setString(7, incident.getInvestigationNotes());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public List<Incident> getAllIncidents() {

        List<Incident> incidents = new ArrayList<>();

        String sql = """
                SELECT *
                FROM incidents
                ORDER BY id DESC
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {

                Incident incident = new Incident();

                incident.setId(result.getInt("id"));
                incident.setAlertId(result.getInt("alert_id"));
                incident.setTitle(result.getString("title"));
                incident.setDescription(result.getString("description"));
                incident.setSeverity(result.getString("severity"));
                incident.setAssignedTo(result.getString("assigned_to"));
                incident.setStatus(result.getString("status"));
                incident.setInvestigationNotes(
                        result.getString("investigation_notes")
                );

                incidents.add(incident);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return incidents;
    }

    public boolean updateStatus(int incidentId, String status) {

        String sql = """
                UPDATE incidents
                SET status = ?,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, status);
            statement.setInt(2, incidentId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public boolean assignAnalyst(int incidentId, String analyst) {

        String sql = """
                UPDATE incidents
                SET assigned_to = ?,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, analyst);
            statement.setInt(2, incidentId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public boolean addInvestigationNotes(
            int incidentId,
            String notes) {

        String sql = """
                UPDATE incidents
                SET investigation_notes = ?,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, notes);
            statement.setInt(2, incidentId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }
}