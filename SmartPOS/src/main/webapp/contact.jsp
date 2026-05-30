<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartPOS | Contact Us</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8fafc;
            color: #334155;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
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
            font-weight: 500;
        }
        .nav-link:hover, .nav-link.active {
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

        /* Page Header */
        .page-header {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
            padding: 140px 0 80px;
            color: white;
            text-align: center;
            border-bottom-left-radius: 40px;
            border-bottom-right-radius: 40px;
            margin-bottom: -60px; /* Overlap effect */
            box-shadow: 0 10px 30px rgba(59, 130, 246, 0.15);
            position: relative;
            overflow: hidden;
        }
        .page-header::after {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
            bottom: -150px;
            right: -50px;
        }
        .page-header h1 {
            font-weight: 800;
            font-size: 3rem;
            letter-spacing: -1px;
            position: relative;
            z-index: 2;
        }
        .page-header p {
            opacity: 0.9;
            font-weight: 300;
            position: relative;
            z-index: 2;
        }

        /* Contact Section */
        .contact-section {
            position: relative;
            z-index: 10;
            padding-bottom: 80px;
            flex: 1;
        }

        /* Info Box */
        .info-box {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            border-radius: 20px;
            padding: 40px;
            height: 100%;
            box-shadow: 0 15px 35px rgba(37, 99, 235, 0.25);
            position: relative;
            overflow: hidden;
        }
        .info-box::before {
            content: '';
            position: absolute;
            top: -50px;
            left: -50px;
            width: 150px;
            height: 150px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }
        .contact-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 25px;
            position: relative;
            z-index: 2;
        }
        .contact-item i {
            font-size: 1.2rem;
            margin-right: 15px;
            background: rgba(255, 255, 255, 0.2);
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            flex-shrink: 0;
            transition: transform 0.3s ease;
        }
        .contact-item:hover i {
            transform: scale(1.1);
            background: rgba(255, 255, 255, 0.3);
        }

        /* Form Card */
        .contact-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 45px 40px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.02);
            height: 100%;
        }

        /* Modern Inputs */
        .form-control {
            border-radius: 12px;
            padding: 14px 15px;
            border: 1px solid #e2e8f0;
            background-color: #f8fafc;
            transition: all 0.3s ease;
            font-size: 0.95rem;
            box-shadow: none !important;
        }
        .form-control:focus {
            border-color: #3b82f6;
            background-color: #ffffff;
            box-shadow: 0 0 0 0.25rem rgba(59, 130, 246, 0.1) !important;
        }
        .form-label {
            font-weight: 500;
            color: #475569;
            font-size: 0.9rem;
            margin-bottom: 8px;
        }

        /* Footer */
        .footer {
            background: #0f172a;
            color: #94a3b8;
            text-align: center;
            padding: 30px 0;
            border-top: 1px solid #1e293b;
        }
    </style>
</head>
<body>

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
                        <a href="index.jsp" class="nav-link me-lg-4 fw-medium ">Home</a>
                    </li>
                    <li class="nav-item">
                        <a href="contact.jsp" class="nav-link active me-lg-4">Contact Us</a>
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

    <div class="page-header">
        <div class="container">
            <h1>Get in Touch</h1>
            <p class="lead">We'd love to hear from you. Our friendly team is always here to chat.</p>
        </div>
    </div>

    <div class="container contact-section">
        <div class="row g-4 justify-content-center">

            <div class="col-lg-4 col-md-5">
                <div class="info-box">
                    <h4 class="fw-bold mb-4 position-relative" style="z-index:2;">Contact Information</h4>
                    <p class="mb-5 position-relative text-white-50" style="z-index:2; font-size:0.95rem;">Have questions about SmartPOS? Need technical support? Reach out to us.</p>

                    <div class="mt-4">
                        <div class="contact-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <div>
                                <h6 class="fw-bold mb-1">Our Location</h6>
                                <p class="text-white-50 mb-0 small">123 SmartPOS Avenue,<br>Colombo 03, Sri Lanka</p>
                            </div>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-phone-alt"></i>
                            <div>
                                <h6 class="fw-bold mb-1">Phone Number</h6>
                                <p class="text-white-50 mb-0 small">+94 11 234 5678</p>
                            </div>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            <div>
                                <h6 class="fw-bold mb-1">Email Address</h6>
                                <p class="text-white-50 mb-0 small">support@smartpos.com</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-7 col-md-7">
                <div class="contact-card">
                    <h4 class="fw-bold mb-4 text-dark">Send us a Message</h4>
                    <form action="#" method="post">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="name" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="name" name="name" placeholder="John Doe" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="john@example.com" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="subject" class="form-label">Subject</label>
                            <input type="text" class="form-control" id="subject" name="subject" placeholder="How can we help?" required>
                        </div>
                        <div class="mb-4">
                            <label for="message" class="form-label">Message</label>
                            <textarea class="form-control" id="message" name="message" rows="5" placeholder="Write your message here..." required></textarea>
                        </div>
                        <button type="button" class="btn btn-primary-custom btn-modern px-5">
                            <i class="fas fa-paper-plane me-2"></i> Send Message
                        </button>
                    </form>
                </div>
            </div>

        </div>
    </div>

    <footer class="footer mt-auto">
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