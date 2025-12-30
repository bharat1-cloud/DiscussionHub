<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.discussionhub.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Questions</title>
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
            <%
                String filter = request.getParameter("filter");
                if (filter == null) filter = "latest";

                String filterTitle = "Top Questions";
                if ("latest".equals(filter)) filterTitle = "Latest Questions";
                else if ("views".equals(filter)) filterTitle = "Most Viewed Questions";
                else if ("answers".equals(filter)) filterTitle = "Most Answered Questions";

                // Pagination setup
                int pages = 1;
                int pageSize = 10;
                String pageParam = request.getParameter("pages");
                if (pageParam != null) {
                    try {
                        pages = Integer.parseInt(pageParam);
                    } catch (NumberFormatException e) {
                        pages = 1;
                    }
                }
                int offset = (pages - 1) * pageSize;

            %>

            <!-- Filter Header & Dropdown -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="mb-0"><%= filterTitle %></h3>
                <form method="GET" class="d-flex gap-2">
                    <select name="filter" class="form-select" onchange="this.form.submit()">
                        <option value="latest" <%= "latest".equals(filter) ? "selected" : "" %>>Latest</option>
                        <option value="views" <%= "views".equals(filter) ? "selected" : "" %>>Most Viewed</option>
                        <option value="answers" <%= "answers".equals(filter) ? "selected" : "" %>>Most Answered</option>
                    </select>
                </form>
            </div>

            <%
                String orderBy = "q.created_at DESC";
                if ("views".equals(filter)) orderBy = "q.views DESC";
                else if ("answers".equals(filter)) orderBy = "answer_count DESC";

                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    conn = DBConnection.getConnection();

                    // SQL with LIMIT for pagination
                    String sql = "SELECT q.id, q.title, q.description, q.views, q.created_at, " +
                                 "u.username, c.name AS category, " +
                                 "(SELECT COUNT(*) FROM answers a WHERE a.question_id = q.id) AS answer_count " +
                                 "FROM questions q " +
                                 "JOIN users u ON q.user_id = u.id " +
                                 "JOIN category c ON q.category_id = c.id " +
                                 "ORDER BY " + orderBy + 
                                 " LIMIT ? OFFSET ?";

                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, pageSize);
                    ps.setInt(2, offset);
                    rs = ps.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");

                    while (rs.next()) {
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
                                <span class="badge bg-primary me-1"><%= tag %></span>
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
                    
                    // Count total questions for pagination
                    String countSql = "SELECT COUNT(*) FROM questions q";
                    PreparedStatement countStmt = conn.prepareStatement(countSql);
                    ResultSet countRs = countStmt.executeQuery();
                    int totalQuestions = 0;
                    if (countRs.next()) {
                        totalQuestions = countRs.getInt(1);
                    }

                    int totalPages = (int) Math.ceil((double) totalQuestions / pageSize);
            %>

            <!-- Pagination -->
            <div class="d-flex justify-content-center mt-4">
                <ul class="pagination">
                    <li class="page-item <%= pages == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?filter=<%= filter %>&pages=<%= pages - 1 %>">Previous</a>
                    </li>
                    <%
                        for (int i = 1; i <= totalPages; i++) {
                            if (i == pages) {
                    %>
                        <li class="page-item active"><a class="page-link" href="?filter=<%= filter %>&pages=<%= i %>"><%= i %></a></li>
                    <%
                            } else {
                    %>
                        <li class="page-item"><a class="page-link" href="?filter=<%= filter %>&pages=<%= i %>"><%= i %></a></li>
                    <%
                            }
                        }
                    %>
                    <li class="page-item <%= pages == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?filter=<%= filter %>&pages=<%= pages + 1 %>">Next</a>
                    </li>
                </ul>
            </div>

            <%
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <div class="alert alert-danger">❌ Error loading questions</div>
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
