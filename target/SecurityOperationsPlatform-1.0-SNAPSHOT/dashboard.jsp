<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.security.securityoperationsplatform.DashboardDAO"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");

    /*
     * Security statistics are required only for
     * ANALYST and ADMIN dashboards.
     */
    int totalAlerts = 0;
    int openAlerts = 0;
    int totalIncidents = 0;
    int openIncidents = 0;
    int highCriticalAlerts = 0;

    if ("ANALYST".equals(role) || "ADMIN".equals(role)) {

        DashboardDAO dashboardDAO = new DashboardDAO();

        totalAlerts = dashboardDAO.getTotalAlerts();
        openAlerts = dashboardDAO.getOpenAlerts();
        totalIncidents = dashboardDAO.getTotalIncidents();
        openIncidents = dashboardDAO.getOpenIncidents();
        highCriticalAlerts = dashboardDAO.getHighCriticalAlerts();
    }

    System.out.println("Dashboard username: " + username);
    System.out.println("Dashboard role: " + role);
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        <%= "USER".equals(role)
                ? "Personal Security Dashboard"
                : "Security Operations Dashboard" %>
    </title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;

            background:
                radial-gradient(
                    circle at 15% 10%,
                    rgba(37, 99, 235, 0.14),
                    transparent 28%
                ),
                radial-gradient(
                    circle at 85% 85%,
                    rgba(14, 165, 233, 0.08),
                    transparent 30%
                ),
                #020617;

            color: #e5e7eb;
            min-height: 100vh;
        }

        body::before {
            content: "";

            position: fixed;
            inset: 0;

            background-image:
                linear-gradient(
                    rgba(59, 130, 246, 0.025) 1px,
                    transparent 1px
                ),
                linear-gradient(
                    90deg,
                    rgba(59, 130, 246, 0.025) 1px,
                    transparent 1px
                );

            background-size: 45px 45px;

            pointer-events: none;
            z-index: -1;
        }


        /* =========================
           SIDEBAR
           ========================= */

        .sidebar {

            position: fixed;

            left: 0;
            top: 0;
            bottom: 0;

            width: 255px;

            background:
                rgba(7, 15, 30, 0.96);

            border-right:
                1px solid rgba(148, 163, 184, 0.10);

            padding: 24px 14px;

            z-index: 10;

            backdrop-filter: blur(14px);
        }


        .logo {

            padding: 4px 12px 24px;

            border-bottom:
                1px solid rgba(148, 163, 184, 0.10);

            margin-bottom: 24px;
        }


        .logo-title {

            display: flex;

            align-items: center;

            gap: 9px;

            color: #ffffff;

            font-size: 19px;

            font-weight: bold;

            letter-spacing: -0.3px;
        }


        .logo-icon {

            width: 34px;
            height: 34px;

            display: flex;

            align-items: center;
            justify-content: center;

            border-radius: 9px;

            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #0891b2
                );

            box-shadow:
                0 6px 20px
                rgba(37, 99, 235, 0.25);
        }


        .logo p {

            color: #64748b;

            font-size: 10px;

            margin-top: 8px;

            padding-left: 43px;
        }


        .nav-title {

            color: #475569;

            font-size: 10px;

            text-transform: uppercase;

            letter-spacing: 1.3px;

            padding: 0 12px;

            margin-bottom: 9px;
        }


        .nav a {

            display: flex;

            align-items: center;

            gap: 10px;

            text-decoration: none;

            color: #94a3b8;

            padding: 11px 12px;

            border-radius: 8px;

            margin-bottom: 4px;

            font-size: 13px;

            transition:
                background 0.2s,
                color 0.2s,
                transform 0.2s;
        }


        .nav-icon {

            width: 18px;

            text-align: center;

            font-size: 14px;
        }


        .nav a:hover {

            color: #ffffff;

            background:
                rgba(59, 130, 246, 0.10);

            transform: translateX(3px);
        }


        .nav a.active {

            color: #ffffff;

            background:
                linear-gradient(
                    90deg,
                    rgba(37, 99, 235, 0.24),
                    rgba(37, 99, 235, 0.05)
                );

            border-left:
                3px solid #3b82f6;

            box-shadow:
                inset 0 0 18px
                rgba(37, 99, 235, 0.04);
        }


        .sidebar-bottom {

            position: absolute;

            left: 14px;
            right: 14px;

            bottom: 18px;

            padding-top: 14px;

            border-top:
                1px solid rgba(148, 163, 184, 0.10);
        }


        .sidebar-bottom a {

            display: flex;

            align-items: center;

            gap: 10px;

            color: #94a3b8;

            text-decoration: none;

            font-size: 13px;

            padding: 9px 12px;

            border-radius: 8px;

            transition: 0.2s;
        }


        .sidebar-bottom a:hover {

            color: #f87171;

            background:
                rgba(239, 68, 68, 0.07);
        }


        /* =========================
           MAIN
           ========================= */

        .main {

            margin-left: 255px;

            padding: 30px 32px;

            min-height: 100vh;

            max-width: 1700px;
        }


        /* =========================
           TOPBAR
           ========================= */

        .topbar {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 24px;
        }


        .page-title h1 {

            font-size: 27px;

            color: #ffffff;

            letter-spacing: -0.5px;

            margin-bottom: 5px;
        }


        .page-title p {

            color: #64748b;

            font-size: 12px;
        }


        .user-info {

            display: flex;

            align-items: center;

            gap: 12px;

            padding: 7px 9px 7px 14px;

            background:
                rgba(15, 23, 42, 0.70);

            border:
                1px solid rgba(148, 163, 184, 0.10);

            border-radius: 10px;
        }


        .user-details {

            text-align: right;
        }


        .user-details strong {

            display: block;

            color: #ffffff;

            font-size: 12px;

            margin-bottom: 3px;
        }


        .user-details span {

            display: inline-block;

            color: #60a5fa;

            font-size: 9px;

            text-transform: uppercase;

            letter-spacing: 0.8px;

            font-weight: bold;
        }


        .user-avatar {

            width: 37px;
            height: 37px;

            border-radius: 9px;

            display: flex;

            align-items: center;
            justify-content: center;

            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #0891b2
                );

            color: white;

            font-size: 13px;

            font-weight: bold;

            box-shadow:
                0 5px 15px
                rgba(37, 99, 235, 0.20);
        }


        /* =========================
           SYSTEM STATUS
           ========================= */

        .system-status {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            padding: 6px 10px;

            margin-bottom: 18px;

            border:
                1px solid rgba(34, 197, 94, 0.16);

            border-radius: 20px;

            background:
                rgba(34, 197, 94, 0.06);

            color: #86efac;

            font-size: 10px;

            text-transform: uppercase;

            letter-spacing: 0.8px;

            font-weight: bold;
        }


        .status-dot {

            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: #22c55e;

            box-shadow:
                0 0 8px
                rgba(34, 197, 94, 0.8);
        }


        /* =========================
           WELCOME
           ========================= */

        .welcome {

            position: relative;

            overflow: hidden;

            background:
                linear-gradient(
                    135deg,
                    rgba(37, 99, 235, 0.17),
                    rgba(8, 145, 178, 0.07)
                );

            border:
                1px solid rgba(59, 130, 246, 0.16);

            border-radius: 14px;

            padding: 23px;

            margin-bottom: 27px;
        }


        .welcome::after {

            content: "SECURITY";

            position: absolute;

            right: 25px;
            top: 50%;

            transform: translateY(-50%);

            font-size: 48px;

            font-weight: bold;

            color: rgba(255,255,255,0.025);

            letter-spacing: 4px;

            pointer-events: none;
        }


        .welcome h2 {

            color: #ffffff;

            font-size: 18px;

            margin-bottom: 7px;

            position: relative;

            z-index: 1;
        }


        .welcome p {

            color: #94a3b8;

            font-size: 12px;

            position: relative;

            z-index: 1;
        }


        /* =========================
           SECTION TITLE
           ========================= */

        .section-title {

            display: flex;

            align-items: center;

            gap: 9px;

            font-size: 15px;

            color: #e2e8f0;

            margin-bottom: 13px;
        }


        .section-title::before {

            content: "";

            width: 3px;
            height: 17px;

            border-radius: 5px;

            background:
                linear-gradient(
                    #3b82f6,
                    #06b6d4
                );
        }


        /* =========================
           STAT CARDS
           ========================= */

        .stats {

            display: grid;

            grid-template-columns:
                repeat(5, 1fr);

            gap: 13px;

            margin-bottom: 30px;
        }


        .stat-card {

            position: relative;

            overflow: hidden;

            background:
                rgba(15, 23, 42, 0.76);

            border:
                1px solid rgba(148, 163, 184, 0.09);

            border-radius: 12px;

            padding: 18px;

            transition:
                transform 0.2s,
                border-color 0.2s,
                box-shadow 0.2s;
        }


        .stat-card::before {

            content: "";

            position: absolute;

            left: 0;
            top: 0;

            width: 100%;
            height: 2px;

            background:
                rgba(59, 130, 246, 0.35);
        }


        .stat-card:hover {

            transform: translateY(-3px);

            border-color:
                rgba(59, 130, 246, 0.28);

            box-shadow:
                0 12px 30px
                rgba(0, 0, 0, 0.22);
        }


        .stat-label {

            color: #64748b;

            font-size: 9px;

            letter-spacing: 1px;

            font-weight: bold;

            margin-bottom: 10px;
        }


        .stat-number {

            color: #ffffff;

            font-size: 27px;

            font-weight: bold;

            line-height: 1;
        }


        .stat-sub {

            color: #475569;

            font-size: 9px;

            margin-top: 9px;
        }


        .stat-card.open::before {
            background: #f59e0b;
        }


        .stat-card.open .stat-number {
            color: #fbbf24;
        }


        .stat-card.incident::before {
            background: #8b5cf6;
        }


        .stat-card.incident .stat-number {
            color: #a78bfa;
        }


        .stat-card.danger::before {
            background: #ef4444;
        }


        .stat-card.danger .stat-number {
            color: #f87171;
        }


        /* =========================
           OPERATIONS
           ========================= */

        .operations {

            display: grid;

            grid-template-columns:
                repeat(2, 1fr);

            gap: 13px;
        }


        .operation-card {

            position: relative;

            background:
                rgba(15, 23, 42, 0.70);

            border:
                1px solid rgba(148, 163, 184, 0.09);

            border-radius: 12px;

            padding: 19px;

            transition:
                transform 0.2s,
                border-color 0.2s,
                background 0.2s;
        }


        .operation-card:hover {

            border-color:
                rgba(59, 130, 246, 0.28);

            background:
                rgba(15, 23, 42, 0.90);

            transform: translateY(-2px);
        }


        .operation-icon {

            width: 34px;
            height: 34px;

            display: flex;

            align-items: center;
            justify-content: center;

            border-radius: 8px;

            background:
                rgba(37, 99, 235, 0.10);

            margin-bottom: 13px;

            font-size: 16px;
        }


        .operation-card h3 {

            color: #f8fafc;

            font-size: 14px;

            margin-bottom: 6px;
        }


        .operation-card p {

            color: #64748b;

            font-size: 11px;

            line-height: 1.6;

            margin-bottom: 14px;
        }


        .operation-card a {

            display: inline-flex;

            align-items: center;

            text-decoration: none;

            color: #60a5fa;

            font-size: 11px;

            font-weight: bold;

            transition: 0.2s;
        }


        .operation-card a:hover {

            color: #93c5fd;

            transform: translateX(3px);
        }


        /* =========================
           USER QUICK ACCESS
           ========================= */

        .user-card {

            background:
                rgba(15, 23, 42, 0.76);

            border:
                1px solid rgba(148, 163, 184, 0.09);

            border-radius: 12px;

            padding: 20px;

            transition:
                transform 0.2s,
                border-color 0.2s,
                background 0.2s;
        }


        .user-card:hover {

            transform: translateY(-2px);

            border-color:
                rgba(59, 130, 246, 0.28);

            background:
                rgba(15, 23, 42, 0.90);
        }


        .user-card .operation-icon {

            background:
                rgba(37, 99, 235, 0.12);
        }


        .user-card h3 {

            color: #f8fafc;

            font-size: 15px;

            margin-bottom: 7px;
        }


        .user-card p {

            color: #64748b;

            font-size: 11px;

            line-height: 1.6;

            margin-bottom: 15px;
        }


        .user-button {

            display: inline-flex;

            align-items: center;

            text-decoration: none;

            padding: 9px 14px;

            border-radius: 7px;

            background:
                rgba(37, 99, 235, 0.12);

            border:
                1px solid rgba(59, 130, 246, 0.20);

            color: #60a5fa;

            font-size: 11px;

            font-weight: bold;

            transition: 0.2s;
        }


        .user-button:hover {

            background:
                rgba(37, 99, 235, 0.22);

            color: #93c5fd;

            transform: translateY(-1px);
        }


        /* =========================
           ADMIN
           ========================= */

        .admin-section {

            margin-top: 30px;

            padding-bottom: 20px;
        }


        .admin-card {

            background:
                linear-gradient(
                    135deg,
                    rgba(139, 92, 246, 0.08),
                    rgba(15, 23, 42, 0.75)
                );

            border:
                1px solid rgba(139, 92, 246, 0.16);

            border-radius: 12px;

            padding: 20px;
        }


        .admin-card h3 {

            color: #f8fafc;

            font-size: 14px;

            margin-bottom: 6px;
        }


        .admin-card p {

            color: #64748b;

            font-size: 11px;

            margin-bottom: 15px;
        }


        .admin-button {

            display: inline-flex;

            align-items: center;

            padding: 9px 14px;

            background:
                rgba(139, 92, 246, 0.12);

            border:
                1px solid rgba(139, 92, 246, 0.25);

            border-radius: 7px;

            color: #c4b5fd;

            text-decoration: none;

            font-size: 11px;

            font-weight: bold;

            transition: 0.2s;
        }


        .admin-button:hover {

            background:
                rgba(139, 92, 246, 0.22);

            transform: translateY(-1px);
        }


        /* =========================
           MOBILE
           ========================= */

        @media (max-width: 1150px) {

            .stats {
                grid-template-columns:
                    repeat(3, 1fr);
            }
        }


        @media (max-width: 850px) {

            .sidebar {

                position: relative;

                width: 100%;

                height: auto;

                border-right: none;

                border-bottom:
                    1px solid
                    rgba(148,163,184,0.12);
            }


            .sidebar-bottom {

                position: static;

                margin-top: 15px;
            }


            .main {

                margin-left: 0;

                padding: 22px;
            }


            .stats {

                grid-template-columns:
                    repeat(2, 1fr);
            }


            .operations {

                grid-template-columns: 1fr;
            }
        }


        @media (max-width: 550px) {

            .main {

                padding: 17px;
            }


            .topbar {

                align-items: flex-start;
            }


            .user-info {

                display: none;
            }


            .stats {

                grid-template-columns: 1fr;
            }


            .welcome::after {

                display: none;
            }
        }

    </style>

