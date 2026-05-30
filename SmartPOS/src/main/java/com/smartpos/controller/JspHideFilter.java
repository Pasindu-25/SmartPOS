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
        String method = request.getMethod(); // රික්වෙස්ට් එකේ වර්ගය ගන්නවා (GET ද POST ද කියලා)

        // 1. .jsp තියෙන ලින්ක් එකක් ආවොත්, ඒක අයින් කරලා රීඩිරෙක්ට් කරන්නේ 'GET' රික්වෙස්ට් එකක් නම් විතරයි
        if (method.equalsIgnoreCase("GET") && path.endsWith(".jsp")) {
            String cleanPath = path.substring(0, path.length() - 4);
            response.sendRedirect(request.getContextPath() + cleanPath);
            return;
        }

        // 2. .jsp නැති ලින්ක් එකක් ආවොත්, ඒක පිටිපස්සෙන් .jsp ෆයිල් එකට යවන්නෙත් 'GET' රික්වෙස්ට් එකක් නම් විතරයි
        if (method.equalsIgnoreCase("GET") && !path.contains(".") && !path.equals("/") && !path.startsWith("/api")) {
            String jspPath = path + ".jsp";
            String realPath = request.getServletContext().getRealPath(jspPath);

            if (realPath != null && new File(realPath).exists()) {
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }
        }

        // POST රික්වෙස්ට් (Login වෙන ඒවා, Add කරන ඒවා) සහ අනිත් ඒවා කිසිම බාධාවකින් තොරව Servlet එකට යන්න දෙනවා
        chain.doFilter(request, response);
    }
}