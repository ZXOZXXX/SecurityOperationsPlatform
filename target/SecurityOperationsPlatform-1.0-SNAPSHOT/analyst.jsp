<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role =
            (String) session.getAttribute("role");

    if (!"ANALYST".equals(role)) {
        response.sendError(
                403,
                "Access Denied: Analyst role required."
        );
        return;
    }

    String username =
            (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Analyst Panel | Security Operations Platform
    </title>

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
                Helvetica,
                sans-serif;

            min-height: 100vh;

            background:
                radial-gradient(
                    circle at 10% 10%,
                    rgba(37, 99, 235, 0.10),
                    transparent 30%
                ),
                radial-gradient(
                    circle at 90% 90%,
                    rgba(6, 182, 212, 0.07),
                    transparent 30%
                ),
                #0b1120;

            color: #e5e7eb;
        }


        /* ==============================
           SIDEBAR
           ============================== */

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

            color: #f8fafc;

            font-size: 19px;

            font-weight: 700;
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


        /* ==============================
           MAIN
           ============================== */

        .main {
            margin-left: 255px;

            min-height: 100vh;
        }


        /* ==============================
           TOPBAR
           ============================== */

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


        /* ==============================
           CONTENT
           ============================== */

        .content {
            padding: 32px;
        }


        /* ==============================
           WELCOME
           ============================== */

        .welcome-card {
            position: relative;

            overflow: hidden;

            background:
                linear-gradient(
                    135deg,
                    #111c35,
                    #0f172a
                );

            border: 1px solid #1e3a5f;

            border-radius: 14px;

            padding: 30px;

            margin-bottom: 26px;
        }

        .welcome-card::after {
            content: "ANALYST";

            position: absolute;

            right: 25px;
            bottom: -12px;

            font-size: 70px;

            font-weight: 900;

            color: rgba(59, 130, 246, 0.045);

            pointer-events: none;
        }

        .welcome-card h2 {
            color: #f8fafc;

            font-size: 23px;

            margin-bottom: 8px;
        }

        .welcome-card h2 span {
            color: #60a5fa;
        }

        .welcome-card p {
            max-width: 700px;

            color: #94a3b8;

            font-size: 13px;

            line-height: 1.7;
        }

        .status-pill {
            display: inline-flex;

            align-items: center;

            gap: 7px;

            margin-top: 18px;

            padding: 7px 12px;

            background: #052e16;

            border: 1px solid #166534;

            border-radius: 20px;

            color: #4ade80;

            font-size: 11px;

            font-weight: 700;
        }

        .status-dot {
            width: 7px;
            height: 7px;

            background: #22c55e;

            border-radius: 50%;

            box-shadow:
                0 0 8px
                rgba(34, 197, 94, 0.7);
        }


        /* ==============================
           SECTION TITLE
           ============================== */

        .section-title {
            display: flex;

            align-items: center;

            gap: 10px;

            margin-bottom: 15px;
        }

        .section-title::before {
            content: "";

            width: 4px;
            height: 18px;

            border-radius: 3px;

            background: #3b82f6;
        }

        .section-title h3 {
            color: #f1f5f9;

            font-size: 15px;
        }


        /* ==============================
           FUNCTION CARDS
           ============================== */

        .function-grid {
            display: grid;

            grid-template-columns:
                repeat(
                    2,
                    minmax(0, 1fr)
                );

            gap: 18px;

            max-width: 1000px;
        }

        .function-card {
            position: relative;

            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 12px;

            padding: 22px;

            text-decoration: none;

            transition:
                transform 0.2s,
                border-color 0.2s,
                background 0.2s;
        }

        .function-card:hover {
            transform:
                translateY(-3px);

            background: #151f32;

            border-color: #334155;
        }

        .function-icon {
            width: 42px;
            height: 42px;

            display: flex;

            align-items: center;
            justify-content: center;

            background: #172554;

            border: 1px solid #1e40af;

            border-radius: 10px;

            color: #60a5fa;

            font-size: 19px;

            margin-bottom: 15px;
        }

        .function-card h4 {
            color: #f1f5f9;

            font-size: 14px;

            margin-bottom: 7px;
        }

        .function-card p {
            color: #64748b;

            font-size: 12px;

            line-height: 1.6;
        }

        .card-arrow {
            position: absolute;

            right: 18px;
            top: 20px;

            color: #475569;

            font-size: 17px;

            transition: 0.2s;
        }

        .function-card:hover .card-arrow {
            color: #60a5fa;

            transform:
                translateX(3px);
        }


        /* ==============================
           ANALYST INFORMATION
           ============================== */

        .info-card {
            margin-top: 25px;

            max-width: 1000px;

            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 12px;

            padding: 22px;
        }

        .info-card h3 {
            color: #e2e8f0;

            font-size: 14px;

            margin-bottom: 15px;
        }

        .info-grid {
            display: grid;

            grid-template-columns:
                repeat(
                    3,
                    minmax(0, 1fr)
                );

            gap: 12px;
        }

        .info-item {
            background: #0f172a;

            border: 1px solid #1f2937;

            border-radius: 8px;

            padding: 13px;
        }

        .info-label {
            color: #64748b;

            font-size: 10px;

            text-transform: uppercase;

            letter-spacing: 0.6px;

            margin-bottom: 5px;
        }

        .info-value {
            color: #cbd5e1;

            font-size: 12px;

            font-weight: 600;
        }


        /* ==============================
           FOOTER
           ============================== */

        .footer {
            margin-top: 35px;

            padding-top: 18px;

            border-top: 1px solid #1f2937;

            color: #475569;

            font-size: 11px;
        }


        /* ==============================
           RESPONSIVE
           ============================== */

        @media (max-width: 850px) {

            .function-grid {
                grid-template-columns: 1fr;
            }

            .info-grid {
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

        Analyst

    </div>


    <a href="analyst.jsp"
       class="nav-link active">

        <span class="nav-icon">
            🧑‍💻
        </span>

        Analyst Panel

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


    <!-- ================= TOPBAR ================= -->

    <header class="topbar">


        <div class="page-heading">

            <h1>
                Analyst Panel
            </h1>

            <p>
                Security monitoring and investigation workspace
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
                    ANALYST
                </div>

            </div>


        </div>


    </header>


    <!-- ================= CONTENT ================= -->

    <section class="content">


        <!-- WELCOME -->

        <div class="welcome-card">


            <h2>

                Welcome,
                <span>
                    <%= username %>
                </span>

            </h2>


            <p>

                You are signed in as a Security Analyst.
                Use this workspace to monitor security alerts,
                investigate incidents, analyze security events,
                and review threat intelligence indicators.

            </p>


            <div class="status-pill">

                <span class="status-dot"></span>

                Analyst Access Active

            </div>


        </div>


        <!-- FUNCTIONS -->

        <div class="section-title">

            <h3>
                Security Analyst Functions
            </h3>

        </div>


        <div class="function-grid">


            <!-- ALERTS -->

            <a
                href="alerts"
                class="function-card"
            >

                <div class="function-icon">
                    ⚠
                </div>

                <h4>
                    Security Alerts
                </h4>

                <p>
                    Review detected security alerts,
                    severity levels, source IPs,
                    and current alert status.
                </p>

                <span class="card-arrow">
                    →
                </span>

            </a>


            <!-- INCIDENTS -->

            <a
                href="incidents"
                class="function-card"
            >

                <div class="function-icon">
                    🚨
                </div>

                <h4>
                    Incident Investigation
                </h4>

                <p>
                    Investigate security incidents,
                    update statuses, assign analysts,
                    and maintain investigation notes.
                </p>

                <span class="card-arrow">
                    →
                </span>

            </a>


            <!-- EVENTS -->

            <a
                href="security-events"
                class="function-card"
            >

                <div class="function-icon">
                    🔍
                </div>

                <h4>
                    Security Events
                </h4>

                <p>
                    Analyze authentication activity,
                    failed login attempts, source IPs,
                    and recorded security events.
                </p>

                <span class="card-arrow">
                    →
                </span>

            </a>


            <!-- IOC -->

            <a
                href="iocs"
                class="function-card"
            >

                <div class="function-icon">
                    ◈
                </div>

                <h4>
                    Threat Intelligence
                </h4>

                <p>
                    Review indicators of compromise
                    including IP addresses, domains,
                    URLs, and hashes.
                </p>

                <span class="card-arrow">
                    →
                </span>

            </a>


        </div>


        <!-- ANALYST INFORMATION -->

        <div class="info-card">


            <h3>
                Analyst Access
            </h3>


            <div class="info-grid">


                <div class="info-item">

                    <div class="info-label">
                        Account
                    </div>

                    <div class="info-value">
                        <%= username %>
                    </div>

                </div>


                <div class="info-item">

                    <div class="info-label">
                        Role
                    </div>

                    <div class="info-value">
                        Security Analyst
                    </div>

                </div>


                <div class="info-item">

                    <div class="info-label">
                        Access Level
                    </div>

                    <div class="info-value">
                        Analyst Operations
                    </div>

                </div>


            </div>


        </div>


        <div class="footer">

            Security Operations Platform
            &nbsp;•&nbsp;
            Analyst Workspace
            &nbsp;•&nbsp;
            Access controlled by role-based authorization

        </div>


    </section>


</main>


</body>

</html>