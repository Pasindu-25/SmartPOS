package com.smartpos.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;

@WebFilter("/*")
public class JspHideFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());
        String method = request.getMethod(); // Get the request type (whether it is GET or POST)

        // 1. If a link with .jsp arrives, remove it and redirect only if it is a 'GET' request
        if (method.equalsIgnoreCase("GET") && path.endsWith(".jsp")) {
            String cleanPath = path.substring(0, path.length() - 4);
            response.sendRedirect(request.getContextPath() + cleanPath);
            return;
        }

        // 2. If a link without .jsp arrives, forward it to the .jsp file only if it is a 'GET' request
        if (method.equalsIgnoreCase("GET") && !path.contains(".") && !path.equals("/") && !path.startsWith("/api")) {
            String jspPath = path + ".jsp";
            String realPath = request.getServletContext().getRealPath(jspPath);

            if (realPath != null && new File(realPath).exists()) {
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }
        }

        // Allow POST requests (like Login, Add) and others to pass through to the Servlet without any interruption
        chain.doFilter(request, response);
    }
}