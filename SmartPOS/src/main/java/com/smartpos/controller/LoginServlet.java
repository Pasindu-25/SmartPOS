package com.smartpos.controller;

import com.smartpos.dao.UserDAO;
import com.smartpos.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class for handling user login and session creation.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Authenticate user against the database
        User user = userDAO.authenticateUser(email, password);

        if (user != null) {
            // Login successful: Create a new session
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);

            // Redirect user based on their role
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("cashier_dashboard.jsp");
            }
        } else {
            // Login failed: Redirect back to login page with an error message
            request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}