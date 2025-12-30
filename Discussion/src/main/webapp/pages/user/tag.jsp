<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.discussionhub.util.DBConnection" %>
<%@ page session="true" %>

<%
    String tagName = request.getParameter("name");
    if (tagName == null || tagName.isEmpty()) {
        response.sendRedirect("index.jsp");
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

    // Create lists to store the additional data
    List<String> authorNames = new ArrayList<>();
    List<Integer> viewsList = new ArrayList<>();
    List<Integer> answerCounts = new ArrayList<>();
    List<Timestamp> createdAts = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Questions Tagged: <%= tagName %></title>
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
        <div class="container">
            <h3 class="mb-4">Questions Tagged: "<%= tagName %>"</h3>

            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    conn = DBConnection.getConnection();

                    // Count total
                    ps = conn.prepareStatement(
                        "SELECT COUNT(*) FROM questions q " +
                        "JOIN question_tags qt ON q.id = qt.question_id " +
                        "JOIN tags t ON qt.tag_id = t.id " +
                        "WHERE t.name = ?"
                    );
                    ps.setString(1, tagName);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        totalQuestions = rs.getInt(1);
                        totalPages = (int) Math.ceil(totalQuestions / (double) limit);
                    }
                    rs.close();
                    ps.close();

                    ps = conn.prepareStatement(
                        "SELECT q.id, q.title, q.description, q.views, q.created_at, " +
                        "(SELECT COUNT(*) FROM answers WHERE question_id = q.id) AS answer_count, " +
                        "c.name AS category, u.username AS author " +
                        "FROM questions q " +
                        "JOIN question_tags qt ON q.id = qt.question_id " +
                        "JOIN tags t ON qt.tag_id = t.id " +
                        "JOIN category c ON q.category_id = c.id " +
                        "JOIN users u ON q.user_id = u.id " +
                        "WHERE t.name = ? " +
                        "ORDER BY q.created_at DESC " +
                        "LIMIT ? OFFSET ?"
                    );
                    ps.setString(1, tagName);
                    ps.setInt(2, limit);
                    ps.setInt(3, offset);
                    rs = ps.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
                    boolean hasResults = false;

                    while (rs.next()) {
                        hasResults = true;
                        int questionId = rs.getInt("id");
                        String title = rs.getString("title");
                        String description = rs.getString("description");
                        int views = rs.getInt("views");
                        int answers = rs.getInt("answer_count");
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        String category = rs.getString("category");
                        String author = rs.getString("author");

                        // Add the retrieved data to the lists
                        authorNames.add(author);
                        viewsList.add(views);
                        answerCounts.add(answers);
                        createdAts.add(createdAt);

                        // Fetch tags for this question
                        PreparedStatement tagStmt = conn.prepareStatement(
                            "SELECT t.name FROM tags t " +
                            "JOIN question_tags qt ON t.id = qt.tag_id " +
                            "WHERE qt.question_id = ?");
                        tagStmt.setInt(1, questionId);
                        ResultSet tagRs = tagStmt.executeQuery();

                        List<String> tags = new ArrayList<>();
                        while (tagRs.next()) {
                            tags.add(tagRs.getString("name"));
                        }
                        tagRs.close();
                        tagStmt.close();
            %>
            <div class="card mb-3 shadow-sm">
                <div class="card-body">
                    <div class="mb-1">
                        <span class="badge bg-primary"><i class="bi bi-folder me-1"></i> <%= category %></span>
                    </div>
                    <h5 class="card-title mb-2">
                        <a href="questionDetails.jsp?id=<%= questionId %>"><%= title %></a>
                    </h5>
                    <p class="card-text text-truncate"><%= description %></p>
                    <div class="mb-2">
                        <% for (String tag : tags) { %>
                            <span class="badge bg-secondary me-1"><%= tag %></span>
                        <% } %>
                    </div>

                    <!-- Display additional info: Author, Views, Answers, Created At -->
                    <div class="d-flex justify-content-between small text-muted">
                        <span><i class="bi bi-person-fill"></i> <%= authorNames.get(authorNames.size() - 1) %></span>
                        <span><i class="bi bi-eye"></i> <%= viewsList.get(viewsList.size() - 1) %> views</span>
                        <span><i class="bi bi-chat-left-text"></i> <%= answerCounts.get(answerCounts.size() - 1) %> answers</span>
                        <span><i class="bi bi-clock"></i> <%= sdf.format(createdAts.get(createdAts.size() - 1)) %></span>
                    </div>
                </div>
            </div>
            <%
                    }
                    if (!hasResults) {
            %>
            <p class="text-muted">No questions found for this tag.</p>
            <%
                    }

                    rs.close();
                    ps.close();
                } catch (Exception e) {
                    e.printStackTrace();
            %>
            <div class="alert alert-danger">Something went wrong while loading questions.</div>
            <%
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                    if (ps != null) try { ps.close(); } catch (Exception ignored) {}
                    if (conn != null) try { conn.close(); } catch (Exception ignored) {}
                }
            %>

            <!-- Pagination -->
            <% if (totalPages > 1) { %>
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center mt-4">
                    <li class="page-item <%= pages == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="tag.jsp?name=<%= tagName %>&page=<%= pages - 1 %>">Previous</a>
                    </li>
                    <% for (int p = 1; p <= totalPages; p++) { %>
                        <li class="page-item <%= p == pages ? "active" : "" %>">
                            <a class="page-link" href="tag.jsp?name=<%= tagName %>&page=<%= p %>"><%= p %></a>
                        </li>
                    <% } %>
                    <li class="page-item <%= pages == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="tag.jsp?name=<%= tagName %>&page=<%= pages + 1 %>">Next</a>
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
