<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.smartpos.model.User" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Security Check
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POS Cashier | SmartPOS</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>

    <style>
        body {
            background-color: #f4f7f6;
            height: 100vh;
            overflow: hidden; /* Desktop එකට විතරයි */
            font-family: 'Poppins', sans-serif;
        }

        /* Modern Top Navigation */
        .top-nav {
            background: linear-gradient(90deg, #111827 0%, #1f2937 100%);
            color: white;
            padding: 12px 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            z-index: 10;
            position: relative;
        }

        .pos-container { height: calc(100vh - 65px); padding: 20px; }

        /* Modern Cards */
        .dash-card {
            background: #ffffff;
            border-radius: 16px;
            border: none;
            box-shadow: 0 8px 30px rgba(0,0,0,0.04);
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        /* Inputs & Buttons */
        .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            border: 1px solid #e5e7eb;
            box-shadow: none;
            background-color: #f9fafb;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #3b82f6;
            background-color: #ffffff;
            box-shadow: 0 0 0 0.25rem rgba(59, 130, 246, 0.1);
        }
        .barcode-input { font-size: 1.1rem; }

        /* Table Layout */
        .table-container { flex-grow: 1; overflow-y: auto; overflow-x: auto; margin-top: 15px; padding-right: 5px; }
        .cart-table th {
            position: sticky;
            top: 0;
            background: #f8fafc;
            z-index: 1;
            color: #64748b;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
            white-space: nowrap;
        }

        /* Total Amount Box */
        .total-box {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            padding: 25px 20px;
            border-radius: 16px;
            text-align: right;
            margin-bottom: 20px;
            box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3);
        }
        .total-box h6 { font-weight: 500; opacity: 0.9; letter-spacing: 1px; }
        .total-box h1 { font-size: 3.5rem; margin: 0; font-weight: 700; }

        /* Summary Section */
        .summary-row { display: flex; justify-content: space-between; font-size: 1.1rem; margin-bottom: 12px; border-bottom: 1px dashed #e2e8f0; padding-bottom: 8px; }

        .pay-btn {
            height: 75px;
            font-size: 1.5rem;
            font-weight: 600;
            border-radius: 12px;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            border: none;
            transition: all 0.3s ease;
        }
        .pay-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(16, 185, 129, 0.3) !important;
        }

        /* --- Mobile Responsive Code --- */
        @media (max-width: 991px) {
            body { height: auto; overflow-y: auto; }
            .pos-container { height: auto; padding: 10px; }
            .top-nav { padding: 10px 15px; flex-wrap: wrap; gap: 10px; }
            .top-nav h4 { font-size: 1.2rem; }
            .dash-card { height: auto !important; min-height: 400px; }
            .col-lg-4 { margin-top: 15px; }
            .table-container { min-height: 250px; }
            .total-box h1 { font-size: 2.5rem; }
            .pay-btn { height: 60px; font-size: 1.2rem; }

            /* Scanner Text Size for Mobile */
            #reader { font-size: 14px; }
        }

        /* --- Print CSS --- */
        @media print {
            body * { visibility: hidden; }
            #printReceiptArea, #printReceiptArea * { visibility: visible; }
            #printReceiptArea {
                position: absolute; left: 0; top: 0;
                width: 80mm;
                padding: 10px;
                font-family: 'Courier New', Courier, monospace;
                font-size: 12px;
                color: black;
            }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body>

    <div class="top-nav d-flex justify-content-between align-items-center no-print flex-wrap">
        <h4 class="mb-0 fw-bold"><i class="fas fa-store text-info me-2"></i> SmartPOS Cashier</h4>
        <div class="d-flex align-items-center gap-2">
            <div class="bg-white bg-opacity-10 px-3 py-1 rounded-pill border border-secondary border-opacity-50">
                <i class="fas fa-user-circle me-1 text-light"></i>
                <span class="text-white-50 d-none d-sm-inline">Cashier:</span>
                <strong class="text-white"><%= loggedUser.getFullName() %></strong>
            </div>
            <a href="logout.jsp" class="btn btn-sm btn-outline-light rounded-pill px-3" title="Logout"><i class="fas fa-sign-out-alt"></i></a>
        </div>
    </div>

    <div class="container-fluid pos-container no-print">
        <div class="row h-100 g-3">

            <div class="col-lg-8 h-100">
                <div class="dash-card p-3 p-md-4">

                    <div class="input-group shadow-sm rounded-3 mb-2">
                        <span class="input-group-text bg-white text-primary border-end-0 px-3"><i class="fas fa-barcode fs-5"></i></span>
                        <input type="text" id="barcodeInput" class="form-control barcode-input border-start-0 ps-0" placeholder="Scan or Type Barcode..." autofocus autocomplete="off">

                        <button class="btn btn-primary px-3 px-md-4" type="button" data-bs-toggle="modal" data-bs-target="#scannerModal" title="Open Camera">
                            <i class="fas fa-camera"></i>
                        </button>
                        <button class="btn btn-dark px-3 px-md-4" id="searchBtn"><i class="fas fa-search d-none d-md-inline me-2"></i> Add</button>
                    </div>

                    <div class="table-container">
                        <table class="table table-hover cart-table align-middle">
                            <thead>
                                <tr>
                                    <th width="40%">Item Name</th>
                                    <th width="15%">Price</th>
                                    <th width="20%" class="text-center">Qty</th>
                                    <th width="15%" class="text-end">Subtotal</th>
                                    <th width="10%" class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody id="cartTableBody">
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-5">
                                        <i class="fas fa-shopping-cart fs-1 text-light mb-3"></i><br>
                                        Scan an item to begin...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-3 text-end pt-3 border-top">
                        <button class="btn btn-light text-danger border fw-medium rounded-pill px-4 w-100 w-sm-auto" id="clearBillBtn">
                            <i class="fas fa-trash-alt me-2"></i>Clear Bill
                        </button>
                    </div>
                </div>
            </div>

            <div class="col-lg-4 h-100">
                <div class="dash-card p-3 p-md-4 bg-light">

                    <div class="total-box">
                        <h6>TOTAL AMOUNT</h6>
                        <h1>Rs. 0.00</h1>
                    </div>

                    <div class="mt-2 flex-grow-1">
                        <div class="summary-row">
                            <span class="text-muted fw-medium sub-total-text">Sub Total:</span>
                            <span class="fw-bold text-dark sub-total-amount">Rs. 0.00</span>
                        </div>

                        <div class="mt-3 mb-3 p-3 p-md-4 bg-white rounded-4 border shadow-sm">
                            <label class="form-label fw-bold text-secondary mb-2">Cash Received</label>
                            <div class="input-group mb-3 shadow-sm rounded-3">
                                <span class="input-group-text bg-light text-muted fw-bold border-end-0">Rs.</span>
                                <input type="number" id="cashReceived" class="form-control form-control-lg fw-bold text-end fs-4 text-primary border-start-0" placeholder="0.00">
                            </div>
                            <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                                <span class="fw-bold text-secondary">Balance:</span>
                                <h3 class="fw-bold text-success mb-0" id="balanceAmount">Rs. 0.00</h3>
                            </div>
                        </div>
                    </div>

                    <div class="mt-auto">
                        <button class="btn btn-success w-100 pay-btn shadow-lg text-white"><i class="fas fa-check-circle me-2"></i> PROCESS PAYMENT</button>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade no-print" id="scannerModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-dark text-white border-0">
                    <h5 class="modal-title fw-bold"><i class="fas fa-qrcode me-2"></i> Scan Product</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center p-0 bg-light">
                    <div id="reader" style="width: 100%; min-height: 300px; border-radius: 0 0 8px 8px; overflow: hidden; background: #fff;"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade no-print" id="successModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg text-center rounded-4">
                <div class="modal-body p-4 p-md-5">
                    <div class="mb-4">
                        <i class="fas fa-check-circle text-success" style="font-size: 5rem;"></i>
                    </div>
                    <h3 class="fw-bold mb-3 text-dark">Payment Successful!</h3>
                    <p class="text-muted mb-2">The transaction has been completed.</p>
                    <div class="bg-light p-3 rounded-3 border mb-4">
                        <span class="text-muted d-block mb-1 small fw-medium">Invoice Number:</span>
                        <h4 class="fw-bold text-primary mb-0 font-monospace" id="invoiceDisplay">INV-000000</h4>
                    </div>

                    <div class="d-flex justify-content-center gap-2 flex-wrap mt-4">
                        <button type="button" class="btn btn-outline-dark btn-lg px-4 rounded-pill fw-medium" onclick="printReceipt()">
                            <i class="fas fa-print me-2"></i> Print Bill
                        </button>
                        <button type="button" class="btn btn-success btn-lg px-4 rounded-pill shadow-sm fw-medium" data-bs-dismiss="modal">
                            New Bill <i class="fas fa-arrow-right ms-2"></i>
                        </button>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <div class="modal fade no-print" id="customAlertModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg text-center rounded-4">
                <div class="modal-body p-4 py-5">
                    <div class="bg-warning bg-opacity-10 text-warning rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 80px; height: 80px;">
                        <i class="fas fa-exclamation-circle fa-2x"></i>
                    </div>
                    <h4 class="fw-bold text-dark mb-2">Attention!</h4>
                    <p class="text-muted mb-4 small" id="customAlertMessage"></p>
                    <button type="button" class="btn btn-dark rounded-pill px-4 shadow-sm" data-bs-dismiss="modal">OK, Got it</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade no-print" id="customConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow-lg text-center rounded-4">
                <div class="modal-body p-4 py-5">
                    <div class="bg-danger bg-opacity-10 text-danger rounded-circle d-inline-flex align-items-center justify-content-center mb-4" style="width: 80px; height: 80px;">
                        <i class="fas fa-trash-alt fa-2x"></i>
                    </div>
                    <h4 class="fw-bold text-dark mb-2">Clear Bill?</h4>
                    <p class="text-muted mb-4 small">Are you sure you want to clear all items from the current bill?</p>
                    <div class="d-flex justify-content-center gap-2 mt-2">
                        <button type="button" class="btn btn-light border fw-medium rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger rounded-pill px-4 shadow-sm" id="confirmClearBtn">Yes, Clear</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="printReceiptArea" style="display: none;">
        <div style="text-align: center; margin-bottom: 10px; border-bottom: 1px dashed black; padding-bottom: 10px;">
            <h3 style="margin:0; font-weight: bold;">SMART POS</h3>
            <p style="margin:0;">123 Supermarket Road</p>
            <p style="margin:0;">Tel: 011-2345678</p>
            <p style="margin:5px 0 0 0; font-weight: bold;" id="receiptInvoice">INV-XXXX</p>
            <p style="margin:0;">Date: <span id="receiptDate"></span></p>
        </div>

        <table style="width: 100%; text-align: left; margin-bottom: 10px; border-bottom: 1px dashed black; padding-bottom: 10px;">
            <thead><tr><th>Item</th><th style="text-align: center;">Qty</th><th style="text-align: right;">Amount</th></tr></thead>
            <tbody id="receiptItems"></tbody>
        </table>

        <div style="text-align: right; font-weight: bold; font-size: 14px;">
            <p style="margin:2px 0;">TOTAL: <span id="receiptTotal">0.00</span></p>
            <p style="margin:2px 0;">CASH: <span id="receiptCash">0.00</span></p>
            <p style="margin:2px 0;">BALANCE: <span id="receiptBalance">0.00</span></p>
        </div>

        <div style="text-align: center; margin-top: 15px; border-top: 1px dashed black; padding-top: 10px;">
            <p style="margin:0;">Thank You! Come Again.</p>
            <p style="margin:0; font-size: 10px;">System by SmartPOS</p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // --- 0. Custom Alert Show Function ---
        function showCustomAlert(message) {
            document.getElementById('customAlertMessage').innerText = message;
            var alertModal = new bootstrap.Modal(document.getElementById('customAlertModal'));
            alertModal.show();
        }

        // --- 1. Camera Scanner Logic (FIXED FOR MOBILE) ---
        let html5QrcodeScanner = null;

        function onScanSuccess(decodedText, decodedResult) {
            document.getElementById('barcodeInput').value = decodedText;
            processBarcode();

            var myModalEl = document.getElementById('scannerModal');
            var modal = bootstrap.Modal.getInstance(myModalEl);
            modal.hide();
        }

        function onScanFailure(error) {
            // Error log
        }

        const scannerModal = document.getElementById('scannerModal');

        scannerModal.addEventListener('shown.bs.modal', function () {
            if (!html5QrcodeScanner) {
                html5QrcodeScanner = new Html5QrcodeScanner(
                    "reader",
                    {
                        fps: 10,
                        qrbox: {width: 250, height: 250},
                        rememberLastUsedCamera: true
                    },
                    false
                );
                html5QrcodeScanner.render(onScanSuccess, onScanFailure);
            }
        });

        scannerModal.addEventListener('hidden.bs.modal', function () {
            if (html5QrcodeScanner) {
                html5QrcodeScanner.clear().then(() => {
                    html5QrcodeScanner = null; // Reset
                }).catch(error => {
                    console.error("Failed to clear scanner. ", error);
                });
            }
        });

        // --- 2. POS Cart & AJAX Logic ---
        let cart = [];

        function processBarcode() {
            let input = document.getElementById('barcodeInput');
            let barcode = input.value.trim();
            if (barcode !== "") {
                fetchProductByBarcode(barcode);
                input.value = '';
                input.focus();
            }
        }

        document.getElementById('barcodeInput').addEventListener('keypress', function (e) {
            if (e.key === 'Enter') { processBarcode(); }
        });

        document.getElementById('searchBtn').addEventListener('click', function() {
            processBarcode();
        });

        function fetchProductByBarcode(barcode) {
            fetch('api/product?barcode=' + barcode)
                .then(response => {
                    if (!response.ok) throw new Error('Product not found or out of stock!');
                    return response.json();
                })
                .then(product => { addToCart(product); })
                .catch(error => { showCustomAlert(error.message); });
        }

        function addToCart(product) {
            let existingItem = cart.find(item => item.barcode === product.barcode);
            if (existingItem) {
                existingItem.qty += 1;
                existingItem.subtotal = existingItem.qty * existingItem.price;
            } else {
                cart.push({
                    id: product.productId,
                    barcode: product.barcode,
                    name: product.productName,
                    price: product.sellingPrice,
                    qty: 1,
                    subtotal: product.sellingPrice
                });
            }
            updateCartTable();
        }

        function updateCartTable() {
            let tbody = document.getElementById('cartTableBody');
            tbody.innerHTML = '';
            let grandTotal = 0;
            let totalItems = 0;

            if (cart.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-5"><i class="fas fa-shopping-cart fs-1 text-light mb-3"></i><br>Scan an item to begin...</td></tr>';
            } else {
                cart.forEach((item, index) => {
                    grandTotal += item.subtotal;
                    totalItems += item.qty;

                    let row = `
                        <tr>
                            <td class="fw-bold text-dark">\${item.name} <br><small class="text-muted font-monospace">\${item.barcode}</small></td>
                            <td class="fw-medium text-secondary">Rs. \${item.price.toFixed(2)}</td>
                            <td>
                                <div class="input-group input-group-sm mx-auto shadow-sm" style="width: 100px; border-radius: 8px; overflow: hidden;">
                                    <button class="btn btn-light border px-2" onclick="changeQty(\${index}, -1)">-</button>
                                    <input type="text" class="form-control text-center fw-bold px-0 border-light" value="\${item.qty}" readonly>
                                    <button class="btn btn-light border px-2" onclick="changeQty(\${index}, 1)">+</button>
                                </div>
                            </td>
                            <td class="fw-bold text-end text-dark">Rs. \${item.subtotal.toFixed(2)}</td>
                            <td class="text-center">
                                <button class="btn btn-sm btn-light text-danger border rounded-3" onclick="removeItem(\${index})"><i class="fas fa-times"></i></button>
                            </td>
                        </tr>
                    `;
                    tbody.innerHTML += row;
                });
            }

            document.querySelector('.total-box h1').innerText = 'Rs. ' + grandTotal.toFixed(2);
            document.querySelector('.sub-total-amount').innerText = 'Rs. ' + grandTotal.toFixed(2);
            document.querySelector('.sub-total-text').innerText = 'Sub Total (' + totalItems + ' items):';
            document.getElementById('cashReceived').setAttribute('data-total', grandTotal);
            calculateChange();
        }

        function changeQty(index, amount) {
            if (cart[index].qty + amount > 0) {
                cart[index].qty += amount;
                cart[index].subtotal = cart[index].qty * cart[index].price;
                updateCartTable();
            }
        }

        function removeItem(index) {
            cart.splice(index, 1);
            updateCartTable();
        }

        let customConfirmModal;
        document.getElementById('clearBillBtn').addEventListener('click', function() {
            if(cart.length > 0) {
                customConfirmModal = new bootstrap.Modal(document.getElementById('customConfirmModal'));
                customConfirmModal.show();
            }
        });

        document.getElementById('confirmClearBtn').addEventListener('click', function() {
            cart = [];
            updateCartTable();
            document.getElementById('cashReceived').value = '';
            document.getElementById('balanceAmount').innerText = 'Rs. 0.00';
            customConfirmModal.hide();
        });

        document.getElementById('cashReceived').addEventListener('keyup', calculateChange);

        function calculateChange() {
            let total = parseFloat(document.getElementById('cashReceived').getAttribute('data-total')) || 0;
            let cash = parseFloat(document.getElementById('cashReceived').value) || 0;
            let balance = cash - total;

            let balanceEl = document.getElementById('balanceAmount');
            if (cash >= total && total > 0) {
                balanceEl.innerText = 'Rs. ' + balance.toFixed(2);
                balanceEl.classList.replace('text-danger', 'text-success');
            } else {
                balanceEl.innerText = 'Rs. 0.00';
                balanceEl.classList.replace('text-success', 'text-danger');
            }
        }

        // --- 3. Process Payment Logic ---
        document.querySelector('.pay-btn').addEventListener('click', function() {
            if(cart.length === 0) {
                showCustomAlert("Cart is empty! Add products to bill first.");
                return;
            }

            let total = parseFloat(document.getElementById('cashReceived').getAttribute('data-total')) || 0;
            let cash = parseFloat(document.getElementById('cashReceived').value) || 0;

            if(cash < total) {
                showCustomAlert("Insufficient cash! Please enter an amount greater than or equal to Rs. " + total.toFixed(2));
                return;
            }

            let payload = {
                total: total,
                cash: cash,
                balance: cash - total,
                cart: cart
            };

            let payBtn = this;
            payBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i> PROCESSING...';
            payBtn.disabled = true;

            fetch('api/checkout', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            })
            .then(res => res.json())
            .then(data => {
                if(data.success) {
                    document.getElementById('invoiceDisplay').innerText = data.invoice;

                    // Print  Data fill
                    document.getElementById('receiptInvoice').innerText = data.invoice;
                    document.getElementById('receiptDate').innerText = new Date().toLocaleString();
                    let rItems = '';
                    cart.forEach(item => {
                        rItems += `<tr><td>\${item.name}</td><td style="text-align: center;">\${item.qty}</td><td style="text-align:right;">\${item.subtotal.toFixed(2)}</td></tr>`;
                    });
                    document.getElementById('receiptItems').innerHTML = rItems;
                    document.getElementById('receiptTotal').innerText = total.toFixed(2);
                    document.getElementById('receiptCash').innerText = cash.toFixed(2);
                    document.getElementById('receiptBalance').innerText = (cash - total).toFixed(2);

                    var successModal = new bootstrap.Modal(document.getElementById('successModal'));
                    successModal.show();

                    // Reset POS Screen
                    cart = [];
                    updateCartTable();
                    document.getElementById('cashReceived').value = '';
                    document.getElementById('balanceAmount').innerText = 'Rs. 0.00';
                    document.querySelector('.total-box h1').innerText = 'Rs. 0.00';
                } else {
                    showCustomAlert("Payment Failed: " + data.message);
                }
            })
            .catch(err => {
                showCustomAlert("Error connecting to server.");
            })
            .finally(() => {
                payBtn.innerHTML = '<i class="fas fa-check-circle me-2"></i> PROCESS PAYMENT';
                payBtn.disabled = false;
            });
        });

        function printReceipt() {
            document.getElementById('printReceiptArea').style.display = 'block';
            window.print();
            document.getElementById('printReceiptArea').style.display = 'none';
        }

    </script>
</body>
</html>