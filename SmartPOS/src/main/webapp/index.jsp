<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartPOS | Point of Sale System</title>

    <!-- Google Fonts: Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8fafc; /* Modern soft background */
            color: #334155;
        }

        /* Modern Navbar */
        .navbar-modern {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.03);
            padding: 15px 0;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }
        .navbar-brand {
            font-size: 1.5rem;
            letter-spacing: 0.5px;
        }
        .nav-link {
            color: #475569 !important;
            transition: color 0.3s ease;
        }
        .nav-link:hover {
            color: #3b82f6 !important;
        }

        /* Modern Buttons */
        .btn-modern {
            border-radius: 50px;
            padding: 12px 28px;
            font-weight: 500;
            transition: all 0.3s ease;
            letter-spacing: 0.5px;
        }
        .btn-primary-custom {
            background-color: #3b82f6;
            color: white;
            border: none;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
        }
        .btn-primary-custom:hover {
            background-color: #2563eb;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.4);
        }
        .btn-light-custom {
            background-color: #ffffff;
            color: #3b82f6;
            border: none;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .btn-light-custom:hover {
            background-color: #f8fafc;
            color: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
            color: white;
            padding: 140px 0 100px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        /* Decorative circles for Hero */
        .hero-section::before {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -50px;
            left: -100px;
        }
        .hero-section::after {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
            bottom: -150px;
            right: -100px;
        }
        .hero-content {
            position: relative;
            z-index: 10;
        }
        .hero-section h1 {
            font-size: 4rem;
            font-weight: 800;
            margin-bottom: 20px;
            letter-spacing: -1px;
        }
        .hero-section .lead {
            font-size: 1.25rem;
            font-weight: 300;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Feature Cards */
        .feature-card {
            background: #ffffff;
            padding: 40px 30px;
            border-radius: 20px;
            text-align: center;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
            transition: all 0.3s ease;
            height: 100%;
        }
        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
        }

        .icon-box {
            background: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
            width: 80px;
            height: 80px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            margin-bottom: 25px;
            transition: transform 0.3s ease;
        }
        .feature-card:hover .icon-box {
            transform: scale(1.1) rotate(5deg);
            background: #3b82f6;
            color: white;
        }

        .feature-card h4 {
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 15px;
        }
        .feature-card p {
            color: #64748b;
            font-size: 0.95rem;
            line-height: 1.6;
            margin: 0;
        }

        /* Section Header */
        .section-header {
            margin-bottom: 60px;
        }
        .section-header h2 {
            font-weight: 800;
            color: #0f172a;
            position: relative;
            display: inline-block;
            padding-bottom: 15px;
        }
        .section-header h2::after {
            content: '';
            position: absolute;
            width: 60px;
            height: 4px;
            background-color: #3b82f6;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 2px;
        }

        /* Footer */
        .footer {
            background: #0f172a; /* Deep dark blue */
            color: #94a3b8;
            text-align: center;
            padding: 30px 0;
            margin-top: 60px;
            border-top: 1px solid #1e293b;
        }
    </style>
</head>
<body>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light navbar-modern fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="index.jsp">
                <i class="fas fa-store me-2"></i>SmartPOS
            </a>

            <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <a href="index.jsp" class="nav-link active me-lg-4 fw-medium">Home</a>
                    </li>
                    <li class="nav-item">
                        <a href="contact.jsp" class="nav-link me-lg-4 fw-medium">Contact Us</a>
                    </li>
                    <li class="nav-item mt-3 mt-lg-0">
                        <a href="login.jsp" class="btn btn-primary-custom btn-modern">
                            <i class="fas fa-sign-in-alt me-2"></i> Login to System
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <header class="hero-section">
        <div class="container hero-content">
            <div class="mb-4">
                <div class="d-inline-flex align-items-center justify-content-center bg-white bg-opacity-25 rounded-circle mb-4" style="width: 100px; height: 100px;">
                    <i class="fas fa-store fa-3x text-white"></i>
                </div>
            </div>
            <h1>SmartPOS System</h1>
            <p class="lead mb-5">A complete Web & Mobile solution for your Point of Sale and Inventory Management needs. Elevate your business today.</p>
            <a href="login.jsp" class="btn btn-light-custom btn-modern btn-lg px-5">
                Get Started <i class="fas fa-arrow-right ms-2"></i>
            </a>
        </div>
    </header>

    <!-- Features Section -->
    <section class="container py-5">
        <div class="text-center section-header">
            <h2>Why Choose SmartPOS?</h2>
        </div>

        <div class="row g-4 justify-content-center">

            <!-- Feature 1 -->
            <div class="col-lg-4 col-md-6">
                <div class="feature-card">
                    <div class="icon-box">
                        <i class="fas fa-boxes"></i>
                    </div>
                    <h4>Smart Inventory</h4>
                    <p>Track your stock levels in real-time. Get automatic alerts when items are running low, ensuring you never run out of top sellers.</p>
                </div>
            </div>

            <!-- Feature 2 -->
            <div class="col-lg-4 col-md-6">
                <div class="feature-card">
                    <div class="icon-box">
                        <i class="fas fa-barcode"></i>
                    </div>
                    <h4>Barcode Ready</h4>
                    <p>Quickly scan items using standard barcode readers or your device camera to add them to the bill, drastically speeding up checkouts.</p>
                </div>
            </div>

            <!-- Feature 3 -->
            <div class="col-lg-4 col-md-6">
                <div class="feature-card">
                    <div class="icon-box">
                        <i class="fas fa-chart-pie"></i>
                    </div>
                    <h4>Detailed Reports</h4>
                    <p>View daily and monthly sales reports, track revenue, and understand your business performance with clean, easy-to-read insights.</p>
                </div>
            </div>

        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-center">
                <div class="mb-3 mb-md-0">
                    <h5 class="text-white fw-bold mb-0"><i class="fas fa-store text-primary me-2"></i>SmartPOS</h5>
                </div>
                <div>
                    <p class="mb-0 small">&copy; 2026 SmartPOS System. Designed for Modern Businesses.</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>