<%@ page import="java.sql.*" %>

<%
    String userIdStr = request.getParameter("user_id");

    if (userIdStr != null) {
        int userId = Integer.parseInt(userIdStr);

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");

            String deleteQuery = "DELETE FROM users WHERE id = ?";
            ps = conn.prepareStatement(deleteQuery);
            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }

    response.sendRedirect("adminUsers.jsp");
%>
