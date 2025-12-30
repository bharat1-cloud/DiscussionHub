<%@ page import="java.sql.*, javax.sql.*, java.util.*, java.text.*" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

if (session.getAttribute("admin_username") == null) {
    response.sendRedirect("index.jsp");
    return;
}

    int questionId = Integer.parseInt(request.getParameter("id"));
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String title = "", description = "", category = "", userName = "", tagsString = "";
    int viewCount = 0;
    java.util.Date dateCreated = null;
    List<Map<String, Object>> answers = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");

        // Get question details
        String query = "SELECT q.title, q.description, c.name AS category, q.views, q.created_at, u.username " +
                       "FROM questions q " +
                       "JOIN users u ON q.user_id = u.id " +
                       "JOIN category c ON q.category_id = c.id " +
                       "WHERE q.id = ?";
        ps = conn.prepareStatement(query);
        ps.setInt(1, questionId);
        rs = ps.executeQuery();
        if (rs.next()) {
            title = rs.getString("title");
            description = rs.getString("description");
            category = rs.getString("category");
            viewCount = rs.getInt("views");
            dateCreated = rs.getTimestamp("created_at");
            userName = rs.getString("username");
        }
        rs.close();
        ps.close();

        // Get tags for the question (assuming you have a question_tags table linking tags to questions)
        String tagQuery = "SELECT t.name FROM tags t JOIN question_tags qt ON t.id = qt.tag_id WHERE qt.question_id = ?";
        ps = conn.prepareStatement(tagQuery);
        ps.setInt(1, questionId);
        rs = ps.executeQuery();
        List<String> tags = new ArrayList<>();
        while (rs.next()) {
            tags.add(rs.getString("name"));
        }
        tagsString = String.join(", ", tags);
        rs.close();
        ps.close();

     // Only increment view count if NOT an admin
        if (session.getAttribute("admin") == null) {
            String updateViews = "UPDATE questions SET views = views WHERE id = ?";
            ps = conn.prepareStatement(updateViews);
            ps.setInt(1, questionId);
            ps.executeUpdate();
            ps.close();
        }


        // Get answers
        String answerQuery = "SELECT a.content, a.created_at, u.username, a.id FROM answers a " +
                             "JOIN users u ON a.user_id = u.id WHERE a.question_id = ?";
        ps = conn.prepareStatement(answerQuery);
        ps.setInt(1, questionId);
        rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> answer = new HashMap<>();
            answer.put("answer_text", rs.getString("content"));
            answer.put("created_at", rs.getTimestamp("created_at"));
            answer.put("username", rs.getString("username"));
            answer.put("answer_id", rs.getInt("id"));
            answers.add(answer);
        }
        rs.close();
        ps.close();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Question Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="../../assets/css/main.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card { border-left: 5px solid #0d6efd; transition: transform 0.2s ease; }
        .card:hover { transform: scale(1.02); }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="main-container">
    <%@ include file="sidebar.jsp" %>
<div class="container py-3">
    <div class="row">
        <!-- Question Details -->
        <!-- Question Card -->
<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="updateQuestion.jsp" method="post">
            <input type="hidden" name="question_id" value="<%= questionId %>">
            
            <div class="mb-3">
                <label class="form-label"><strong>Title:</strong></label>
                <input type="text" class="form-control" name="title" value="<%= title %>">
            </div>

            <div class="mb-3">
                <label class="form-label"><strong>Category:</strong></label>
                <input type="text" class="form-control" value="<%= category %>" disabled>
            </div>

            <div class="mb-3">
                <label class="form-label"><strong>Tags:</strong></label>
                <input type="text" class="form-control" value="<%= tagsString %>" disabled>
            </div>

            <div class="mb-3">
                <label class="form-label"><strong>Description:</strong></label>
                <textarea name="description" class="form-control" rows="5"><%= description %></textarea>
            </div>

            <button type="submit" class="btn btn-primary btn-sm">
                <i class="bi bi-pencil-square"></i> Update Question
            </button>

            <a href="deleteQuestion.jsp?question_id=<%= questionId %>" class="btn btn-danger btn-sm ms-2"
               onclick="return confirm('Are you sure you want to delete this question?');">
                <i class="bi bi-trash"></i> Delete
            </a>
        </form>
    </div>
</div>


<%
    for (Map<String, Object> ans : answers) {
        String content = (String) ans.get("answer_text");
        String username = (String) ans.get("username");
        String formattedDate = "N/A";
        if (ans.get("created_at") instanceof java.util.Date) {
            formattedDate = new SimpleDateFormat("dd MMM yyyy").format((java.util.Date) ans.get("created_at"));
        }
%>
<div class="card mb-3 shadow-sm">
    <div class="card-body">
        <form action="updateAnswer.jsp" method="post">
            <input type="hidden" name="answer_id" value="<%= ans.get("answer_id") %>">
            <input type="hidden" name="question_id" value="<%= questionId %>">

            <p><strong><%= username %></strong> - <%= formattedDate %></p>

            <div class="mb-3">
                <textarea name="content" class="form-control" rows="3"><%= content %></textarea>
            </div>

            <button type="submit" class="btn btn-primary btn-sm">
                <i class="bi bi-pencil-square"></i> Update Answer
            </button>

            <button type="submit" formaction="deleteAnswer.jsp" class="btn btn-danger btn-sm ms-2"
                    onclick="return confirm('Are you sure you want to delete this answer?');">
                <i class="bi bi-trash"></i> Delete
            </button>
        </form>
    </div>
</div>
<%
    }
%>


        <!-- Answers Section -->
        
    </div>
</div>
</div>
<%@ include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
