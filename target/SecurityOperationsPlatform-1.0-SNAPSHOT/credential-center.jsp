<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.security.securityoperationsplatform.Credential"%>
<%@page import="com.security.securityoperationsplatform.CredentialActivity"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    List<Credential> credentials =
            (List<Credential>) request.getAttribute("credentials");

    List<CredentialActivity> activities =
            (List<CredentialActivity>) request.getAttribute("activities");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Credential Center | Security Operations Platform</title>

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

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 255px;
            height: 100vh;
            background: #111827;
            border-right: 1px solid #1f2937;
            padding: 22px 16px;
            z-index: 10;
        }

        .logo {
            font-size: 20px;
            font-weight: 700;
            color: #f8fafc;
            margin-bottom: 32px;
            padding: 0 10px;
        }

        .logo span {
            color: #38bdf8;
        }

        .nav-title {
            font-size: 11px;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 18px 10px 8px;
        }

        .nav-link {
            display: block;
            text-decoration: none;
            color: #94a3b8;
            padding: 11px 12px;
            border-radius: 8px;
            margin-bottom: 4px;
            font-size: 14px;
            transition: 0.2s;
        }

        .nav-link:hover {
            background: #1e293b;
            color: #f8fafc;
        }

        .nav-link.active {
            background: #0f2a3d;
            color: #38bdf8;
            border-left: 3px solid #38bdf8;
        }

        .user-box {
            position: absolute;
            left: 16px;
            right: 16px;
            bottom: 20px;
            background: #0f172a;
            border: 1px solid #1e293b;
            border-radius: 10px;
            padding: 13px;
        }

        .user-name {
            color: #f8fafc;
            font-size: 14px;
            font-weight: 600;
        }

        .user-role {
            color: #64748b;
            font-size: 12px;
            margin-top: 3px;
        }

        .main {
            margin-left: 255px;
            min-height: 100vh;
        }

        .topbar {
            height: 72px;
            border-bottom: 1px solid #1f2937;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            background: #0b1120;
        }

        .page-title {
            font-size: 21px;
            font-weight: 650;
            color: #f8fafc;
        }

        .security-status {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            color: #86efac;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #22c55e;
        }

        .content {
            padding: 32px;
        }

        .hero {
            background: linear-gradient(135deg, #111827, #0f1d32);
            border: 1px solid #1e293b;
            border-radius: 14px;
            padding: 26px;
            margin-bottom: 24px;
        }

        .hero h1 {
            font-size: 25px;
            color: #f8fafc;
            margin-bottom: 8px;
        }

        .hero p {
            color: #94a3b8;
            font-size: 14px;
            max-width: 720px;
            line-height: 1.6;
        }

        .grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 350px;
            gap: 24px;
            align-items: start;
        }

        .card {
            background: #111827;
            border: 1px solid #1e293b;
            border-radius: 14px;
            padding: 22px;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .card-title {
            font-size: 16px;
            font-weight: 650;
            color: #f8fafc;
        }

        .count {
            background: #172033;
            color: #94a3b8;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 11px;
        }

        .credential {
            border: 1px solid #1f2937;
            background: #0d1525;
            border-radius: 10px;
            padding: 17px;
            margin-bottom: 12px;
        }

        .credential:last-child {
            margin-bottom: 0;
        }

        .credential-top {
            display: flex;
            justify-content: space-between;
            gap: 15px;
        }

        .credential-name {
            color: #f8fafc;
            font-size: 15px;
            font-weight: 600;
        }

        .credential-type {
            color: #64748b;
            font-size: 12px;
            margin-top: 4px;
        }

        .credential-description {
            color: #94a3b8;
            font-size: 13px;
            margin-top: 12px;
            line-height: 1.5;
        }

        .credential-meta {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            margin-top: 13px;
            font-size: 11px;
            color: #64748b;
        }

        .badge {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .4px;
        }

        .badge-active {
            background: rgba(34, 197, 94, .12);
            color: #86efac;
        }

        .badge-revoked {
            background: rgba(239, 68, 68, .12);
            color: #fca5a5;
        }

        .credential-actions {
            display: flex;
            gap: 8px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .action-btn {
            border: 1px solid #263244;
            border-radius: 7px;
            padding: 7px 12px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            transition: .2s;
            text-decoration: none;
            display: inline-block;
        }

        .view-btn {
            background: #102a3d;
            color: #38bdf8;
        }

        .view-btn:hover {
            background: #153d55;
        }

        .edit-btn {
            background: #102a3d;
            color: #38bdf8;
        }

        .edit-btn:hover {
            background: #153d55;
        }

        .remove-btn {
            background: #2a1418;
            color: #fca5a5;
        }

        .remove-btn:hover {
            background: #401a20;
        }

        .edit-panel {
            display: none;
            margin-top: 16px;
            padding: 16px;
            background: #111827;
            border: 1px solid #263244;
            border-radius: 9px;
        }

        .edit-panel.active {
            display: block;
        }

        .edit-panel-title {
            color: #e2e8f0;
            font-size: 13px;
            font-weight: 650;
            margin-bottom: 14px;
        }

        .edit-panel input,
        .edit-panel select,
        .edit-panel textarea {
            width: 100%;
            background: #0b1120;
            color: #e5e7eb;
            border: 1px solid #263244;
            border-radius: 8px;
            padding: 10px 11px;
            font-family: inherit;
            font-size: 12px;
            outline: none;
            margin-bottom: 12px;
        }

        .edit-panel input:focus,
        .edit-panel select:focus,
        .edit-panel textarea:focus {
            border-color: #38bdf8;
        }

        .edit-panel textarea {
            resize: vertical;
            min-height: 75px;
        }

        .edit-actions {
            display: flex;
            gap: 8px;
        }

        .save-edit {
            background: #0284c7;
            color: white;
            border: none;
            border-radius: 7px;
            padding: 8px 13px;
            font-size: 11px;
            font-weight: 650;
            cursor: pointer;
        }

        .cancel-edit {
            background: #1e293b;
            color: #94a3b8;
            border: none;
            border-radius: 7px;
            padding: 8px 13px;
            font-size: 11px;
            font-weight: 650;
            cursor: pointer;
        }

        .empty {
            text-align: center;
            padding: 45px 20px;
            border: 1px dashed #263244;
            border-radius: 10px;
        }

        .empty-icon {
            font-size: 30px;
            margin-bottom: 12px;
        }

        .empty h3 {
            color: #e2e8f0;
            font-size: 15px;
            margin-bottom: 6px;
        }

        .empty p {
            color: #64748b;
            font-size: 12px;
        }

        label {
            display: block;
            color: #cbd5e1;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 7px;
        }

        input,
        select,
        textarea {
            width: 100%;
            background: #0b1120;
            color: #e5e7eb;
            border: 1px solid #263244;
            border-radius: 8px;
            padding: 11px 12px;
            font-family: inherit;
            font-size: 13px;
            outline: none;
            margin-bottom: 16px;
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: #38bdf8;
        }

        textarea {
            resize: vertical;
            min-height: 90px;
        }

        input[type="file"] {
            padding: 9px;
            cursor: pointer;
        }

        input[type="file"]::file-selector-button {
            background: #1e293b;
            color: #cbd5e1;
            border: 1px solid #334155;
            border-radius: 6px;
            padding: 7px 10px;
            margin-right: 10px;
            cursor: pointer;
        }

        input[type="file"]::file-selector-button:hover {
            background: #263244;
        }

        .file-note {
            color: #64748b;
            font-size: 11px;
            line-height: 1.5;
            margin-top: -8px;
            margin-bottom: 16px;
        }

        .btn {
            width: 100%;
            border: none;
            border-radius: 8px;
            padding: 11px 15px;
            background: #0284c7;
            color: white;
            font-weight: 650;
            cursor: pointer;
            transition: .2s;
        }

        .btn:hover {
            background: #0369a1;
        }

        .notice {
            padding: 11px 13px;
            border-radius: 8px;
            margin-bottom: 18px;
            font-size: 12px;
        }

        .success {
            background: rgba(34, 197, 94, .10);
            border: 1px solid rgba(34, 197, 94, .25);
            color: #86efac;
        }

        .error {
            background: rgba(239, 68, 68, .10);
            border: 1px solid rgba(239, 68, 68, .25);
            color: #fca5a5;
        }

        .security-note {
            margin-top: 18px;
            padding: 13px;
            border-radius: 9px;
            background: #0d1727;
            border: 1px solid #1e293b;
        }

        .security-note strong {
            display: block;
            color: #cbd5e1;
            font-size: 12px;
            margin-bottom: 5px;
        }

        .security-note span {
            color: #64748b;
            font-size: 11px;
            line-height: 1.5;
        }

        /* ACTIVITY HISTORY */

        .activity-section {
            margin-top: 24px;
        }

        .activity-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .activity-item {
            background: #0d1525;
            border: 1px solid #1f2937;
            border-radius: 10px;
            padding: 15px;
        }

        .activity-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .activity-action {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: .5px;
        }

        .activity-add,
        .activity-view {
            background: rgba(56, 189, 248, .12);
            color: #7dd3fc;
        }

        .activity-edit {
            background: rgba(250, 204, 21, .12);
            color: #fde047;
        }

        .activity-delete {
            background: rgba(239, 68, 68, .12);
            color: #fca5a5;
        }

        .activity-description {
            color: #cbd5e1;
            font-size: 12px;
            margin-top: 10px;
            line-height: 1.5;
        }

        .activity-meta {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
            margin-top: 10px;
            color: #64748b;
            font-size: 11px;
        }

        .activity-success {
            color: #86efac;
            font-weight: 600;
        }

        .activity-failed {
            color: #fca5a5;
            font-weight: 600;
        }

        .activity-empty {
            text-align: center;
            padding: 30px 20px;
            border: 1px dashed #263244;
            border-radius: 10px;
            color: #64748b;
            font-size: 12px;
        }

        @media (max-width: 1050px) {

            .grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 760px) {

            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
            }

            .user-box {
                position: static;
                margin-top: 20px;
            }

            .main {
                margin-left: 0;
            }

            .topbar {
                padding: 0 18px;
            }

            .content {
                padding: 18px;
            }

            .credential-top {
                flex-direction: column;
            }
        }

    </style>
</head>

<body>

<div class="sidebar">

    <div class="logo">
        🛡 Security <span>Ops</span>
    </div>


    <!-- ==========================================
         USER SIDEBAR
         ========================================== -->

    <% if ("USER".equalsIgnoreCase(role)) { %>

        <div class="nav-title">
            Personal Security
        </div>

        <a href="dashboard.jsp" class="nav-link">
            Dashboard
        </a>

        <a href="credentials" class="nav-link active">
            Credential Center
        </a>

        <a href="user-login-activity" class="nav-link">
            My Login Activity
        </a>


        <div class="nav-title">
            Account
        </div>

        <a href="change-password.jsp" class="nav-link">
            Change Password
        </a>

        <a href="logout" class="nav-link">
            Logout
        </a>


    <!-- ==========================================
         ANALYST / ADMIN SIDEBAR
         ========================================== -->

    <% } else { %>

        <div class="nav-title">
            Operations
        </div>

        <a href="dashboard.jsp" class="nav-link">
            Dashboard
        </a>

        <a href="alerts" class="nav-link">
            Security Alerts
        </a>

        <a href="incidents" class="nav-link">
            Incidents
        </a>

        <a href="security-events" class="nav-link">
            Security Events
        </a>

        <a href="iocs" class="nav-link">
            Threat Intelligence
        </a>

        <a href="sessions" class="nav-link">
            Session History
        </a>


        <div class="nav-title">
            Identity Security
        </div>

        <a href="credentials" class="nav-link active">
            Credential Center
        </a>


        <div class="nav-title">
            Account
        </div>

        <a href="change-password.jsp" class="nav-link">
            Change Password
        </a>


        <% if ("ADMIN".equalsIgnoreCase(role)) { %>

            <div class="nav-title">
                Administration
            </div>

            <a href="admin.jsp" class="nav-link">
                User Management
            </a>

            <a href="audit-logs" class="nav-link">
                Audit Logs
            </a>

            <a href="security-config" class="nav-link">
                Security Configuration
            </a>

            <a href="system-maintenance" class="nav-link">
                System Maintenance
            </a>

        <% } %>


        <a href="logout" class="nav-link">
            Logout
        </a>

    <% } %>


    <div class="user-box">

        <div class="user-name">
            <%= username != null ? username : "User" %>
        </div>

        <div class="user-role">
            <%= role != null ? role : "USER" %>
        </div>

    </div>

</div>


<div class="main">

    <div class="topbar">

        <div class="page-title">
            Credential Center
        </div>

        <div class="security-status">
            <span class="status-dot"></span>
            Identity Security Active
        </div>

    </div>


    <div class="content">

        <div class="hero">

            <h1>
                Digital Identity & Credential Security
            </h1>

            <p>
                Manage your digital credentials through a controlled security
                environment with identity-aware access, activity monitoring,
                and security auditing.
            </p>

        </div>


        <!-- SUCCESS MESSAGES -->

        <% if ("added".equals(success)) { %>

            <div class="notice success">
                Credential added successfully.
            </div>

        <% } else if ("updated".equals(success)) { %>

            <div class="notice success">
                Credential updated successfully.
            </div>

        <% } else if ("deleted".equals(success)) { %>

            <div class="notice success">
                Credential removed successfully.
            </div>

        <% } %>


        <!-- ERROR MESSAGES -->

        <% if ("required".equals(error)) { %>

            <div class="notice error">
                Credential name and credential type are required.
            </div>

        <% } else if ("failed".equals(error)) { %>

            <div class="notice error">
                Unable to complete the credential operation. Please try again.
            </div>

        <% } else if ("filetype".equals(error)) { %>

            <div class="notice error">
                Invalid file type. Please upload a supported document or image.
            </div>

        <% } else if ("nofile".equals(error)) { %>

            <div class="notice error">
                No file is attached to this credential.
            </div>

        <% } else if ("filemissing".equals(error)) { %>

            <div class="notice error">
                The uploaded file could not be found.
            </div>

        <% } %>


        <!-- CREDENTIALS + ADD CREDENTIAL -->

        <div class="grid">


            <!-- CREDENTIAL LIST -->

            <div class="card">

                <div class="card-header">

                    <div class="card-title">
                        Your Credentials
                    </div>

                    <div class="count">
                        <%= credentials != null ? credentials.size() : 0 %>
                        Records
                    </div>

                </div>


                <% if (credentials != null && !credentials.isEmpty()) { %>


                    <% for (Credential credential : credentials) { %>

                        <div class="credential">

                            <div class="credential-top">

                                <div>

                                    <div class="credential-name">
                                        <%= credential.getCredentialName() %>
                                    </div>

                                    <div class="credential-type">
                                        <%= credential.getCredentialType() %>
                                    </div>

                                </div>


                                <% if ("ACTIVE".equalsIgnoreCase(
                                        credential.getStatus())) { %>

                                    <span class="badge badge-active">
                                        Active
                                    </span>

                                <% } else { %>

                                    <span class="badge badge-revoked">
                                        <%= credential.getStatus() %>
                                    </span>

                                <% } %>

                            </div>


                            <% if (credential.getDescription() != null
                                    && !credential.getDescription()
                                    .trim().isEmpty()) { %>

                                <div class="credential-description">
                                    <%= credential.getDescription() %>
                                </div>

                            <% } %>


                            <div class="credential-meta">

                                <span>
                                    Credential ID:
                                    #<%= credential.getId() %>
                                </span>

                                <span>
                                    Added:
                                    <%= credential.getUploadedAt() %>
                                </span>

                                <% if (credential.getFileName() != null
                                        && !credential.getFileName()
                                        .trim().isEmpty()) { %>

                                    <span>
                                        File:
                                        <%= credential.getFileName() %>
                                    </span>

                                <% } %>

                            </div>


                            <div class="credential-actions">

                                <% if (credential.getFilePath() != null
                                        && !credential.getFilePath()
                                        .trim().isEmpty()) { %>

                                    <a
                                        href="credentials?action=view&id=<%= credential.getId() %>"
                                        class="action-btn view-btn"
                                        target="_blank"
                                        rel="noopener noreferrer">

                                        View Document

                                    </a>

                                <% } %>


                                <button
                                    type="button"
                                    class="action-btn edit-btn"
                                    onclick="toggleEdit(
                                        <%= credential.getId() %>)">

                                    Edit

                                </button>


                                <form
                                    action="credentials"
                                    method="post"
                                    style="display:inline;"
                                    onsubmit="return confirm(
                                        'Are you sure you want to remove this credential?');">

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="delete">

                                    <input
                                        type="hidden"
                                        name="id"
                                        value="<%= credential.getId() %>">

                                    <button
                                        type="submit"
                                        class="action-btn remove-btn">

                                        Remove

                                    </button>

                                </form>

                            </div>


                            <!-- EDIT PANEL -->

                            <div
                                id="edit-<%= credential.getId() %>"
                                class="edit-panel">

                                <div class="edit-panel-title">
                                    Edit Credential
                                </div>


                                <form
                                    action="credentials"
                                    method="post">

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="edit">

                                    <input
                                        type="hidden"
                                        name="id"
                                        value="<%= credential.getId() %>">


                                    <label>
                                        Credential Name
                                    </label>

                                    <input
                                        type="text"
                                        name="credentialName"
                                        value="<%= credential.getCredentialName() %>"
                                        maxlength="150"
                                        required>


                                    <label>
                                        Credential Type
                                    </label>

                                    <select
                                        name="credentialType"
                                        required>

                                        <option value="">
                                            Select credential type
                                        </option>

                                        <option
                                            value="Academic Certificate"
                                            <%= "Academic Certificate".equals(
                                                credential.getCredentialType())
                                                ? "selected" : "" %>>

                                            Academic Certificate

                                        </option>

                                        <option
                                            value="Course Certificate"
                                            <%= "Course Certificate".equals(
                                                credential.getCredentialType())
                                                ? "selected" : "" %>>

                                            Course Certificate

                                        </option>

                                        <option
                                            value="Student ID"
                                            <%= "Student ID".equals(
                                                credential.getCredentialType())
                                                ? "selected" : "" %>>

                                            Student ID

                                        </option>

                                        <option
                                            value="Professional Credential"
                                            <%= "Professional Credential".equals(
                                                credential.getCredentialType())
                                                ? "selected" : "" %>>

                                            Professional Credential

                                        </option>

                                        <option
                                            value="Resume"
                                            <%= "Resume".equals(
                                                credential.getCredentialType())
                                                ? "selected" : "" %>>

                                            Resume

                                        </option>

                                        <option
                                            value="Other"
                                            <%= "Other".equals(
                                                credential.getCredentialType())
                                                ? "selected" : "" %>>

                                            Other

                                        </option>

                                    </select>


                                    <label>
                                        Description
                                    </label>

                                    <textarea
                                        name="description"
                                        maxlength="500"
                                        placeholder="Brief description of this credential"><%= credential.getDescription() != null
                                            ? credential.getDescription()
                                            : "" %></textarea>


                                    <div class="edit-actions">

                                        <button
                                            type="submit"
                                            class="save-edit">

                                            Save Changes

                                        </button>

                                        <button
                                            type="button"
                                            class="cancel-edit"
                                            onclick="toggleEdit(
                                                <%= credential.getId() %>)">

                                            Cancel

                                        </button>

                                    </div>

                                </form>

                            </div>

                        </div>

                    <% } %>


                <% } else { %>


                    <div class="empty">

                        <div class="empty-icon">
                            🔐
                        </div>

                        <h3>
                            No credentials registered
                        </h3>

                        <p>
                            Add your first digital credential using the
                            secure registration form.
                        </p>

                    </div>


                <% } %>

            </div>


            <!-- ADD CREDENTIAL -->

            <div class="card">

                <div class="card-header">

                    <div class="card-title">
                        Add Credential
                    </div>

                </div>


                <form
                    action="credentials"
                    method="post"
                    enctype="multipart/form-data">

                    <label for="credentialName">
                        Credential Name
                    </label>

                    <input
                        type="text"
                        id="credentialName"
                        name="credentialName"
                        placeholder="e.g. BCA Certificate"
                        maxlength="150"
                        required>


                    <label for="credentialType">
                        Credential Type
                    </label>

                    <select
                        id="credentialType"
                        name="credentialType"
                        required>

                        <option value="">
                            Select credential type
                        </option>

                        <option value="Academic Certificate">
                            Academic Certificate
                        </option>

                        <option value="Course Certificate">
                            Course Certificate
                        </option>

                        <option value="Student ID">
                            Student ID
                        </option>

                        <option value="Professional Credential">
                            Professional Credential
                        </option>

                        <option value="Resume">
                            Resume
                        </option>

                        <option value="Other">
                            Other
                        </option>

                    </select>


                    <label for="description">
                        Description
                    </label>

                    <textarea
                        id="description"
                        name="description"
                        maxlength="500"
                        placeholder="Brief description of this credential"></textarea>


                    <label for="credentialFile">
                        Credential File
                    </label>

                    <input
                        type="file"
                        id="credentialFile"
                        name="credentialFile"
                        accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.jpg,.jpeg,.png,.gif,.webp,.txt">

                    <div class="file-note">
                        Optional. Maximum file size: 10 MB.
                        Upload a demo certificate, document, or image.
                    </div>


                    <button
                        type="submit"
                        class="btn">

                        Add Credential

                    </button>

                </form>


                <div class="security-note">

                    <strong>
                        Security Notice
                    </strong>

                    <span>
                        This module is designed for demo credentials and
                        sample documents. Do not upload real Aadhaar, PAN,
                        passport, or other sensitive government identity
                        documents. File encryption and secure sharing will
                        be added in the next stages.
                    </span>

                </div>

            </div>

        </div>


        <!-- CREDENTIAL ACTIVITY HISTORY -->

        <div class="card activity-section">

            <div class="card-header">

                <div class="card-title">
                    Credential Activity History
                </div>

                <div class="count">
                    <%= activities != null ? activities.size() : 0 %>
                    Activities
                </div>

            </div>


            <% if (activities != null && !activities.isEmpty()) { %>

                <div class="activity-list">

                    <% for (CredentialActivity activity : activities) { %>

                        <div class="activity-item">

                            <div class="activity-top">

                                <%
                                    String actionClass = "activity-view";

                                    if ("ADD".equalsIgnoreCase(
                                            activity.getAction())) {

                                        actionClass = "activity-add";

                                    } else if ("EDIT".equalsIgnoreCase(
                                            activity.getAction())) {

                                        actionClass = "activity-edit";

                                    } else if ("DELETE".equalsIgnoreCase(
                                            activity.getAction())) {

                                        actionClass = "activity-delete";
                                    }
                                %>

                                <span class="activity-action <%= actionClass %>">
                                    <%= activity.getAction() %>
                                </span>

                                <span
                                    class="<%= "SUCCESS".equalsIgnoreCase(
                                                activity.getStatus())
                                                ? "activity-success"
                                                : "activity-failed" %>">

                                    <%= activity.getStatus() %>

                                </span>

                            </div>


                            <div class="activity-description">
                                <%= activity.getDescription() %>
                            </div>


                            <div class="activity-meta">

                                <span>
                                    Credential ID:
                                    #<%= activity.getCredentialId() %>
                                </span>

                                <span>
                                    User:
                                    <%= activity.getUsername() %>
                                </span>

                                <span>
                                    IP:
                                    <%= activity.getSourceIp() %>
                                </span>

                                <span>
                                    Time:
                                    <%= activity.getCreatedAt() %>
                                </span>

                            </div>

                        </div>

                    <% } %>

                </div>

            <% } else { %>

                <div class="activity-empty">
                    No credential activity has been recorded yet.
                </div>

            <% } %>

        </div>

    </div>

</div>


<script>

    function toggleEdit(id) {

        const panel = document.getElementById("edit-" + id);

        if (!panel) {
            return;
        }

        if (panel.classList.contains("active")) {
            panel.classList.remove("active");
        } else {
            panel.classList.add("active");
        }
    }

</script>

</body>
</html>