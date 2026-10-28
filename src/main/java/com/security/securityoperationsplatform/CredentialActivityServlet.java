package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/credential-activity")
public class CredentialActivityServlet extends HttpServlet {

    private CredentialActivityDAO credentialActivityDAO;

    @Override
    public void init() {

        credentialActivityDAO =
                new CredentialActivityDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // ==========================================
        // CHECK LOGIN
        // ==========================================

        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // ==========================================
        // GET ROLE
        // ==========================================

        String role =
                (String) session.getAttribute("role");

        // ==========================================
        // ONLY ANALYST / ADMIN
        // ==========================================

        if (!"ANALYST".equals(role)
                && !"ADMIN".equals(role)) {

            response.sendRedirect("dashboard.jsp");
            return;
        }

        // ==========================================
        // GET ALL CREDENTIAL ACTIVITY
        // ==========================================

        List<CredentialActivity> activities =
                credentialActivityDAO.getAllActivities();

        request.setAttribute(
                "activities",
                activities
        );

        // ==========================================
        // OPEN MONITORING PAGE
        // ==========================================

        request.getRequestDispatcher(
                "credential-activity.jsp"
        ).forward(request, response);
    }
}