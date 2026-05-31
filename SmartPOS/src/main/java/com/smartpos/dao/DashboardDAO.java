package com.smartpos.dao;

import com.smartpos.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DashboardDAO {
    // 1. Today's total sales
    public double getTodaysSales() {
        double total = 0.0;
        String query = "SELECT SUM(net_total) AS todays_total FROM sales WHERE DATE(sale_date) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                total = rs.getDouble("todays_total");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return total;
    }

    // 2. Total number of available products
    public int getTotalProducts() {
        int count = 0;
        String query = "SELECT COUNT(*) AS total_prods FROM products WHERE status = 'AVAILABLE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt("total_prods");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

    // 3. Number of low stock products
    public int getLowStockCount() {
        int count = 0;
        String query = "SELECT COUNT(*) AS low_stock FROM products WHERE stock_quantity <= min_stock_level AND status = 'AVAILABLE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt("low_stock");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }
}