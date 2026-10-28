<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.security.securityoperationsplatform.IOC"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<IOC> iocs =
            (List<IOC>) request.getAttribute("iocs");

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

    <title>Threat Intelligence | Security Operations Platform</title>

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

            max-width: 850px;
        }

        .intel-pill {
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

        /* ================= ADD IOC ================= */

        .add-ioc-card {
            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 12px;

            padding: 22px;

            margin-bottom: 28px;
        }

        .add-header {
            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 18px;
        }

        .add-header h3 {
            color: #f1f5f9;

            font-size: 15px;
        }

        .access-badge {
            padding: 5px 9px;

            border-radius: 6px;

            background: #052e16;

            border: 1px solid #14532d;

            color: #4ade80;

            font-size: 9px;

            font-weight: 700;

            text-transform: uppercase;
        }

        .ioc-form-grid {
            display: grid;

            grid-template-columns:
                repeat(2, 1fr);

            gap: 15px;
        }

        .form-group {
            display: flex;

            flex-direction: column;

            gap: 7px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        label {
            color: #94a3b8;

            font-size: 10px;

            font-weight: 600;

            text-transform: uppercase;

            letter-spacing: 0.5px;
        }

        input,
        select,
        textarea {
            width: 100%;

            background: #0f172a;

            color: #cbd5e1;

            border: 1px solid #334155;

            border-radius: 7px;

            padding: 10px 11px;

            font-family: inherit;

            font-size: 12px;

            outline: none;
        }

        textarea {
            min-height: 80px;

            resize: vertical;
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: #3b82f6;
        }

        .add-button {
            margin-top: 15px;

            padding: 10px 17px;

            border: none;

            border-radius: 7px;

            background: #1d4ed8;

            color: white;

            font-size: 11px;

            font-weight: 700;

            cursor: pointer;

            transition: 0.2s;
        }

        .add-button:hover {
            background: #2563eb;
        }

        /* ================= IOC TABLE ================= */

        .table-container {
            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 12px;

            overflow-x: auto;
        }

        table {
            width: 100%;

            min-width: 1050px;

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

        .ioc-id {
            color: #64748b;

            font-family: monospace;

            font-size: 11px;
        }

        .ioc-type {
            display: inline-flex;

            padding: 5px 8px;

            border-radius: 5px;

            background: #1e293b;

            border: 1px solid #334155;

            color: #cbd5e1;

            font-size: 9px;

            font-weight: 700;
        }

        .ioc-value {
            color: #93c5fd;

            font-family: monospace;

            font-size: 11px;

            word-break: break-all;
        }

        /* ================= THREAT BADGES ================= */

        .badge {
            display: inline-flex;

            padding: 5px 9px;

            border-radius: 6px;

            font-size: 9px;

            font-weight: 700;
        }

        .critical {
            background: #450a0a;

            color: #fca5a5;
        }

        .high {
            background: #451a03;

            color: #fb923c;
        }

        .medium {
            background: #422006;

            color: #facc15;
        }

        .low {
            background: #052e16;

            color: #4ade80;
        }

        .active {
            background: #052e16;

            color: #4ade80;
        }

        .inactive {
            background: #1e293b;

            color: #94a3b8;
        }

        .source {
            color: #94a3b8;

            font-size: 11px;
        }

        .description {
            color: #94a3b8;

            line-height: 1.5;

            max-width: 320px;
        }

        /* ================= EMPTY ================= */

        .empty-state {
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

        .logout {
            color: #f87171;

            border-color: #4c1d1d;
        }

        .logout:hover {
            background: #2b1518;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 850px) {

            .ioc-form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full {
                grid-column: auto;
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
       class="nav-link active">

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
                Threat Intelligence
            </h1>

            <p>
                Monitor and manage indicators of compromise
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
                Indicators of Compromise
            </h2>

            <p>
                Manage known malicious or suspicious indicators
                used by the detection engine to identify potentially
                harmful login activity and other security events.
            </p>


            <div class="intel-pill">

                <span class="status-dot"></span>

                Threat Intelligence Monitoring Active

            </div>

        </div>


        <%
            if ("ANALYST".equals(role)
                    || "ADMIN".equals(role)) {
        %>


        <!-- ================= ADD IOC ================= -->

        <div class="section-header">

            <div class="section-title">
                IOC Management
            </div>

            <div class="section-description">
                Add an indicator to the active threat intelligence database.
            </div>

        </div>


        <div class="add-ioc-card">


            <div class="add-header">

                <h3>
                    Add New Indicator
                </h3>

                <span class="access-badge">
                    Analyst / Admin
                </span>

            </div>


            <form action="create-ioc"
                  method="post">


                <div class="ioc-form-grid">


                    <!-- IOC TYPE -->

                    <div class="form-group">

                        <label>
                            IOC Type
                        </label>

                        <select name="iocType"
                                required>

                            <option value="IP">
                                IP Address
                            </option>

                            <option value="DOMAIN">
                                Domain
                            </option>

                            <option value="URL">
                                URL
                            </option>

                            <option value="HASH">
                                File Hash
                            </option>

                        </select>

                    </div>


                    <!-- THREAT LEVEL -->

                    <div class="form-group">

                        <label>
                            Threat Level
                        </label>

                        <select name="threatLevel"
                                required>

                            <option value="LOW">
                                LOW
                            </option>

                            <option value="MEDIUM">
                                MEDIUM
                            </option>

                            <option value="HIGH">
                                HIGH
                            </option>

                            <option value="CRITICAL">
                                CRITICAL
                            </option>

                        </select>

                    </div>


                    <!-- IOC VALUE -->

                    <div class="form-group">

                        <label>
                            IOC Value
                        </label>

                        <input
                            type="text"
                            name="iocValue"
                            placeholder="e.g. 192.168.1.100"
                            required
                        >

                    </div>


                    <!-- SOURCE -->

                    <div class="form-group">

                        <label>
                            Intelligence Source
                        </label>

                        <input
                            type="text"
                            name="source"
                            placeholder="e.g. Internal Investigation"
                        >

                    </div>


                    <!-- DESCRIPTION -->

                    <div class="form-group full">

                        <label>
                            Description
                        </label>

                        <textarea
                            name="description"
                            placeholder="Describe the indicator and why it is considered suspicious..."
                        ></textarea>

                    </div>


                </div>


                <button
                    type="submit"
                    class="add-button">

                    + Add Indicator

                </button>


            </form>

        </div>


        <%
            }
        %>


        <!-- ================= IOC LIST ================= -->

        <div class="section-header">

            <div class="section-title">
                IOC Database
            </div>

            <div class="section-description">
                Active and historical indicators available to the detection engine.
            </div>

        </div>


        <div class="table-container">

            <table>

                <thead>

                    <tr>

                        <th>ID</th>

                        <th>IOC Type</th>

                        <th>IOC Value</th>

                        <th>Threat Level</th>

                        <th>Status</th>

                        <th>Source</th>

                        <th>Description</th>

                    </tr>

                </thead>


                <tbody>


                <%
                    if (iocs != null && !iocs.isEmpty()) {

                        for (IOC ioc : iocs) {

                            String threatLevel =
                                    ioc.getThreatLevel();

                            String threatClass =
                                    "medium";

                            if ("CRITICAL".equalsIgnoreCase(threatLevel)) {
                                threatClass = "critical";
                            } else if ("HIGH".equalsIgnoreCase(threatLevel)) {
                                threatClass = "high";
                            } else if ("LOW".equalsIgnoreCase(threatLevel)) {
                                threatClass = "low";
                            }


                            String iocStatus =
                                    ioc.getStatus();

                            String statusClass =
                                    "active";

                            if (!"ACTIVE".equalsIgnoreCase(iocStatus)) {
                                statusClass = "inactive";
                            }
                %>


                    <tr>


                        <td>

                            <span class="ioc-id">

                                #<%= ioc.getId() %>

                            </span>

                        </td>


                        <td>

                            <span class="ioc-type">

                                <%= ioc.getIocType() %>

                            </span>

                        </td>


                        <td>

                            <span class="ioc-value">

                                <%= ioc.getIocValue() %>

                            </span>

                        </td>


                        <td>

                            <span class="badge <%= threatClass %>">

                                <%= threatLevel %>

                            </span>

                        </td>


                        <td>

                            <span class="badge <%= statusClass %>">

                                <%= iocStatus %>

                            </span>

                        </td>


                        <td>

                            <span class="source">

                                <%= ioc.getSource() != null
                                        ? ioc.getSource()
                                        : "-" %>

                            </span>

                        </td>


                        <td>

                            <div class="description">

                                <%= ioc.getDescription() != null
                                        ? ioc.getDescription()
                                        : "No description provided." %>

                            </div>

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
                                    ◈
                                </div>

                                <h3>
                                    No IOC Records
                                </h3>

                                <p>
                                    No indicators of compromise are
                                    currently available.
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


        <!-- ================= FOOTER ================= -->

        <div class="footer-actions">

            <a
                href="dashboard.jsp"
                class="footer-link">

                ← Back to Dashboard

            </a>


            <a
                href="security-events"
                class="footer-link">

                Security Events →

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