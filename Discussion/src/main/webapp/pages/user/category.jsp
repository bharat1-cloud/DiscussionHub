<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.discussionhub.util.DBConnection" %>

<%
    String catIdParam = request.getParameter("id");
    if (catIdParam == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
   

    int categoryId = Integer.parseInt(catIdParam);
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Category Questions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="../../assets/css/main.css" rel="stylesheet">
</head>
<body>
<%@ include file="../../includes/navbar.jsp" %>
<div style="display: flex; flex: 1; padding-top: 70px;">
    <%@ include file="../../includes/sidebar.jsp" %>

    <main style="flex: 1; overflow-y: auto; padding: 20px;">

<div class="container mt-5">
    <h3 class="mb-4">Questions in this Category</h3>

<%
    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement(
                "SELECT q.id, q.title, q.description, q.views, q.created_at, u.username, c.name AS category_name, " +
                "(SELECT COUNT(*) FROM answers WHERE question_id = q.id) AS answer_count " +
                "FROM questions q " +
                "JOIN users u ON q.user_id = u.id " +
                "JOIN category c ON q.category_id = c.id " +
                "WHERE q.category_id = ? " +
                "ORDER BY q.created_at DESC"
            );

        ps.setInt(1, categoryId);
        rs = ps.executeQuery();

        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy hh:mm a");

        boolean hasResults = false;
        while (rs.next()) {
            hasResults = true;
            int qId = rs.getInt("id");
            String title = rs.getString("title");
            String desc = rs.getString("description");
            int views = rs.getInt("views");
            Timestamp createdAt = rs.getTimestamp("created_at");
            String username = rs.getString("username");
            String categoryName = rs.getString("category_name");
            int answerCount = rs.getInt("answer_count");
%>
    <div class="card mb-3 shadow-sm">
        <div class="card-body">
            <div class="mb-2">
                <span class="badge bg-primary"><i class="bi bi-collection me-1"></i><%= categoryName %></span>
            </div>
            <h5 class="card-title mb-1">
                <a href="questionDetails.jsp?id=<%= qId %>" class="text-decoration-none"><%= title %></a>
            </h5>
            <p class="card-text text-truncate"><%= desc %></p>
            <div class="d-flex justify-content-between small text-muted">
                <span><i class="bi bi-person-fill"></i> <%= username %></span>
                <span><i class="bi bi-eye me-1"></i> <%= views %> views</span>
                <span><i class="bi bi-chat-left-text me-1"></i> <%= answerCount %> answers</span>
                <span><i class="bi bi-clock me-1"></i> <%= sdf.format(createdAt) %></span>
            </div>
        </div>
    </div>
<%
        }

        if (!hasResults) {
%>
    <p class="text-muted">No questions found in this category.</p>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
    <div class="alert alert-danger">Error loading questions.</div>
<%
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
        
    }
%>

</div>
</main>
</div>

<%@ include file="../../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
