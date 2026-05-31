package com.smartpos.controller;

import com.smartpos.dao.ProductDAO;
import com.smartpos.dao.CategoryDAO;
import com.smartpos.model.Product;
import com.smartpos.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Check if a delete command is received
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if(productDAO.deleteProduct(id)) {
                request.getSession().setAttribute("successMsg", "Product deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to delete! Product is already used in sales.");
            }

            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        // Send categories to the dropdown and products to the table
        List<Category> categories = categoryDAO.getAllCategories();
        List<Product> products = productDAO.getAllProducts();

        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.getRequestDispatcher("manage_products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        Product p = new Product();
        p.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        p.setBarcode(request.getParameter("barcode"));
        p.setProductName(request.getParameter("productName"));
        p.setCostPrice(Double.parseDouble(request.getParameter("costPrice")));
        p.setSellingPrice(Double.parseDouble(request.getParameter("sellingPrice")));
        p.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
        p.setMinStockLevel(Integer.parseInt(request.getParameter("minStockLevel")));
        p.setStatus(request.getParameter("status"));
        p.setDescription("-"); // Default description

        if ("update".equals(action)) {
            // Editing
            p.setProductId(Integer.parseInt(request.getParameter("productId")));
            if (productDAO.updateProduct(p)) {
                request.getSession().setAttribute("successMsg", "Product updated successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to update product.");
            }
        } else {
            // Add new
            if (productDAO.addProduct(p)) {
                request.getSession().setAttribute("successMsg", "Product added successfully!");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to add product.");
            }
        }


        response.sendRedirect(request.getContextPath() + "/products");
    }
}