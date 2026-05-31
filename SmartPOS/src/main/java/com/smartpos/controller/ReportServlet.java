package com.smartpos.controller;

import com.smartpos.dao.SaleDAO;
import com.smartpos.model.Sale;
import com.smartpos.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private SaleDAO saleDAO;

    @Override
    public void init() {
        saleDAO = new SaleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null || !"ADMIN".equals(loggedUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fetch sales records
        List<Sale> salesList = saleDAO.getAllSales();

        // Calculate Total Revenue from the list
        double totalRevenue = 0;
        for (Sale s : salesList) {
            totalRevenue += s.getNetTotal();
        }

        request.setAttribute("salesList", salesList);
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("sales_reports.jsp").forward(request, response);
    }
}