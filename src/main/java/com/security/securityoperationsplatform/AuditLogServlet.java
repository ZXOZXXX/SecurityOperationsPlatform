package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class AuditLogServlet extends HttpServlet {

    private AuditLogDAO auditLogDAO;

    @Override
    public void init() {
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    protected void doGet(
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

        if (!"ADMIN".equals(role)) {

            response.sendError(
                    403,
                    "Access Denied: Admin role required."
            );
            return;
        }

        List<AuditLog> logs =
                auditLogDAO.getAllLogs();

        request.setAttribute("logs", logs);

        request.getRequestDispatcher("audit-logs.jsp")
                .forward(request, response);
    }
}