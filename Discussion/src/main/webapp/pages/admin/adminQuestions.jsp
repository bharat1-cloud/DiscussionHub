<%@ page import="java.sql.*, java.util.*" %>
<%

if (session.getAttribute("admin_username") == null) {
    response.sendRedirect("index.jsp");
    return;
}

    int pages = 1;
    int recordsPerPage = 10;
    if (request.getParameter("page") != null) {
        pages = Integer.parseInt(request.getParameter("page"));
    }
    int start = (pages - 1) * recordsPerPage;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<Map<String, String>> questions = new ArrayList<>();
    int totalRecords = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");

        // Fetch questions with user, category, tags
        String sql = "SELECT q.id, q.title, q.description, q.views, q.created_at, u.username, c.name AS category " +
                     "FROM questions q " +
                     "JOIN users u ON q.user_id = u.id " +
                     "JOIN category c ON q.category_id = c.id " +
                     "ORDER BY q.created_at DESC LIMIT ?, ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, start);
        ps.setInt(2, recordsPerPage);
        rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> question = new HashMap<>();
            question.put("id", rs.getString("id"));
            question.put("title", rs.getString("title"));
            question.put("description", rs.getString("description"));
            question.put("views", rs.getString("views"));
            question.put("created_at", rs.getString("created_at"));
            question.put("username", rs.getString("username"));
            question.put("category", rs.getString("category"));
            questions.add(question);
        }
        rs.close();
        ps.close();

        // Count total records
        ps = conn.prepareStatement("SELECT COUNT(*) FROM questions");
        rs = ps.executeQuery();
        if (rs.next()) totalRecords = rs.getInt(1);

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) conn.close();
    }

    int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - All Questions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="../../assets/css/main.css" rel="stylesheet">
    <style>
        <style>
    body {
        background-color: #f8f9fa;
    }
    .card {
        border: none;
        border-radius: 8px;
        margin-bottom: 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
    }
    .card:hover {
        transform: scale(1.01);
        box-shadow: 0 4px 16px rgba(0,0,0,0.1);
    }
    .card-body a {
        text-decoration: none;
        color: inherit;
    }
    .card-title {
        font-size: 1.25rem;
        font-weight: bold;
        margin-bottom: 0.5rem;
    }
    .card-text {
        font-size: 0.95rem;
        color: #6c757d;
    }
    .badge {
        font-size: 0.8rem;
    }
</style>

    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="main-container">
    <%@ include file="sidebar.jsp" %>
    <div class="main-content">
        <div class="container py-4">
            <h4 class="fw-bold mb-4">All Questions</h4>

            <% if (questions.isEmpty()) { %>
                <div class="alert alert-info">No questions found.</div>
            <% } else { %>
                <% for (Map<String, String> q : questions) { %>
                  <div class="card">
    <div class="card-body">
        <a href="questionDetails.jsp?id=<%= q.get("id") %>">
            <h5 class="card-title"><%= q.get("title") %></h5>
            <p class="card-text"><%= q.get("description") %></p>

            <div class="d-flex flex-wrap gap-2">
                <span class="badge bg-primary"><%= q.get("category") %></span>
                <span class="text-muted"><i class="bi bi-eye"></i> <%= q.get("views") %> views</span>
                <span class="text-muted"><i class="bi bi-clock"></i> <%= q.get("created_at") %></span>
                <span class="text-muted"><i class="bi bi-person"></i> <%= q.get("username") %></span>
            </div>
        </a>
    </div>
</div>


                <% } %>

                <!-- Pagination -->
               <div class="d-flex justify-content-center mt-4">
    <nav>
        <ul class="pagination">
            <li class="page-item <%= (pages == 1) ? "disabled" : "" %>">
                <a class="page-link" href="adminQuestions.jsp?page=<%= pages - 1 %>">Previous</a>
            </li>

            <% for (int i = 1; i <= totalPages; i++) { %>
                <li class="page-item <%= (i == pages) ? "active" : "" %>">
                    <a class="page-link" href="adminQuestions.jsp?page=<%= i %>"><%= i %></a>
                </li>
            <% } %>

            <li class="page-item <%= (pages == totalPages) ? "disabled" : "" %>">
                <a class="page-link" href="adminQuestions.jsp?page=<%= pages + 1 %>">Next</a>
            </li>
        </ul>
    </nav>
</div>

            <% } %>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
