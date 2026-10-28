<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.security.securityoperationsplatform.Incident"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Incident> incidents =
            (List<Incident>) request.getAttribute("incidents");

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

    <title>Incident Management | Security Operations Platform</title>

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

        /* ================= INTRO ================= */

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

        .investigation-pill {
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

        /* ================= INCIDENT CARDS ================= */

        .incident-list {
            display: grid;

            grid-template-columns: 1fr;

            gap: 17px;
        }

        .incident-card {
            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 12px;

            overflow: hidden;

            transition: 0.2s;
        }

        .incident-card:hover {
            border-color: #334155;
        }

        .incident-header {
            display: flex;

            align-items: center;
            justify-content: space-between;

            padding: 17px 19px;

            background: #0f172a;

            border-bottom: 1px solid #1f2937;
        }

        .incident-heading {
            display: flex;

            align-items: center;

            gap: 13px;
        }

        .incident-id {
            color: #64748b;

            font-family: monospace;

            font-size: 11px;
        }

        .incident-title {
            color: #f1f5f9;

            font-size: 14px;

            font-weight: 700;
        }

        .incident-body {
            padding: 19px;
        }

        /* ================= META ================= */

        .meta-grid {
            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 12px;

            margin-bottom: 20px;
        }

        .meta-box {
            background: #0f172a;

            border: 1px solid #1f2937;

            border-radius: 8px;

            padding: 12px;
        }

        .meta-label {
            color: #64748b;

            font-size: 9px;

            text-transform: uppercase;

            letter-spacing: 0.7px;

            margin-bottom: 6px;
        }

        .meta-value {
            color: #cbd5e1;

            font-size: 12px;

            font-weight: 600;
        }

        /* ================= BADGES ================= */

        .badge {
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

        .status-open {
            background: #3f1d1d;
            color: #f87171;
        }

        .status-investigating {
            background: #172554;
            color: #60a5fa;
        }

        .status-resolved {
            background: #052e16;
            color: #4ade80;
        }

        .status-false {
            background: #1e293b;
            color: #94a3b8;
        }

        .unassigned {
            color: #64748b;

            font-style: italic;
        }

        /* ================= INVESTIGATION ================= */

        .investigation-grid {
            display: grid;

            grid-template-columns:
                1.5fr 1fr 1fr;

            gap: 15px;

            margin-top: 5px;
        }

        .panel {
            background: #0f172a;

            border: 1px solid #1f2937;

            border-radius: 9px;

            padding: 15px;
        }

        .panel-title {
            color: #cbd5e1;

            font-size: 11px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.6px;

            margin-bottom: 11px;
        }

        .notes-display {
            min-height: 55px;

            color: #94a3b8;

            font-size: 12px;

            line-height: 1.6;

            margin-bottom: 12px;
        }

        textarea,
        input[type="text"],
        select {
            width: 100%;

            background: #111827;

            color: #cbd5e1;

            border: 1px solid #334155;

            border-radius: 6px;

            padding: 9px;

            font-family: inherit;

            font-size: 11px;

            outline: none;
        }

        textarea {
            min-height: 75px;

            resize: vertical;
        }

        textarea:focus,
        input[type="text"]:focus,
        select:focus {
            border-color: #3b82f6;
        }

        .form-button {
            margin-top: 8px;

            border: none;

            border-radius: 6px;

            padding: 8px 11px;

            background: #1d4ed8;

            color: white;

            font-size: 10px;

            font-weight: 600;

            cursor: pointer;

            transition: 0.2s;
        }

        .form-button:hover {
            background: #2563eb;
        }

        .assign-button {
            background: #334155;
        }

        .assign-button:hover {
            background: #475569;
        }

        /* ================= EMPTY ================= */

        .empty-state {
            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 12px;

            text-align: center;

            padding: 55px 20px;
        }

        .empty-icon {
            font-size: 32px;

            opacity: 0.7;

            margin-bottom: 12px;
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

        .footer-link.logout {
            color: #f87171;

            border-color: #4c1d1d;
        }

        .footer-link.logout:hover {
            background: #2b1518;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 1050px) {

            .meta-grid {
                grid-template-columns:
                    repeat(2, 1fr);
            }

            .investigation-grid {
                grid-template-columns: 1fr;
            }
        }

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
       class="nav-link">

        <span class="nav-icon">
            ⚠
        </span>

        Security Alerts

    </a>


    <a href="incidents"
       class="nav-link active">

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
                Incident Management
            </h1>

            <p>
                Investigate, assign and resolve security incidents
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
                Incident Investigation Console
            </h2>

            <p>
                Manage security incidents created from detected alerts.
                Assign analysts, record investigation findings and
                track each incident through its resolution lifecycle.
            </p>


            <div class="investigation-pill">

                <span class="status-dot"></span>

                Investigation Workflow Active

            </div>

        </div>


        <!-- INCIDENTS -->

        <div class="section-header">

            <div>

                <div class="section-title">
                    Active Security Incidents
                </div>

                <div class="section-description">
                    Review incident context, investigation notes,
                    ownership and current status.
                </div>

            </div>

        </div>


        <div class="incident-list">


        <%
            if (incidents != null && !incidents.isEmpty()) {

                for (Incident incident : incidents) {

                    String severity =
                            incident.getSeverity();

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


                    String status =
                            incident.getStatus();

                    String statusClass =
                            "status-open";

                    if ("INVESTIGATING".equalsIgnoreCase(status)) {
                        statusClass =
                                "status-investigating";
                    } else if ("RESOLVED".equalsIgnoreCase(status)) {
                        statusClass =
                                "status-resolved";
                    } else if ("FALSE_POSITIVE".equalsIgnoreCase(status)) {
                        statusClass =
                                "status-false";
                    }
        %>


            <!-- INCIDENT CARD -->

            <div class="incident-card">


                <!-- HEADER -->

                <div class="incident-header">

                    <div class="incident-heading">

                        <span class="incident-id">

                            #<%= incident.getId() %>

                        </span>

                        <span class="incident-title">

                            <%= incident.getTitle() %>

                        </span>

                    </div>


                    <span class="badge <%= severityClass %>">

                        <%= severity %>

                    </span>

                </div>


                <!-- BODY -->

                <div class="incident-body">


                    <!-- META -->

                    <div class="meta-grid">


                        <div class="meta-box">

                            <div class="meta-label">
                                Source Alert
                            </div>

                            <div class="meta-value">

                                #<%= incident.getAlertId() %>

                            </div>

                        </div>


                        <div class="meta-box">

                            <div class="meta-label">
                                Assigned Analyst
                            </div>

                            <div class="meta-value">

                                <%
                                    if (incident.getAssignedTo() != null
                                            && !incident.getAssignedTo().isBlank()) {
                                %>

                                    <%= incident.getAssignedTo() %>

                                <%
                                    } else {
                                %>

                                    <span class="unassigned">
                                        Unassigned
                                    </span>

                                <%
                                    }
                                %>

                            </div>

                        </div>


                        <div class="meta-box">

                            <div class="meta-label">
                                Current Status
                            </div>

                            <div>

                                <span class="badge <%= statusClass %>">

                                    <%= status.replace("_", " ") %>

                                </span>

                            </div>

                        </div>


                        <div class="meta-box">

                            <div class="meta-label">
                                Severity
                            </div>

                            <div>

                                <span class="badge <%= severityClass %>">

                                    <%= severity %>

                                </span>

                            </div>

                        </div>

                    </div>


                    <!-- INVESTIGATION PANELS -->

                    <div class="investigation-grid">


                        <!-- NOTES -->

                        <div class="panel">

                            <div class="panel-title">
                                Investigation Notes
                            </div>


                            <div class="notes-display">

                                <%
                                    if (incident.getInvestigationNotes() != null
                                            && !incident.getInvestigationNotes().isBlank()) {
                                %>

                                    <%= incident.getInvestigationNotes() %>

                                <%
                                    } else {
                                %>

                                    No investigation notes have been
                                    recorded for this incident.

                                <%
                                    }
                                %>

                            </div>


                            <form
                                action="incident-notes"
                                method="post">

                                <input
                                    type="hidden"
                                    name="incidentId"
                                    value="<%= incident.getId() %>"
                                >


                                <textarea
                                    name="notes"
                                    placeholder="Enter investigation findings..."
                                    required></textarea>


                                <button
                                    type="submit"
                                    class="form-button">

                                    Save Investigation Notes

                                </button>

                            </form>

                        </div>


                        <!-- STATUS -->

                        <div class="panel">

                            <div class="panel-title">
                                Incident Status
                            </div>


                            <form
                                action="update-incident"
                                method="post">

                                <input
                                    type="hidden"
                                    name="incidentId"
                                    value="<%= incident.getId() %>"
                                >


                                <select name="status">

                                    <option value="OPEN"
                                        <%= "OPEN".equals(incident.getStatus())
                                                ? "selected" : "" %>>
                                        OPEN
                                    </option>


                                    <option value="INVESTIGATING"
                                        <%= "INVESTIGATING".equals(incident.getStatus())
                                                ? "selected" : "" %>>
                                        INVESTIGATING
                                    </option>


                                    <option value="RESOLVED"
                                        <%= "RESOLVED".equals(incident.getStatus())
                                                ? "selected" : "" %>>
                                        RESOLVED
                                    </option>


                                    <option value="FALSE_POSITIVE"
                                        <%= "FALSE_POSITIVE".equals(incident.getStatus())
                                                ? "selected" : "" %>>
                                        FALSE POSITIVE
                                    </option>

                                </select>


                                <button
                                    type="submit"
                                    class="form-button">

                                    Update Status

                                </button>

                            </form>

                        </div>


                        <!-- ASSIGNMENT -->

                        <div class="panel">

                            <div class="panel-title">
                                Analyst Assignment
                            </div>


                            <form
                                action="assign-incident"
                                method="post">

                                <input
                                    type="hidden"
                                    name="incidentId"
                                    value="<%= incident.getId() %>"
                                >


                                <input
                                    type="text"
                                    name="analyst"
                                    placeholder="Analyst username"
                                    value="<%= incident.getAssignedTo() != null
                                            ? incident.getAssignedTo()
                                            : "" %>"
                                    required
                                >


                                <button
                                    type="submit"
                                    class="form-button assign-button">

                                    Assign Analyst

                                </button>

                            </form>

                        </div>


                    </div>


                </div>

            </div>


        <%
                }

            } else {
        %>


            <!-- EMPTY STATE -->

            <div class="empty-state">

                <div class="empty-icon">
                    ✓
                </div>

                <h3>
                    No Security Incidents
                </h3>

                <p>
                    No incidents have been created from security alerts yet.
                </p>

            </div>


        <%
            }
        %>


        </div>


        <!-- FOOTER -->

        <div class="footer-actions">

            <a
                href="dashboard.jsp"
                class="footer-link">

                ← Back to Dashboard

            </a>


            <a
                href="alerts"
                class="footer-link">

                ← Security Alerts

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