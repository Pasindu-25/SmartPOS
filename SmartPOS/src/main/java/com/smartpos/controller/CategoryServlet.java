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

        // Check if a delete command is received
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

        // Sending the list
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

        // Check whether to update or add new
        if ("update".equals(action)) {
            cat.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            if (categoryDAO.updateCategory(cat)) {
                request.getSession().setAttribute("successMsg", "Category updated successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to update category.");
            }
        } else {
            // Add new
            if (categoryDAO.addCategory(cat)) {
                request.getSession().setAttribute("successMsg", "Category added successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to add category.");
            }
        }

        response.sendRedirect("categories");
    }
}