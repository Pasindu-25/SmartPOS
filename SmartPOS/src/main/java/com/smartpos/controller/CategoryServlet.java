package com.smartpos.controller;

import com.smartpos.dao.CategoryDAO;
import com.smartpos.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Delete කමාන්ඩ් එකක් ඇවිත්ද කියලා බලනවා
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if(categoryDAO.deleteCategory(id)) {
                request.getSession().setAttribute("successMsg", "Category deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to delete! Products might be using this category.");
            }
            response.sendRedirect("categories");
            return;
        }

        // List එක යවන කොටස
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("manage_categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        Category cat = new Category();
        cat.setCategoryName(request.getParameter("categoryName"));
        cat.setDescription(request.getParameter("description"));

        // Update කරනවද, අලුතින් Add කරනවද කියලා බලනවා
        if ("update".equals(action)) {
            cat.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            if (categoryDAO.updateCategory(cat)) {
                request.getSession().setAttribute("successMsg", "Category updated successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to update category.");
            }
        } else {
            // අලුතින් Add කිරීම
            if (categoryDAO.addCategory(cat)) {
                request.getSession().setAttribute("successMsg", "Category added successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to add category.");
            }
        }

        response.sendRedirect("categories");
    }
}