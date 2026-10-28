package com.security.securityoperationsplatform;

public class IOCTest {

    public static void main(String[] args) {

        IOC ioc = new IOC(
                "IP",
                "192.0.2.10",
                "HIGH",
                "Internal Threat Intelligence",
                "Test IOC for development."
        );

        IOCDAO dao = new IOCDAO();

        if (dao.createIOC(ioc)) {

            System.out.println("IOC inserted successfully!");

        } else {

            System.out.println("Failed to insert IOC.");
        }
    }
}