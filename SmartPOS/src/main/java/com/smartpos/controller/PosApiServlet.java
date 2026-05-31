package com.smartpos.controller;

import com.google.gson.Gson;
import com.smartpos.dao.ProductDAO;
import com.smartpos.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

// We access this via the /api/product link
@WebServlet("/api/product")
public class PosApiServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String barcode = request.getParameter("barcode");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (barcode != null && !barcode.trim().isEmpty()) {
            Product p = productDAO.getProductByBarcode(barcode.trim());

            if (p != null) {
                // If the product exists, send it as JSON
                Gson gson = new Gson();
                String productJson = gson.toJson(p);
                out.print(productJson);
            } else {
                // If the product is not found, send an error
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Product not found or out of stock\"}");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Barcode is missing\"}");
        }
        out.flush();
    }
}