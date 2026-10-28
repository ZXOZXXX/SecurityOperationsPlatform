<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Login | Security Operations Platform
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
           BACKGROUND GRID
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


        /* ==============================
           GLOWING ORBS
           ============================== */

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
           NETWORK CANVAS
           ============================== */

        #networkCanvas {
            position: fixed;

            inset: 0;

            width: 100%;
            height: 100%;

            pointer-events: none;

            opacity: 0.42;
        }


        /* ==============================
           LOGIN WRAPPER
           ============================== */

        .login-wrapper {
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
           LEFT INFORMATION PANEL
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
           LOGIN CARD
           ============================== */

        .login-card {
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


        .login-header {
            margin-bottom: 23px;
        }

        .login-header h2 {
            color: #f8fafc;

            font-size: 22px;

            margin-bottom: 7px;
        }

        .login-header p {
            color: #64748b;

            font-size: 12px;

            line-height: 1.5;
        }


        /* ==============================
           ERROR MESSAGE
           ============================== */

        .message {
            padding: 11px 13px;

            border-radius: 8px;

            margin-bottom: 18px;

            font-size: 12px;

            line-height: 1.5;
        }

        .error-message {
            background:
                rgba(127, 29, 29, 0.28);

            border:
                1px solid #7f1d1d;

            color: #fca5a5;
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
                43px
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
           PASSWORD TOGGLE
           ============================== */

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
           FORGOT PASSWORD
           ============================== */

        .forgot-password {
            text-align: right;

            margin-top: -7px;

            margin-bottom: 19px;
        }

        .forgot-password a {
            color: #60a5fa;

            text-decoration: none;

            font-size: 11px;
        }

        .forgot-password a:hover {
            text-decoration: underline;
        }


        /* ==============================
           LOGIN BUTTON
           ============================== */

        .login-button {
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

            box-shadow:
                0 8px 24px
                rgba(37, 99, 235, 0.22);
        }

        .login-button:hover {
            transform:
                translateY(-1px);

            box-shadow:
                0 12px 30px
                rgba(37, 99, 235, 0.32);
        }

        .login-button:disabled {
            opacity: 0.65;

            cursor: not-allowed;

            transform: none;
        }


        /* ==============================
           REGISTER
           ============================== */

        .register-link {
            text-align: center;

            margin-top: 20px;

            padding-top: 18px;

            border-top:
                1px solid #1f2937;

            color: #64748b;

            font-size: 12px;
        }

        .register-link a {
            color: #60a5fa;

            text-decoration: none;

            font-weight: 600;
        }

        .register-link a:hover {
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

            .login-wrapper {
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

            .login-card {
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

    <canvas id="networkCanvas"></canvas>


    <!-- ==============================
         LOGIN WRAPPER
         ============================== -->

    <div class="login-wrapper">


        <!-- ==============================
             INTRO
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

                Secure access to your
                <span>
                    security operations.
                </span>

            </h2>


            <p class="intro-description">

                Monitor security events, investigate alerts,
                manage incidents, analyze indicators of compromise,
                and maintain a centralized security environment.

            </p>


            <div class="security-status">

                <span class="status-dot"></span>

                Security Monitoring Environment

            </div>


            <div class="feature-list">


                <div class="feature">

                    <span class="feature-icon">
                        ✓
                    </span>

                    Secure Authentication

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

                    Alert & Incident Management

                </div>


                <div class="feature">

                    <span class="feature-icon">
                        ✓
                    </span>

                    Threat Intelligence

                </div>


            </div>


        </section>


        <!-- ==============================
             LOGIN CARD
             ============================== -->

        <section class="login-card">


            <div class="login-header">

                <h2>
                    Welcome Back
                </h2>

                <p>
                    Sign in to continue to the security operations
                    platform.
                </p>

            </div>


            <!-- ERROR -->

            <%
                if ("locked".equals(error)) {
            %>

                <div class="message error-message">

                    Account is locked.
                    Please contact an administrator.

                </div>

            <%
                } else if ("invalid".equals(error)) {
            %>

                <div class="message error-message">

                    Invalid username or password.

                </div>

            <%
                }
            %>


            <!-- LOGIN FORM -->

            <form
                action="login"
                method="post"
                onsubmit="handleLogin()"
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
                        placeholder="Enter your username"
                        autocomplete="username"
                        required
                    >

                </div>


                <!-- PASSWORD -->

                <div class="form-group">

                    <label for="password">
                        Password
                    </label>

                    <div class="input-wrapper">

                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required
                        >

                        <button
                            type="button"
                            class="show-password"
                            onclick="togglePassword()"
                            id="passwordToggle"
                        >
                            Show
                        </button>

                    </div>

                </div>


                <!-- FORGOT PASSWORD -->

                <div class="forgot-password">

                    <a
                        href="#"
                        onclick="forgotPassword(); return false;"
                    >
                        Forgot Password?
                    </a>

                </div>


                <!-- LOGIN -->

                <button
                    type="submit"
                    class="login-button"
                    id="loginButton"
                >
                    Login
                </button>


            </form>


            <!-- REGISTER -->

            <div class="register-link">

                Don't have an account?

                <a href="register.jsp">
                    Register here
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
   LOGIN BUTTON
   ========================================== */

function handleLogin() {

    const button =
        document.getElementById("loginButton");

    button.disabled = true;

    button.textContent =
        "Signing in...";
}


/* ==========================================
   FORGOT PASSWORD
   ========================================== */

function forgotPassword() {

    alert(
        "Password reset by email OTP will be added later."
    );
}


/* ==========================================
   CYBERSECURITY NETWORK BACKGROUND
   ========================================== */

const canvas =
    document.getElementById("networkCanvas");

const ctx =
    canvas.getContext("2d");


let width;

let height;

let nodes = [];


const NODE_COUNT = 45;

const MAX_DISTANCE = 150;


function resizeCanvas() {

    width =
        canvas.width =
        window.innerWidth;

    height =
        canvas.height =
        window.innerHeight;

}


function createNodes() {

    nodes = [];

    for (
        let i = 0;
        i < NODE_COUNT;
        i++
    ) {

        nodes.push({

            x:
                Math.random()
                * width,

            y:
                Math.random()
                * height,

            vx:
                (Math.random() - 0.5)
                * 0.25,

            vy:
                (Math.random() - 0.5)
                * 0.25,

            radius:
                Math.random() * 1.8
                + 0.8

        });

    }

}


function drawNetwork() {

    ctx.clearRect(
        0,
        0,
        width,
        height
    );


    /* Move nodes */

    nodes.forEach(node => {

        node.x += node.vx;

        node.y += node.vy;


        if (
            node.x < 0 ||
            node.x > width
        ) {

            node.vx *= -1;

        }


        if (
            node.y < 0 ||
            node.y > height
        ) {

            node.vy *= -1;

        }

    });


    /* Draw connections */

    for (
        let i = 0;
        i < nodes.length;
        i++
    ) {

        for (
            let j = i + 1;
            j < nodes.length;
            j++
        ) {

            const nodeA =
                nodes[i];

            const nodeB =
                nodes[j];


            const dx =
                nodeA.x - nodeB.x;

            const dy =
                nodeA.y - nodeB.y;


            const distance =
                Math.sqrt(
                    dx * dx +
                    dy * dy
                );


            if (
                distance <
                MAX_DISTANCE
            ) {

                const opacity =
                    (
                        1 -
                        distance /
                        MAX_DISTANCE
                    ) * 0.22;


                ctx.beginPath();


                ctx.moveTo(
                    nodeA.x,
                    nodeA.y
                );


                ctx.lineTo(
                    nodeB.x,
                    nodeB.y
                );


                ctx.strokeStyle =
                    `rgba(
                        59,
                        130,
                        246,
                        ${opacity}
                    )`;

                ctx.lineWidth = 1;

                ctx.stroke();

            }

        }

    }


    /* Draw nodes */

    nodes.forEach(node => {

        ctx.beginPath();


        ctx.arc(
            node.x,
            node.y,
            node.radius,
            0,
            Math.PI * 2
        );


        ctx.fillStyle =
            "rgba(96, 165, 250, 0.65)";


        ctx.shadowBlur = 10;


        ctx.shadowColor =
            "rgba(59, 130, 246, 0.7)";


        ctx.fill();


        ctx.shadowBlur = 0;

    });


    requestAnimationFrame(
        drawNetwork
    );

}


window.addEventListener(
    "resize",
    () => {

        resizeCanvas();

        createNodes();

    }
);


resizeCanvas();

createNodes();

drawNetwork();


</script>


</body>

</html>