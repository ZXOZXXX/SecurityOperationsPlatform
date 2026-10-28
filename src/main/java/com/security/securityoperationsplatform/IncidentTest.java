package com.security.securityoperationsplatform;

public class IncidentTest {

    public static void main(String[] args) {

        Incident incident = new Incident(
                1,
                "Brute Force Investigation",
                "Investigation of repeated failed login attempts.",
                "HIGH"
        );

        incident.setAssignedTo("analyst01");
        incident.setInvestigationNotes(
                "Initial investigation started."
        );

        IncidentDAO incidentDAO = new IncidentDAO();

        if (incidentDAO.createIncident(incident)) {
            System.out.println("Incident inserted successfully!");
        } else {
            System.out.println("Failed to insert incident.");
        }
    }
}