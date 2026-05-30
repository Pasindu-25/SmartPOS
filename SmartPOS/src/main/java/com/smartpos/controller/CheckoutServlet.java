package com.smartpos.controller;

import com.google.gson.Gson;
import com.smartpos.dao.SaleDAO;
import com.smartpos.model.Sale;
import com.smartpos.model.SaleItem;
import com.smartpos.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/api/checkout")
public class CheckoutServlet extends HttpServlet {
    private SaleDAO saleDAO;

    @Override
    public void init() {
        saleDAO = new SaleDAO();
    }

    // JSON දත්ත ලබාගැනීම සඳහා Class එකක්
    static class CheckoutRequest {
        double total;
        double cash;
        double balance;
        List<CartItem> cart;
    }
    static class CartItem {
        int id;
        int qty;
        double price;
        double subtotal;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");

        if (loggedUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false, \"message\":\"User not logged in\"}");
            return;
        }

        try {
            // Read JSON body
            BufferedReader reader = request.getReader();
            Gson gson = new Gson();
            CheckoutRequest checkoutData = gson.fromJson(reader, CheckoutRequest.class);

            // Generate Invoice Number (INV- + timestamp)
            String invoiceNo = "INV-" + System.currentTimeMillis();

            // Create Sale Object
            Sale sale = new Sale();
            sale.setInvoiceNumber(invoiceNo);
            sale.setUserId(loggedUser.getUserId());
            sale.setNetTotal(checkoutData.total);
            sale.setAmountTendered(checkoutData.cash);
            sale.setChangeDue(checkoutData.balance);

            // Create SaleItems List
            List<SaleItem> items = new ArrayList<>();
            for (CartItem cItem : checkoutData.cart) {
                SaleItem item = new SaleItem();
                item.setProductId(cItem.id);
                item.setQuantity(cItem.qty);
                item.setUnitPrice(cItem.price);
                item.setItemSubtotal(cItem.subtotal);
                items.add(item);
            }

            // Save to DB
            boolean isSaved = saleDAO.processCheckout(sale, items);

            if (isSaved) {
                out.print("{\"success\":true, \"invoice\":\"" + invoiceNo + "\"}");
            } else {
                out.print("{\"success\":false, \"message\":\"Database Error\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false, \"message\":\"Server Error\"}");
        }
    }
}