package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class SecurityConfigServlet extends HttpServlet {

    private SecurityConfigDAO securityConfigDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() {
        securityConfigDAO = new SecurityConfigDAO();
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Login check
        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        String role =
                (String) session.getAttribute("role");

        // ADMIN only
        if (!"ADMIN".equals(role)) {

            response.sendError(
                    403,
                    "Access Denied: Admin role required."
            );

            return;
        }

        request.getRequestDispatcher(
                "security-config.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Login check
        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        String role =
                (String) session.getAttribute("role");

        // ADMIN only
        if (!"ADMIN".equals(role)) {

            response.sendError(
                    403,
                    "Access Denied: Admin role required."
            );

            return;
        }

        String username =
                (String) session.getAttribute("username");

        String configKey =
                request.getParameter("configKey");

        String configValue =
                request.getParameter("configValue");

        if (configKey == null
                || configValue == null
                || configKey.isBlank()
                || configValue.isBlank()) {

            response.sendRedirect(
                    "security-config?error=required"
            );

            return;
        }

        boolean updated =
                securityConfigDAO.updateConfig(
                        configKey,
                        configValue,
                        username
                );

        if (updated) {

            String sourceIp =
                    request.getRemoteAddr();

            AuditLog auditLog =
                    new AuditLog(
                            username,
                            "SECURITY_CONFIG_UPDATED",
                            "Security configuration "
                            + configKey
                            + " updated to "
                            + configValue
                            + ".",
                            sourceIp
                    );

            auditLogDAO.createLog(auditLog);

            response.sendRedirect(
                    "security-config?success=true"
            );

        } else {

            response.sendRedirect(
                    "security-config?error=failed"
            );
        }
    }
}