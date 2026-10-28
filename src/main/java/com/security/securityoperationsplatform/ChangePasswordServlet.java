package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class ChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO;
    private AuditLogDAO auditLogDAO;
    private SecurityConfigDAO securityConfigDAO;

    @Override
    public void init() {

        userDAO = new UserDAO();
        auditLogDAO = new AuditLogDAO();
        securityConfigDAO = new SecurityConfigDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher(
                "change-password.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        int userId =
                (Integer) session.getAttribute("userId");

        String username =
                (String) session.getAttribute("username");

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        /*
         * Read minimum password length
         * from Security Configuration.
         */

        int minPasswordLength = 8;

        String minLengthValue =
                securityConfigDAO.getConfigValue(
                        "MIN_PASSWORD_LENGTH"
                );

        if (minLengthValue != null) {

            try {

                minPasswordLength =
                        Integer.parseInt(minLengthValue);

            } catch (NumberFormatException e) {

                minPasswordLength = 8;
            }
        }

        /*
         * Check required fields.
         */

        if (currentPassword == null
                || newPassword == null
                || confirmPassword == null
                || currentPassword.isBlank()
                || newPassword.isBlank()
                || confirmPassword.isBlank()) {

            response.sendRedirect(
                    "change-password.jsp?error=required"
            );

            return;
        }

        /*
         * Find current user.
         */

        User user =
                userDAO.findByUsername(username);

        if (user == null) {

            response.sendRedirect(
                    "change-password.jsp?error=user"
            );

            return;
        }

        /*
         * Verify current password.
         */

        if (!PasswordUtil.checkPassword(
                currentPassword,
                user.getPassword())) {

            response.sendRedirect(
                    "change-password.jsp?error=current"
            );

            return;
        }

        /*
         * Check whether both new passwords match.
         */

        if (!newPassword.equals(confirmPassword)) {

            response.sendRedirect(
                    "change-password.jsp?error=match"
            );

            return;
        }

        /*
         * Check password length using
         * Security Configuration.
         */

        if (newPassword.length() < minPasswordLength) {

            response.sendRedirect(
                    "change-password.jsp?error=length&min="
                    + minPasswordLength
            );

            return;
        }

        /*
         * New password must be different
         * from the current password.
         */

        if (PasswordUtil.checkPassword(
                newPassword,
                user.getPassword())) {

            response.sendRedirect(
                    "change-password.jsp?error=same"
            );

            return;
        }

        /*
         * Hash the new password.
         */

        String hashedPassword =
                PasswordUtil.hashPassword(
                        newPassword
                );

        boolean updated =
                userDAO.updatePassword(
                        userId,
                        hashedPassword
                );

        if (updated) {

            String sourceIp =
                    request.getRemoteAddr();

            AuditLog auditLog =
                    new AuditLog(
                            username,
                            "PASSWORD_CHANGED",
                            "User changed their password.",
                            sourceIp
                    );

            auditLogDAO.createLog(auditLog);

            response.sendRedirect(
                    "change-password.jsp?success=true"
            );

        } else {

            response.sendRedirect(
                    "change-password.jsp?error=failed"
            );
        }
    }
}