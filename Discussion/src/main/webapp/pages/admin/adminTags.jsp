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

    // Display message from session (one time only)
    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");  // Clear the message to avoid reuse after redirect
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");

        // Handle Add / Update / Delete
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String name = request.getParameter("name");
            String idParam = request.getParameter("id");

            // Check if the tag already exists
            ps = conn.prepareStatement("SELECT * FROM tags WHERE name = ?");
            ps.setString(1, name.trim());
            rs = ps.executeQuery();

            if (rs.next()) {
                // Tag already exists
                message = "Tag already exists. Please choose a different name.";
                session.setAttribute("message", message);
                response.sendRedirect("adminTags.jsp?sort=" + sort + "&page=" + pageNum); // Redirect after error
                return;
            } else {
                // If it's not a delete or update, add the new tag
                if (request.getParameter("deleteId") != null) {
                    int deleteId = Integer.parseInt(request.getParameter("deleteId"));
                    ps = conn.prepareStatement("DELETE FROM tags WHERE id = ?");
                    ps.setInt(1, deleteId);
                    ps.executeUpdate();
                    session.setAttribute("message", "Tag deleted successfully.");
                    response.sendRedirect("adminTags.jsp?sort=" + sort + "&page=" + pageNum); // Redirect after successful deletion
                    return;
                } else if (idParam != null && !idParam.isEmpty()) {
                    int id = Integer.parseInt(idParam);
                    ps = conn.prepareStatement("UPDATE tags SET name = ? WHERE id = ?");
                    ps.setString(1, name);
                    ps.setInt(2, id);
                    ps.executeUpdate();
                    session.setAttribute("message", "Tag updated successfully.");
                    response.sendRedirect("adminTags.jsp?sort=" + sort + "&page=" + pageNum); // Redirect after successful update
                    return;
                } else if (name != null && !name.trim().isEmpty()) {
                    ps = conn.prepareStatement("INSERT INTO tags (name) VALUES (?)");
                    ps.setString(1, name.trim());
                    ps.executeUpdate();
                    session.setAttribute("message", "Tag added successfully.");
                    response.sendRedirect("adminTags.jsp?sort=" + sort + "&page=" + pageNum); // Redirect after successful addition
                    return;
                }
            }
        }
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
        e.printStackTrace(new PrintWriter(out));
        session.setAttribute("message", message);
        response.sendRedirect("adminTags.jsp?sort=" + sort + "&page=" + pageNum); // Redirect after error
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin - Manage Tags</title>
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
        <h2>Manage Tags</h2>
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-warning"><%= message %></div>
        <% } %>

        <!-- Add Tag Form -->
        <form method="post" class="row g-3 mb-4">
            <div class="col-md-6">
                <input type="text" name="name" class="form-control" placeholder="New Tag Name" required>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary">Add Tag</button>
            </div>
        </form>

        <!-- Sort Buttons -->
        <div class="mb-3">
            <a href="adminTags.jsp?sort=ASC" class="btn btn-outline-secondary btn-sm">Sort A-Z</a>
            <a href="adminTags.jsp?sort=DESC" class="btn btn-outline-secondary btn-sm">Sort Z-A</a>
        </div>

        <!-- Tags Table -->
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
                    ps = conn.prepareStatement("SELECT * FROM tags ORDER BY name " + sort + " LIMIT ?, ?");
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
                                onclick="return confirm('Delete this tag?');">Delete</button>
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
<!-- Pagination -->
<div class="d-flex justify-content-center mt-4">
 <nav>
        <ul class="pagination">
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");
            ps = conn.prepareStatement("SELECT COUNT(*) FROM tags");
            rs = ps.executeQuery();
            if (rs.next()) {
                int totalRecords = rs.getInt(1);
                int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

                // Previous button
                if (pageNum > 1) {
    %>
   <li class="page-item">
                <a class="page-link" href="adminTags.jsp?page=<%= pageNum - 1 %>&sort=<%= sort %>">Previous</a>
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
                <a class="page-link" href="adminTags.jsp?page=<%= i %>&sort=<%= sort %>"><%= i %></a>
            </li>
            <% } %>

            <%  // Next Button
                if (pageNum < totalPages) {
            %>
            <li class="page-item">
                <a class="page-link" href="adminTags.jsp?page=<%= pageNum + 1 %>&sort=<%= sort %>">Next</a>
            </li>
            <% } else { %>
            <li class="page-item disabled">
                <span class="page-link">Next</span>
            </li>
    <%
                }
            }
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
