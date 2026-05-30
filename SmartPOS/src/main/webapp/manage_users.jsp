<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartpos.model.User" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

    // Security Check: බලයලත් Admin කෙනෙක්දැයි පරීක්ෂා කිරීම
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"ADMIN".equals(loggedUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Main Admin (Super Admin) ද කියලා පරීක්ෂා කිරීම
    boolean isMainAdmin = "admin@pos.com".equals(loggedUser.getEmail());
    request.setAttribute("isMainAdmin", isMainAdmin);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users | SmartPOS</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            background-color: #f4f7f6;
            overflow-x: hidden;
            font-family: 'Poppins', sans-serif;
        }

        /* -------------------------------------------
           Mobile Responsive Sidebar Styles
           ------------------------------------------- */
        .sidebar {
            width: 280px;
            min-height: 100vh;
            background: linear-gradient(180deg, #111827 0%, #1f2937 100%);
            color: white;
            transition: all 0.3s ease;
            box-shadow: 4px 0 15px rgba(0,0,0,0.05);
            z-index: 1040;
        }
        .sidebar-brand { font-size: 1.5rem; letter-spacing: 1px; }
        .sidebar a {
            color: #9ca3af;
            text-decoration: none;
            display: block;
            padding: 12px 20px;
            margin: 8px 15px;
            border-radius: 10px;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .sidebar a:hover {
            background-color: rgba(255, 255, 255, 0.05);
            color: #ffffff;
            transform: translateX(5px);
        }
        .sidebar a.active {
            background-color: #3b82f6;
            color: white;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4);
        }

        .main-content {
            width: calc(100% - 280px);
            flex-grow: 1;
            transition: all 0.3s ease;
        }

        /* Top Navbar */
        .top-navbar {
            background-color: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }

        /* Modern Cards */
        .dash-card {
            border: none;
            border-radius: 16px;
            background: #ffffff;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
            transition: all 0.3s ease;
        }
        .dash-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.08);
        }

        /* Form Inputs & Buttons Styling */
        .form-control, .form-select {
            border-radius: 10px;
            padding: 10px 15px;
            border: 1px solid #e5e7eb;
            box-shadow: none;
            transition: border-color 0.3s;
            background-color: #f9fafb;
        }
        .form-control:focus, .form-select:focus {
            border-color: #3b82f6;
            background-color: #ffffff;
            box-shadow: 0 0 0 0.25rem rgba(59, 130, 246, 0.1);
        }
        .btn-primary {
            background-color: #3b82f6;
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-primary:hover {
            background-color: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(37, 99, 235, 0.3);
        }

        /* Table Styling */
        .table-light th {
            background-color: #f8fafc;
            color: #64748b;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
        }

        /* Modern Badges */
        .badge-soft-primary { background-color: rgba(59, 130, 246, 0.1); color: #3b82f6; border: 1px solid rgba(59, 130, 246, 0.2); }
        .badge-soft-success { background-color: rgba(16, 185, 129, 0.1); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.2); transition: all 0.2s; }
        .badge-soft-danger { background-color: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.2); }
        .badge-soft-secondary { background-color: rgba(108, 117, 125, 0.1); color: #6c757d; border: 1px solid rgba(108, 117, 125, 0.2); transition: all 0.2s; }

        .clickable-badge:hover {
            cursor: pointer;
            opacity: 0.8;
            transform: scale(1.05);
        }

        /* --- Media Queries for Mobile/Tablet --- */
        @media (max-width: 991px) {
            .sidebar {
                position: fixed;
                left: -280px;
            }
            .sidebar.show-sidebar {
                left: 0;
            }
            .main-content {
                width: 100%;
            }
            .sidebar-overlay {
                position: fixed;
                top: 0; left: 0; right: 0; bottom: 0;
                background-color: rgba(0,0,0,0.5);
                z-index: 1030;
                display: none;
            }
            .sidebar-overlay.show {
                display: block;
            }
        }
    </style>
</head>
<body>

    <div class="d-flex position-relative">

        <div class="sidebar-overlay" id="sidebarOverlay"></div>

        <div class="sidebar" id="sidebar">
            <div class="text-center py-4 mb-2 border-bottom border-secondary border-opacity-25 d-flex justify-content-between align-items-center px-4">
                <h4 class="mb-0 fw-bold sidebar-brand text-white">
                    <i class="fas fa-store text-primary me-2"></i>SmartPOS
                </h4>
                <button class="btn btn-sm btn-outline-light d-lg-none border-0" id="closeSidebar"><i class="fas fa-times"></i></button>
            </div>
            <div class="py-2">
                <a href="admin_dashboard.jsp"><i class="fas fa-layer-group me-3 w-20px text-center"></i> Dashboard</a>
                <a href="categories"><i class="fas fa-tags me-3 w-20px text-center"></i> Categories</a>
                <a href="products"><i class="fas fa-box-open me-3 w-20px text-center"></i> Manage Products</a>
                <a href="reports"><i class="fas fa-chart-pie me-3 w-20px text-center"></i> Sales Reports</a>
                <a href="users" class="active"><i class="fas fa-users me-3 w-20px text-center"></i> Manage Users</a>
                <a href="logout.jsp" class="text-danger mt-5"><i class="fas fa-sign-out-alt me-3 w-20px text-center"></i> Logout</a>
            </div>
        </div>

        <div class="main-content">

            <nav class="navbar top-navbar px-4 py-3 sticky-top mb-4">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light shadow-sm border-0 d-lg-none me-3" id="sidebarToggle">
                        <i class="fas fa-bars text-dark"></i>
                    </button>
                    <h4 class="mb-0 fw-bold text-dark d-none d-sm-block">Manage Users</h4>
                    <h5 class="mb-0 fw-bold text-dark d-block d-sm-none">System Users</h5>
                </div>

                <div class="d-flex align-items-center bg-light px-3 py-2 rounded-pill border">
                    <i class="fas fa-user-shield text-primary me-2"></i>
                    <span class="text-muted fw-medium fs-6 d-none d-md-inline">Welcome, </span>
                    <strong class="text-dark ms-md-1"><%= loggedUser.getFullName() %></strong>

                    <c:if test="${isMainAdmin}">
                        <span class="badge bg-danger ms-2">Super Admin</span>
                    </c:if>
                </div>
            </nav>

            <div class="container-fluid px-4">

                <c:if test="${not empty sessionScope.successMsg}">
                    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-3">
                        <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMsg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMsg" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-3">
                        <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMsg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="errorMsg" scope="session" />
                </c:if>

                <div class="row g-4">

                    <div class="col-xl-4 col-lg-5">
                        <div class="card dash-card p-4 h-100">
                            <div class="d-flex align-items-center mb-4">
                                <div class="bg-primary bg-opacity-10 text-primary p-2 rounded-3 me-3">
                                    <i class="fas fa-user-plus fs-5"></i>
                                </div>
                                <h5 class="fw-bold mb-0">Create New Account</h5>
                            </div>

                            <form action="users" method="post">
                                <div class="mb-3">
                                    <label class="form-label text-muted fw-medium small">Full Name</label>
                                    <input type="text" name="fullName" class="form-control" required placeholder="e.g. Nimal Perera">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-muted fw-medium small">Email Address</label>
                                    <input type="email" name="email" class="form-control" required placeholder="name@company.com">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-muted fw-medium small">Password</label>
                                    <input type="password" name="password" class="form-control" required placeholder="Create a strong password">
                                </div>

                                <div class="row mb-4">
                                    <div class="col">
                                        <label class="form-label text-muted fw-medium small">Role</label>
                                        <select name="role" class="form-select">
                                            <option value="CASHIER">Cashier</option>
                                            <c:if test="${isMainAdmin}">
                                                <option value="ADMIN">Admin</option>
                                            </c:if>
                                        </select>
                                    </div>
                                    <div class="col">
                                        <label class="form-label text-muted fw-medium small">Status</label>
                                        <select name="status" class="form-select">
                                            <option value="ACTIVE">Active</option>
                                            <option value="INACTIVE">Inactive</option>
                                        </select>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 shadow-sm mt-auto">Create User</button>
                            </form>
                        </div>
                    </div>

                    <div class="col-xl-8 col-lg-7">
                        <div class="card dash-card p-4 h-100">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h5 class="fw-bold mb-0">System Users</h5>
                                <span class="badge bg-light text-dark border"><i class="fas fa-users-cog me-1"></i> Directory</span>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="py-3 px-3 rounded-start">Name & Email</th>
                                            <th class="py-3 text-center">Role</th>
                                            <th class="py-3 text-center">Status</th>
                                            <th class="py-3 px-3 rounded-end text-end">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <c:forEach var="u" items="${usersList}">

                                            <c:set var="isMaster" value="${u.email == 'admin@pos.com'}" />
                                            <c:set var="canManage" value="${isMainAdmin or (u.role == 'CASHIER' and not isMaster)}" />

                                            <tr>
                                                <td class="px-3 fw-bold text-dark">
                                                    <div class="d-flex align-items-center">
                                                        <div class="bg-secondary bg-opacity-10 text-secondary rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px; flex-shrink: 0;">
                                                            <i class="fas fa-user"></i>
                                                        </div>
                                                        <div>
                                                            ${u.fullName} <br>
                                                            <small class="text-muted fw-normal">${u.email}</small>
                                                        </div>
                                                    </div>
                                                </td>

                                                <td class="text-center">
                                                    <c:if test="${u.role == 'ADMIN'}">
                                                        <span class="badge badge-soft-danger px-3 py-2 rounded-pill">Admin</span>
                                                    </c:if>
                                                    <c:if test="${u.role == 'CASHIER'}">
                                                        <span class="badge badge-soft-primary px-3 py-2 rounded-pill">Cashier</span>
                                                    </c:if>
                                                </td>

                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${canManage and not isMaster}">
                                                            <a href="users?action=toggle&id=${u.userId}" class="text-decoration-none">
                                                                <c:if test="${u.status == 'ACTIVE'}">
                                                                    <span class="badge badge-soft-success px-3 py-2 rounded-pill clickable-badge">Active</span>
                                                                </c:if>
                                                                <c:if test="${u.status != 'ACTIVE'}">
                                                                    <span class="badge badge-soft-secondary px-3 py-2 rounded-pill clickable-badge">Inactive</span>
                                                                </c:if>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:if test="${u.status == 'ACTIVE'}">
                                                                <span class="badge badge-soft-success px-3 py-2 rounded-pill">Active</span>
                                                            </c:if>
                                                            <c:if test="${u.status != 'ACTIVE'}">
                                                                <span class="badge badge-soft-secondary px-3 py-2 rounded-pill">Inactive</span>
                                                            </c:if>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td class="px-3 text-end">
                                                    <c:choose>
                                                        <c:when test="${canManage and not isMaster}">
                                                            <a href="users?action=delete&id=${u.userId}" onclick="return confirm('Are you sure you want to delete ${u.fullName}?');" class="btn btn-sm btn-light text-danger border rounded-3" title="Delete User">
                                                                <i class="fas fa-trash"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-sm btn-light text-muted border rounded-3" disabled title="No Permission">
                                                                <i class="fas fa-lock"></i>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>

                                        </c:forEach>

                                        <c:if test="${empty usersList}">
                                            <tr>
                                                <td colspan="4" class="text-center text-muted py-5">
                                                    <i class="fas fa-users-slash fs-1 text-light mb-3"></i><br>
                                                    No users found in the system.
                                                </td>
                                            </tr>
                                        </c:if>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');
        const toggleBtn = document.getElementById('sidebarToggle');
        const closeBtn = document.getElementById('closeSidebar');

        // Toggle Sidebar
        toggleBtn.addEventListener('click', () => {
            sidebar.classList.add('show-sidebar');
            overlay.classList.add('show');
        });

        // Close Sidebar
        const closeSidebar = () => {
            sidebar.classList.remove('show-sidebar');
            overlay.classList.remove('show');
        };

        closeBtn.addEventListener('click', closeSidebar);
        overlay.addEventListener('click', closeSidebar);
    </script>
</body>
</html>