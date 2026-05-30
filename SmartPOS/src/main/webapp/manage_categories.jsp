<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartpos.model.User" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"ADMIN".equals(loggedUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories | SmartPOS</title>

    <!-- Google Fonts: Poppins -->
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
        .sidebar-brand {
            font-size: 1.5rem;
            letter-spacing: 1px;
        }
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
        .form-control {
            border-radius: 10px;
            padding: 10px 15px;
            border: 1px solid #e5e7eb;
            box-shadow: none;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            border-color: #3b82f6;
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

        /* --- Media Queries for Mobile/Tablet --- */
        @media (max-width: 991px) {
            .sidebar {
                position: fixed; /* මෙනු එක පාවෙන විදිහට හදනවා */
                left: -280px;    /* මුලින්ම හැංගිලා තියෙන්නේ */
            }
            .sidebar.show-sidebar {
                left: 0;         /* ඉරි තුන එබුවම එළියට එනවා */
            }
            .main-content {
                width: 100%;     /* ෆෝන් එකේදි Main Content එක Full Screen දුවනවා */
            }
            /* Sidebar එක එළියට ආවම පිටිපස්ස කළුවර කරන Overlay එක */
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

        <!-- Mobile Overlay Background -->
        <div class="sidebar-overlay" id="sidebarOverlay"></div>

        <!-- Sidebar -->
        <div class="sidebar" id="sidebar">
            <div class="text-center py-4 mb-2 border-bottom border-secondary border-opacity-25 d-flex justify-content-between align-items-center px-4">
                <h4 class="mb-0 fw-bold sidebar-brand text-white">
                    <i class="fas fa-store text-primary me-2"></i>SmartPOS
                </h4>
                <!-- ෆෝන් එකේදි Sidebar එක වහන (X) බොත්තම -->
                <button class="btn btn-sm btn-outline-light d-lg-none border-0" id="closeSidebar"><i class="fas fa-times"></i></button>
            </div>
            <div class="py-2">
                <a href="admin_dashboard.jsp"><i class="fas fa-layer-group me-3 w-20px text-center"></i> Dashboard</a>
                <a href="categories" class="active"><i class="fas fa-tags me-3 w-20px text-center"></i> Categories</a>
                <a href="products"><i class="fas fa-box-open me-3 w-20px text-center"></i> Manage Products</a>
                <a href="reports"><i class="fas fa-chart-pie me-3 w-20px text-center"></i> Sales Reports</a>
                <a href="users"><i class="fas fa-users me-3 w-20px text-center"></i> Manage Users</a>
                <a href="logout.jsp" class="text-danger mt-5"><i class="fas fa-sign-out-alt me-3 w-20px text-center"></i> Logout</a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Topbar -->
            <nav class="navbar top-navbar px-4 py-3 sticky-top mb-4">
                <div class="d-flex align-items-center">
                    <!-- Hamburger Menu Button (ෆෝන් එකෙන් බලද්දි විතරක් පේනවා) -->
                    <button class="btn btn-light shadow-sm border-0 d-lg-none me-3" id="sidebarToggle">
                        <i class="fas fa-bars text-dark"></i>
                    </button>
                    <!-- Titles -->
                    <h4 class="mb-0 fw-bold text-dark d-none d-sm-block">Manage Categories</h4>
                    <h5 class="mb-0 fw-bold text-dark d-block d-sm-none">Categories</h5>
                </div>

                <div class="d-flex align-items-center bg-light px-3 py-2 rounded-pill border">
                    <i class="fas fa-user-shield text-primary me-2"></i>
                    <span class="text-muted fw-medium fs-6 d-none d-md-inline">Welcome, </span>
                    <strong class="text-dark ms-md-1"><%= loggedUser.getFullName() %></strong>
                </div>
            </nav>

            <div class="container-fluid px-4">

                <!-- Alerts -->
                <c:if test="${not empty sessionScope.successMsg}">
                    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm rounded-3" role="alert">
                        <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMsg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMsg" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMsg}">
                    <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-3" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i> ${sessionScope.errorMsg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMsg" scope="session" />
                </c:if>

                <div class="row g-4">
                    <!-- Add Category Form -->
                    <div class="col-md-4">
                        <div class="card dash-card p-4">
                            <div class="d-flex align-items-center mb-4">
                                <div class="bg-primary bg-opacity-10 text-primary p-2 rounded-3 me-3">
                                    <i class="fas fa-plus fs-5"></i>
                                </div>
                                <h5 class="fw-bold mb-0">Add New Category</h5>
                            </div>

                            <form action="categories" method="post">
                                <input type="hidden" name="action" value="add">

                                <div class="mb-3">
                                    <label class="form-label text-muted fw-medium">Category Name</label>
                                    <input type="text" name="categoryName" class="form-control bg-light" required placeholder="e.g. Beverages">
                                </div>
                                <div class="mb-4">
                                    <label class="form-label text-muted fw-medium">Description (Optional)</label>
                                    <textarea name="description" class="form-control bg-light" rows="4" placeholder="Short description..."></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 shadow-sm">Save Category</button>
                            </form>
                        </div>
                    </div>

                    <!-- Category List Table -->
                    <div class="col-md-8">
                        <div class="card dash-card p-4">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h5 class="fw-bold mb-0">Category List</h5>
                                <span class="badge bg-light text-dark border"><i class="fas fa-list me-1"></i> Directory</span>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="py-3 px-3 rounded-start">ID</th>
                                            <th class="py-3">Category Name</th>
                                            <th class="py-3">Description</th>
                                            <th class="py-3 px-3 rounded-end text-end">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="cat" items="${categories}">
                                            <tr>
                                                <td class="px-3"><span class="badge bg-secondary bg-opacity-10 text-secondary border">#${cat.categoryId}</span></td>
                                                <td class="fw-bold text-dark">${cat.categoryName}</td>
                                                <td class="text-muted small">${cat.description}</td>
                                                <td class="px-3 text-end">
                                                    <!-- Edit Button -->
                                                    <button class="btn btn-sm btn-light text-primary border rounded-3 me-1" title="Edit"
                                                            onclick="editCategory(${cat.categoryId}, '${cat.categoryName}', '${cat.description}')">
                                                        <i class="fas fa-edit"></i>
                                                    </button>

                                                    <!-- Delete Button -->
                                                    <button class="btn btn-sm btn-light text-danger border rounded-3" title="Delete"
                                                            onclick="confirmDelete(${cat.categoryId}, '${cat.categoryName}')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty categories}">
                                            <tr>
                                                <td colspan="4" class="text-center text-muted py-5">
                                                    <i class="fas fa-folder-open fs-1 text-light mb-3"></i><br>
                                                    No categories found. Add one to get started!
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

    <!-- Edit Category Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0 px-4 pt-4">
                    <h5 class="modal-title fw-bold text-dark"><i class="fas fa-edit text-primary me-2"></i> Edit Category</h5>
                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal"></button>
                </div>
                <form action="categories" method="post">
                    <div class="modal-body px-4 py-4">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="categoryId" id="editCategoryId">

                        <div class="mb-3">
                            <label class="form-label text-muted fw-medium">Category Name</label>
                            <input type="text" name="categoryName" id="editCategoryName" class="form-control" required>
                        </div>
                        <div class="mb-0">
                            <label class="form-label text-muted fw-medium">Description (Optional)</label>
                            <textarea name="description" id="editDescription" class="form-control" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 px-4 pb-4 pt-0">
                        <button type="button" class="btn btn-light border fw-medium rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Update Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modern Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg rounded-4 text-center">
                <div class="modal-body p-4 py-5">
                    <div class="bg-danger bg-opacity-10 text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 80px; height: 80px;">
                        <i class="fas fa-exclamation-triangle fa-2x"></i>
                    </div>
                    <h4 class="fw-bold text-dark mb-2">Delete Category?</h4>
                    <p class="text-muted mb-4 small">Are you sure you want to delete <strong id="deleteCategoryName" class="text-dark"></strong>? This action cannot be undone.</p>

                    <div class="d-flex justify-content-center gap-2 mt-2">
                        <button type="button" class="btn btn-light border fw-medium rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger rounded-pill px-4 shadow-sm">Yes, Delete</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JavaScript Functions -->
    <script>
        // Edit Modal Trigger
        function editCategory(id, name, desc) {
            document.getElementById('editCategoryId').value = id;
            document.getElementById('editCategoryName').value = name;
            document.getElementById('editDescription').value = desc;

            var editModal = new bootstrap.Modal(document.getElementById('editModal'));
            editModal.show();
        }

        // Delete Modal Trigger
        function confirmDelete(id, name) {
            document.getElementById('deleteCategoryName').innerText = "'" + name + "'";
            document.getElementById('confirmDeleteBtn').href = 'categories?action=delete&id=' + id;

            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }

        // --- Mobile Sidebar Toggle Script ---
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