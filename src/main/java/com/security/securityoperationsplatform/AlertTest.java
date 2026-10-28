package com.security.securityoperationsplatform;

public class AlertTest {

    public static void main(String[] args) {

        Alert alert = new Alert(
                "Test Security Alert",
                "Testing alert insertion into the database",
                "HIGH",
                "127.0.0.1"
        );

        AlertDAO alertDAO = new AlertDAO();

        if (alertDAO.createAlert(alert)) {
            System.out.println("Alert inserted successfully!");
        } else {
            System.out.println("Failed to insert alert.");
        }
    }
}