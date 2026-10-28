
package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class SecurityEventServlet extends HttpServlet {

    private SecurityEventDAO securityEventDAO;

    @Override
    public void init() {
        securityEventDAO = new SecurityEventDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * User must be logged in.
         */
        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        /*
         * Only ANALYST and ADMIN can view
         * security events.
         */
        String role =
                (String) session.getAttribute("role");

        if (!"ANALYST".equals(role)
                && !"ADMIN".equals(role)) {

            response.sendError(
                    403,
                    "Access Denied: Analyst or Admin role required."
            );

            return;
        }

        /*
         * Retrieve security events.
         */
        List<SecurityEvent> events =
                securityEventDAO.getAllEvents();

        request.setAttribute(
                "events",
                events
        );

        request.getRequestDispatcher(
                "security-events.jsp"
        ).forward(request, response);
    }
}
