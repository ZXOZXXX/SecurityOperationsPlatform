
package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;
    private SecurityEventDAO securityEventDAO;
    private DetectionEngine detectionEngine;
    private AuditLogDAO auditLogDAO;
    private SecurityConfigDAO securityConfigDAO;
    private UserSessionDAO userSessionDAO;
    private UserLoginActivityDAO userLoginActivityDAO;

    @Override
    public void init() {

        userDAO = new UserDAO();
        securityEventDAO = new SecurityEventDAO();
        detectionEngine = new DetectionEngine();
        auditLogDAO = new AuditLogDAO();
        securityConfigDAO = new SecurityConfigDAO();
        userSessionDAO = new UserSessionDAO();
        userLoginActivityDAO = new UserLoginActivityDAO();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String sourceIp = request.getRemoteAddr();

        User user = userDAO.findByUsername(username);

        /*
         * Read account security settings
         * from the database.
         */

        int maxFailedAttempts = 5;
        boolean accountLockoutEnabled = true;

        String maxAttemptsValue =
                securityConfigDAO.getConfigValue(
                        "MAX_FAILED_ATTEMPTS"
                );

        String lockoutValue =
                securityConfigDAO.getConfigValue(
                        "ACCOUNT_LOCKOUT_ENABLED"
                );

        /*
         * Convert MAX_FAILED_ATTEMPTS
         * from String to integer.
         */

        if (maxAttemptsValue != null) {

            try {

                maxFailedAttempts =
                        Integer.parseInt(maxAttemptsValue);

            } catch (NumberFormatException e) {

                // Keep safe default value
                maxFailedAttempts = 5;
            }
        }

        /*
         * Convert ACCOUNT_LOCKOUT_ENABLED
         * from String to boolean.
         */

        if (lockoutValue != null) {

            accountLockoutEnabled =
                    Boolean.parseBoolean(lockoutValue);
        }

        /*
         * Check whether the account exists
         * and is locked.
         */

        if (user != null && user.isLocked()) {

            SecurityEvent event = new SecurityEvent(
                    "LOGIN_BLOCKED",
                    username,
                    sourceIp,
                    "Login attempt blocked because account is locked"
            );

            securityEventDAO.createEvent(event);

            AuditLog auditLog = new AuditLog(
                    username,
                    "LOGIN_BLOCKED",
                    "Login attempt blocked because account is locked.",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);

            // Record activity for the user
            userLoginActivityDAO.addActivity(
                    user.getId(),
                    user.getUsername(),
                    "LOGIN_BLOCKED",
                    "Login attempt blocked because account is locked",
                    sourceIp
            );

            response.sendRedirect(
                    "login.jsp?error=locked"
            );

            return;
        }

        /*
         * Check whether the account is disabled.
         *
         * This is handled separately so that a disabled
         * account is not treated as a wrong password.
         */

        if (user != null && !user.isEnabled()) {

            SecurityEvent event = new SecurityEvent(
                    "LOGIN_BLOCKED",
                    username,
                    sourceIp,
                    "Login attempt blocked because account is disabled"
            );

            securityEventDAO.createEvent(event);

            AuditLog auditLog = new AuditLog(
                    username,
                    "LOGIN_BLOCKED",
                    "Login attempt blocked because account is disabled.",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);

            // Record activity for the user
            userLoginActivityDAO.addActivity(
                    user.getId(),
                    user.getUsername(),
                    "LOGIN_BLOCKED",
                    "Login attempt blocked because account is disabled",
                    sourceIp
            );

            response.sendRedirect(
                    "login.jsp?error=disabled"
            );

            return;
        }

        /*
         * Successful login
         */

        if (user != null
                && PasswordUtil.checkPassword(
                        password,
                        user.getPassword())) {

            // Reset failed attempts after successful login
            userDAO.resetFailedAttempts(
                    user.getId()
            );

            SecurityEvent event = new SecurityEvent(
                    "LOGIN_SUCCESS",
                    username,
                    sourceIp,
                    "User logged in successfully"
            );

            securityEventDAO.createEvent(event);

            AuditLog auditLog = new AuditLog(
                    username,
                    "LOGIN_SUCCESS",
                    "User logged in successfully.",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);

            detectionEngine.checkIOC(sourceIp);

            /*
             * Create HTTP session
             */

            HttpSession session =
                    request.getSession(true);

            session.setAttribute(
                    "userId",
                    user.getId()
            );

            session.setAttribute(
                    "username",
                    user.getUsername()
            );

            session.setAttribute(
                    "role",
                    user.getRole()
            );

            /*
             * Store source IP in the session.
             * This is required by SessionListener
             * when the session expires.
             */

            session.setAttribute(
                    "sourceIp",
                    sourceIp
            );

            /*
             * Store login session in database
             */

            userSessionDAO.createSession(
                    session.getId(),
                    user.getId(),
                    user.getUsername(),
                    user.getRole(),
                    sourceIp
            );

            /*
             * Record successful login activity
             */

            userLoginActivityDAO.addActivity(
                    user.getId(),
                    user.getUsername(),
                    "LOGIN",
                    "User logged in successfully",
                    sourceIp
            );

            /*
             * Check whether the user logged in
             * from a different IP address.
             */

            detectionEngine.checkDifferentIpLogin(
                    user.getId(),
                    user.getUsername(),
                    session.getId(),
                    sourceIp
            );

            response.sendRedirect(
                    "dashboard.jsp"
            );

        } else {

            /*
             * Failed login
             */

            SecurityEvent event = new SecurityEvent(
                    "LOGIN_FAILURE",
                    username,
                    sourceIp,
                    "Invalid username or password"
            );

            securityEventDAO.createEvent(event);

            AuditLog auditLog = new AuditLog(
                    username,
                    "LOGIN_FAILURE",
                    "Failed login attempt.",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);

            detectionEngine.checkBruteForce(sourceIp);

            detectionEngine.checkIOC(sourceIp);

            /*
             * Increase failed attempts only
             * when the username exists.
             */

            if (user != null) {

                // Record failed login activity
                userLoginActivityDAO.addActivity(
                        user.getId(),
                        user.getUsername(),
                        "FAILED_LOGIN",
                        "Invalid password",
                        sourceIp
                );

                userDAO.incrementFailedAttempts(
                        user.getId()
                );

                int failedAttempts =
                        user.getFailedAttempts() + 1;

                /*
                 * Lock the account only when
                 * account lockout is enabled.
                 */

                if (accountLockoutEnabled
                        && failedAttempts >= maxFailedAttempts) {

                    userDAO.lockUser(
                            user.getId()
                    );

                    AuditLog lockAudit =
                            new AuditLog(
                                    username,
                                    "ACCOUNT_LOCKED",
                                    "Account locked after "
                                    + maxFailedAttempts
                                    + " failed login attempts.",
                                    sourceIp
                            );

                    auditLogDAO.createLog(
                            lockAudit
                    );
                }

            }

            response.sendRedirect(
                    "login.jsp?error=invalid"
            );
        }
    }
}