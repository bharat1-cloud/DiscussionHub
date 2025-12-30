<%@ page import="java.sql.*, javax.sql.*, java.util.*, java.text.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("admin_username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int itemsPerPage = 16;
    int currentPage = 1;
    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }

    int offset = (currentPage - 1) * itemsPerPage;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int totalUsers = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");

        String countQuery = "SELECT COUNT(*) FROM users";
        ps = conn.prepareStatement(countQuery);
        rs = ps.executeQuery();
        if (rs.next()) totalUsers = rs.getInt(1);
        rs.close(); ps.close();

        String userQuery = "SELECT * FROM users LIMIT ? OFFSET ?";
        ps = conn.prepareStatement(userQuery);
        ps.setInt(1, itemsPerPage);
        ps.setInt(2, offset);
        rs = ps.executeQuery();

    } catch (Exception e) {
        e.printStackTrace();
    }

    int totalPages = (int) Math.ceil((double) totalUsers / itemsPerPage);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Users - Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="../../assets/css/main.css" rel="stylesheet">

    <style>
        body { background-color: #f8f9fa; }
        .user-card { transition: transform 0.2s ease; }
        .user-card:hover { transform: scale(1.02); }
        .user-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 50%;
            background-color: #e9ecef;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="main-container">
    <%@ include file="sidebar.jsp" %>
    <div class="main-content">
        <div class="container py-4">
            <h3 class="mb-4 fw-bold">All Users</h3>

            <%
                int count = 0;
                while (rs.next()) {
                    if (count % 4 == 0) {
            %>
            <div class="row g-4">
            <%
                    }

                    String profilePics = rs.getString("profile_picture");
                    if (profilePics == null || profilePics.trim().isEmpty()) {
                        profilePics = "uploads/default.png";
                    } else {
                        profilePics = "uploads/" + profilePics;
                    }
            %>
                <div class="col-md-3">
                   <div class="card shadow-sm user-card h-100">
                      <div class="card-body d-flex flex-column text-center">


                            <img src="<%= profilePics %>" class="user-img mb-3" alt="User Image">
                            <h5 class="card-title"><%= rs.getString("username") %></h5>

                            <% if (rs.getString("full_name") != null && !rs.getString("full_name").trim().isEmpty()) { %>
                                <p><strong>Full Name:</strong> <%= rs.getString("full_name") %></p>
                            <% } %>
                            <% if (rs.getString("email") != null && !rs.getString("email").trim().isEmpty()) { %>
                                <p><strong>Email:</strong> <%= rs.getString("email") %></p>
                            <% } %>
                            <% if (rs.getString("mobile") != null && !rs.getString("mobile").trim().isEmpty()) { %>
                                <p><strong>Mobile:</strong> <%= rs.getString("mobile") %></p>
                            <% } %>
                            <% if (rs.getString("bio") != null && !rs.getString("bio").trim().isEmpty()) { %>
                                <p><strong>Bio:</strong> <%= rs.getString("bio") %></p>
                            <% } %>

                                <form action="deleteUser.jsp" method="post" onsubmit="return confirm('Are you sure you want to delete this user?');" class="mt-auto">
                                <input type="hidden" name="user_id" value="<%= rs.getInt("id") %>">
                                <button type="submit" class="btn btn-danger btn-sm mt-2">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                            </form>
                            
                        </div>
                      
                    </div>
                    
                </div>
                  <br>
            <%
                    count++;
                    if (count % 4 == 0) {
            %>
            </div>
            <%
                    }
                }
                if (count % 4 != 0) {
            %>
            </div>
            <%
                }
                rs.close(); ps.close(); conn.close();
            %>

            <!-- Pagination -->
            <div class="d-flex justify-content-center mt-4">
                <ul class="pagination">
                    <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage - 1 %>">Previous</a>
                    </li>

                    <%
                        for (int i = 1; i <= totalPages; i++) {
                            String active = (i == currentPage) ? "active" : "";
                    %>
                    <li class="page-item <%= active %>">
                        <a class="page-link" href="?page=<%= i %>"><%= i %></a>
                    </li>
                    <% } %>

                    <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage + 1 %>">Next</a>
                    </li>
                </ul>
            </div>

        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
