package com.smartpos.dao;

import com.smartpos.model.Category;
import com.smartpos.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    // Fetch all categories from the database
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM categories ORDER BY category_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Category cat = new Category();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setCategoryName(rs.getString("category_name"));
                cat.setDescription(rs.getString("description"));
                categories.add(cat);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    // Add a new category
    public boolean addCategory(Category category) {
        String query = "INSERT INTO categories (category_name, description) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // 1. Category එකක් Edit/Update කිරීම
    public boolean updateCategory(com.smartpos.model.Category category) {
        String query = "UPDATE categories SET category_name = ?, description = ? WHERE category_id = ?";
        try (java.sql.Connection conn = com.smartpos.util.DBConnection.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            stmt.setInt(3, category.getCategoryId());
            return stmt.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. Category එකක් Delete කිරීම
    public boolean deleteCategory(int id) {
        String query = "DELETE FROM categories WHERE category_id = ?";
        try (java.sql.Connection conn = com.smartpos.util.DBConnection.getConnection();
             java.sql.PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            // සටහන: යම් භාණ්ඩයක් මේ Category එකට link වෙලා තියෙනවා නම් Delete වෙන්නේ නෑ.
            return false;
        }
    }
}