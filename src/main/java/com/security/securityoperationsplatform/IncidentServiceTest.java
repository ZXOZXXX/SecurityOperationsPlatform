package com.security.securityoperationsplatform;

public class IncidentServiceTest {

    public static void main(String[] args) {

        IncidentService incidentService =
                new IncidentService();

        int alertId = 1;

        if (incidentService.createIncidentFromAlert(alertId)) {

            System.out.println(
                    "Alert successfully converted into an incident!"
            );

        } else {

            System.out.println(
                    "Failed to create incident from alert."
            );
        }
    }
}