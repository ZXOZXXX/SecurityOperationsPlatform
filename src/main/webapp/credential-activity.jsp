<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.security.securityoperationsplatform.CredentialActivity" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");

    if (!"ANALYST".equals(role) && !"ADMIN".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    List<CredentialActivity> activities =
            (List<CredentialActivity>) request.getAttribute("activities");

    int totalActivities = 0;
    int addCount = 0;
    int viewCount = 0;
    int editCount = 0;
    int deleteCount = 0;

    if (activities != null) {

        totalActivities = activities.size();

        for (CredentialActivity activity : activities) {

            String action = activity.getAction();

            if ("ADD".equalsIgnoreCase(action)) {
                addCount++;
            } else if ("VIEW".equalsIgnoreCase(action)) {
                viewCount++;
            } else if ("EDIT".equalsIgnoreCase(action)) {
                editCount++;
            } else if ("DELETE".equalsIgnoreCase(action)) {
                deleteCount++;
            }
        }
    }
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Credential Activity | Security Operations Platform</title>

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

    margin-bottom: 25px;
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

.monitoring-pill {
    display: inline-flex;

    align-items: center;

    gap: 7px;

    margin-top: 15px;

    padding: 6px 11px;

    border-radius: 20px;

    background: #052e16;

    border: 1px solid #14532d;

    color: #4ade80;

    font-size: 11px;

    font-weight: 600;
}

.status-dot {
    width: 7px;
    height: 7px;

    border-radius: 50%;

    background: #4ade80;
}

/* ================= STAT CARDS ================= */

.stats-grid {
    display: grid;

    grid-template-columns:
        repeat(5, 1fr);

    gap: 15px;

    margin-bottom: 28px;
}

.stat-card {
    background: #111827;

    border: 1px solid #1f2937;

    border-radius: 11px;

    padding: 18px;
}

.stat-label {
    color: #64748b;

    font-size: 10px;

    font-weight: 700;

    text-transform: uppercase;

    letter-spacing: 0.6px;

    margin-bottom: 9px;
}

.stat-value {
    color: #f8fafc;

    font-size: 24px;

    font-weight: 700;
}

.stat-description {
    color: #64748b;

    font-size: 10px;

    margin-top: 5px;
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

/* ================= TABLE ================= */

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

.activity-id {
    color: #64748b;

    font-family: monospace;

    font-size: 11px;
}

.user-name-cell {
    color: #e2e8f0;

    font-weight: 600;

    font-size: 12px;
}

.credential-id {
    color: #93c5fd;

    font-family: monospace;

    font-size: 11px;
}

.description {
    color: #94a3b8;

    line-height: 1.5;

    max-width: 300px;
}

.source-ip {
    color: #cbd5e1;

    font-family: monospace;

    font-size: 11px;
}

/* ================= BADGES ================= */

.badge {
    display: inline-flex;

    padding: 5px 9px;

    border-radius: 6px;

    font-size: 9px;

    font-weight: 700;
}

.add {
    background: #052e16;

    color: #4ade80;
}

.view {
    background: #172554;

    color: #60a5fa;
}

.edit {
    background: #422006;

    color: #facc15;
}

.delete {
    background: #450a0a;

    color: #fca5a5;
}

.success {
    background: #052e16;

    color: #4ade80;
}

.failed {
    background: #450a0a;

    color: #fca5a5;
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

@media (max-width: 1100px) {

    .stats-grid {
        grid-template-columns:
            repeat(3, 1fr);
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

    .stats-grid {
        grid-template-columns:
            repeat(2, 1fr);
    }
}

@media (max-width: 500px) {

    .stats-grid {
        grid-template-columns: 1fr;
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


    <div class="nav-title"
         style="margin-top:24px;">

        Identity Security

    </div>



    <a href="credential-activity"
       class="nav-link active">

        <span class="nav-icon">
            ▤
        </span>

        Credential Activity

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
                Credential Activity
            </h1>

            <p>
                Monitor digital credential activity across users
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
                Credential Activity Monitoring
            </h2>

            <p>
                Monitor credential uploads, views, edits,
                and deletions performed by users across the
                digital identity security platform.
            </p>


            <div class="monitoring-pill">

                <span class="status-dot"></span>

                Credential Security Monitoring Active

            </div>

        </div>


        <!-- ================= STATISTICS ================= -->

        <div class="stats-grid">


            <div class="stat-card">

                <div class="stat-label">
                    Total Activities
                </div>

                <div class="stat-value">
                    <%= totalActivities %>
                </div>

                <div class="stat-description">
                    Recorded credential actions
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-label">
                    Uploads
                </div>

                <div class="stat-value">
                    <%= addCount %>
                </div>

                <div class="stat-description">
                    Credentials added
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-label">
                    Views
                </div>

                <div class="stat-value">
                    <%= viewCount %>
                </div>

                <div class="stat-description">
                    Credential access events
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-label">
                    Edits
                </div>

                <div class="stat-value">
                    <%= editCount %>
                </div>

                <div class="stat-description">
                    Credential modifications
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-label">
                    Deletes
                </div>

                <div class="stat-value">
                    <%= deleteCount %>
                </div>

                <div class="stat-description">
                    Credential removal events
                </div>

            </div>

        </div>


        <!-- ================= ACTIVITY TABLE ================= -->

        <div class="section-header">

            <div class="section-title">
                Credential Activity Log
            </div>

            <div class="section-description">
                Activity recorded from credential management operations.
            </div>

        </div>


        <div class="table-container">

            <table>

                <thead>

                    <tr>

                        <th>
                            ID
                        </th>

                        <th>
                            User
                        </th>

                        <th>
                            Action
                        </th>

                        <th>
                            Credential ID
                        </th>

                        <th>
                            Description
                        </th>

                        <th>
                            Source IP
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Date / Time
                        </th>

                    </tr>

                </thead>


                <tbody>


                <%
                    if (activities != null
                            && !activities.isEmpty()) {

                        for (CredentialActivity activity
                                : activities) {

                            String action =
                                    activity.getAction();

                            String actionClass =
                                    "view";

                            if ("ADD".equalsIgnoreCase(action)) {
                                actionClass = "add";
                            } else if ("EDIT".equalsIgnoreCase(action)) {
                                actionClass = "edit";
                            } else if ("DELETE".equalsIgnoreCase(action)) {
                                actionClass = "delete";
                            }


                            String status =
                                    activity.getStatus();

                            String statusClass =
                                    "success";

                            if (!"SUCCESS".equalsIgnoreCase(status)) {
                                statusClass = "failed";
                            }
                %>


                    <tr>


                        <td>

                            <span class="activity-id">
                                #<%= activity.getId() %>
                            </span>

                        </td>


                        <td>

                            <span class="user-name-cell">
                                <%= activity.getUsername() != null
                                        ? activity.getUsername()
                                        : "-" %>
                            </span>

                        </td>


                        <td>

                            <span class="badge <%= actionClass %>">

                                <%= action != null
                                        ? action
                                        : "-" %>

                            </span>

                        </td>


                        <td>

                            <span class="credential-id">

                                #<%= activity.getCredentialId() %>

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

                            <span class="source-ip">

                                <%= activity.getSourceIp() != null
                                        ? activity.getSourceIp()
                                        : "-" %>

                            </span>

                        </td>


                        <td>

                            <span class="badge <%= statusClass %>">

                                <%= status != null
                                        ? status
                                        : "-" %>

                            </span>

                        </td>


                        <td>

                            <%= activity.getCreatedAt() != null
                                    ? activity.getCreatedAt()
                                    : "-" %>

                        </td>


                    </tr>


                <%
                        }

                    } else {
                %>


                    <tr>

                        <td colspan="8">

                            <div class="empty-state">

                                <div class="empty-icon">
                                    ▤
                                </div>

                                <h3>
                                    No Credential Activity
                                </h3>

                                <p>
                                    No credential activity has
                                    been recorded yet.
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

                ← Dashboard

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