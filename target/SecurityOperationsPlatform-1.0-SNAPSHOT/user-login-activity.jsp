<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.security.securityoperationsplatform.UserLoginActivity" %>


<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    List<UserLoginActivity> activities =
            (List<UserLoginActivity>) request.getAttribute("activities");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Login Activity | Security Operations Platform</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family:
                "Segoe UI",
                Arial,
                sans-serif;

            background: #0b1120;
            color: #e5e7eb;

            min-height: 100vh;
        }

        /* ================= SIDEBAR ================= */

        .sidebar {
            position: fixed;

            left: 0;
            top: 0;

            width: 255px;
            height: 100vh;

            background: #111827;

            border-right: 1px solid #1f2937;

            padding: 24px 16px;

            z-index: 100;
        }

        .logo {
            display: flex;

            align-items: center;

            gap: 12px;

            padding: 0 10px 28px;

            font-size: 19px;

            font-weight: 700;

            color: #f8fafc;
        }

        .logo-icon {
            width: 38px;
            height: 38px;

            display: flex;

            align-items: center;
            justify-content: center;

            background: #172554;

            border: 1px solid #1d4ed8;

            border-radius: 10px;

            font-size: 18px;
        }

        .nav-title {
            color: #64748b;

            font-size: 11px;

            font-weight: 700;

            letter-spacing: 1px;

            text-transform: uppercase;

            padding: 0 12px 10px;
        }

        .nav-link {
            display: flex;

            align-items: center;

            gap: 12px;

            text-decoration: none;

            color: #94a3b8;

            padding: 11px 12px;

            margin-bottom: 4px;

            border-radius: 8px;

            font-size: 14px;

            transition: 0.2s;
        }

        .nav-link:hover {
            background: #1e293b;

            color: #f8fafc;
        }

        .nav-link.active {
            background: #172554;

            color: #60a5fa;

            border-left: 3px solid #3b82f6;
        }

        .nav-icon {
            width: 20px;

            text-align: center;

            font-size: 15px;
        }

        .sidebar-bottom {
            position: absolute;

            left: 16px;
            right: 16px;

            bottom: 20px;
        }

        .logout-link {
            color: #f87171;
        }

        .logout-link:hover {
            background: #2b1518;

            color: #fca5a5;
        }

        /* ================= MAIN ================= */

        .main {
            margin-left: 255px;

            min-height: 100vh;
        }

        /* ================= TOPBAR ================= */

        .topbar {
            height: 76px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 0 32px;

            background: #0f172a;

            border-bottom: 1px solid #1f2937;
        }

        .page-heading h1 {
            font-size: 21px;

            color: #f8fafc;

            margin-bottom: 4px;
        }

        .page-heading p {
            font-size: 13px;

            color: #64748b;
        }

        .user-profile {
            display: flex;

            align-items: center;

            gap: 11px;
        }

        .user-avatar {
            width: 38px;
            height: 38px;

            display: flex;

            align-items: center;
            justify-content: center;

            border-radius: 50%;

            background: #172554;

            border: 1px solid #2563eb;

            color: #60a5fa;

            font-weight: 700;
        }

        .user-info {
            line-height: 1.3;
        }

        .user-name {
            font-size: 13px;

            font-weight: 600;

            color: #e2e8f0;
        }

        .user-role {
            font-size: 11px;

            color: #64748b;
        }

        /* ================= CONTENT ================= */

        .content {
            padding: 30px 32px 45px;
        }

        /* ================= OVERVIEW ================= */

        .overview-card {
            background:
                linear-gradient(
                    135deg,
                    #111c35,
                    #0f172a
                );

            border: 1px solid #1e3a5f;

            border-radius: 14px;

            padding: 25px;

            margin-bottom: 27px;
        }

        .overview-card h2 {
            font-size: 22px;

            color: #f8fafc;

            margin-bottom: 7px;
        }

        .overview-card p {
            color: #94a3b8;

            font-size: 13px;

            line-height: 1.6;

            max-width: 850px;
        }

        .security-pill {
            display: inline-flex;

            align-items: center;

            gap: 7px;

            margin-top: 15px;

            padding: 6px 11px;

            border-radius: 20px;

            background: #172554;

            border: 1px solid #1e40af;

            color: #60a5fa;

            font-size: 11px;

            font-weight: 600;
        }

        .status-dot {
            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: #3b82f6;
        }

        /* ================= SECTION ================= */

        .section-header {
            margin-bottom: 15px;
        }

        .section-title {
            font-size: 16px;

            font-weight: 700;

            color: #f1f5f9;
        }

        .section-title::before {
            content: "";

            display: inline-block;

            width: 3px;
            height: 17px;

            background: #3b82f6;

            margin-right: 9px;

            vertical-align: -3px;

            border-radius: 3px;
        }

        .section-description {
            margin-top: 5px;

            font-size: 12px;

            color: #64748b;
        }

        /* ================= ACTIVITY CARD ================= */

        .activity-card {
            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 12px;

            overflow: hidden;
        }

        .activity-header {
            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 20px 22px;

            border-bottom: 1px solid #1f2937;

            background: #111827;
        }

        .activity-header h3 {
            color: #f1f5f9;

            font-size: 15px;
        }

        .activity-header p {
            color: #64748b;

            font-size: 11px;

            margin-top: 5px;
        }

        .activity-badge {
            padding: 5px 9px;

            border-radius: 6px;

            background: #052e16;

            border: 1px solid #14532d;

            color: #4ade80;

            font-size: 9px;

            font-weight: 700;

            text-transform: uppercase;
        }

        /* ================= TABLE ================= */

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;

            min-width: 800px;

            border-collapse: collapse;
        }

        th {
            background: #0f172a;

            color: #64748b;

            font-size: 10px;

            text-transform: uppercase;

            letter-spacing: 0.7px;

            text-align: left;

            padding: 14px 15px;

            border-bottom: 1px solid #1f2937;
        }

        td {
            padding: 14px 15px;

            border-bottom: 1px solid #1f2937;

            color: #cbd5e1;

            font-size: 12px;

            vertical-align: top;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background: #151e2e;
        }

        /* ================= ACTION BADGES ================= */

        .badge {
            display: inline-flex;

            padding: 5px 9px;

            border-radius: 6px;

            font-size: 9px;

            font-weight: 700;

            letter-spacing: 0.3px;
        }

        .login {
            background: #052e16;

            color: #4ade80;
        }

        .logout {
            background: #1e293b;

            color: #94a3b8;
        }

        .expired {
            background: #422006;

            color: #facc15;
        }

        .failed {
            background: #450a0a;

            color: #fca5a5;
        }

        /* ================= DATA ================= */

        .description {
            color: #94a3b8;

            line-height: 1.5;

            max-width: 400px;
        }

        .ip-address {
            color: #93c5fd;

            font-family: monospace;

            font-size: 11px;
        }

        .date-time {
            color: #94a3b8;

            font-family: monospace;

            font-size: 11px;

            white-space: nowrap;
        }

        /* ================= EMPTY ================= */

        .empty-state {
            text-align: center;

            padding: 60px 20px;
        }

        .empty-icon {
            width: 48px;
            height: 48px;

            display: flex;

            align-items: center;
            justify-content: center;

            margin: 0 auto 14px;

            border-radius: 12px;

            background: #172554;

            border: 1px solid #1e3a8a;

            color: #60a5fa;

            font-size: 22px;
        }

        .empty-state h3 {
            color: #94a3b8;

            font-size: 15px;

            margin-bottom: 5px;
        }

        .empty-state p {
            color: #64748b;

            font-size: 12px;
        }

        /* ================= FOOTER ================= */

        .footer-actions {
            display: flex;

            gap: 12px;

            margin-top: 25px;
        }

        .footer-link {
            text-decoration: none;

            padding: 9px 14px;

            border: 1px solid #334155;

            border-radius: 7px;

            color: #94a3b8;

            font-size: 12px;

            transition: 0.2s;
        }

        .footer-link:hover {
            background: #1e293b;

            color: #f1f5f9;
        }

        .logout-footer {
            color: #f87171;

            border-color: #4c1d1d;
        }

        .logout-footer:hover {
            background: #2b1518;

            color: #fca5a5;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 800px) {

            .sidebar {
                position: relative;

                width: 100%;

                height: auto;

                border-right: none;

                border-bottom: 1px solid #1f2937;
            }

            .sidebar-bottom {
                position: static;

                margin-top: 20px;
            }

            .main {
                margin-left: 0;
            }

            .topbar {
                padding: 0 20px;
            }

            .content {
                padding: 22px 18px;
            }

            .user-info {
                display: none;
            }

            .activity-header {
                align-items: flex-start;

                gap: 12px;
            }

        }

    </style>

