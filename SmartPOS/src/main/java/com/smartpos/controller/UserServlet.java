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
import java.util.List;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        // Only Admin can access this page
        if (loggedUser == null || !"ADMIN".equals(loggedUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Handle Delete and Toggle Commands
        String action = request.getParameter("action");
        if (action != null) {
            int userId = Integer.parseInt(request.getParameter("id"));
            if ("delete".equals(action)) {
                userDAO.deleteUser(userId);
                session.setAttribute("successMsg", "User deleted successfully.");
            } else if ("toggle".equals(action)) {
                userDAO.toggleUserStatus(userId);
                session.setAttribute("successMsg", "User status updated successfully.");
            }
            response.sendRedirect("users");
            return;
        }

        List<User> userList = userDAO.getAllUsers();
        request.setAttribute("usersList", userList);
        request.getRequestDispatcher("manage_users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        // Check if the user is the Main Admin
        boolean isMainAdmin = "admin@pos.com".equals(loggedUser.getEmail());

        User newUser = new User();
        newUser.setFullName(request.getParameter("fullName"));
        newUser.setEmail(request.getParameter("email"));
        newUser.setPassword(request.getParameter("password"));

        String role = request.getParameter("role");
        // If a regular Admin tries to create a new Admin, make them a Cashier
        if (!isMainAdmin && "ADMIN".equals(role)) {
            role = "CASHIER";
        }
        newUser.setRole(role);

        newUser.setStatus(request.getParameter("status"));

        boolean isAdded = userDAO.addUser(newUser);

        if (isAdded) {
            request.getSession().setAttribute("successMsg", "User created successfully!");
        } else {
            request.getSession().setAttribute("errorMsg", "Failed to create user. Email might already exist.");
        }

        response.sendRedirect("users");
    }
}