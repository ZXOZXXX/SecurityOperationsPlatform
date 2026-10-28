package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class CreateIOCServlet extends HttpServlet {

    private IOCDAO iocDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() {
        iocDAO = new IOCDAO();
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

        String iocType = request.getParameter("iocType");
        String iocValue = request.getParameter("iocValue");
        String threatLevel = request.getParameter("threatLevel");
        String source = request.getParameter("source");
        String description = request.getParameter("description");

        if (iocType == null || iocValue == null
                || threatLevel == null) {

            response.sendError(
                    400,
                    "Required IOC fields are missing."
            );
            return;
        }

        IOC ioc = new IOC(
                iocType,
                iocValue,
                threatLevel,
                source,
                description
        );

        boolean created = iocDAO.createIOC(ioc);

        if (created) {

            String username =
                    (String) session.getAttribute("username");

            String sourceIp =
                    request.getRemoteAddr();

            AuditLog auditLog = new AuditLog(
                    username,
                    "IOC_CREATED",
                    iocType + " IOC added: "
                    + iocValue + ".",
                    sourceIp
            );

            auditLogDAO.createLog(auditLog);

            response.sendRedirect("iocs");

        } else {

            response.sendError(
                    500,
                    "Unable to create IOC."
            );
        }
    }
}