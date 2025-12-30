<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.discussionhub.util.DBConnection" %>
<%@ page session="true" %>

<%
    String email = request.getParameter("email");
    boolean isValidUser = false;

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        // Establish database connection
        conn = DBConnection.getConnection();

        // Check if the email exists in the database
        String query = "SELECT * FROM users WHERE email=?";
        pst = conn.prepareStatement(query);
        pst.setString(1, email);
        rs = pst.executeQuery();

        if (rs.next()) {
            // If user exists, send the password reset link (this part is just a placeholder for now)
            isValidUser = true;
        }

        if (isValidUser) {
%>
            <script>
                alert("A password reset link has been sent to your email.");
                window.location.href = "../../login.html"; // Redirect to login page after success
            </script>
<%
        } else {
%>
            <script>
                alert("You are not a valid user or the email does not exist.");
                history.back(); // Go back to the previous page
            </script>
<%
        }

    } catch (Exception e) {
%>
        <script>
            alert("Error: <%= e.getMessage() %>");
            history.back(); // Go back to the previous page
        </script>
<%
    } finally {
        // Close the resources to avoid memory leaks
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (conn != null) conn.close();
    }
%>
