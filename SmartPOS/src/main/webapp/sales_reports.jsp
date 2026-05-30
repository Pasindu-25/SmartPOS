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
    <title>Sales Reports | SmartPOS</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body { background-color: #f4f7f6; overflow-x: hidden; font-family: 'Poppins', sans-serif; }

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
        .sidebar a { color: #9ca3af; text-decoration: none; display: block; padding: 12px 20px; margin: 8px 15px; border-radius: 10px; transition: all 0.3s ease; font-weight: 500; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.05); color: #ffffff; transform: translateX(5px); }
        .sidebar a.active { background-color: #3b82f6; color: white; box-shadow: 0 4px 15px rgba(59, 130, 246, 0.4); }

        .main-content {
            width: calc(100% - 280px);
            flex-grow: 1;
            transition: all 0.3s ease;
        }

        .top-navbar { background-color: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); box-shadow: 0 4px 20px rgba(0,0,0,0.03); border-bottom: 1px solid rgba(0,0,0,0.05); }

        .dash-card { border: none; border-radius: 16px; background: #ffffff; box-shadow: 0 10px 30px rgba(0,0,0,0.04); transition: all 0.3s ease; }
        .dash-card:hover { box-shadow: 0 15px 35px rgba(0,0,0,0.08); }

        .revenue-card { background: linear-gradient(135deg, #10b981 0%, #047857 100%); color: white; border: none; border-radius: 16px; box-shadow: 0 10px 30px rgba(16, 185, 129, 0.2); transition: all 0.3s ease; }
        .revenue-card:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(16, 185, 129, 0.3); }
        .revenue-icon { background: rgba(255, 255, 255, 0.2); width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; }

        .table-light th { background-color: #f8fafc; color: #64748b; font-weight: 600; border-bottom: 2px solid #e2e8f0; }
        .badge-soft-secondary { background-color: rgba(108, 117, 125, 0.1); color: #6c757d; border: 1px solid rgba(108, 117, 125, 0.2); }

        /* Modal Custom Styles */
        .modal-content { border-radius: 24px; overflow: hidden; border: none; }
        .invoice-box { background-color: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 16px; }
        .modal-table th { color: #94a3b8; font-weight: 500; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #f1f5f9 !important; }
        .modal-table td { border-bottom: 1px solid #f8fafc; }

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
                <h4 class="mb-0 fw-bold sidebar-brand text-white"><i class="fas fa-store text-primary me-2"></i>SmartPOS</h4>
                <button class="btn btn-sm btn-outline-light d-lg-none border-0" id="closeSidebar"><i class="fas fa-times"></i></button>
            </div>
            <div class="py-2">
                <a href="admin_dashboard.jsp"><i class="fas fa-layer-group me-3 w-20px text-center"></i> Dashboard</a>
                <a href="categories"><i class="fas fa-tags me-3 w-20px text-center"></i> Categories</a>
                <a href="products"><i class="fas fa-box-open me-3 w-20px text-center"></i> Manage Products</a>
                <a href="reports" class="active"><i class="fas fa-chart-pie me-3 w-20px text-center"></i> Sales Reports</a>
                <a href="users"><i class="fas fa-users me-3 w-20px text-center"></i> Manage Users</a>
                <a href="logout.jsp" class="text-danger mt-5"><i class="fas fa-sign-out-alt me-3 w-20px text-center"></i> Logout</a>
            </div>
        </div>

        <div class="main-content">
            <nav class="navbar top-navbar px-4 py-3 sticky-top mb-4">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light shadow-sm border-0 d-lg-none me-3" id="sidebarToggle">
                        <i class="fas fa-bars text-dark"></i>
                    </button>
                    <h4 class="mb-0 fw-bold text-dark d-none d-sm-block">Sales & Revenue Reports</h4>
                    <h5 class="mb-0 fw-bold text-dark d-block d-sm-none">Sales Reports</h5>
                </div>

                <div class="d-flex align-items-center bg-light px-3 py-2 rounded-pill border">
                    <i class="fas fa-user-shield text-primary me-2"></i>
                    <span class="text-muted fw-medium fs-6 d-none d-md-inline">Welcome, </span>
                    <strong class="text-dark ms-md-1"><%= loggedUser.getFullName() %></strong>
                </div>
            </nav>

            <div class="container-fluid px-4">
                <div class="row mb-4">
                    <div class="col-xl-4 col-md-6">
                        <div class="card revenue-card p-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="text-white-50 fw-medium mb-1 fs-6">Total Revenue</p>
                                    <h2 class="fw-bold mb-0">Rs. ${totalRevenue != null ? totalRevenue : "0.00"}</h2>
                                </div>
                                <div class="revenue-icon"><i class="fas fa-chart-line text-white"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card dash-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                        <h5 class="fw-bold mb-0">Recent Transactions</h5>
                        <button id="exportBtn" class="btn btn-sm btn-outline-secondary rounded-pill px-3 border"><i class="fas fa-download me-2"></i> Export Data</button>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="salesTable">
                            <thead class="table-light">
                                <tr>
                                    <th class="py-3 px-3 rounded-start">Date & Time</th>
                                    <th class="py-3">Invoice No</th>
                                    <th class="py-3">Cashier</th>
                                    <th class="py-3 text-center">Payment Method</th>
                                    <th class="py-3 text-end">Amount</th>
                                    <th class="py-3 px-3 rounded-end text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sale" items="${salesList}">
                                    <tr>
                                        <td class="px-3 text-muted small"><i class="far fa-clock me-1"></i> ${sale.saleDate}</td>
                                        <td class="fw-bold"><span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 font-monospace">${sale.invoiceNumber}</span></td>
                                        <td class="text-dark fw-medium"><i class="fas fa-user-circle text-secondary me-1"></i> ${sale.cashierName}</td>
                                        <td class="text-center"><span class="badge badge-soft-secondary px-3 py-2 rounded-pill"><i class="fas fa-money-bill-wave me-1"></i> ${sale.paymentMethod}</span></td>
                                        <td class="fw-bold text-success text-end fs-6">Rs. ${sale.netTotal}</td>
                                        <td class="px-3 text-end">
                                            <button class="btn btn-sm btn-light text-primary border rounded-3" title="View Details" onclick="viewSaleDetails(${sale.saleId}, '${sale.invoiceNumber}', ${sale.netTotal})">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty salesList}">
                                    <tr><td colspan="6" class="text-center text-muted py-5"><i class="fas fa-receipt fs-1 text-light mb-3"></i><br>No sales recorded yet.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="invoiceModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">

                <div class="modal-header border-0 pb-0 px-4 pt-4">
                    <div class="d-flex align-items-center">
                        <div class="bg-primary bg-opacity-10 text-primary p-3 rounded-circle me-3 d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                            <i class="fas fa-file-invoice-dollar fs-4"></i>
                        </div>
                        <div>
                            <h4 class="modal-title fw-bold text-dark mb-0">Invoice Details</h4>
                            <p class="text-muted small mb-0">Transaction Summary</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close shadow-none mb-auto mt-2" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body px-4 py-4">

                    <div class="invoice-box p-3 mb-4 text-center">
                        <span class="text-muted fw-medium small d-block mb-1">Invoice Number</span>
                        <span class="fw-bold text-primary font-monospace fs-5" id="modalInvoiceNo">INV-XXXX</span>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-borderless modal-table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th class="px-0">Item Name</th>
                                    <th class="text-center">Qty</th>
                                    <th class="text-end">Price</th>
                                    <th class="text-end px-0">Total</th>
                                </tr>
                            </thead>
                            <tbody id="modalItemsBody">
                                </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="3" class="text-end fw-bold text-muted pt-4 pb-0 px-0">Net Total:</td>
                                    <td class="text-end fw-bold text-success fs-4 pt-4 pb-0 px-0" id="modalNetTotal">Rs. 0.00</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>

                <div class="modal-footer border-0 px-4 pb-4 pt-0 justify-content-center">
                    <button type="button" class="btn btn-light border fw-medium rounded-pill px-5 py-2" data-bs-dismiss="modal">Close Window</button>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function viewSaleDetails(saleId, invoiceNo, netTotal) {
            document.getElementById('modalInvoiceNo').innerText = invoiceNo;
            document.getElementById('modalNetTotal').innerText = 'Rs. ' + parseFloat(netTotal).toFixed(2);

            let tbody = document.getElementById('modalItemsBody');
            tbody.innerHTML = '<tr><td colspan="4" class="text-center py-5"><i class="fas fa-spinner fa-spin text-primary fs-3 mb-2"></i><br><span class="text-muted">Loading items...</span></td></tr>';

            var modal = new bootstrap.Modal(document.getElementById('invoiceModal'));
            modal.show();

            fetch('api/sale-details?id=' + saleId)
                .then(res => res.json())
                .then(data => {
                    tbody.innerHTML = '';
                    if(data.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-4">No items found.</td></tr>';
                    } else {
                        data.forEach(item => {
                            let row = `
                                <tr>
                                    <td class="px-0 fw-medium text-dark py-3">\${item.productName}</td>
                                    <td class="text-center text-muted py-3">\${item.qty}</td>
                                    <td class="text-end text-muted py-3">Rs. \${item.price.toFixed(2)}</td>
                                    <td class="px-0 text-end fw-bold text-dark py-3">Rs. \${item.subtotal.toFixed(2)}</td>
                                </tr>
                            `;
                            tbody.innerHTML += row;
                        });
                    }
                })
                .catch(err => {
                    tbody.innerHTML = '<tr><td colspan="4" class="text-center text-danger py-4"><i class="fas fa-exclamation-triangle me-2"></i> Error loading details.</td></tr>';
                });
        }
    </script>

    <script>
        document.getElementById("exportBtn").addEventListener("click", function () {
            let csv = [];
            let rows = document.querySelectorAll("#salesTable tr");

            for (let i = 0; i < rows.length; i++) {
                let row = [], cols = rows[i].querySelectorAll("td, th");
                let colCount = (cols.length > 1) ? cols.length - 1 : cols.length;

                for (let j = 0; j < colCount; j++) {
                    let text = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, "").trim();
                    row.push('"' + text + '"');
                }
                if(row.length > 0) csv.push(row.join(","));
            }

            let csvFile = new Blob([csv.join("\n")], { type: "text/csv" });
            let downloadLink = document.createElement("a");
            downloadLink.download = "SmartPOS_Sales_Report.csv";
            downloadLink.href = window.URL.createObjectURL(csvFile);
            downloadLink.style.display = "none";
            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
        });

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