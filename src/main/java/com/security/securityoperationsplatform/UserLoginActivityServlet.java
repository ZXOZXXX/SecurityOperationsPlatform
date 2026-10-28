package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/user-login-activity")
public class UserLoginActivityServlet extends HttpServlet {

    private UserLoginActivityDAO activityDAO;

    @Override
    public void init() throws ServletException {
        activityDAO = new UserLoginActivityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check whether the user is logged in
        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // Get the currently logged-in user's ID
        int userId = (Integer) session.getAttribute("userId");

        // Get only this user's activities
        List<UserLoginActivity> activities =
                activityDAO.getActivitiesByUserId(userId);

        // Send activities to JSP
        request.setAttribute("activities", activities);

        // Open the activity page
        request.getRequestDispatcher("user-login-activity.jsp")
                .forward(request, response);
    }
}