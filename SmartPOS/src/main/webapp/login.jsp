<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartPOS | Login</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background: linear-gradient(135deg, #f6f8fd 0%, #f1f5f9 100%);
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
        }

        .login-card {
            background: #ffffff;
            border-radius: 24px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
            padding: 45px 40px;
            width: 100%;
            max-width: 420px;
            position: relative;
            border: 1px solid rgba(255, 255, 255, 0.5);
        }

        .brand-logo {
            text-align: center;
            margin-bottom: 35px;
        }

        .icon-wrapper {
            background: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 2.5rem;
            box-shadow: 0 10px 20px rgba(59, 130, 246, 0.1);
        }

        /* Modern Input Fields */
        .input-group {
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #e5e7eb;
            background-color: #f9fafb;
            transition: all 0.3s;
        }
        .input-group:focus-within {
            border-color: #3b82f6;
            background-color: #ffffff;
            box-shadow: 0 0 0 0.25rem rgba(59, 130, 246, 0.1);
        }
        .input-group-text {
            background-color: transparent;
            border: none;
            color: #9ca3af;
            padding-left: 20px;
        }
        .form-control {
            background-color: transparent;
            border: none;
            padding: 14px 15px 14px 10px;
            box-shadow: none !important;
            font-size: 0.95rem;
        }
        .form-control::placeholder {
            color: #9ca3af;
        }
        .form-label {
            font-weight: 500;
            color: #4b5563;
            font-size: 0.9rem;
            margin-bottom: 8px;
        }

        /* Modern Login Button */
        .login-btn {
            background-color: #3b82f6;
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-size: 1.1rem;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.25);
            margin-top: 10px;
        }
        .login-btn:hover {
            background-color: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.35);
        }

        /* Error Alert */
        .alert-modern {
            background-color: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            border: none;
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 500;
            padding: 12px 15px;
        }

        /* Back to Home Link */
        .back-to-home {
            display: inline-block;
            margin-top: 25px;
            color: #6b7280;
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 500;
            transition: color 0.3s;
        }
        .back-to-home:hover {
            color: #3b82f6;
        }
    </style>
</head>
<body>

<div class="login-card mx-3">

    <div class="brand-logo">
        <div class="icon-wrapper">
            <i class="fas fa-store"></i>
        </div>
        <h3 class="mt-2 text-dark fw-bold mb-1">SmartPOS</h3>
        <p class="text-muted small fw-medium">Secure Login Portal</p>
    </div>

    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
        <div class="alert alert-modern mb-4 text-center" role="alert">
            <i class="fas fa-exclamation-circle me-1"></i> <%= errorMessage %>
        </div>
    <% } %>

    <form action="login" method="post">
        <div class="mb-4">
            <label for="email" class="form-label">Email Address</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required autofocus>
            </div>
        </div>

        <div class="mb-4">
            <label for="password" class="form-label">Password</label>
            <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
            </div>
        </div>

        <button type="submit" class="btn btn-primary login-btn">
            Sign In <i class="fas fa-arrow-right ms-2"></i>
        </button>
    </form>

    <div class="text-center">
        <a href="index.jsp" class="back-to-home">
            <i class="fas fa-arrow-left me-1"></i> Back to Homepage
        </a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>