<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Register | Security Operations Platform
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
                    circle at 15% 15%,
                    rgba(37, 99, 235, 0.16),
                    transparent 32%
                ),
                radial-gradient(
                    circle at 85% 85%,
                    rgba(6, 182, 212, 0.10),
                    transparent 32%
                ),
                #030712;

            color: #e5e7eb;

            display: flex;

            align-items: center;

            justify-content: center;

            padding: 25px;

            overflow: hidden;

            position: relative;
        }


        /* ==============================
           BACKGROUND
           ============================== */

        .grid {
            position: fixed;

            inset: 0;

            background-image:
                linear-gradient(
                    rgba(59, 130, 246, 0.045) 1px,
                    transparent 1px
                ),
                linear-gradient(
                    90deg,
                    rgba(59, 130, 246, 0.045) 1px,
                    transparent 1px
                );

            background-size: 55px 55px;

            mask-image:
                radial-gradient(
                    ellipse at center,
                    black 15%,
                    transparent 78%
                );

            pointer-events: none;
        }

        .orb {
            position: fixed;

            border-radius: 50%;

            filter: blur(80px);

            pointer-events: none;

            animation:
                floatOrb 12s ease-in-out infinite;
        }

        .orb-one {
            width: 280px;
            height: 280px;

            background:
                rgba(37, 99, 235, 0.13);

            top: -100px;
            left: -100px;
        }

        .orb-two {
            width: 320px;
            height: 320px;

            background:
                rgba(6, 182, 212, 0.08);

            right: -130px;
            bottom: -130px;

            animation-delay: -5s;
        }

        @keyframes floatOrb {

            0%, 100% {
                transform:
                    translate(0, 0);
            }

            50% {
                transform:
                    translate(30px, -20px);
            }
        }


        /* ==============================
           REGISTER WRAPPER
           ============================== */

        .register-wrapper {
            width: 100%;

            max-width: 960px;

            display: grid;

            grid-template-columns:
                minmax(0, 1fr)
                420px;

            gap: 50px;

            align-items: center;

            position: relative;

            z-index: 10;
        }


        /* ==============================
           LEFT PANEL
           ============================== */

        .intro-panel {
            padding: 20px 10px;
        }

        .brand {
            display: flex;

            align-items: center;

            gap: 14px;

            margin-bottom: 25px;
        }

        .brand-icon {
            width: 54px;
            height: 54px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 14px;

            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #0891b2
                );

            border: 1px solid
                rgba(96, 165, 250, 0.45);

            font-size: 25px;

            box-shadow:
                0 0 30px
                rgba(37, 99, 235, 0.28);
        }

        .brand-text h1 {
            font-size: 22px;

            color: #f8fafc;

            margin-bottom: 3px;
        }

        .brand-text p {
            color: #64748b;

            font-size: 12px;
        }

        .intro-panel h2 {
            font-size: 36px;

            line-height: 1.15;

            color: #f8fafc;

            max-width: 500px;

            margin-bottom: 17px;
        }

        .intro-panel h2 span {
            color: #60a5fa;
        }

        .intro-description {
            max-width: 500px;

            color: #94a3b8;

            font-size: 14px;

            line-height: 1.7;

            margin-bottom: 25px;
        }


        /* ==============================
           SECURITY STATUS
           ============================== */

        .security-status {
            display: inline-flex;

            align-items: center;

            gap: 8px;

            padding: 8px 12px;

            border-radius: 20px;

            background:
                rgba(15, 23, 42, 0.75);

            border: 1px solid #1e3a5f;

            color: #93c5fd;

            font-size: 11px;

            font-weight: 600;

            margin-bottom: 28px;
        }

        .status-dot {
            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: #22c55e;

            box-shadow:
                0 0 9px
                rgba(34, 197, 94, 0.7);
        }


        /* ==============================
           FEATURE LIST
           ============================== */

        .feature-list {
            display: grid;

            grid-template-columns:
                repeat(2, minmax(0, 1fr));

            gap: 10px;

            max-width: 520px;
        }

        .feature {
            display: flex;

            align-items: center;

            gap: 9px;

            padding: 10px 12px;

            background:
                rgba(15, 23, 42, 0.55);

            border: 1px solid
                rgba(51, 65, 85, 0.65);

            border-radius: 8px;

            color: #94a3b8;

            font-size: 11px;
        }

        .feature-icon {
            color: #60a5fa;

            font-size: 13px;
        }


        /* ==============================
           REGISTER CARD
           ============================== */

        .register-card {
            width: 100%;

            background:
                rgba(15, 23, 42, 0.88);

            backdrop-filter:
                blur(20px);

            -webkit-backdrop-filter:
                blur(20px);

            border:
                1px solid
                rgba(71, 85, 105, 0.55);

            border-radius: 16px;

            padding: 30px;

            box-shadow:
                0 25px 70px
                rgba(0, 0, 0, 0.50),

                inset 0 1px 0
                rgba(255, 255, 255, 0.04);
        }


        .register-header {
            margin-bottom: 23px;
        }

        .register-header h2 {
            color: #f8fafc;

            font-size: 22px;

            margin-bottom: 7px;
        }

        .register-header p {
            color: #64748b;

            font-size: 12px;

            line-height: 1.5;
        }


        /* ==============================
           FORM
           ============================== */

        .form-group {
            margin-bottom: 17px;
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
                13px;

            background:
                #0b1120;

            border:
                1px solid #334155;

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


        /* ==============================
           PASSWORD
           ============================== */

        .password-row {
            position: relative;
        }

        .password-row input {
            padding-right: 45px;
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
           PASSWORD HINT
           ============================== */

        .password-hint {
            margin-top: 7px;

            color: #475569;

            font-size: 10px;

            line-height: 1.5;
        }


        /* ==============================
           REGISTER BUTTON
           ============================== */

        .register-button {
            width: 100%;

            padding: 12px;

            margin-top: 5px;

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

            box-shadow:
                0 8px 24px
                rgba(37, 99, 235, 0.22);
        }

        .register-button:hover {
            transform:
                translateY(-1px);

            box-shadow:
                0 12px 30px
                rgba(37, 99, 235, 0.32);
        }

        .register-button:disabled {
            opacity: 0.65;

            cursor: not-allowed;

            transform: none;
        }


        /* ==============================
           LOGIN LINK
           ============================== */

        .login-link {
            text-align: center;

            margin-top: 20px;

            padding-top: 18px;

            border-top:
                1px solid #1f2937;

            color: #64748b;

            font-size: 12px;
        }

        .login-link a {
            color: #60a5fa;

            text-decoration: none;

            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }


        /* ==============================
           SECURITY NOTE
           ============================== */

        .security-note {
            display: flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            margin-top: 16px;

            color: #475569;

            font-size: 10px;

            text-align: center;
        }


        /* ==============================
           RESPONSIVE
           ============================== */

        @media (max-width: 850px) {

            .register-wrapper {
                grid-template-columns: 1fr;

                max-width: 430px;

                gap: 20px;
            }

            .intro-panel {
                text-align: center;

                padding: 0;
            }

            .brand {
                justify-content: center;
            }

            .intro-panel h2 {
                font-size: 28px;

                margin-left: auto;

                margin-right: auto;
            }

            .intro-description {
                margin-left: auto;

                margin-right: auto;
            }

            .security-status {
                margin-bottom: 15px;
            }

            .feature-list {
                display: none;
            }
        }


        @media (max-width: 480px) {

            body {
                padding: 15px;
            }

            .register-card {
                padding: 23px;
            }

            .intro-panel h2 {
                font-size: 24px;
            }

            .brand-text h1 {
                font-size: 19px;
            }
        }

    </style>

</head>


<body>


    <!-- BACKGROUND -->

    <div class="grid"></div>

    <div class="orb orb-one"></div>

    <div class="orb orb-two"></div>


    <!-- ==============================
         MAIN WRAPPER
         ============================== -->

    <div class="register-wrapper">


        <!-- ==============================
             INTRO PANEL
             ============================== -->

        <section class="intro-panel">


            <div class="brand">

                <div class="brand-icon">
                    🛡
                </div>

                <div class="brand-text">

                    <h1>
                        Security Ops
                    </h1>

                    <p>
                        Security Operations Platform
                    </p>

                </div>

            </div>


            <h2>

                Create your
                <span>
                    secure account.
                </span>

            </h2>


            <p class="intro-description">

                Create an account to access the security
                operations environment and work with security
                events, alerts, incidents, and threat intelligence.

            </p>


            <div class="security-status">

                <span class="status-dot"></span>

                Protected Registration Environment

            </div>


            <div class="feature-list">


                <div class="feature">

                    <span class="feature-icon">
                        ✓
                    </span>

                    Secure Account Creation

                </div>


                <div class="feature">

                    <span class="feature-icon">
                        ✓
                    </span>

                    Password Protection

                </div>


                <div class="feature">

                    <span class="feature-icon">
                        ✓
                    </span>

                    Security Event Monitoring

                </div>


                <div class="feature">

                    <span class="feature-icon">
                        ✓
                    </span>

                    Role-Based Access

                </div>


            </div>


        </section>


        <!-- ==============================
             REGISTER CARD
             ============================== -->

        <section class="register-card">


            <div class="register-header">

                <h2>
                    Create Account
                </h2>

                <p>
                    Enter your details to create a new platform account.
                </p>

            </div>


            <!-- REGISTER FORM -->

            <form
                action="register"
                method="post"
                onsubmit="handleRegister()"
            >


                <!-- USERNAME -->

                <div class="form-group">

                    <label for="username">
                        Username
                    </label>

                    <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Choose a username"
                        autocomplete="username"
                        required
                    >

                </div>


                <!-- EMAIL -->

                <div class="form-group">

                    <label for="email">
                        Email Address
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Enter your email address"
                        autocomplete="email"
                        required
                    >

                </div>


                <!-- PASSWORD -->

                <div class="form-group">

                    <label for="password">
                        Password
                    </label>

                    <div class="password-row">

                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Create a secure password"
                            autocomplete="new-password"
                            required
                        >

                        <button
                            type="button"
                            class="show-password"
                            id="passwordToggle"
                            onclick="togglePassword()"
                        >
                            Show
                        </button>

                    </div>

                    <div class="password-hint">

                        Use a strong password. Your password is
                        securely protected by the platform.

                    </div>

                </div>


                <!-- REGISTER -->

                <button
                    type="submit"
                    class="register-button"
                    id="registerButton"
                >

                    Create Account

                </button>


            </form>


            <!-- LOGIN -->

            <div class="login-link">

                Already have an account?

                <a href="login.jsp">
                    Sign in here
                </a>

            </div>


        </section>


        <div class="security-note">

            🔒 Protected Security Operations Environment

        </div>


    </div>


<script>


/* ==========================================
   SHOW / HIDE PASSWORD
   ========================================== */

function togglePassword() {

    const password =
        document.getElementById("password");

    const button =
        document.getElementById("passwordToggle");


    if (password.type === "password") {

        password.type = "text";

        button.textContent = "Hide";

    } else {

        password.type = "password";

        button.textContent = "Show";

    }

}


/* ==========================================
   REGISTER BUTTON
   ========================================== */

function handleRegister() {

    const button =
        document.getElementById("registerButton");

    button.disabled = true;

    button.textContent =
        "Creating Account...";

}

</script>


</body>

</html>