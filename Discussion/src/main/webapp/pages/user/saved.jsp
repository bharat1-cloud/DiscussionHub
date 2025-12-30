<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.discussionhub.util.DBConnection" %>
<%@ page session="true" %>

<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("../../login.html");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Saved Questions - DiscussionHub</title>
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
            <h3>Your Saved Questions</h3>
            <hr/>

            <%
                try {
                    conn = DBConnection.getConnection();
                    ps = conn.prepareStatement(
                        "SELECT q.id, q.title, q.description, q.views, q.created_at, " +
                        "u.username, c.name AS category, " +
                        "(SELECT COUNT(*) FROM answers a WHERE a.question_id = q.id) AS answer_count " +
                        "FROM saved_questions sq " +
                        "JOIN questions q ON sq.question_id = q.id " +
                        "JOIN users u ON q.user_id = u.id " +
                        "JOIN category c ON q.category_id = c.id " +
                        "WHERE sq.user_id = ? ORDER BY q.created_at DESC"
                    );
                    ps.setInt(1, userId);
                    rs = ps.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
                    boolean hasResults = false;

                    while (rs.next()) {
                        hasResults = true;
                        int qId = rs.getInt("id");
                        String title = rs.getString("title");
                        String desc = rs.getString("description");
                        String username = rs.getString("username");
                        String category = rs.getString("category");
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        int views = rs.getInt("views");
                        int answers = rs.getInt("answer_count");

                        // Fetch tags
                        PreparedStatement tagStmt = conn.prepareStatement(
                            "SELECT t.name FROM tags t JOIN question_tags qt ON t.id = qt.tag_id WHERE qt.question_id = ?"
                        );
                        tagStmt.setInt(1, qId);
                        ResultSet tagRs = tagStmt.executeQuery();
                        ArrayList<String> tags = new ArrayList<>();
                        while (tagRs.next()) {
                            tags.add(tagRs.getString("name"));
                        }
                        tagRs.close();
                        tagStmt.close();
            %>

            <div class="card mb-3 shadow-sm">
                <div class="card-body">
                    <!-- Category Badge -->
                    <div class="mb-1">
                        <span class="badge bg-primary">
                            <i class="bi bi-collection me-1"></i> <%= category %>
                        </span>
                    </div>

                    <!-- Question Title -->
                    <h5 class="card-title mb-2">
                        <a href="questionDetails.jsp?id=<%= qId %>"><%= title %></a>
                    </h5>

                    <!-- Description -->
                    <p class="card-text text-truncate"><%= desc %></p>

                    <!-- Tags -->
                    <div class="mb-2">
                        <% for (String tag : tags) { %>
                            <span class="badge bg-secondary me-1"><%= tag %></span>
                        <% } %>
                    </div>

                    <!-- Meta Info -->
                    <div class="d-flex justify-content-between small text-muted">
                         <span><i class="bi bi-person-fill"></i> <%= username %></span>
                        <span><i class="bi bi-eye"></i> <%= views %> views</span>
                        <span><i class="bi bi-chat-left-text"></i> <%= answers %> answers</span>
                        <span><i class="bi bi-clock"></i> <%= sdf.format(createdAt) %></span>
                    </div>
                     
                </div>
            </div>

            <%
                    }

                    if (!hasResults) {
            %>
                        <div class="alert alert-info">You haven't saved any questions yet.</div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                    <div class="alert alert-danger">❌ Error loading saved questions</div>
            <%
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (ps != null) ps.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
            %>
        </div>
    </main>
</div>

<%@ include file="../../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
