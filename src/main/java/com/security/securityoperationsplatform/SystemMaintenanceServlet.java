package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class SystemMaintenanceServlet extends HttpServlet {

    private SystemMaintenanceDAO maintenanceDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() {

        maintenanceDAO =
                new SystemMaintenanceDAO();

        auditLogDAO =
                new AuditLogDAO();
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

        String role =
                (String) session.getAttribute("role");

        if (!"ADMIN".equals(role)) {

            response.sendError(
                    403,
                    "Access Denied: Admin role required."
            );

            return;
        }

        request.getRequestDispatcher(
                "system-maintenance.jsp"
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

    String role =
            (String) session.getAttribute("role");

    if (!"ADMIN".equals(role)) {

        response.sendError(
                403,
                "Access Denied: Admin role required."
        );

        return;
    }

    String action =
            request.getParameter("action");

    String username =
            (String) session.getAttribute("username");

    String sourceIp =
            request.getRemoteAddr();

    if ("clearSecurityData".equals(action)) {

        boolean cleared =
                maintenanceDAO.clearTestSecurityData();

        if (cleared) {

            AuditLog auditLog =
                    new AuditLog(
                            username,
                            "TEST_SECURITY_DATA_CLEARED",
                            "Administrator cleared test security data.",
                            sourceIp
                    );

            auditLogDAO.createLog(auditLog);

            response.sendRedirect(
                    "system-maintenance?success=true"
            );

        } else {

            response.sendRedirect(
                    "system-maintenance?error=failed"
            );
        }

        return;
    }

    if ("clearSessions".equals(action)) {

        boolean cleared =
                maintenanceDAO.clearSessionHistory();

        if (cleared) {

            AuditLog auditLog =
                    new AuditLog(
                            username,
                            "SESSION_HISTORY_CLEARED",
                            "Administrator cleared session history.",
                            sourceIp
                    );

            auditLogDAO.createLog(auditLog);

            response.sendRedirect(
                    "system-maintenance?sessionSuccess=true"
            );

        } else {

            response.sendRedirect(
                    "system-maintenance?sessionError=failed"
            );
        }

        return;
    }

    response.sendRedirect(
            "system-maintenance"
    );
}
}