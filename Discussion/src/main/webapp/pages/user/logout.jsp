<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    session.invalidate();  // Destroys session
    response.sendRedirect("../../login.html");
%>
