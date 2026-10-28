package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class IncidentNotesServlet extends HttpServlet {

    private IncidentDAO incidentDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
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

        int incidentId = Integer.parseInt(
                request.getParameter("incidentId")
        );

        String notes = request.getParameter("notes");

        boolean updated = incidentDAO.addInvestigationNotes(
                incidentId,
                notes
        );

        if (updated) {

            String username =
                    (String) session.getAttribute("username");

            String sourceIp =
                    request.getRemoteAddr();

            AuditLog auditLog = new AuditLog(
                    username,
                    "INVESTIGATION_NOTES_UPDATED",
                    "Investigation notes updated for Incident #"
                    + incidentId + ".",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);
        }

        response.sendRedirect("incidents");
    }
}