</head>

<body>

<!-- ================= SIDEBAR ================= -->

<aside class="sidebar">

    <div class="logo">

        <div class="logo-icon">
            🛡
        </div>

        <span>
            Security Ops
        </span>

    </div>


<%
    if ("USER".equals(role)) {
%>

    <div class="nav-title">
        Personal Security
    </div>


    <a href="dashboard.jsp"
       class="nav-link">

        <span class="nav-icon">
            ▦
        </span>

        Dashboard

    </a>


    <a href="credentials"
       class="nav-link">

        <span class="nav-icon">
            ◈
        </span>

        Credential Center

    </a>


    <a href="user-login-activity"
       class="nav-link active">

        <span class="nav-icon">
            ◌
        </span>

        My Login Activity

    </a>


    <div class="nav-title"
         style="margin-top:24px;">

        Account

    </div>


    <a href="change-password"
       class="nav-link">

        <span class="nav-icon">
            🔑
        </span>

        Change Password

    </a>


    <div class="sidebar-bottom">

        <a href="logout"
           class="nav-link logout-link">

            <span class="nav-icon">
                ↪
            </span>

            Logout

        </a>

    </div>


<%
    } else {
%>

    <div class="nav-title">
        Operations
    </div>


    <a href="dashboard.jsp"
       class="nav-link">

        <span class="nav-icon">
            ▦
        </span>

        Dashboard

    </a>


    <a href="alerts"
       class="nav-link">

        <span class="nav-icon">
            ⚠
        </span>

        Security Alerts

    </a>


    <a href="incidents"
       class="nav-link">

        <span class="nav-icon">
            ◉
        </span>

        Incidents

    </a>


    <a href="security-events"
       class="nav-link">

        <span class="nav-icon">
            ⌁
        </span>

        Security Events

    </a>


    <a href="threat-intelligence"
       class="nav-link">

        <span class="nav-icon">
            ◈
        </span>

        Threat Intelligence

    </a>


    <a href="session-history"
       class="nav-link">

        <span class="nav-icon">
            ◌
        </span>

        Session History

    </a>


    <div class="nav-title"
         style="margin-top:24px;">

        Identity Security

    </div>


    <a href="credentials"
       class="nav-link">

        <span class="nav-icon">
            ◈
        </span>

        Credential Center

    </a>


    <div class="nav-title"
         style="margin-top:24px;">

        Account

    </div>


    <a href="change-password"
       class="nav-link">

        <span class="nav-icon">
            🔑
        </span>

        Change Password

    </a>


<%
        if ("ADMIN".equals(role)) {
%>

    <div class="nav-title"
         style="margin-top:24px;">

        Administration

    </div>


    <a href="user-management"
       class="nav-link">

        <span class="nav-icon">
            ◉
        </span>

        User Management

    </a>


    <a href="audit-logs"
       class="nav-link">

        <span class="nav-icon">
            ▤
        </span>

        Audit Logs

    </a>


    <a href="security-config"
       class="nav-link">

        <span class="nav-icon">
            ⚙
        </span>

        Security Configuration

    </a>


    <a href="system-maintenance"
       class="nav-link">

        <span class="nav-icon">
            ⚙
        </span>

        System Maintenance

    </a>


<%
        }
%>


    <div class="sidebar-bottom">

        <a href="logout"
           class="nav-link logout-link">

            <span class="nav-icon">
                ↪
            </span>

            Logout

        </a>

    </div>


<%
    }
