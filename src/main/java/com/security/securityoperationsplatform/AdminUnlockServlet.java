package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AdminUnlockServlet extends HttpServlet {

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

        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

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

        boolean unlocked =
                adminUserDAO.unlockUser(userId);

        if (unlocked) {

            String username =
                    (String) session.getAttribute("username");

            String sourceIp =
                    request.getRemoteAddr();

            AuditLog auditLog = new AuditLog(
                    username,
                    "USER_ACCOUNT_UNLOCKED",
                    "User #" + userId
                    + " account unlocked.",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);
        }

        response.sendRedirect("admin.jsp");
    }
}