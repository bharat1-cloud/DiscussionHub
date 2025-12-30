<%@page import="java.sql.*, com.discussionhub.util.DBConnection"%>
<%
    // Handle form submission
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    Integer userId = (Integer) session.getAttribute("user_id");
    String success = request.getParameter("success");

    try {
        if (userId == null) {
            response.sendRedirect("../../login.html");
            return;
        }

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            conn = DBConnection.getConnection();

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("category"));
            String tagsInput = request.getParameter("tags");

            // Insert question
            ps = conn.prepareStatement(
                "INSERT INTO questions (title, description, category_id, user_id) VALUES (?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setInt(3, categoryId);
            ps.setInt(4, userId);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            int questionId = 0;
            if (rs.next()) {
                questionId = rs.getInt(1);
            }

            // Handle tags
            String[] tags = tagsInput.split(",");
            for (String tagName : tags) {
                tagName = tagName.trim();
                if (!tagName.isEmpty()) {
                    PreparedStatement tagStmt = conn.prepareStatement("SELECT id FROM tags WHERE name = ?");
                    tagStmt.setString(1, tagName);
                    ResultSet tagRs = tagStmt.executeQuery();

                    int tagId;
                    if (tagRs.next()) {
                        tagId = tagRs.getInt("id");
                    } else {
                        PreparedStatement insertTag = conn.prepareStatement(
                            "INSERT INTO tags (name) VALUES (?)",
                            Statement.RETURN_GENERATED_KEYS
                        );
                        insertTag.setString(1, tagName);
                        insertTag.executeUpdate();
                        ResultSet newTagRs = insertTag.getGeneratedKeys();
                        newTagRs.next();
                        tagId = newTagRs.getInt(1);
                        newTagRs.close();
                        insertTag.close();
                    }

                    PreparedStatement linkStmt = conn.prepareStatement(
                        "INSERT INTO question_tags (question_id, tag_id) VALUES (?, ?)"
                    );
                    linkStmt.setInt(1, questionId);
                    linkStmt.setInt(2, tagId);
                    linkStmt.executeUpdate();

                    tagRs.close();
                    tagStmt.close();
                    linkStmt.close();
                }
            }

            response.sendRedirect("askquestion.jsp?success=1");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Ask Question - DiscussionHub</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link href="../../assets/css/main.css" rel="stylesheet">
</head>
<body>

<%@include file="../../includes/navbar.jsp"%>

<div class="main-container">
    <%@include file="../../includes/sidebar.jsp"%>

    <main style="flex: 1; overflow-y: auto; padding: 20px; height:50%;">
        <div class="container">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Ask a Question</h4>
                </div>

                <div class="card-body">
                    <% if (success != null) { %>
                        <div class="alert alert-success">
                             Question posted successfully!
                        </div>
                        <script>
                            // Remove success=1 from URL to prevent alert on refresh
                            if (window.history.replaceState) {
                                const url = new URL(window.location.href);
                                url.searchParams.delete("success");
                                window.history.replaceState({}, document.title, url.pathname);
                            }
                        </script>
                    <% } %>

                    <form method="POST">
                        <div class="mb-3">
                            <label class="form-label">Title</label>
                            <input type="text" name="title" class="form-control"
                                   placeholder="What's your question?" required>
                           
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control"
                                      rows="6" placeholder="Include all details..." required></textarea>
                            <small class="text-muted">Include code snippets if needed</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Category</label>
                            <select name="category" class="form-select" required>
                                <option value="">Choose a category</option>
                                <%
                                Connection catCon = DBConnection.getConnection();
                                try {
                                    PreparedStatement catStmt = catCon.prepareStatement("SELECT * FROM category");
                                    ResultSet catRs = catStmt.executeQuery();
                                    while (catRs.next()) {
                                %>
                                        <option value="<%= catRs.getInt("id") %>">
                                            <%= catRs.getString("name") %>
                                        </option>
                                <%
                                    }
                                    catRs.close();
                                    catStmt.close();
                                } finally {
                                    catCon.close();
                                }
                                %>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Tags</label>
                            <input type="text" name="tags" class="form-control"
                                   placeholder="e.g., java, spring-boot, mysql">
                            <small class="text-muted">Add up to 5 tags separated by commas</small>
                        </div>

                        <div class="d-flex justify-content-end">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-send me-2"></i>Post Question
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<%@include file="../../includes/footer.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
