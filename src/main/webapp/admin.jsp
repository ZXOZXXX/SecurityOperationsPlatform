<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.security.securityoperationsplatform.User"%>
<%@page import="com.security.securityoperationsplatform.AdminUserDAO"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = (String) session.getAttribute("role");

    if (!"ADMIN".equals(role)) {
        response.sendError(
                403,
                "Access Denied: Admin role required."
        );
        return;
    }

    AdminUserDAO adminUserDAO = new AdminUserDAO();

    List<User> users = adminUserDAO.getAllUsers();

    int loggedInUserId =
            (Integer) session.getAttribute("userId");

    String username =
            (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Admin Panel | Security Operations Platform</title>

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

        .admin-profile {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .admin-avatar {
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

        .admin-info {
            line-height: 1.3;
        }

        .admin-name {
            font-size: 13px;
            font-weight: 600;
            color: #e2e8f0;
        }

        .admin-role {
            font-size: 11px;
            color: #60a5fa;
        }

        /* ================= CONTENT ================= */

        .content {
            padding: 30px 32px 45px;
        }

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

            padding: 27px;

            margin-bottom: 28px;
        }

        .welcome-card::after {
            content: "ADMIN";

            position: absolute;

            right: 25px;
            top: 15px;

            font-size: 65px;
            font-weight: 800;

            color: rgba(59, 130, 246, 0.045);

            pointer-events: none;
        }

        .welcome-card h2 {
            font-size: 23px;
            margin-bottom: 7px;
            color: #f8fafc;
        }

        .welcome-card p {
            color: #94a3b8;
            font-size: 14px;
        }

        .security-pill {
            display: inline-flex;
            align-items: center;
            gap: 7px;

            margin-top: 16px;

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

        /* ================= SECTION ================= */

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;

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
            font-size: 12px;
            color: #64748b;
        }

        /* ================= USER TABLE ================= */

        .table-container {
            background: #111827;
            border: 1px solid #1f2937;

            border-radius: 12px;

            overflow-x: auto;

            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;

            min-width: 1000px;
        }

        th {
            background: #0f172a;

            color: #64748b;

            font-size: 11px;
            text-transform: uppercase;

            letter-spacing: 0.6px;

            text-align: left;

            padding: 14px 15px;

            border-bottom: 1px solid #1f2937;
        }

        td {
            padding: 15px;

            border-bottom: 1px solid #1f2937;

            font-size: 13px;
            color: #cbd5e1;

            vertical-align: middle;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background: #151e2e;
        }

        .user-id {
            color: #64748b;
            font-family: monospace;
        }

        .username {
            font-weight: 600;
            color: #f1f5f9;
        }

        .email {
            color: #94a3b8;
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

        .badge-admin {
            background: #312e81;
            color: #a5b4fc;
        }

        .badge-analyst {
            background: #172554;
            color: #60a5fa;
        }

        .badge-user {
            background: #1e293b;
            color: #94a3b8;
        }

        .badge-enabled {
            background: #052e16;
            color: #4ade80;
        }

        .badge-disabled {
            background: #3f1d1d;
            color: #f87171;
        }

        .badge-locked {
            background: #451a03;
            color: #fb923c;
        }

        .badge-unlocked {
            background: #052e16;
            color: #4ade80;
        }

        /* ================= FORMS ================= */

        select {
            background: #0f172a;
            color: #cbd5e1;

            border: 1px solid #334155;

            border-radius: 6px;

            padding: 7px 9px;

            font-size: 12px;

            outline: none;
        }

        select:focus {
            border-color: #3b82f6;
        }

        button {
            border: none;

            border-radius: 6px;

            padding: 7px 11px;

            margin-left: 5px;

            background: #1d4ed8;
            color: white;

            font-size: 11px;
            font-weight: 600;

            cursor: pointer;

            transition: 0.2s;
        }

        button:hover {
            background: #2563eb;
        }

        .btn-warning {
            background: #92400e;
        }

        .btn-warning:hover {
            background: #b45309;
        }

        .btn-danger {
            background: #991b1b;
        }

        .btn-danger:hover {
            background: #b91c1c;
        }

        .current-admin {
            color: #60a5fa;
            font-size: 11px;
            font-weight: 600;
        }

        /* ================= MANAGEMENT CARDS ================= */

        .management-grid {
            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 18px;

            margin-top: 10px;
        }

        .management-card {
            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 12px;

            padding: 21px;

            transition: 0.2s;
        }

        .management-card:hover {
            border-color: #334155;
            transform: translateY(-2px);
        }

        .card-icon {
            width: 39px;
            height: 39px;

            display: flex;
            align-items: center;
            justify-content: center;

            border-radius: 9px;

            background: #172554;
            border: 1px solid #1e3a8a;

            margin-bottom: 16px;

            font-size: 18px;
        }

        .management-card h3 {
            font-size: 15px;
            color: #f1f5f9;

            margin-bottom: 8px;
        }

        .management-card p {
            color: #64748b;

            font-size: 12px;
            line-height: 1.6;

            min-height: 58px;

            margin-bottom: 16px;
        }

        .management-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;

            text-decoration: none;

            color: #60a5fa;

            font-size: 12px;
            font-weight: 600;
        }

        .management-link:hover {
            color: #93c5fd;
        }

        .maintenance-card {
            border-color: #3f2a18;
        }

        .maintenance-card .card-icon {
            background: #2a1b0d;
            border-color: #78350f;
        }

        /* ================= FOOTER LINKS ================= */

        .footer-actions {
            display: flex;
            gap: 12px;

            margin-top: 30px;
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

        @media (max-width: 1100px) {

            .management-grid {
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

            .admin-info {
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

        <span>Security Ops</span>

    </div>

    <div class="nav-title">
        Operations
    </div>

    <a href="dashboard.jsp"
       class="nav-link">

        <span class="nav-icon">▦</span>

        Dashboard

    </a>

    <a href="alerts"
       class="nav-link">

        <span class="nav-icon">⚠</span>

        Security Alerts

    </a>

    <a href="incidents"
       class="nav-link">

        <span class="nav-icon">◉</span>

        Incidents

    </a>

    <a href="security-events"
       class="nav-link">

        <span class="nav-icon">⌁</span>

        Security Events

    </a>

    <a href="iocs"
       class="nav-link">

        <span class="nav-icon">◈</span>

        Threat Intelligence

    </a>

    <a href="sessions"
       class="nav-link">

        <span class="nav-icon">◌</span>

        Session History

    </a>

    <div class="nav-title"
         style="margin-top: 24px;">

        Administration

    </div>

    <a href="admin.jsp"
       class="nav-link active">

        <span class="nav-icon">⚙</span>

        Admin Panel

    </a>

    <a href="audit-logs"
       class="nav-link">

        <span class="nav-icon">▤</span>

        Audit Logs

    </a>

    <div class="sidebar-bottom">

        <a href="change-password.jsp"
           class="nav-link">

            <span class="nav-icon">🔑</span>

            Change Password

        </a>

        <a href="logout"
           class="nav-link logout-link">

            <span class="nav-icon">↪</span>

            Logout

        </a>

    </div>

</aside>


<!-- ================= MAIN ================= -->

<main class="main">

    <!-- TOPBAR -->

    <header class="topbar">

        <div class="page-heading">

            <h1>Administrator Control Center</h1>

            <p>
                Manage platform users, security controls and system operations
            </p>

        </div>

        <div class="admin-profile">

            <div class="admin-avatar">
                <%= username != null
                        ? username.substring(0, 1).toUpperCase()
                        : "A" %>
            </div>

            <div class="admin-info">

                <div class="admin-name">
                    <%= username %>
                </div>

                <div class="admin-role">
                    SYSTEM ADMINISTRATOR
                </div>

            </div>

        </div>

    </header>


    <!-- CONTENT -->

    <section class="content">

        <!-- WELCOME -->

        <div class="welcome-card">

            <h2>
                Administration Console
            </h2>

            <p>
                Welcome back, <strong><%= username %></strong>.
                Use this area to manage users, security policies,
                audit activity and system maintenance.
            </p>

            <div class="security-pill">

                <span class="status-dot"></span>

                Administrative Access Active

            </div>

        </div>


        <!-- USER MANAGEMENT -->

        <div class="section-header">

            <div>

                <div class="section-title">
                    User Management
                </div>

                <div class="section-description">
                    Manage roles, account status and lockout controls.
                </div>

            </div>

        </div>


        <div class="table-container">

            <table>

                <thead>

                    <tr>

                        <th>ID</th>
                        <th>User</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Change Role</th>
                        <th>Account</th>
                        <th>Lock Status</th>

                    </tr>

                </thead>

                <tbody>

                <%
                    if (users != null && !users.isEmpty()) {

                        for (User user : users) {
                %>

                    <tr>

                        <td class="user-id">
                            #<%= user.getId() %>
                        </td>

                        <td>

                            <div class="username">
                                <%= user.getUsername() %>
                            </div>

                        </td>

                        <td class="email">
                            <%= user.getEmail() %>
                        </td>

                        <td>

                            <span class="badge
                                <%= "ADMIN".equals(user.getRole())
                                        ? "badge-admin"
                                        : "ANALYST".equals(user.getRole())
                                            ? "badge-analyst"
                                            : "badge-user" %>">

                                <%= user.getRole() %>

                            </span>

                        </td>

                        <td>

                            <span class="badge
                                <%= user.isEnabled()
                                        ? "badge-enabled"
                                        : "badge-disabled" %>">

                                <%= user.isEnabled()
                                        ? "ENABLED"
                                        : "DISABLED" %>

                            </span>

                        </td>


                        <!-- ROLE MANAGEMENT -->

                        <td>

                            <%
                                if (user.getId() == loggedInUserId) {
                            %>

                                <span class="current-admin">
                                    Current Admin
                                </span>

                            <%
                                } else {
                            %>

                            <form
                                action="update-role"
                                method="post">

                                <input
                                    type="hidden"
                                    name="userId"
                                    value="<%= user.getId() %>"
                                >

                                <select name="role">

                                    <option value="USER"
                                        <%= "USER".equals(user.getRole())
                                                ? "selected" : "" %>>
                                        USER
                                    </option>

                                    <option value="ANALYST"
                                        <%= "ANALYST".equals(user.getRole())
                                                ? "selected" : "" %>>
                                        ANALYST
                                    </option>

                                    <option value="ADMIN"
                                        <%= "ADMIN".equals(user.getRole())
                                                ? "selected" : "" %>>
                                        ADMIN
                                    </option>

                                </select>

                                <button type="submit">
                                    Update
                                </button>

                            </form>

                            <%
                                }
                            %>

                        </td>


                        <!-- ACCOUNT STATUS -->

                        <td>

                            <%
                                if (user.getId() == loggedInUserId) {
                            %>

                                <span class="current-admin">
                                    Protected
                                </span>

                            <%
                                } else {
                            %>

                            <form
                                action="update-status"
                                method="post"
                                onsubmit="return confirm(
                                    'Are you sure you want to change this account status?'
                                );">

                                <input
                                    type="hidden"
                                    name="userId"
                                    value="<%= user.getId() %>"
                                >

                                <input
                                    type="hidden"
                                    name="enabled"
                                    value="<%= !user.isEnabled() %>"
                                >

                                <button
                                    type="submit"
                                    class="<%= user.isEnabled()
                                            ? "btn-warning"
                                            : "" %>">

                                    <%= user.isEnabled()
                                            ? "Disable"
                                            : "Enable" %>

                                </button>

                            </form>

                            <%
                                }
                            %>

                        </td>


                        <!-- LOCK MANAGEMENT -->

                        <td>

                            <%
                                if (user.getId() == loggedInUserId) {
                            %>

                                <span class="current-admin">
                                    Protected
                                </span>

                            <%
                                } else if (user.isLocked()) {
                            %>

                                <span class="badge badge-locked">
                                    LOCKED
                                </span>

                                <form
                                    action="unlock-user"
                                    method="post"
                                    style="margin-top: 8px;"
                                    onsubmit="return confirm(
                                        'Unlock this user account?'
                                    );">

                                    <input
                                        type="hidden"
                                        name="userId"
                                        value="<%= user.getId() %>"
                                    >

                                    <button type="submit">
                                        Unlock
                                    </button>

                                </form>

                            <%
                                } else {
                            %>

                                <span class="badge badge-unlocked">
                                    UNLOCKED
                                </span>

                                <form
                                    action="lock-user"
                                    method="post"
                                    style="margin-top: 8px;"
                                    onsubmit="return confirm(
                                        'Lock this user account?'
                                    );">

                                    <input
                                        type="hidden"
                                        name="userId"
                                        value="<%= user.getId() %>"
                                    >

                                    <button
                                        type="submit"
                                        class="btn-danger">

                                        Lock

                                    </button>

                                </form>

                            <%
                                }
                            %>

                        </td>

                    </tr>

                <%
                        }

                    } else {
                %>

                    <tr>

                        <td
                            colspan="8"
                            style="
                                text-align:center;
                                padding:35px;
                                color:#64748b;
                            ">

                            No users found.

                        </td>

                    </tr>

                <%
                    }
                %>

                </tbody>

            </table>

        </div>


        <!-- ADMINISTRATION FUNCTIONS -->

        <div class="section-header">

            <div>

                <div class="section-title">
                    Administrative Functions
                </div>

                <div class="section-description">
                    Platform security and operational controls.
                </div>

            </div>

        </div>


        <div class="management-grid">


            <!-- SECURITY CONFIG -->

            <div class="management-card">

                <div class="card-icon">
                    ⚙
                </div>

                <h3>
                    Security Configuration
                </h3>

                <p>
                    Configure authentication, password policies,
                    detection controls and audit logging settings.
                </p>

                <a
                    href="security-config"
                    class="management-link">

                    Open Configuration →

                </a>

            </div>


            <!-- AUDIT -->

            <div class="management-card">

                <div class="card-icon">
                    ▤
                </div>

                <h3>
                    System Audit Logs
                </h3>

                <p>
                    Review administrator actions and important
                    security-related activities recorded by the platform.
                </p>

                <a
                    href="audit-logs"
                    class="management-link">

                    Open Audit Logs →

                </a>

            </div>


            <!-- MAINTENANCE -->

            <div class="management-card maintenance-card">

                <div class="card-icon">
                    ⚠
                </div>

                <h3>
                    System Maintenance
                </h3>

                <p>
                    Manage test and security monitoring data generated
                    during development and testing.
                </p>

                <a
                    href="system-maintenance"
                    class="management-link">

                    Open Maintenance →

                </a>

            </div>

        </div>


        <!-- MAINTENANCE NOTICE -->

        <div style="
            margin-top:20px;
            padding:15px 17px;
            background:#17120c;
            border:1px solid #3f2a18;
            border-radius:9px;
            color:#a8a29e;
            font-size:12px;
            line-height:1.6;
        ">

            <strong style="color:#fb923c;">
                Maintenance Protection:
            </strong>

            User accounts, IOC records and security configuration
            are protected from the test-data cleanup functions.

        </div>


        <!-- FOOTER ACTIONS -->

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