
package com.security.securityoperationsplatform;

import java.sql.Connection;

public class DatabaseTest {

    public static void main(String[] args) {

        try (Connection connection = DBConnection.getConnection()) {

            System.out.println("================================");
            System.out.println("MySQL connection successful!");
            System.out.println("================================");

        } catch (Exception e) {

            System.out.println("================================");
            System.out.println("MySQL connection failed!");
            System.out.println("================================");

            e.printStackTrace();
        }
    }
}
