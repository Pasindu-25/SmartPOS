<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // පවතින Session එක සම්පූර්ණයෙන්ම අවලංගු කිරීම (Clear the session)
    if (session != null) {
        session.invalidate();
    }

    // ආපහු Login පිටුවට යැවීම (Redirect to login page)
    response.sendRedirect("login.jsp");
%>