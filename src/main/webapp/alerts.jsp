<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.security.securityoperationsplatform.Alert"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Alert> alerts =
            (List<Alert>) request.getAttribute("alerts");

    String username =
            (String) session.getAttribute("username");

    String role =
            (String) session.getAttribute("role");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Security Alerts | Security Operations Platform</title>

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

            font-size: 19px;
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
        }

        .monitoring-pill {
            display: inline-flex;

            align-items: center;

            gap: 7px;

            margin-top: 15px;

            padding: 6px 11px;

            border-radius: 20px;

            background: #0f2a20;

            border: 1px solid #14532d;

            color: #4ade80;

            font-size: 11px;

            font-weight: 600;
        }

        .status-dot {
            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: #22c55e;
        }

        /* ================= SECTION HEADER ================= */

        .section-header {
            display: flex;

            align-items: center;
            justify-content: space-between;

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

        /* ================= ALERT TABLE ================= */

        .table-container {
            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 12px;

            overflow-x: auto;
        }

        table {
            width: 100%;

            min-width: 1200px;

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
            padding: 15px;

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

        .alert-id {
            color: #64748b;

            font-family: monospace;

            font-size: 11px;
        }

        .alert-title {
            color: #f1f5f9;

            font-weight: 600;

            line-height: 1.4;
        }

        .description {
            color: #94a3b8;

            line-height: 1.5;

            max-width: 320px;
        }

        .source-ip {
            color: #93c5fd;

            font-family: monospace;

            font-size: 11px;

            white-space: nowrap;
        }

        /* ================= SEVERITY ================= */

        .severity {
            display: inline-flex;

            padding: 5px 9px;

            border-radius: 6px;

            font-size: 10px;

            font-weight: 700;

            letter-spacing: 0.3px;
        }

        .severity-critical {
            background: #450a0a;
            color: #fca5a5;
        }

        .severity-high {
            background: #451a03;
            color: #fb923c;
        }

        .severity-medium {
            background: #422006;
            color: #facc15;
        }

        .severity-low {
            background: #052e16;
            color: #4ade80;
        }

        /* ================= STATUS ================= */

        .status-form {
            display: flex;

            align-items: center;

            gap: 6px;
        }

        select {
            background: #0f172a;

            color: #cbd5e1;

            border: 1px solid #334155;

            border-radius: 6px;

            padding: 7px 8px;

            font-size: 11px;

            outline: none;
        }

        select:focus {
            border-color: #3b82f6;
        }

        .update-btn {
            border: none;

            border-radius: 6px;

            padding: 7px 10px;

            background: #1d4ed8;

            color: white;

            font-size: 10px;

            font-weight: 600;

            cursor: pointer;

            transition: 0.2s;
        }

        .update-btn:hover {
            background: #2563eb;
        }

        /* ================= INCIDENT ================= */

        .incident-btn {
            border: none;

            border-radius: 6px;

            padding: 8px 11px;

            background: #172554;

            border: 1px solid #1e40af;

            color: #60a5fa;

            font-size: 10px;

            font-weight: 600;

            cursor: pointer;

            transition: 0.2s;
        }

        .incident-btn:hover {
            background: #1e3a8a;

            color: #bfdbfe;
        }

        /* ================= EMPTY STATE ================= */

        .empty-state {
            text-align: center;

            padding: 55px 20px;

            color: #64748b;
        }

        .empty-icon {
            font-size: 32px;

            margin-bottom: 12px;

            opacity: 0.7;
        }

        .empty-state h3 {
            color: #94a3b8;

            font-size: 15px;

            margin-bottom: 5px;
        }

        .empty-state p {
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

        .footer-link.logout {
            color: #f87171;

            border-color: #4c1d1d;
        }

        .footer-link.logout:hover {
            background: #2b1518;
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
       class="nav-link active">

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


    <a href="iocs"
       class="nav-link">

        <span class="nav-icon">
            ◈
        </span>

        Threat Intelligence

    </a>


    <a href="sessions"
       class="nav-link">

        <span class="nav-icon">
            ◌
        </span>

        Session History

    </a>


    <%
        if ("ADMIN".equals(role)) {
    %>

    <div class="nav-title"
         style="margin-top:24px;">

        Administration

    </div>


    <a href="admin.jsp"
       class="nav-link">

        <span class="nav-icon">
            ⚙
        </span>

        Admin Panel

    </a>


    <a href="audit-logs"
       class="nav-link">

        <span class="nav-icon">
            ▤
        </span>

        Audit Logs

    </a>

    <%
        }
    %>


    <div class="sidebar-bottom">

        <a href="change-password.jsp"
           class="nav-link">

            <span class="nav-icon">
                🔑
            </span>

            Change Password

        </a>


        <a href="logout"
           class="nav-link logout-link">

            <span class="nav-icon">
                ↪
            </span>

            Logout

        </a>

    </div>

</aside>


<!-- ================= MAIN ================= -->

<main class="main">


    <!-- TOPBAR -->

    <header class="topbar">

        <div class="page-heading">

            <h1>
                Security Alerts
            </h1>

            <p>
                Monitor, investigate and manage detected security threats
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
                Security Alert Console
            </h2>

            <p>
                Review alerts generated by the platform's detection engine,
                update their investigation status and create incidents
                when further investigation is required.
            </p>


            <div class="monitoring-pill">

                <span class="status-dot"></span>

                Detection Monitoring Active

            </div>

        </div>


        <!-- ALERT LIST -->

        <div class="section-header">

            <div>

                <div class="section-title">
                    Detected Security Alerts
                </div>

                <div class="section-description">
                    Security events requiring analyst attention or investigation.
                </div>

            </div>

        </div>


        <div class="table-container">

            <table>

                <thead>

                    <tr>

                        <th>ID</th>

                        <th>Alert</th>

                        <th>Description</th>

                        <th>Severity</th>

                        <th>Source IP</th>

                        <th>Status</th>

                        <th>Incident</th>

                    </tr>

                </thead>


                <tbody>


                <%
                    if (alerts != null && !alerts.isEmpty()) {

                        for (Alert alert : alerts) {

                            String severity =
                                    alert.getSeverity();

                            String severityClass =
                                    "severity-medium";

                            if ("CRITICAL".equalsIgnoreCase(severity)) {
                                severityClass =
                                        "severity-critical";
                            } else if ("HIGH".equalsIgnoreCase(severity)) {
                                severityClass =
                                        "severity-high";
                            } else if ("LOW".equalsIgnoreCase(severity)) {
                                severityClass =
                                        "severity-low";
                            }
                %>


                    <tr>


                        <!-- ID -->

                        <td>

                            <span class="alert-id">

                                #<%= alert.getId() %>

                            </span>

                        </td>


                        <!-- TITLE -->

                        <td>

                            <div class="alert-title">

                                <%= alert.getTitle() %>

                            </div>

                        </td>


                        <!-- DESCRIPTION -->

                        <td>

                            <div class="description">

                                <%= alert.getDescription() %>

                            </div>

                        </td>


                        <!-- SEVERITY -->

                        <td>

                            <span class="severity <%= severityClass %>">

                                <%= severity %>

                            </span>

                        </td>


                        <!-- SOURCE IP -->

                        <td>

                            <span class="source-ip">

                                <%= alert.getSourceIp() %>

                            </span>

                        </td>


                        <!-- STATUS -->

                        <td>

                            <form
                                action="update-alert"
                                method="post"
                                class="status-form">

                                <input
                                    type="hidden"
                                    name="alertId"
                                    value="<%= alert.getId() %>"
                                >


                                <select name="status">

                                    <option value="OPEN"
                                        <%= "OPEN".equals(alert.getStatus())
                                                ? "selected" : "" %>>
                                        OPEN
                                    </option>


                                    <option value="INVESTIGATING"
                                        <%= "INVESTIGATING".equals(alert.getStatus())
                                                ? "selected" : "" %>>
                                        INVESTIGATING
                                    </option>


                                    <option value="RESOLVED"
                                        <%= "RESOLVED".equals(alert.getStatus())
                                                ? "selected" : "" %>>
                                        RESOLVED
                                    </option>


                                    <option value="FALSE_POSITIVE"
                                        <%= "FALSE_POSITIVE".equals(alert.getStatus())
                                                ? "selected" : "" %>>
                                        FALSE POSITIVE
                                    </option>

                                </select>


                                <button
                                    type="submit"
                                    class="update-btn">

                                    Update

                                </button>

                            </form>

                        </td>


                        <!-- INCIDENT -->

                        <td>

                            <form
                                action="create-incident"
                                method="post"
                                onsubmit="return confirm(
                                    'Create an incident from this security alert?'
                                );">

                                <input
                                    type="hidden"
                                    name="alertId"
                                    value="<%= alert.getId() %>"
                                >


                                <button
                                    type="submit"
                                    class="incident-btn">

                                    Create Incident

                                </button>

                            </form>

                        </td>


                    </tr>


                <%
                        }

                    } else {
                %>


                    <tr>

                        <td colspan="7">

                            <div class="empty-state">

                                <div class="empty-icon">
                                    ✓
                                </div>

                                <h3>
                                    No Security Alerts
                                </h3>

                                <p>
                                    The platform has not detected any
                                    active security alerts.
                                </p>

                            </div>

                        </td>

                    </tr>


                <%
                    }
                %>


                </tbody>

            </table>

        </div>


        <!-- FOOTER -->

        <div class="footer-actions">

            <a
                href="dashboard.jsp"
                class="footer-link">

                ← Back to Dashboard

            </a>


            <a
                href="logout"
                class="footer-link logout">

                Logout

            </a>

        </div>


    </section>

</main>

</body>

</html>