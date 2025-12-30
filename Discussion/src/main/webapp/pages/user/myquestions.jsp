<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.discussionhub.util.DBConnection" %>
<%@ page session="true" %>

<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("../../login.html");
        return;
    }

    int limit = 5;
    int pages = 1;
    if (request.getParameter("page") != null) {
        try {
            pages = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            pages = 1;
        }
    }
    int offset = (pages - 1) * limit;

    int totalQuestions = 0;
    int totalPages = 1;

    ArrayList<Integer> questionIds = new ArrayList<>();
    ArrayList<String> titles = new ArrayList<>();
    ArrayList<String> descriptions = new ArrayList<>();
    ArrayList<String> categories = new ArrayList<>();
    ArrayList<String> authorNames = new ArrayList<>();
    ArrayList<Timestamp> createdAts = new ArrayList<>();
    ArrayList<Integer> viewsList = new ArrayList<>();
    ArrayList<Integer> answerCounts = new ArrayList<>();
    ArrayList<ArrayList<String>> tagList = new ArrayList<>();

    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");

    try (Connection con = DBConnection.getConnection()) {
        // Count total questions
        PreparedStatement countStmt = con.prepareStatement("SELECT COUNT(*) FROM questions WHERE user_id = ?");
        countStmt.setInt(1, userId);
        ResultSet countRs = countStmt.executeQuery();
        if (countRs.next()) {
            totalQuestions = countRs.getInt(1);
            totalPages = (int) Math.ceil(totalQuestions / (double) limit);
        }

        PreparedStatement ps = con.prepareStatement(
            "SELECT q.id, q.title, q.description, q.views, q.created_at, c.name AS category, " +
            "u.username AS author, (SELECT COUNT(*) FROM answers a WHERE a.question_id = q.id) AS answer_count " +
            "FROM questions q " +
            "JOIN category c ON q.category_id = c.id " +
            "JOIN users u ON q.user_id = u.id " +
            "WHERE q.user_id = ? ORDER BY q.created_at DESC LIMIT ? OFFSET ?"
        );
        ps.setInt(1, userId);
        ps.setInt(2, limit);
        ps.setInt(3, offset);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int qId = rs.getInt("id");
            questionIds.add(qId);
            titles.add(rs.getString("title"));
            descriptions.add(rs.getString("description"));
            categories.add(rs.getString("category"));
            authorNames.add(rs.getString("author"));
            createdAts.add(rs.getTimestamp("created_at"));
            viewsList.add(rs.getInt("views"));
            answerCounts.add(rs.getInt("answer_count"));

            ArrayList<String> tags = new ArrayList<>();
            PreparedStatement tagStmt = con.prepareStatement(
                "SELECT t.name FROM tags t JOIN question_tags qt ON t.id = qt.tag_id WHERE qt.question_id = ?"
            );
            tagStmt.setInt(1, qId);
            ResultSet tagRs = tagStmt.executeQuery();
            while (tagRs.next()) {
                tags.add(tagRs.getString("name"));
            }
            tagRs.close();
            tagStmt.close();
            tagList.add(tags);
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Questions</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="../../assets/css/main.css" rel="stylesheet">
</head>
<body>
<%@ include file="../../includes/navbar.jsp" %>

<div style="display: flex; flex: 1; padding-top: 70px;">
    <%@ include file="../../includes/sidebar.jsp" %>

    <main style="flex: 1; overflow-y: auto; padding: 20px;">
        <div class="container mt-4">
            <h2 class="mb-4">Your Questions</h2>
            <% if (questionIds.isEmpty()) { %>
                <p>You haven't asked any questions yet.</p>
            <% } else {
                for (int i = 0; i < questionIds.size(); i++) {
            %>
            <div class="card mb-3 shadow-sm">
                <div class="card-body">
                    <div class="mb-1">
                        <span class="badge bg-primary">
                            <i class="bi bi-collection me-1"></i> <%= categories.get(i) %>
                        </span>
                    </div>
                    <h5 class="card-title mb-2">
                        <a href="questionDetails.jsp?id=<%= questionIds.get(i) %>"><%= titles.get(i) %></a>
                    </h5>
                    <p class="card-text text-truncate"><%= descriptions.get(i) %></p>
                    <div class="mb-2">
                        <% for (String tag : tagList.get(i)) { %>
                            <span class="badge bg-secondary me-1"><%= tag %></span>
                        <% } %>
                    </div>
                    <div class="d-flex justify-content-between small text-muted">
                        <span><i class="bi bi-person-fill"></i> <%= authorNames.get(i) %></span>
                        <span><i class="bi bi-eye"></i> <%= viewsList.get(i) %> views</span>
                        <span><i class="bi bi-chat-left-text"></i> <%= answerCounts.get(i) %> answers</span>
                        <span><i class="bi bi-clock"></i> <%= sdf.format(createdAts.get(i)) %></span>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Pagination -->
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center mt-4">
                    <li class="page-item <%= pages == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= pages - 1 %>">Previous</a>
                    </li>
                    <% for (int p = 1; p <= totalPages; p++) { %>
                        <li class="page-item <%= pages == p ? "active" : "" %>">
                            <a class="page-link" href="?page=<%= p %>"><%= p %></a>
                        </li>
                    <% } %>
                    <li class="page-item <%= pages == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= pages + 1 %>">Next</a>
                    </li>
                </ul>
            </nav>

            <% } %>
        </div>
    </main>
</div>

<%@ include file="../../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
