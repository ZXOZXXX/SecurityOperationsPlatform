package com.security.securityoperationsplatform;

public class IncidentService {

    private AlertDAO alertDAO;
    private IncidentDAO incidentDAO;

    public IncidentService() {
        alertDAO = new AlertDAO();
        incidentDAO = new IncidentDAO();
    }

    public boolean createIncidentFromAlert(int alertId) {

        Alert alert = alertDAO.findById(alertId);

        if (alert == null) {
            System.out.println("Alert not found.");
            return false;
        }

        Incident incident = new Incident(
                alert.getId(),
                "Investigation: " + alert.getTitle(),
                alert.getDescription(),
                alert.getSeverity()
        );

        incident.setAssignedTo("analyst01");
        incident.setInvestigationNotes(
                "Incident created from security alert."
        );

        boolean created = incidentDAO.createIncident(incident);

        if (created) {
            System.out.println(
                    "Incident created successfully from Alert #"
                    + alertId
            );
        }

        return created;
    }
}