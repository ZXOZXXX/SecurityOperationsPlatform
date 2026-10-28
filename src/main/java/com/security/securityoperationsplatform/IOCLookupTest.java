package com.security.securityoperationsplatform;

public class IOCLookupTest {

    public static void main(String[] args) {

        IOCDAO dao = new IOCDAO();

        IOC ioc = dao.findByValue("192.0.2.10");

        if (ioc != null) {

            System.out.println("IOC found!");
            System.out.println("Type: " + ioc.getIocType());
            System.out.println("Value: " + ioc.getIocValue());
            System.out.println("Threat Level: " + ioc.getThreatLevel());
            System.out.println("Status: " + ioc.getStatus());
            System.out.println("Source: " + ioc.getSource());

        } else {

            System.out.println("IOC not found.");
        }
    }
}