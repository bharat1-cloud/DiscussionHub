<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.StringWriter, java.io.PrintWriter" %>

<%

if (session.getAttribute("admin_username") == null) {
    response.sendRedirect("index.jsp");
    return;
}

    int pageSize = 10;
    int pageNum = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int offset = (pageNum - 1) * pageSize;
    String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "ASC";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // One-time session message
    String message = (String) session.getAttribute("message");
    if (message != null) session.removeAttribute("message");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String name = request.getParameter("name");
            String idParam = request.getParameter("id");

            if (request.getParameter("deleteId") != null) {
                int deleteId = Integer.parseInt(request.getParameter("deleteId"));
                ps = conn.prepareStatement("DELETE FROM category WHERE id = ?");
                ps.setInt(1, deleteId);
                ps.executeUpdate();
                session.setAttribute("message", "Category deleted successfully.");
                response.sendRedirect("adminCategories.jsp?sort=" + sort + "&page=" + pageNum);
                return;

            } else if (idParam != null && !idParam.isEmpty()) {
                // UPDATE
                int id = Integer.parseInt(idParam);
                ps = conn.prepareStatement("SELECT * FROM category WHERE name = ? AND id != ?");
                ps.setString(1, name.trim());
                ps.setInt(2, id);
                rs = ps.executeQuery();
                if (rs.next()) {
                    session.setAttribute("message", "Category already exists. Please choose a different name.");
                } else {
                    ps = conn.prepareStatement("UPDATE category SET name = ? WHERE id = ?");
                    ps.setString(1, name.trim());
                    ps.setInt(2, id);
                    ps.executeUpdate();
                    session.setAttribute("message", "Category updated successfully.");
                }
                response.sendRedirect("adminCategories.jsp?sort=" + sort + "&page=" + pageNum);
                return;

            } else if (name != null && !name.trim().isEmpty()) {
                // ADD
                ps = conn.prepareStatement("SELECT * FROM category WHERE name = ?");
                ps.setString(1, name.trim());
                rs = ps.executeQuery();
                if (rs.next()) {
                    session.setAttribute("message", "Category already exists. Please choose a different name.");
                } else {
                    ps = conn.prepareStatement("INSERT INTO category (name) VALUES (?)");
                    ps.setString(1, name.trim());
                    ps.executeUpdate();
                    session.setAttribute("message", "Category added successfully.");
                }
                response.sendRedirect("adminCategories.jsp?sort=" + sort + "&page=" + pageNum);
                return;
            }
        }

    } catch (Exception e) {
        e.printStackTrace(new PrintWriter(out));
        session.setAttribute("message", "Error: " + e.getMessage());
        response.sendRedirect("adminCategories.jsp?sort=" + sort + "&page=" + pageNum);
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>


<!DOCTYPE html>
<html>
<head>
    <title>Admin - Manage Categories</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="../../assets/css/main.css" rel="stylesheet">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="main-container">
    <%@ include file="sidebar.jsp" %>
    <div class="container mt-4">
        <h2>Manage Categories</h2>
        
        <% if (message != null && !message.isEmpty()) { %>
    <div class="alert alert-<%= message.contains("successfully") ? "success" : "warning" %>"><%= message %></div>
<% } %>
        

        <!-- Add Category Form -->
        <form method="post" class="row g-3 mb-4">
            <div class="col-md-6">
                <input type="text" name="name" class="form-control" placeholder="New Category Name" required>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary">Add Category</button>
            </div>
        </form>

        <!-- Sort Buttons -->
        <div class="mb-3">
            <a href="adminCategories.jsp?sort=ASC" class="btn btn-outline-secondary btn-sm">Sort A-Z</a>
            <a href="adminCategories.jsp?sort=DESC" class="btn btn-outline-secondary btn-sm">Sort Z-A</a>
        </div>

        <!-- Categories Table -->
        <table class="table table-bordered">
            <thead class="table-light">
            <tr>
                <th>#</th>
                <th>Name</th>
                <th style="width: 200px;">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                int serialNumber = offset + 1;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");
                    ps = conn.prepareStatement("SELECT * FROM category ORDER BY name " + sort + " LIMIT ?, ?");
                    ps.setInt(1, offset);
                    ps.setInt(2, pageSize);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
            %>
            <tr>
                <form method="post">
                    <td><%= serialNumber++ %></td>
                    <td>
                        <input type="hidden" name="id" value="<%= id %>">
                        <input type="text" name="name" value="<%= name %>" class="form-control" required>
                    </td>
                    <td>
                        <button type="submit" class="btn btn-warning btn-sm">Update</button>
                        <button type="submit" name="deleteId" value="<%= id %>" class="btn btn-danger btn-sm"
                                onclick="return confirm('Delete this category?');">Delete</button>
                    </td>
                </form>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace(new PrintWriter(out));
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                    if (ps != null) try { ps.close(); } catch (Exception ignored) {}
                    if (conn != null) try { conn.close(); } catch (Exception ignored) {}
                }
            %>
            </tbody>
        </table>

        <!-- Pagination -->
       <!-- Pagination -->
<div class="d-flex justify-content-center mt-4">
    <nav>
        <ul class="pagination">
            <%
                int totalRecords = 0, totalPages = 0;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");
                    ps = conn.prepareStatement("SELECT COUNT(*) FROM category");
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        totalRecords = rs.getInt(1);
                        totalPages = (int) Math.ceil((double) totalRecords / pageSize);
                    }

                    // Previous Button
                    if (pageNum > 1) {
            %>
            <li class="page-item">
                <a class="page-link" href="adminCategories.jsp?page=<%= pageNum - 1 %>&sort=<%= sort %>">Previous</a>
            </li>
            <% } else { %>
            <li class="page-item disabled">
                <span class="page-link">Previous</span>
            </li>
            <% } %>

            <%  // Numbered Page Links
                for (int i = 1; i <= totalPages; i++) {
            %>
            <li class="page-item <%= (i == pageNum) ? "active" : "" %>">
                <a class="page-link" href="adminCategories.jsp?page=<%= i %>&sort=<%= sort %>"><%= i %></a>
            </li>
            <% } %>

            <%  // Next Button
                if (pageNum < totalPages) {
            %>
            <li class="page-item">
                <a class="page-link" href="adminCategories.jsp?page=<%= pageNum + 1 %>&sort=<%= sort %>">Next</a>
            </li>
            <% } else { %>
            <li class="page-item disabled">
                <span class="page-link">Next</span>
            </li>
            <% }

                } catch (Exception e) {
                    e.printStackTrace(new PrintWriter(out));
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                    if (ps != null) try { ps.close(); } catch (Exception ignored) {}
                    if (conn != null) try { conn.close(); } catch (Exception ignored) {}
                }
            %>
        </ul>
    </nav>
</div>

    </div>
</div>
<%@ include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
