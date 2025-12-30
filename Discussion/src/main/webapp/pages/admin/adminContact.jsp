<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer adminId = (Integer) session.getAttribute("admin_id");
    if (adminId == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Messages</title>
 <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <link href="../../assets/css/main.css" rel="stylesheet"></head>
<body>
<%@ include file="navbar.jsp" %>
<div class="main-container">
    <%@ include file="sidebar.jsp" %>
<div class="container mt-5">
    <h3 class="mb-4">All Contact Messages</h3>
    <table class="table table-bordered table-hover">
        <thead class="table-success">
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Subject</th>
                <th>Message</th>
                <th>Sent At</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM contact ORDER BY created_at DESC");
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("full_name") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("subject") != null ? rs.getString("subject") : "-" %></td>
                <td><%= rs.getString("message") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
            </tr>
        <%
                }

                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>
</div>
<%@ include file="footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