%>

</aside>


<!-- ================= MAIN ================= -->

<main class="main">


    <!-- TOPBAR -->

    <header class="topbar">

        <div class="page-heading">

            <h1>
                My Login Activity
            </h1>

            <p>
                Monitor your account authentication history
            </p>

        </div>


        <div class="user-profile">

            <div class="user-avatar">

                <%= username != null
                        ? username.substring(0, 1).toUpperCase()
                        : "U" %>

            </div>


            <div class="user-info">

                <div class="user-name">
                    <%= username %>
                </div>

                <div class="user-role">
                    <%= role %>
                </div>

            </div>

        </div>

    </header>


    <!-- ================= CONTENT ================= -->

    <section class="content">


        <!-- OVERVIEW -->

        <div class="overview-card">

            <h2>
                Account Security Activity
            </h2>

            <p>
                Review your recent authentication activity,
                including successful logins, logouts, expired
                sessions and failed login attempts.
            </p>


            <div class="security-pill">

                <span class="status-dot"></span>

                Login Activity Monitoring Active

            </div>

        </div>


        <!-- SECTION HEADER -->

        <div class="section-header">

            <div class="section-title">
                Login Activity History
            </div>

            <div class="section-description">
                Recent security-related activity associated with your account.
            </div>

        </div>


        <!-- ACTIVITY CARD -->

        <div class="activity-card">


            <div class="activity-header">

                <div>

                    <h3>
                        Authentication Events
                    </h3>

                    <p>
                        Review when and from where your account was accessed.
                    </p>

                </div>


                <span class="activity-badge">
                    User Activity
                </span>

            </div>


            <div class="table-container">

