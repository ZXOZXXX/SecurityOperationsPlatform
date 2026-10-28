<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username =
            (String) session.getAttribute("username");

    String role =
            (String) session.getAttribute("role");

    if (!"ADMIN".equals(role)) {
        response.sendError(
                403,
                "Access Denied: Admin role required."
        );
        return;
    }

    String success =
            request.getParameter("success");

    String error =
            request.getParameter("error");

    String sessionSuccess =
            request.getParameter("sessionSuccess");

    String sessionError =
            request.getParameter("sessionError");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        System Maintenance | Security Operations Platform
    </title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;

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

            font-size: 17px;
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

            max-width: 1200px;
        }

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

        .admin-pill {
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

        /* ================= MAINTENANCE GRID ================= */

        .maintenance-grid {
            display: grid;

            grid-template-columns:
                repeat(2, minmax(0, 1fr));

            gap: 20px;
        }

        .maintenance-card {
            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 14px;

            padding: 23px;

            position: relative;
        }

        .maintenance-card:hover {
            border-color: #334155;
        }

        .card-icon {
            width: 42px;
            height: 42px;

            display: flex;

            align-items: center;
            justify-content: center;

            border-radius: 10px;

            margin-bottom: 16px;

            font-size: 19px;

            background: #172554;

            border: 1px solid #1e40af;

            color: #60a5fa;
        }

        .danger-card .card-icon {
            background: #2b1518;

            border-color: #7f1d1d;

            color: #f87171;
        }

        .maintenance-card h3 {
            color: #f1f5f9;

            font-size: 16px;

            margin-bottom: 8px;
        }

        .maintenance-card > p {
            color: #94a3b8;

            font-size: 12px;

            line-height: 1.6;

            margin-bottom: 17px;
        }

        /* ================= DATA LIST ================= */

        .data-box {
            background: #0f172a;

            border: 1px solid #1f2937;

            border-radius: 9px;

            padding: 14px;

            margin-bottom: 18px;
        }

        .data-title {
            color: #cbd5e1;

            font-size: 11px;

            font-weight: 700;

            margin-bottom: 9px;
        }

        .data-list {
            list-style: none;
        }

        .data-list li {
            display: flex;

            align-items: center;

            gap: 8px;

            color: #64748b;

            font-size: 11px;

            padding: 5px 0;
        }

        .delete-mark {
            color: #f87171;

            font-weight: bold;
        }

        .safe-mark {
            color: #4ade80;

            font-weight: bold;
        }

        /* ================= BUTTON ================= */

        .danger-button {
            width: 100%;

            border: none;

            border-radius: 8px;

            padding: 11px 15px;

            background: #991b1b;

            color: #fee2e2;

            font-size: 12px;

            font-weight: 700;

            cursor: pointer;

            transition: 0.2s;
        }

        .danger-button:hover {
            background: #b91c1c;
        }

        .danger-button.secondary {
            background: #7c2d12;

            color: #ffedd5;
        }

        .danger-button.secondary:hover {
            background: #9a3412;
        }

        /* ================= MESSAGES ================= */

        .message {
            border-radius: 8px;

            padding: 12px 14px;

            margin-bottom: 20px;

            font-size: 12px;

            font-weight: 600;
        }

        .success-message {
            background: #052e16;

            border: 1px solid #166534;

            color: #4ade80;
        }

        .error-message {
            background: #2b1518;

            border: 1px solid #7f1d1d;

            color: #f87171;
        }

        /* ================= WARNING ================= */

        .warning-box {
            margin-top: 22px;

            padding: 15px 17px;

            border-radius: 9px;

            background: #2a1b05;

            border: 1px solid #78350f;
        }

        .warning-box strong {
            color: #fb923c;

            font-size: 12px;
        }

        .warning-box p {
            color: #fdba74;

            font-size: 11px;

            line-height: 1.6;

            margin-top: 4px;
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

        @media (max-width: 900px) {

            .maintenance-grid {
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
            📊
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
            🚨
        </span>

        Incidents

    </a>


    <a href="security-events"
       class="nav-link">

        <span class="nav-icon">
            🔍
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
            🖥
        </span>

        Session History

    </a>


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
            📋
        </span>

        Audit Logs

    </a>


    <a href="system-maintenance"
       class="nav-link active">

        <span class="nav-icon">
            🔧
        </span>

        System Maintenance

    </a>


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
                System Maintenance
            </h1>

            <p>
                Administrative tools for controlled security data cleanup
            </p>

        </div>


        <div class="user-profile">


            <div class="user-avatar">

                <%= username != null
                        ? username.substring(0, 1).toUpperCase()
                        : "A" %>

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
                Maintenance Console
            </h2>


            <p>
                Administrative maintenance operations for
                development, testing, and security-data cleanup.
                These operations affect stored records and should
                only be performed when required.
            </p>


            <div class="admin-pill">

                <span class="status-dot"></span>

                Administrator Access

            </div>


        </div>


        <!-- MESSAGES -->


        <%
            if ("true".equals(success)) {
        %>


            <div class="message success-message">

                Test security data was cleared successfully.

            </div>


        <%
            } else if ("failed".equals(error)) {
        %>


            <div class="message error-message">

                The security data could not be cleared.
                Please check the server logs.

            </div>


        <%
            }

            if ("true".equals(sessionSuccess)) {
        %>


            <div class="message success-message">

                Session history was cleared successfully.

            </div>


        <%
            } else if ("failed".equals(sessionError)) {
        %>


            <div class="message error-message">

                Session history could not be cleared.
                Please check the server logs.

            </div>


        <%
            }
        %>


        <!-- SECTION -->

        <div class="section-header">


            <div class="section-title">
                Data Maintenance Operations
            </div>


            <div class="section-description">
                Selective cleanup tools for security and session records.
            </div>


        </div>


        <!-- MAINTENANCE CARDS -->

        <div class="maintenance-grid">


            <!-- SECURITY DATA -->

            <div class="maintenance-card danger-card">


                <div class="card-icon">
                    🗑
                </div>


                <h3>
                    Clear Test Security Data
                </h3>


                <p>
                    Removes security records generated during
                    development and testing. User accounts,
                    IOC records, and security configuration
                    remain unchanged.
                </p>


                <div class="data-box">


                    <div class="data-title">
                        DATA THAT WILL BE DELETED
                    </div>


                    <ul class="data-list">

                        <li>
                            <span class="delete-mark">
                                -
                            </span>
                            Security Events
                        </li>

                        <li>
                            <span class="delete-mark">
                                -
                            </span>
                            Security Alerts
                        </li>

                        <li>
                            <span class="delete-mark">
                                -
                            </span>
                            Incidents
                        </li>

                        <li>
                            <span class="delete-mark">
                                -
                            </span>
                            Audit Logs
                        </li>

                    </ul>


                </div>


                <div class="data-box">


                    <div class="data-title">
                        DATA THAT WILL REMAIN
                    </div>


                    <ul class="data-list">

                        <li>
                            <span class="safe-mark">
                                +
                            </span>
                            User Accounts
                        </li>

                        <li>
                            <span class="safe-mark">
                                +
                            </span>
                            IOC Records
                        </li>

                        <li>
                            <span class="safe-mark">
                                +
                            </span>
                            Security Configuration
                        </li>

                    </ul>


                </div>


                <form
                    action="system-maintenance"
                    method="post"
                    onsubmit="return confirm(
                        'Are you sure you want to clear all test security data? This action cannot be undone.'
                    );"
                >


                    <input
                        type="hidden"
                        name="action"
                        value="clearSecurityData"
                    >


                    <button
                        type="submit"
                        class="danger-button"
                    >

                        Clear All Test Security Data

                    </button>


                </form>


            </div>


            <!-- SESSION HISTORY -->

            <div class="maintenance-card">


                <div class="card-icon">
                    🖥
                </div>


                <h3>
                    Clear Session History
                </h3>


                <p>
                    Removes stored user session history generated
                    during system operation and testing. User
                    accounts and security configuration are not affected.
                </p>


                <div class="data-box">


                    <div class="data-title">
                        DATA THAT WILL BE DELETED
                    </div>


                    <ul class="data-list">

                        <li>
                            <span class="delete-mark">
                                -
                            </span>
                            User Session History
                        </li>

                        <li>
                            <span class="delete-mark">
                                -
                            </span>
                            Login Time
                        </li>

                        <li>
                            <span class="delete-mark">
                                -
                            </span>
                            Logout Time
                        </li>

                        <li>
                            <span class="delete-mark">
                                -
                            </span>
                            Session Status
                        </li>

                    </ul>


                </div>


                <div class="data-box">


                    <div class="data-title">
                        DATA THAT WILL REMAIN
                    </div>


                    <ul class="data-list">

                        <li>
                            <span class="safe-mark">
                                +
                            </span>
                            User Accounts
                        </li>

                        <li>
                            <span class="safe-mark">
                                +
                            </span>
                            IOC Records
                        </li>

                        <li>
                            <span class="safe-mark">
                                +
                            </span>
                            Security Configuration
                        </li>

                    </ul>


                </div>


                <form
                    action="system-maintenance"
                    method="post"
                    onsubmit="return confirm(
                        'Are you sure you want to clear all session history? This action cannot be undone.'
                    );"
                >


                    <input
                        type="hidden"
                        name="action"
                        value="clearSessions"
                    >


                    <button
                        type="submit"
                        class="danger-button secondary"
                    >

                        Clear Session History

                    </button>


                </form>


            </div>


        </div>


        <!-- WARNING -->

        <div class="warning-box">

            <strong>
                Administrative Warning
            </strong>

            <p>
                These operations permanently remove records from
                the database. Use them only for controlled testing
                or maintenance. Export or preserve important
                security records before clearing them.
            </p>

        </div>


        <!-- FOOTER -->

        <div class="footer-actions">


            <a
                href="admin.jsp"
                class="footer-link">

                Back to Admin Panel

            </a>


            <a
                href="audit-logs"
                class="footer-link">

                Audit Logs

            </a>


            <a
                href="dashboard.jsp"
                class="footer-link">

                Dashboard

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