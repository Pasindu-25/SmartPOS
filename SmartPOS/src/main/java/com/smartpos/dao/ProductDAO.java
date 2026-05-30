package com.smartpos.dao;

import com.smartpos.model.Product;
import com.smartpos.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // Fetch all products along with their category name
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT p.*, c.category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "ORDER BY p.product_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setCategoryName(rs.getString("category_name")); // From JOIN
                p.setBarcode(rs.getString("barcode"));
                p.setProductName(rs.getString("product_name"));
                p.setCostPrice(rs.getDouble("cost_price"));
                p.setSellingPrice(rs.getDouble("selling_price"));
                p.setStockQuantity(rs.getInt("stock_quantity"));
                p.setStatus(rs.getString("status"));
                products.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // Add a new product
    public boolean addProduct(Product p) {
        String query = "INSERT INTO products (category_id, barcode, product_name, description, cost_price, selling_price, stock_quantity, min_stock_level, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, p.getCategoryId());
            stmt.setString(2, p.getBarcode());
            stmt.setString(3, p.getProductName());
            stmt.setString(4, p.getDescription());
            stmt.setDouble(5, p.getCostPrice());
            stmt.setDouble(6, p.getSellingPrice());
            stmt.setInt(7, p.getStockQuantity());
            stmt.setInt(8, p.getMinStockLevel());
            stmt.setString(9, p.getStatus());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("SQL Error in ProductDAO: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    // Fetch a single product by Barcode (For POS Terminal)
    public Product getProductByBarcode(String barcode) {
        Product p = null;
        String query = "SELECT * FROM products WHERE barcode = ? AND status = 'AVAILABLE'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, barcode);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setBarcode(rs.getString("barcode"));
                    p.setProductName(rs.getString("product_name"));
                    p.setCostPrice(rs.getDouble("cost_price"));
                    p.setSellingPrice(rs.getDouble("selling_price"));
                    p.setStockQuantity(rs.getInt("stock_quantity"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p; // Returns null if product is not found or out of stock
    }
    // 1. Product එකක් Edit/Update කිරීම
    public boolean updateProduct(com.smartpos.model.Product product) {
        String query = "UPDATE products SET category_id=?, barcode=?, product_name=?, cost_price=?, selling_price=?, stock_quantity=?, min_stock_level=?, status=? WHERE product_id=?";
        try (java.sql.Connection conn = com.smartpos.util.DBConnection.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, product.getCategoryId());
            stmt.setString(2, product.getBarcode());
            stmt.setString(3, product.getProductName());
            stmt.setDouble(4, product.getCostPrice());
            stmt.setDouble(5, product.getSellingPrice());
            stmt.setInt(6, product.getStockQuantity());
            stmt.setInt(7, product.getMinStockLevel());
            stmt.setString(8, product.getStatus());
            stmt.setInt(9, product.getProductId());

            return stmt.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. Product එකක් Delete කිරීම
    public boolean deleteProduct(int productId) {
        String query = "DELETE FROM products WHERE product_id = ?";
        try (java.sql.Connection conn = com.smartpos.util.DBConnection.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, productId);
            return stmt.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            // බිල්පත් වලට (Sales) මේ භාණ්ඩය සම්බන්ධ වී ඇත්නම් මකා දැමිය නොහැක
            return false;
        }
    }
    // තොග අඩු (Low Stock) භාණ්ඩ ලැයිස්තුව ලබා ගැනීම
    public List<Product> getLowStockProducts() {
        List<Product> list = new ArrayList<>();
        // categories table එකත් එක්ක JOIN කරලා තියෙන්නේ Category Name එකත් ගන්න ඕන නිසා
        String query = "SELECT p.*, c.category_name FROM products p JOIN categories c ON p.category_id = c.category_id WHERE p.stock_quantity <= p.min_stock_level";

        try (java.sql.Connection conn = com.smartpos.util.DBConnection.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(query);
             java.sql.ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setCategoryName(rs.getString("category_name"));
                p.setBarcode(rs.getString("barcode"));
                p.setProductName(rs.getString("product_name"));
                p.setCostPrice(rs.getDouble("cost_price"));
                p.setSellingPrice(rs.getDouble("selling_price"));
                p.setStockQuantity(rs.getInt("stock_quantity"));
                p.setMinStockLevel(rs.getInt("min_stock_level"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}