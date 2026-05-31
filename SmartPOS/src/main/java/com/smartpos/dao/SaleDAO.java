package com.smartpos.dao;

import com.smartpos.model.Sale;
import com.smartpos.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SaleDAO {

    // Get all sales with Cashier Name
    public List<Sale> getAllSales() {
        List<Sale> salesList = new ArrayList<>();
        // JOIN query to get the cashier's full name from users table
        String query = "SELECT s.sale_id, s.invoice_number, u.full_name as cashier_name, " +
                "s.net_total, s.payment_method, s.sale_date " +
                "FROM sales s " +
                "JOIN users u ON s.user_id = u.user_id " +
                "ORDER BY s.sale_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Sale sale = new Sale();
                sale.setSaleId(rs.getInt("sale_id"));
                sale.setInvoiceNumber(rs.getString("invoice_number"));
                sale.setCashierName(rs.getString("cashier_name"));
                sale.setNetTotal(rs.getDouble("net_total"));
                sale.setPaymentMethod(rs.getString("payment_method"));
                sale.setSaleDate(rs.getTimestamp("sale_date"));

                salesList.add(sale);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return salesList;
    }
    // Process Checkout (Save Sale, Items and Update Stock)
    public boolean processCheckout(Sale sale, List<com.smartpos.model.SaleItem> items) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // 1. Insert into Sales table
            String saleQuery = "INSERT INTO sales (invoice_number, user_id, sub_total, net_total, payment_method, amount_tendered, change_due) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psSale = conn.prepareStatement(saleQuery, java.sql.Statement.RETURN_GENERATED_KEYS);
            psSale.setString(1, sale.getInvoiceNumber());
            psSale.setInt(2, sale.getUserId());
            psSale.setDouble(3, sale.getNetTotal());
            psSale.setDouble(4, sale.getNetTotal());
            psSale.setString(5, "CASH");
            psSale.setDouble(6, sale.getAmountTendered());
            psSale.setDouble(7, sale.getChangeDue());
            psSale.executeUpdate();

            // Get generated sale_id
            ResultSet rsKeys = psSale.getGeneratedKeys();
            int saleId = 0;
            if (rsKeys.next()) {
                saleId = rsKeys.getInt(1);
            }

            // 2. Insert into Sale Items & Update Products Stock
            String itemQuery = "INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, item_subtotal) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement psItem = conn.prepareStatement(itemQuery);

            String stockQuery = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE product_id = ?";
            PreparedStatement psStock = conn.prepareStatement(stockQuery);

            for (com.smartpos.model.SaleItem item : items) {
                // Prepare Item insert
                psItem.setInt(1, saleId);
                psItem.setInt(2, item.getProductId());
                psItem.setInt(3, item.getQuantity());
                psItem.setDouble(4, item.getUnitPrice());
                psItem.setDouble(5, item.getItemSubtotal());
                psItem.addBatch();

                // Prepare Stock update
                psStock.setInt(1, item.getQuantity());
                psStock.setInt(2, item.getProductId());
                psStock.addBatch();
            }

            psItem.executeBatch();
            psStock.executeBatch();

            conn.commit(); // Save all changes
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } // If error, undo everything
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
    // Get the list of items related to the invoice number
    public java.util.List<java.util.Map<String, Object>> getSaleItemsDetails(int saleId) {
        java.util.List<java.util.Map<String, Object>> items = new java.util.ArrayList<>();

        // Retrieve data by joining sale_items and products tables
        String query = "SELECT p.product_name, si.unit_price, si.quantity, si.item_subtotal " +
                "FROM sale_items si JOIN products p ON si.product_id = p.product_id " +
                "WHERE si.sale_id = ?";

        try (java.sql.Connection conn = com.smartpos.util.DBConnection.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, saleId);
            java.sql.ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                java.util.Map<String, Object> item = new java.util.HashMap<>();
                item.put("productName", rs.getString("product_name"));
                item.put("price", rs.getDouble("unit_price"));
                item.put("qty", rs.getInt("quantity"));
                item.put("subtotal", rs.getDouble("item_subtotal"));
                items.add(item);
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
}