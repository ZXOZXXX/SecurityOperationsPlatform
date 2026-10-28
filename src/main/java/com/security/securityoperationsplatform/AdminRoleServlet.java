package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AdminRoleServlet extends HttpServlet {

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

        String role = request.getParameter("role");

        // Allow only valid roles
        if (!"USER".equals(role)
                && !"ANALYST".equals(role)
                && !"ADMIN".equals(role)) {

            response.sendError(
                    400,
                    "Invalid role."
            );
            return;
        }

        // Prevent Admin from changing their own role
        int loggedInUserId =
                (Integer) session.getAttribute("userId");

        if (userId == loggedInUserId) {

            response.sendError(
                    400,
                    "You cannot change your own role."
            );
            return;
        }

        boolean updated =
                adminUserDAO.updateRole(userId, role);

        if (updated) {

            String username =
                    (String) session.getAttribute("username");

            String sourceIp =
                    request.getRemoteAddr();

            AuditLog auditLog = new AuditLog(
                    username,
                    "USER_ROLE_UPDATED",
                    "User #" + userId
                    + " role changed to "
                    + role + ".",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);
        }

        response.sendRedirect("admin.jsp");
    }
}