<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="com.security.securityoperationsplatform.SecurityConfigDAO"%>

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

    SecurityConfigDAO configDAO =
            new SecurityConfigDAO();

    String maxFailedAttempts =
            configDAO.getConfigValue(
                "MAX_FAILED_ATTEMPTS"
            );

    String accountLockout =
            configDAO.getConfigValue(
                "ACCOUNT_LOCKOUT_ENABLED"
            );

    String bruteForceDetection =
            configDAO.getConfigValue(
                "BRUTE_FORCE_DETECTION_ENABLED"
            );

    String bruteForceWindow =
            configDAO.getConfigValue(
                "BRUTE_FORCE_TIME_WINDOW"
            );

    String minPasswordLength =
            configDAO.getConfigValue(
                "MIN_PASSWORD_LENGTH"
            );

    String auditLogging =
            configDAO.getConfigValue(
                "AUDIT_LOGGING_ENABLED"
            );

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>
        Security Configuration - Security Operations Platform
    </title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #07111f;
            color: #e8f1ff;
        }

        .container {
            width: 90%;
            max-width: 1100px;
            margin: 40px auto;
        }

        .header {
            margin-bottom: 30px;
        }

        .header h1 {
            margin-bottom: 8px;
            color: #ffffff;
        }

        .header p {
            color: #8fa8c4;
        }

        .back {
            display: inline-block;
            margin-bottom: 25px;
            color: #38bdf8;
            text-decoration: none;
        }

        .back:hover {
            text-decoration: underline;
        }

        .message {
            padding: 14px 18px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .success {
            background: #063b2b;
            color: #5ee7b7;
            border: 1px solid #087f5b;
        }

        .error {
            background: #401b1b;
            color: #ff8f8f;
            border: 1px solid #8f3030;
        }

        .section {
            background: #0d1b2e;
            border: 1px solid #1d3552;
            border-radius: 14px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
        }

        .section h2 {
            margin-top: 0;
            color: #38bdf8;
        }

        .setting {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 30px;
            padding: 20px 0;
            border-bottom: 1px solid #1d3552;
        }

        .setting:last-child {
            border-bottom: none;
        }

        .info {
            flex: 1;
        }

        .info h3 {
            margin: 0 0 7px;
            color: #ffffff;
        }

        .info p {
            margin: 0;
            color: #8fa8c4;
            font-size: 14px;
        }

        form {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        input[type="text"],
        input[type="number"],
        select {
            width: 150px;
            padding: 10px;
            border-radius: 7px;
            border: 1px solid #31506f;
            background: #07111f;
            color: #ffffff;
            outline: none;
        }

        input:focus,
        select:focus {
            border-color: #38bdf8;
        }

        button {
            padding: 10px 16px;
            border: none;
            border-radius: 7px;
            background: #0284c7;
            color: white;
            cursor: pointer;
            font-weight: bold;
        }

        button:hover {
            background: #0369a1;
        }

        .footer {
            text-align: center;
            color: #607994;
            margin-top: 35px;
        }

        @media (max-width: 700px) {

            .setting {
                flex-direction: column;
                align-items: flex-start;
            }

            form {
                width: 100%;
            }

            input[type="text"],
            input[type="number"],
            select {
                width: 100%;
            }

        }

    </style>

</head>

<body>

<div class="container">

    <a class="back" href="admin.jsp">
        ← Back to Admin Panel
    </a>

    <div class="header">

        <h1>Security Configuration</h1>

        <p>
            Manage authentication, detection and audit security settings.
        </p>

    </div>

    <%
        if ("true".equals(success)) {
    %>

        <div class="message success">
            Security configuration updated successfully.
        </div>

    <%
        } else if ("required".equals(error)) {
    %>

        <div class="message error">
            Configuration key and value are required.
        </div>

    <%
        } else if ("failed".equals(error)) {
    %>

        <div class="message error">
            Configuration could not be updated.
        </div>

    <%
        }
    %>


    <!-- AUTHENTICATION -->

    <div class="section">

        <h2>Authentication Security</h2>

        <div class="setting">

            <div class="info">

                <h3>Maximum Failed Login Attempts</h3>

                <p>
                    Number of failed login attempts before an account
                    can be automatically locked.
                </p>

            </div>

            <form action="security-config" method="post">

                <input
                    type="hidden"
                    name="configKey"
                    value="MAX_FAILED_ATTEMPTS"
                >

                <input
                    type="number"
                    name="configValue"
                    value="<%= maxFailedAttempts %>"
                    min="1"
                    max="20"
                    required
                >

                <button type="submit">
                    Update
                </button>

            </form>

        </div>


        <div class="setting">

            <div class="info">

                <h3>Account Lockout</h3>

                <p>
                    Enable or disable automatic account lockout.
                </p>

            </div>

            <form action="security-config" method="post">

                <input
                    type="hidden"
                    name="configKey"
                    value="ACCOUNT_LOCKOUT_ENABLED"
                >

                <select name="configValue">

                    <option value="true"
                        <%= "true".equals(accountLockout)
                            ? "selected" : "" %>>
                        Enabled
                    </option>

                    <option value="false"
                        <%= "false".equals(accountLockout)
                            ? "selected" : "" %>>
                        Disabled
                    </option>

                </select>

                <button type="submit">
                    Update
                </button>

            </form>

        </div>


        <div class="setting">

            <div class="info">

                <h3>Minimum Password Length</h3>

                <p>
                    Minimum number of characters required for a new password.
                </p>

            </div>

            <form action="security-config" method="post">

                <input
                    type="hidden"
                    name="configKey"
                    value="MIN_PASSWORD_LENGTH"
                >

                <input
                    type="number"
                    name="configValue"
                    value="<%= minPasswordLength %>"
                    min="6"
                    max="30"
                    required
                >

                <button type="submit">
                    Update
                </button>

            </form>

        </div>

    </div>


    <!-- DETECTION -->

    <div class="section">

        <h2>Detection Security</h2>

        <div class="setting">

            <div class="info">

                <h3>Brute-Force Detection</h3>

                <p>
                    Enable or disable automatic brute-force detection.
                </p>

            </div>

            <form action="security-config" method="post">

                <input
                    type="hidden"
                    name="configKey"
                    value="BRUTE_FORCE_DETECTION_ENABLED"
                >

                <select name="configValue">

                    <option value="true"
                        <%= "true".equals(bruteForceDetection)
                            ? "selected" : "" %>>
                        Enabled
                    </option>

                    <option value="false"
                        <%= "false".equals(bruteForceDetection)
                            ? "selected" : "" %>>
                        Disabled
                    </option>

                </select>

                <button type="submit">
                    Update
                </button>

            </form>

        </div>


        <div class="setting">

            <div class="info">

                <h3>Brute-Force Detection Window</h3>

                <p>
                    Time window in minutes used when detecting repeated
                    failed login attempts.
                </p>

            </div>

            <form action="security-config" method="post">

                <input
                    type="hidden"
                    name="configKey"
                    value="BRUTE_FORCE_TIME_WINDOW"
                >

                <input
                    type="number"
                    name="configValue"
                    value="<%= bruteForceWindow %>"
                    min="1"
                    max="60"
                    required
                >

                <button type="submit">
                    Update
                </button>

            </form>

        </div>

    </div>


    <!-- AUDIT -->

    <div class="section">

        <h2>Audit Security</h2>

        <div class="setting">

            <div class="info">

                <h3>Audit Logging</h3>

                <p>
                    Enable or disable system audit logging.
                </p>

            </div>

            <form action="security-config" method="post">

                <input
                    type="hidden"
                    name="configKey"
                    value="AUDIT_LOGGING_ENABLED"
                >

                <select name="configValue">

                    <option value="true"
                        <%= "true".equals(auditLogging)
                            ? "selected" : "" %>>
                        Enabled
                    </option>

                    <option value="false"
                        <%= "false".equals(auditLogging)
                            ? "selected" : "" %>>
                        Disabled
                    </option>

                </select>

                <button type="submit">
                    Update
                </button>

            </form>

        </div>

    </div>


    <div class="footer">

        Security Operations Platform
        <br>
        Administrative Security Configuration

    </div>

</div>

</body>

</html>