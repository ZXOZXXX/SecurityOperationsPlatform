
package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class LogoutServlet extends HttpServlet {

    private UserSessionDAO userSessionDAO;
    private AuditLogDAO auditLogDAO;
    private UserLoginActivityDAO userLoginActivityDAO;

    @Override
    public void init() {

        userSessionDAO =
                new UserSessionDAO();

        auditLogDAO =
                new AuditLogDAO();

        userLoginActivityDAO =
                new UserLoginActivityDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session != null) {

            String sessionId =
                    session.getId();

            String username =
                    (String) session.getAttribute(
                            "username"
                    );

            Integer userId =
                    (Integer) session.getAttribute(
                            "userId"
                    );

            String sourceIp =
                    request.getRemoteAddr();

            /*
             * End the database session.
             */

            userSessionDAO.endSession(
                    sessionId
            );

            /*
             * Record the logout activity
             * for the current user.
             */

            if (userId != null) {

                userLoginActivityDAO.addActivity(
                        userId,
                        username,
                        "LOGOUT",
                        "User logged out successfully",
                        sourceIp
                );
            }

            /*
             * Record the logout in the
             * main audit log.
             */

            AuditLog auditLog =
                    new AuditLog(
                            username,
                            "LOGOUT",
                            "User logged out successfully.",
                            sourceIp
                    );

            auditLogDAO.createLog(
                    auditLog
            );

            /*
             * Tell SessionListener that this
             * session is being deliberately
             * logged out.
             */

            session.setAttribute(
                    "logoutInitiated",
                    true
            );

            /*
             * Destroy the HTTP session.
             */

            session.invalidate();
        }

        response.sendRedirect(
                "login.jsp"
        );
    }
}
