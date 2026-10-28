
package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class SessionServlet extends HttpServlet {

    private UserSessionDAO userSessionDAO;

    @Override
    public void init() {
        userSessionDAO = new UserSessionDAO();
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

        if (!"ANALYST".equals(role)
                && !"ADMIN".equals(role)) {

            response.sendError(
                    403,
                    "Access Denied: Analyst or Admin role required."
            );

            return;
        }

        List<UserSession> sessions =
                userSessionDAO.getAllSessions();

        request.setAttribute(
                "sessions",
                sessions
        );

        request.getRequestDispatcher(
                "sessions.jsp"
        ).forward(request, response);
    }
}

