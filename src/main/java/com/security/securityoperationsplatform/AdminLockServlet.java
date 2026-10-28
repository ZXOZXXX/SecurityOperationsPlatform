package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AdminLockServlet extends HttpServlet {

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

        int loggedInUserId =
                (Integer) session.getAttribute("userId");

        // Admin cannot lock their own account
        if (userId == loggedInUserId) {

            response.sendError(
                    400,
                    "You cannot lock your own account."
            );
            return;
        }

        boolean locked =
                adminUserDAO.lockUser(userId);

        if (locked) {

            String username =
                    (String) session.getAttribute("username");

            String sourceIp =
                    request.getRemoteAddr();

            AuditLog auditLog = new AuditLog(
                    username,
                    "USER_ACCOUNT_LOCKED",
                    "User #" + userId
                    + " account manually locked by administrator.",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);
        }

        response.sendRedirect("admin.jsp");
    }
}