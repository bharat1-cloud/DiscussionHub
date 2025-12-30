<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.discussionhub.util.DBConnection" %>
<%@ page session="true" %>

<%
    String usernameOrEmail = request.getParameter("usernameOrEmail");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();

        // Allow login via username OR email
        String query = "SELECT * FROM users WHERE (username = ? OR email = ?) AND password = ?";
        pst = conn.prepareStatement(query);
        pst.setString(1, usernameOrEmail);
        pst.setString(2, usernameOrEmail);
        pst.setString(3, password);

        rs = pst.executeQuery();

        if(rs.next()) {
            // Set session with actual username
            session.setAttribute("username", rs.getString("username"));
            session.setAttribute("user_id", rs.getInt("id"));
%>
            <script>
                alert("Login successful!");
                window.location.href = "../../pages/user/index.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert("Invalid username/email or password!");
                history.back();
            </script>
<%
        }
    } catch(Exception e) {
%>
        <script>
            alert("Error: <%= e.getMessage() %>");
            history.back();
        </script>
<%
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception ex) {}
        if(pst != null) try { pst.close(); } catch(Exception ex) {}
        if(conn != null) try { conn.close(); } catch(Exception ex) {}
    }
%>
