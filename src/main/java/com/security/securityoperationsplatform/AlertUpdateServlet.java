package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AlertUpdateServlet extends HttpServlet {

    private AlertDAO alertDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() {
        alertDAO = new AlertDAO();
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

        String role = (String) session.getAttribute("role");

        if (!"ANALYST".equals(role)
                && !"ADMIN".equals(role)) {

            response.sendError(
                    403,
                    "Access Denied: Analyst or Admin role required."
            );
            return;
        }

        int alertId = Integer.parseInt(
                request.getParameter("alertId")
        );

        String status = request.getParameter("status");

        boolean updated = alertDAO.updateStatus(
                alertId,
                status
        );

        if (updated) {

            String username =
                    (String) session.getAttribute("username");

            String sourceIp =
                    request.getRemoteAddr();

            AuditLog auditLog = new AuditLog(
                    username,
                    "ALERT_STATUS_UPDATED",
                    "Alert #" + alertId
                    + " status changed to "
                    + status + ".",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);
        }

        response.sendRedirect("alerts");
    }
}