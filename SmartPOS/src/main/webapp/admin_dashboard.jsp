<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartpos.model.User" %>
<%@ page import="com.smartpos.dao.DashboardDAO" %>
<%@ page import="com.smartpos.dao.ProductDAO" %>
<%@ page import="com.smartpos.model.Product" %>
<%@ page import="java.util.List" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Security Check
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"ADMIN".equals(loggedUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch Dashboard Data directly here
    DashboardDAO dashboardDAO = new DashboardDAO();
    request.setAttribute("todaysSales", dashboardDAO.getTodaysSales());
    request.setAttribute("totalProducts", dashboardDAO.getTotalProducts());

    // Fetch Low Stock Data for Modal
    ProductDAO pDao = new ProductDAO();
    List<Product> lowStockList = pDao.getLowStockProducts();
    request.setAttribute("lowStockList", lowStockList);
    request.setAttribute("lowStockCount", lowStockList.size());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | SmartPOS</title>

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
            color: #9ca3af; text-decoration: none; display: block;
            padding: 12px 20px; margin: 8px 15px; border-radius: 10px;
            transition: all 0.3s ease; font-weight: 500;
        }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.05); color: #ffffff; transform: translateX(5px); }
        .sidebar a.active { background-color: #3b82f6; color: white; box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4); }

        .main-content {
            width: calc(100% - 280px); /* Desktop එකේදි Sidebar එකේ ඉඩ අයින් කරනවා */
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
        .dash-card { border: none; border-radius: 16px; background: #ffffff; box-shadow: 0 10px 30px rgba(0,0,0,0.04); transition: all 0.3s ease; }
        .dash-card:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(0,0,0,0.08); }
        .icon-box { width: 65px; height: 65px; border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; transition: transform 0.3s ease; }
        .dash-card:hover .icon-box { transform: scale(1.1) rotate(5deg); }
        .icon-blue { background: rgba(59, 130, 246, 0.12); color: #3b82f6; }
        .icon-green { background: rgba(16, 185, 129, 0.12); color: #10b981; }
        .icon-red { background: rgba(239, 68, 68, 0.12); color: #ef4444; }

        .btn-modern { border-radius: 10px; padding: 10px 20px; font-weight: 500; transition: all 0.2s; }
        .btn-modern:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .clickable-card { cursor: pointer; border: 1px solid transparent; transition: all 0.3s ease; }
        .clickable-card:hover { border-color: rgba(239, 68, 68, 0.3); box-shadow: 0 15px 35px rgba(239, 68, 68, 0.15); }
        .table-light th { background-color: #f8fafc; color: #64748b; font-weight: 600; border-bottom: 2px solid #e2e8f0; }

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

            .btn-modern {
                width: 100%;
                margin-bottom: 10px;
            }
            .d-flex.gap-3 {
                flex-direction: column;
                gap: 0 !important;
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
                <a href="admin_dashboard.jsp" class="active"><i class="fas fa-layer-group me-3 w-20px text-center"></i> Dashboard</a>
                <a href="categories"><i class="fas fa-tags me-3 w-20px text-center"></i> Categories</a>
                <a href="products"><i class="fas fa-box-open me-3 w-20px text-center"></i> Manage Products</a>
                <a href="reports"><i class="fas fa-chart-pie me-3 w-20px text-center"></i> Sales Reports</a>
                <a href="users"><i class="fas fa-users me-3 w-20px text-center"></i> Manage Users</a>
                <a href="logout.jsp" class="text-danger mt-5"><i class="fas fa-sign-out-alt me-3 w-20px text-center"></i> Logout</a>
            </div>
        </div>

        <div class="main-content">

            <nav class="navbar top-navbar px-4 py-3 sticky-top">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light shadow-sm border-0 d-lg-none me-3" id="sidebarToggle">
                        <i class="fas fa-bars text-dark"></i>
                    </button>
                    <h4 class="mb-0 fw-bold text-dark d-none d-sm-block">Dashboard Overview</h4>
                    <h5 class="mb-0 fw-bold text-dark d-block d-sm-none">Dashboard</h5>
                </div>

                <div class="d-flex align-items-center bg-light px-3 py-2 rounded-pill border">
                    <i class="fas fa-user-shield text-primary me-2"></i>
                    <span class="text-muted fw-medium fs-6 d-none d-md-inline">Welcome, </span>
                    <strong class="text-dark ms-md-1"><%= loggedUser.getFullName() %></strong>
                </div>
            </nav>

            <div class="container-fluid p-4">
                <div class="row g-4 mt-1">

                    <div class="col-md-4">
                        <div class="card dash-card p-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="text-muted fw-medium mb-1 fs-6">Today's Sales</p>
                                    <h2 class="fw-bold mb-0 text-dark">Rs. ${todaysSales != null ? todaysSales : '0.00'}</h2>
                                </div>
                                <div class="icon-box icon-blue"><i class="fas fa-wallet"></i></div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card dash-card p-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="text-muted fw-medium mb-1 fs-6">Total Products in Stock</p>
                                    <h2 class="fw-bold mb-0 text-dark">${totalProducts != null ? totalProducts : '0'}</h2>
                                </div>
                                <div class="icon-box icon-green"><i class="fas fa-boxes"></i></div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card dash-card p-4 clickable-card" data-bs-toggle="modal" data-bs-target="#lowStockModal">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="text-muted fw-medium mb-1 fs-6">Low Stock Alerts</p>
                                    <h2 class="fw-bold mb-0 text-danger">${lowStockCount != null ? lowStockCount : '0'}</h2>
                                    <span class="text-danger small fw-medium mt-2 d-inline-block"><i class="fas fa-search me-1"></i> View Details</span>
                                </div>
                                <div class="icon-box icon-red"><i class="fas fa-exclamation-triangle"></i></div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="card dash-card mt-5 p-4 border-0">
                    <div class="d-flex align-items-center mb-4">
                        <i class="fas fa-bolt text-warning fs-4 me-2"></i>
                        <h5 class="fw-bold mb-0">Quick Actions</h5>
                    </div>
                    <div class="d-flex gap-3">
                        <a href="products" class="btn btn-primary btn-modern"><i class="fas fa-plus me-2"></i> Add New Product</a>
                        <a href="reports" class="btn btn-outline-dark btn-modern bg-white"><i class="fas fa-chart-line me-2"></i> View Sales Reports</a>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <div class="modal fade" id="lowStockModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0 px-4 pt-4">
                    <div class="d-flex align-items-center">
                        <div class="bg-danger bg-opacity-10 text-danger p-3 rounded-circle me-3 d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                            <i class="fas fa-exclamation-triangle fs-4"></i>
                        </div>
                        <div>
                            <h4 class="modal-title fw-bold text-dark mb-0">Low Stock Products</h4>
                            <p class="text-muted small mb-0">Items that need to be restocked immediately.</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close shadow-none mb-auto mt-2" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body px-4 py-4">
                    <div class="table-responsive border rounded-3">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="px-3 py-3">Product Name</th>
                                    <th class="py-3">Category</th>
                                    <th class="py-3 text-center">Current Stock</th>
                                    <th class="py-3 px-3 text-center">Alert Level</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${lowStockList}">
                                    <tr>
                                        <td class="px-3 fw-bold text-dark">${p.productName} <br><small class="text-muted font-monospace">${p.barcode}</small></td>
                                        <td class="text-muted">${p.categoryName}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${p.stockQuantity <= 0}">
                                                    <span class="badge bg-danger px-3 py-2 rounded-pill">Out of Stock</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger fw-bold fs-5">${p.stockQuantity}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-3 text-center text-muted fw-medium">${p.minStockLevel}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty lowStockList}">
                                    <tr>
                                        <td colspan="4" class="text-center text-muted py-5">
                                            <i class="fas fa-check-circle fs-1 text-success opacity-50 mb-3"></i><br>
                                            All products are well stocked!
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 pt-0 justify-content-between">
                    <a href="products" class="btn btn-outline-primary rounded-pill px-4 fw-medium">Manage Inventory <i class="fas fa-arrow-right ms-1"></i></a>
                    <button type="button" class="btn btn-light border fw-medium rounded-pill px-4" data-bs-dismiss="modal">Close</button>
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