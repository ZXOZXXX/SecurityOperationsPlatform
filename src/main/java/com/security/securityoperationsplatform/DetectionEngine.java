package com.security.securityoperationsplatform;

public class DetectionEngine {

    private SecurityEventDAO securityEventDAO;
    private AlertDAO alertDAO;
    private IOCDAO iocDAO;
    private SecurityConfigDAO securityConfigDAO;
    private UserSessionDAO userSessionDAO;

    public DetectionEngine() {

        securityEventDAO =
                new SecurityEventDAO();

        alertDAO =
                new AlertDAO();

        iocDAO =
                new IOCDAO();

        securityConfigDAO =
                new SecurityConfigDAO();

        userSessionDAO =
                new UserSessionDAO();
    }

    public void checkBruteForce(String sourceIp) {

        /*
         * Read brute-force detection setting.
         */

        boolean bruteForceDetectionEnabled = true;

        int timeWindowMinutes = 5;

        String enabledValue =
                securityConfigDAO.getConfigValue(
                        "BRUTE_FORCE_DETECTION_ENABLED"
                );

        String windowValue =
                securityConfigDAO.getConfigValue(
                        "BRUTE_FORCE_TIME_WINDOW"
                );

        /*
         * Convert detection enabled setting.
         */

        if (enabledValue != null) {

            bruteForceDetectionEnabled =
                    Boolean.parseBoolean(
                            enabledValue
                    );
        }

        /*
         * Convert detection time window.
         */

        if (windowValue != null) {

            try {

                timeWindowMinutes =
                        Integer.parseInt(
                                windowValue
                        );

            } catch (NumberFormatException e) {

                timeWindowMinutes = 5;
            }
        }

        /*
         * Do not perform brute-force detection
         * when the Admin has disabled it.
         */

        if (!bruteForceDetectionEnabled) {
            return;
        }

        /*
         * Count failed login attempts within
         * the configured time window.
         */

        int failedAttempts =
                securityEventDAO.countRecentFailedLogins(
                        sourceIp,
                        timeWindowMinutes
                );

        /*
         * Five or more failed attempts
         * indicate possible brute-force activity.
         */

        if (failedAttempts >= 5) {

            boolean alertAlreadyExists =
                    alertDAO.hasOpenBruteForceAlert(
                            sourceIp
                    );

            if (!alertAlreadyExists) {

                Alert alert = new Alert(
                        "Possible Brute Force Attack",
                        "Five or more failed login attempts detected from the same IP within "
                        + timeWindowMinutes
                        + " minutes.",
                        "HIGH",
                        sourceIp
                );

                if (alertDAO.createAlert(alert)) {

                    System.out.println(
                            "HIGH ALERT: Possible brute force attack detected from "
                            + sourceIp
                    );
                }
            }
        }
    }

    public void checkIOC(String sourceIp) {

        IOC ioc =
                iocDAO.findByValue(sourceIp);

        if (ioc != null) {

            boolean alertAlreadyExists =
                    alertDAO.hasOpenIOCAlert(
                            sourceIp
                    );

            if (!alertAlreadyExists) {

                Alert alert = new Alert(
                        "Known IOC Detected",
                        "Login activity detected from an IP address present in the active IOC database.",
                        ioc.getThreatLevel(),
                        sourceIp
                );

                if (alertDAO.createAlert(alert)) {

                    System.out.println(
                            "IOC ALERT: Known IOC detected from "
                            + sourceIp
                    );
                }
            }
        }
    }

    public void checkDifferentIpLogin(
            int userId,
            String username,
            String currentSessionId,
            String currentIp) {

        String previousIp =
                userSessionDAO.getPreviousIp(
                        userId,
                        currentSessionId
                );

        if (previousIp == null) {
            return;
        }

        if (!previousIp.equals(currentIp)) {

            boolean alertAlreadyExists =
                    alertDAO.hasOpenDifferentIpAlert(
                            username,
                            currentIp
                    );

            if (!alertAlreadyExists) {

                Alert alert = new Alert(
                        "Suspicious Login IP Change",
                        "User "
                        + username
                        + " logged in from a different IP address. Previous IP: "
                        + previousIp
                        + ", Current IP: "
                        + currentIp
                        + ".",
                        "MEDIUM",
                        currentIp
                );

                if (alertDAO.createAlert(alert)) {

                    System.out.println(
                            "MEDIUM ALERT: Different IP login detected for "
                            + username
                    );
                }
            }
        }
    }
}
