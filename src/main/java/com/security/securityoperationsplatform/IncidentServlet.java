
package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class IncidentServlet extends HttpServlet {

    private IncidentDAO incidentDAO;

    @Override
    public void init() {
        incidentDAO = new IncidentDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * Check whether the user is logged in.
         */
        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        /*
         * Only ANALYST and ADMIN can view incidents.
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
         * Retrieve incidents.
         */
        List<Incident> incidents =
                incidentDAO.getAllIncidents();

        request.setAttribute(
                "incidents",
                incidents
        );

        request.getRequestDispatcher(
                "incidents.jsp"
        ).forward(request, response);
    }
}
