package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AdminStatusServlet extends HttpServlet {

    private AdminUserDAO adminUserDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() {
        adminUserDAO = new AdminUserDAO();
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // Check Admin role
        String adminRole =
                (String) session.getAttribute("role");

        if (!"ADMIN".equals(adminRole)) {

            response.sendError(
                    403,
                    "Access Denied: Admin role required."
            );
            return;
        }

        int userId = Integer.parseInt(
                request.getParameter("userId")
        );

        String status =
                request.getParameter("enabled");

        // Convert submitted value to boolean
        boolean enabled = "true".equals(status);

        // Prevent Admin from disabling their own account
        int loggedInUserId =
                (Integer) session.getAttribute("userId");

        if (userId == loggedInUserId) {

            response.sendError(
                    400,
                    "You cannot disable your own account."
            );
            return;
        }

        boolean updated =
                adminUserDAO.updateStatus(
                        userId,
                        enabled
                );

        if (updated) {

            String username =
                    (String) session.getAttribute("username");

            String sourceIp =
                    request.getRemoteAddr();

            String action =
                    enabled
                    ? "USER_ACCOUNT_ENABLED"
                    : "USER_ACCOUNT_DISABLED";

            String description =
                    "User #" + userId
                    + " account "
                    + (enabled ? "enabled." : "disabled.");

            AuditLog auditLog = new AuditLog(
                    username,
                    action,
                    description,
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);
        }

        response.sendRedirect("admin.jsp");
    }
}