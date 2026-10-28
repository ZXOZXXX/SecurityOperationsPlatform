/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.security.securityoperationsplatform;


public class SecurityEventTest {

    public static void main(String[] args) {

        SecurityEvent event = new SecurityEvent(
                "TEST_EVENT",
                "analyst01",
                "127.0.0.1",
                "Testing security event insertion"
        );

        SecurityEventDAO dao = new SecurityEventDAO();

        if (dao.createEvent(event)) {
            System.out.println("Security event inserted successfully!");
        } else {
            System.out.println("Failed to insert security event.");
        }
    }
}
