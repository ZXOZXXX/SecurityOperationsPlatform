
package com.security.securityoperationsplatform;

import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

public class SessionListener implements HttpSessionListener {

    private UserSessionDAO userSessionDAO;
    private UserLoginActivityDAO userLoginActivityDAO;

    public SessionListener() {

        userSessionDAO =
                new UserSessionDAO();

        userLoginActivityDAO =
                new UserLoginActivityDAO();
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent event) {

        String sessionId =
                event.getSession().getId();

        Integer userId =
                (Integer) event.getSession()
                        .getAttribute("userId");

        String username =
                (String) event.getSession()
                        .getAttribute("username");

        String sourceIp =
                (String) event.getSession()
                        .getAttribute("sourceIp");

        Boolean logoutInitiated =
                (Boolean) event.getSession()
                        .getAttribute("logoutInitiated");

        /*
         * Update the database session status.
         */

        userSessionDAO.expireSession(
                sessionId
        );

        /*
         * Record SESSION_EXPIRED only when
         * the session was not explicitly logged out.
         */

        if (userId != null
                && !Boolean.TRUE.equals(logoutInitiated)) {

            userLoginActivityDAO.addActivity(
                    userId,
                    username,
                    "SESSION_EXPIRED",
                    "Session expired due to inactivity",
                    sourceIp != null
                            ? sourceIp
                            : "UNKNOWN"
            );
        }
    }
}
