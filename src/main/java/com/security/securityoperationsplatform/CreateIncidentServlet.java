package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class CreateIncidentServlet extends HttpServlet {

    private IncidentService incidentService;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() {
        incidentService = new IncidentService();
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

        boolean created =
                incidentService.createIncidentFromAlert(alertId);

        if (created) {

            String username =
                    (String) session.getAttribute("username");

            String sourceIp =
                    request.getRemoteAddr();

            AuditLog auditLog = new AuditLog(
                    username,
                    "INCIDENT_CREATED",
                    "Incident created from Alert #"
                    + alertId + ".",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);

            response.sendRedirect("incidents");

        } else {

            response.sendError(
                    500,
                    "Unable to create incident from alert."
            );
        }
    }
}