package com.smartpos.controller;

import com.google.gson.Gson;
import com.smartpos.dao.SaleDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet("/api/sale-details")
public class SaleDetailsServlet extends HttpServlet {
    private SaleDAO saleDAO;

    @Override
    public void init() {
        saleDAO = new SaleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            int saleId = Integer.parseInt(request.getParameter("id"));

            List<Map<String, Object>> items = saleDAO.getSaleItemsDetails(saleId);

            Gson gson = new Gson();
            out.print(gson.toJson(items));

        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]");
        }
    }
}