<%
            if (activities != null && !activities.isEmpty()) {
%>

                <table>

                    <thead>

                        <tr>

                            <th>
                                Action
                            </th>

                            <th>
                                Description
                            </th>

                            <th>
                                Source IP
                            </th>

                            <th>
                                Date & Time
                            </th>

                        </tr>

                    </thead>


                    <tbody>

<%
                for (UserLoginActivity activity : activities) {

                    String action =
                            activity.getAction();

                    String badgeClass =
                            "logout";

                    if ("LOGIN".equalsIgnoreCase(action)) {

                        badgeClass = "login";

                    } else if ("LOGOUT".equalsIgnoreCase(action)) {

                        badgeClass = "logout";

                    } else if ("SESSION_EXPIRED".equalsIgnoreCase(action)) {

                        badgeClass = "expired";

                    } else if ("FAILED_LOGIN".equalsIgnoreCase(action)) {

                        badgeClass = "failed";

                    }
%>

                        <tr>


                            <td>

                                <span class="badge <%= badgeClass %>">

                                    <%= action %>

                                </span>

                            </td>


                            <td>

                                <div class="description">

                                    <%= activity.getDescription() != null
                                            ? activity.getDescription()
                                            : "-" %>

                                </div>

                            </td>


                            <td>

                                <span class="ip-address">

                                    <%= activity.getSourceIp() != null
                                            ? activity.getSourceIp()
                                            : "-" %>

                                </span>

                            </td>


                            <td>

                                <span class="date-time">

                                    <%= activity.getCreatedAt() != null
                                            ? activity.getCreatedAt()
                                            : "-" %>

                                </span>

                            </td>


                        </tr>

<%
                }
%>

                    </tbody>

                </table>

<%
            } else {
%>

                <div class="empty-state">

                    <div class="empty-icon">
                        ◌
                    </div>

                    <h3>
                        No Login Activity
                    </h3>

                    <p>
                        No login activity has been recorded for your account yet.
                    </p>

                </div>

<%
            }
%>

            </div>

        </div>


        <!-- FOOTER -->

        <div class="footer-actions">

            <a href="dashboard.jsp"
               class="footer-link">

                 Dashboard

            </a>


            <a href="change-password"
               class="footer-link">

                Change Password

            </a>


            <a href="logout"
               class="footer-link logout-footer">

                Logout

            </a>

        </div>


    </section>


</main>

</body>
</html>