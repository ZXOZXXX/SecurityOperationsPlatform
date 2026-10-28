
package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class AlertServlet extends HttpServlet {

    private AlertDAO alertDAO;

    @Override
    public void init() {
        alertDAO = new AlertDAO();
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
         * Only ANALYST and ADMIN can view alerts.
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
         * Retrieve alerts.
         */
        List<Alert> alerts =
                alertDAO.getAllAlerts();

        request.setAttribute(
                "alerts",
                alerts
        );

        request.getRequestDispatcher(
                "alerts.jsp"
        ).forward(request, response);
    }
}
