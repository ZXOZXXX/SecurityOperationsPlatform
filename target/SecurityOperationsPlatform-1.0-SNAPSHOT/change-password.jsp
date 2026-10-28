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

    String error =
            request.getParameter("error");

    String success =
            request.getParameter("success");

    String minLength =
            request.getParameter("min");

    if (minLength == null || minLength.isBlank()) {
        minLength = "8";
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Change Password | Security Operations Platform
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

            max-width: 1050px;
        }


        /* ==============================
           HEADER CARD
           ============================== */

        .security-header {
            background:
                linear-gradient(
                    135deg,
                    #111c35,
                    #0f172a
                );

            border: 1px solid #1e3a5f;

            border-radius: 14px;

            padding: 24px;

            margin-bottom: 24px;
        }

        .security-header-top {
            display: flex;

            align-items: center;

            gap: 14px;

            margin-bottom: 12px;
        }

        .header-icon {
            width: 44px;
            height: 44px;

            display: flex;

            align-items: center;
            justify-content: center;

            border-radius: 10px;

            background: #172554;

            border: 1px solid #1e40af;

            color: #60a5fa;

            font-size: 20px;
        }

        .security-header h2 {
            color: #f8fafc;

            font-size: 20px;
        }

        .security-header p {
            color: #94a3b8;

            font-size: 13px;

            line-height: 1.6;

            max-width: 700px;
        }

        .account-pill {
            display: inline-flex;

            align-items: center;

            gap: 7px;

            margin-top: 15px;

            padding: 6px 11px;

            border-radius: 20px;

            background: #172554;

            border: 1px solid #1e40af;

            color: #93c5fd;

            font-size: 11px;

            font-weight: 600;
        }

        .status-dot {
            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: #22c55e;

            box-shadow:
                0 0 8px
                rgba(34, 197, 94, 0.65);
        }


        /* ==============================
           MESSAGE
           ============================== */

        .message {
            padding: 12px 14px;

            border-radius: 8px;

            margin-bottom: 18px;

            font-size: 12px;

            font-weight: 600;

            line-height: 1.5;
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


        /* ==============================
           PASSWORD CARD
           ============================== */

        .password-card {
            background: #111827;

            border: 1px solid #1f2937;

            border-radius: 14px;

            padding: 26px;

            max-width: 650px;
        }

        .card-heading {
            margin-bottom: 22px;
        }

        .card-heading h3 {
            color: #f1f5f9;

            font-size: 16px;

            margin-bottom: 5px;
        }

        .card-heading p {
            color: #64748b;

            font-size: 12px;

            line-height: 1.5;
        }


        /* ==============================
           FORM
           ============================== */

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;

            margin-bottom: 7px;

            color: #cbd5e1;

            font-size: 12px;

            font-weight: 600;
        }

        .input-wrapper {
            position: relative;
        }

        .form-group input {
            width: 100%;

            padding:
                12px
                50px
                12px
                13px;

            background: #0b1120;

            border: 1px solid #334155;

            border-radius: 8px;

            color: #f8fafc;

            font-size: 13px;

            outline: none;

            transition:
                border-color 0.2s,
                box-shadow 0.2s;
        }

        .form-group input::placeholder {
            color: #475569;
        }

        .form-group input:focus {
            border-color: #3b82f6;

            box-shadow:
                0 0 0 3px
                rgba(59, 130, 246, 0.12);
        }

        .show-password {
            position: absolute;

            right: 11px;

            top: 50%;

            transform:
                translateY(-50%);

            background: none;

            border: none;

            color: #64748b;

            cursor: pointer;

            font-size: 11px;

            font-weight: 600;
        }

        .show-password:hover {
            color: #93c5fd;
        }


        /* ==============================
           PASSWORD REQUIREMENT
           ============================== */

        .requirement-box {
            background: #0f172a;

            border: 1px solid #1f2937;

            border-radius: 8px;

            padding: 12px 14px;

            margin-bottom: 20px;
        }

        .requirement-title {
            color: #cbd5e1;

            font-size: 11px;

            font-weight: 700;

            margin-bottom: 5px;
        }

        .requirement-text {
            color: #64748b;

            font-size: 11px;

            line-height: 1.5;
        }

        .requirement-text strong {
            color: #93c5fd;
        }


        /* ==============================
           BUTTON
           ============================== */

        .change-button {
            width: 100%;

            padding: 12px;

            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #0891b2
                );

            color: #ffffff;

            border: none;

            border-radius: 8px;

            font-size: 13px;

            font-weight: 700;

            cursor: pointer;

            transition:
                transform 0.2s,
                box-shadow 0.2s,
                opacity 0.2s;
        }

        .change-button:hover {
            transform:
                translateY(-1px);

            box-shadow:
                0 10px 25px
                rgba(37, 99, 235, 0.25);
        }


        /* ==============================
           FOOTER LINKS
           ============================== */

        .footer-actions {
            display: flex;

            gap: 10px;

            margin-top: 22px;
        }

        .footer-link {
            text-decoration: none;

            padding: 9px 13px;

            border: 1px solid #334155;

            border-radius: 7px;

            color: #94a3b8;

            font-size: 11px;

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


        /* ==============================
           RESPONSIVE
           ============================== */

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

        @media (max-width: 500px) {

            .password-card {
                padding: 20px;
            }

            .footer-actions {
                flex-wrap: wrap;
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


    <%
        if ("ADMIN".equals(role)) {
    %>

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
           class="nav-link">

            <span class="nav-icon">
                🔧
            </span>

            System Maintenance

        </a>

    <%
        }
    %>


    <div class="sidebar-bottom">


        <a href="change-password.jsp"
           class="nav-link active">

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
                Change Password
            </h1>

            <p>
                Securely update your account credentials
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


        <!-- HEADER -->

        <div class="security-header">


            <div class="security-header-top">


                <div class="header-icon">
                    🔐
                </div>


                <div>

                    <h2>
                        Account Security
                    </h2>

                </div>


            </div>


            <p>

                Update your password regularly to help protect
                your Security Operations Platform account.
                Your new password must satisfy the current
                security configuration.

            </p>


            <div class="account-pill">

                <span class="status-dot"></span>

                Signed in as <%= username %>

            </div>


        </div>


        <!-- ================= MESSAGES ================= -->

        <%
            if ("true".equals(success)) {
        %>

            <div class="message success-message">

                Password changed successfully.

            </div>

        <%
            } else if ("required".equals(error)) {
        %>

            <div class="message error-message">

                All fields are required.

            </div>

        <%
            } else if ("current".equals(error)) {
        %>

            <div class="message error-message">

                Current password is incorrect.

            </div>

        <%
            } else if ("match".equals(error)) {
        %>

            <div class="message error-message">

                New password and confirm password do not match.

            </div>

        <%
            } else if ("length".equals(error)) {
        %>

            <div class="message error-message">

                New password must be at least
                <strong><%= minLength %></strong>
                characters long.

            </div>

        <%
            } else if ("same".equals(error)) {
        %>

            <div class="message error-message">

                New password must be different from your current password.

            </div>

        <%
            } else if ("user".equals(error)) {
        %>

            <div class="message error-message">

                User account could not be found.

            </div>

        <%
            } else if ("failed".equals(error)) {
        %>

            <div class="message error-message">

                Password could not be updated.
                Please try again.

            </div>

        <%
            }
        %>


        <!-- ================= PASSWORD FORM ================= -->

        <div class="password-card">


            <div class="card-heading">

                <h3>
                    Change Your Password
                </h3>

                <p>
                    Enter your current password and choose a
                    new password for your account.
                </p>

            </div>


            <div class="requirement-box">

                <div class="requirement-title">
                    PASSWORD REQUIREMENT
                </div>

                <div class="requirement-text">

                    Your new password must contain at least
                    <strong><%= minLength %> characters</strong>.

                </div>

            </div>


            <form
                action="change-password"
                method="post"
                onsubmit="handlePasswordChange()"
            >


                <!-- CURRENT PASSWORD -->

                <div class="form-group">

                    <label for="currentPassword">
                        Current Password
                    </label>

                    <div class="input-wrapper">

                        <input
                            type="password"
                            id="currentPassword"
                            name="currentPassword"
                            placeholder="Enter current password"
                            autocomplete="current-password"
                            required
                        >

                        <button
                            type="button"
                            class="show-password"
                            onclick="togglePassword(
                                'currentPassword',
                                this
                            )"
                        >
                            Show
                        </button>

                    </div>

                </div>


                <!-- NEW PASSWORD -->

                <div class="form-group">

                    <label for="newPassword">
                        New Password
                    </label>

                    <div class="input-wrapper">

                        <input
                            type="password"
                            id="newPassword"
                            name="newPassword"
                            minlength="<%= minLength %>"
                            placeholder="Enter new password"
                            autocomplete="new-password"
                            required
                        >

                        <button
                            type="button"
                            class="show-password"
                            onclick="togglePassword(
                                'newPassword',
                                this
                            )"
                        >
                            Show
                        </button>

                    </div>

                </div>


                <!-- CONFIRM PASSWORD -->

                <div class="form-group">

                    <label for="confirmPassword">
                        Confirm New Password
                    </label>

                    <div class="input-wrapper">

                        <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            minlength="<%= minLength %>"
                            placeholder="Confirm new password"
                            autocomplete="new-password"
                            required
                        >

                        <button
                            type="button"
                            class="show-password"
                            onclick="togglePassword(
                                'confirmPassword',
                                this
                            )"
                        >
                            Show
                        </button>

                    </div>

                </div>


                <button
                    type="submit"
                    class="change-button"
                    id="changeButton"
                >

                    Change Password

                </button>


            </form>


        </div>


        <!-- ================= FOOTER ================= -->

        <div class="footer-actions">


            <a
                href="dashboard.jsp"
                class="footer-link">

                Back to Dashboard

            </a>


            <a
                href="logout"
                class="footer-link logout">

                Logout

            </a>


        </div>


    </section>


</main>


<script>


/* ==========================================
   SHOW / HIDE PASSWORD
   ========================================== */

function togglePassword(
    fieldId,
    button
) {

    const field =
        document.getElementById(fieldId);


    if (field.type === "password") {

        field.type = "text";

        button.textContent = "Hide";

    } else {

        field.type = "password";

        button.textContent = "Show";

    }

}


/* ==========================================
   SUBMIT STATE
   ========================================== */

function handlePasswordChange() {

    const button =
        document.getElementById("changeButton");

    button.disabled = true;

    button.textContent =
        "Updating Password...";

}

</script>


</body>

</html>