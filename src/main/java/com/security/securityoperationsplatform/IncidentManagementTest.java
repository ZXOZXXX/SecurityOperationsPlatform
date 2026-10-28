package com.security.securityoperationsplatform;

public class IncidentManagementTest {

    public static void main(String[] args) {

        IncidentDAO incidentDAO = new IncidentDAO();

        System.out.println("=== ALL INCIDENTS ===");

        incidentDAO.getAllIncidents();

        System.out.println("\n=== ASSIGN ANALYST ===");

        if (incidentDAO.assignAnalyst(1, "analyst01")) {
            System.out.println("Analyst assigned successfully!");
        } else {
            System.out.println("Failed to assign analyst.");
        }

        System.out.println("\n=== UPDATE STATUS ===");

        if (incidentDAO.updateStatus(1, "INVESTIGATING")) {
            System.out.println("Incident status updated successfully!");
        } else {
            System.out.println("Failed to update status.");
        }

        System.out.println("\n=== ADD NOTES ===");

        if (incidentDAO.addInvestigationNotes(
                1,
                "Analyst started investigating the repeated login failures.")) {

            System.out.println("Investigation notes added successfully!");

        } else {
            System.out.println("Failed to add investigation notes.");
        }
    }
}