</head>

<body>


    <!-- =========================
         SIDEBAR
         ========================= -->

    <aside class="sidebar">

        <div class="logo">

            <div class="logo-title">

                <div class="logo-icon">
                    🛡
                </div>

                <span>
                    Security Ops
                </span>

            </div>

            <p>
                Security Operations Platform
            </p>

        </div>


        <div class="nav-title">
            Operations
        </div>


        <nav class="nav">

            <a href="dashboard.jsp"
               class="active">

                <span class="nav-icon">⌂</span>

                Dashboard

            </a>


            <% if ("USER".equals(role)) { %>

                <!-- USER ONLY -->

                <a href="credentials">

                    <span class="nav-icon">▣</span>

                    Credential Center

                </a>


                <a href="user-login-activity">

                    <span class="nav-icon">◷</span>

                    My Login Activity

                </a>


            <% } %>


            <% if ("ANALYST".equals(role)
                    || "ADMIN".equals(role)) { %>

                <a href="alerts">

                    <span class="nav-icon">⚠</span>

                    Security Alerts

                </a>


                <a href="incidents">

                    <span class="nav-icon">◈</span>

                    Incidents

                </a>


                <a href="security-events">

                    <span class="nav-icon">◉</span>

                    Security Events

                </a>


                <a href="iocs">

                    <span class="nav-icon">⌁</span>

                    Threat Intelligence

                </a>


                <a href="sessions">

                    <span class="nav-icon">◷</span>

                    Session History

                </a>


                <!-- IDENTITY SECURITY -->

                <div class="nav-title"
                     style="margin-top:25px;">

                    Identity Security

                </div>


                <a href="credential-activity">

                    <span class="nav-icon">▤</span>

                    Credential Activity

                </a>


                <% if ("ADMIN".equals(role)) { %>

                    <!-- ADMINISTRATION -->

                    <div class="nav-title"
                         style="margin-top:25px;">

                        Administration

                    </div>


                    <a href="admin.jsp">

                        <span class="nav-icon">⚙</span>

                        Admin Panel

                    </a>


                    <a href="audit-logs">

                        <span class="nav-icon">▤</span>

                        Audit Logs

                    </a>

                <% } %>

            <% } %>

        </nav>


        <div class="nav-title"
             style="margin-top:25px;">

            Account

        </div>


        <nav class="nav">

            <a href="change-password">

                <span class="nav-icon">⚿</span>

                Change Password

            </a>

        </nav>


        <div class="sidebar-bottom">

            <a href="logout">

                <span class="nav-icon">↪</span>

                Logout

            </a>

        </div>

    </aside>


    <!-- =========================
         MAIN CONTENT
         ========================= -->

    <main class="main">


        <!-- =========================
             USER DASHBOARD
             ========================= -->

        <% if ("USER".equals(role)) { %>


            <div class="topbar">

                <div class="page-title">

                    <h1>
                        Personal Dashboard
                    </h1>

                    <p>
                        Your personal security and digital identity
                    </p>

                </div>


                <div class="user-info">

                    <div class="user-details">

                        <strong>
                            <%= username %>
                        </strong>

                        <span>
                            USER
                        </span>

                    </div>


                    <div class="user-avatar">

                        <%= username != null
                                ? username.substring(0,1).toUpperCase()
                                : "U" %>

                    </div>

                </div>

            </div>


            <div class="system-status">

                <span class="status-dot"></span>

                Account Security Active

            </div>


            <div class="welcome">

                <h2>
                    Welcome back, <%= username %>
                </h2>

                <p>
                    Manage your digital credentials and
                    review your personal account security activity.
                </p>

            </div>


            <h2 class="section-title">
                My Security
            </h2>


            <div class="operations">


                <!-- CREDENTIAL CENTER -->

                <div class="user-card">

                    <div class="operation-icon">
                        ▣
                    </div>

                    <h3>
                        Credential Center
                    </h3>

                    <p>
                        Upload, manage, view and remove
                        your digital credentials securely.
                    </p>

                    <a href="credentials"
                       class="user-button">

                        Open Credential Center →

                    </a>

                </div>


                <!-- LOGIN ACTIVITY -->

                <div class="user-card">

                    <div class="operation-icon">
                        ◷
                    </div>

                    <h3>
                        My Login Activity
                    </h3>

                    <p>
                        Review your own login, logout and
                        session expiration history.
                    </p>

                    <a href="user-login-activity"
                       class="user-button">

                        View My Activity →

                    </a>

                </div>


                <!-- ACCOUNT SECURITY -->

                <div class="user-card">

                    <div class="operation-icon">
                        ⚿
                    </div>

                    <h3>
                        Account Security
                    </h3>

                    <p>
                        Keep your account secure by managing
                        your password.
                    </p>

                    <a href="change-password"
                       class="user-button">

                        Change Password →

                    </a>

                </div>


            </div>


        <!-- =========================
             ANALYST / ADMIN DASHBOARD
             ========================= -->

        <% } else { %>


            <div class="topbar">

                <div class="page-title">

                    <h1>
                        Security Dashboard
                    </h1>

                    <p>
                        Security operations overview and monitoring
                    </p>

                </div>


                <div class="user-info">

                    <div class="user-details">

                        <strong>
                            <%= username %>
                        </strong>

                        <span>
                            <%= role %>
                        </span>

                    </div>


                    <div class="user-avatar">

                        <%= username != null
                                ? username.substring(0,1).toUpperCase()
                                : "U" %>

                    </div>

                </div>

            </div>


            <div class="system-status">

                <span class="status-dot"></span>

                Security Monitoring Active

            </div>


            <div class="welcome">

                <h2>
                    Welcome back, <%= username %>
                </h2>

                <p>
                    Your security operations environment is ready.
                    Monitor alerts, incidents and security events from one place.
                </p>

            </div>


            <h2 class="section-title">
                Security Overview
            </h2>


            <div class="stats">


                <div class="stat-card">

                    <div class="stat-label">
                        TOTAL ALERTS
                    </div>

                    <div class="stat-number">
                        <%= totalAlerts %>
                    </div>

                    <div class="stat-sub">
                        All detected alerts
                    </div>

                </div>


                <div class="stat-card open">

                    <div class="stat-label">
                        OPEN ALERTS
                    </div>

                    <div class="stat-number">
                        <%= openAlerts %>
                    </div>

                    <div class="stat-sub">
                        Require attention
                    </div>

                </div>


                <div class="stat-card incident">

                    <div class="stat-label">
                        TOTAL INCIDENTS
                    </div>

                    <div class="stat-number">
                        <%= totalIncidents %>
                    </div>

                    <div class="stat-sub">
                        Security incidents
                    </div>

                </div>


                <div class="stat-card open">

                    <div class="stat-label">
                        OPEN INCIDENTS
                    </div>

                    <div class="stat-number">
                        <%= openIncidents %>
                    </div>

                    <div class="stat-sub">
                        Active investigations
                    </div>

                </div>


                <div class="stat-card danger">

                    <div class="stat-label">
                        HIGH / CRITICAL
                    </div>

                    <div class="stat-number">
                        <%= highCriticalAlerts %>
                    </div>

                    <div class="stat-sub">
                        High-priority alerts
                    </div>

                </div>


            </div>


            <h2 class="section-title">
                Security Operations
            </h2>


            <div class="operations">


                <div class="operation-card">

                    <div class="operation-icon">
                        ⚠
                    </div>

                    <h3>
                        Security Alerts
                    </h3>

                    <p>
                        Monitor and investigate detected
                        security alerts and suspicious activity.
                    </p>

                    <a href="alerts">
                        Open Alerts →
                    </a>

                </div>


                <div class="operation-card">

                    <div class="operation-icon">
                        ◈
                    </div>

                    <h3>
                        Incident Management
                    </h3>

                    <p>
                        Track, assign and investigate
                        security incidents.
                    </p>

                    <a href="incidents">
                        Open Incidents →
                    </a>

                </div>


                <div class="operation-card">

                    <div class="operation-icon">
                        ◉
                    </div>

                    <h3>
                        Security Events
                    </h3>

                    <p>
                        Review authentication and
                        security activity.
                    </p>

                    <a href="security-events">
                        View Events →
                    </a>

                </div>


                <div class="operation-card">

                    <div class="operation-icon">
                        ⌁
                    </div>

                    <h3>
                        Threat Intelligence
                    </h3>

                    <p>
                        Manage indicators of compromise
                        and threat information.
                    </p>

                    <a href="iocs">
                        View Threat Intelligence →
                    </a>

                </div>


                <div class="operation-card">

                    <div class="operation-icon">
                        ◷
                    </div>

                    <h3>
                        Session History
                    </h3>

                    <p>
                        Monitor user login sessions,
                        logout activity and session status.
                    </p>

                    <a href="sessions">
                        View Sessions →
                    </a>

                </div>


            </div>


            <!-- =========================
                 IDENTITY SECURITY
                 ========================= -->

            <div style="margin-top:30px;">

                <h2 class="section-title">
                    Identity Security
                </h2>


                <div class="operations">


                    <!-- CREDENTIAL ACTIVITY -->

                    <div class="operation-card">

                        <div class="operation-icon">
                            ▤
                        </div>

                        <h3>
                            Credential Activity
                        </h3>

                        <p>
                            Monitor credential uploads, views,
                            edits and deletions across users.
                        </p>

                        <a href="credential-activity">
                            View Credential Activity →
                        </a>

                    </div>


                </div>

            </div>

             <% } %>
    </main>


</body>
</html>