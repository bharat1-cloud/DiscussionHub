<%@ page import="java.sql.*, java.util.*, com.discussionhub.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String keyword = request.getParameter("keyword");
    if (keyword == null || keyword.trim().equalsIgnoreCase("null")) keyword = "";
    int pages = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int limit = 10;
    int offset = (pages - 1) * limit;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<Map<String, String>> results = new ArrayList<>();
    int totalRecords = 0;

    try {
        conn = DBConnection.getConnection();

        // Count total results
        String countSql = "SELECT COUNT(DISTINCT q.id) FROM questions q " +
                          "LEFT JOIN question_tags qt ON q.id = qt.question_id " +
                          "LEFT JOIN tags t ON qt.tag_id = t.id " +
                          "WHERE q.title LIKE ? OR q.description LIKE ? OR t.name LIKE ?";
        ps = conn.prepareStatement(countSql);
        for (int i = 1; i <= 3; i++) ps.setString(i, "%" + keyword + "%");
        ResultSet countRs = ps.executeQuery();
        if (countRs.next()) totalRecords = countRs.getInt(1);
        countRs.close();
        ps.close();

        // Fetch results
        String sql = "SELECT DISTINCT q.id, q.title, q.description, q.created_at, c.name AS category_name " +
                     "FROM questions q " +
                     "JOIN category c ON q.category_id = c.id " +
                     "LEFT JOIN question_tags qt ON q.id = qt.question_id " +
                     "LEFT JOIN tags t ON qt.tag_id = t.id " +
                     "WHERE q.title LIKE ? OR q.description LIKE ? OR t.name LIKE ? " +
                     "ORDER BY q.created_at DESC LIMIT ? OFFSET ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, "%" + keyword + "%");
        ps.setString(2, "%" + keyword + "%");
        ps.setString(3, "%" + keyword + "%");
        ps.setInt(4, limit);
        ps.setInt(5, offset);

        rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> map = new HashMap<>();
            map.put("id", rs.getString("id"));
            map.put("title", rs.getString("title"));
            map.put("description", rs.getString("description"));
            map.put("category", rs.getString("category_name"));
            map.put("created_at", rs.getString("created_at"));
            results.add(map);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }

    int totalPages = (int) Math.ceil((double) totalRecords / limit);
%>

<%! 
    public String highlight(String text, String word) {
        if (text == null || word == null || word.trim().isEmpty()) return text;
        return text.replaceAll("(?i)(" + java.util.regex.Pattern.quote(word) + ")", "<mark>$1</mark>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Results</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="../../assets/css/main.css" rel="stylesheet">
</head>
<body>

<%@ include file="../../includes/navbar.jsp" %>
<div style="display: flex; flex: 1; padding-top: 70px;">
    <%@ include file="../../includes/sidebar.jsp" %>
    <main style="flex: 1; overflow-y: auto; padding: 20px;">
        <div class="container mt-5">
            <h3>Search Results for "<%= keyword %>"</h3>

            <!-- Results -->
            <% if (results.size() > 0) { %>
                <div class="row">
                <% for (Map<String, String> result : results) { %>
                    <div class="col-md-12 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <a href="questionDetails.jsp?id=<%= result.get("id") %>">
                                        <%= highlight(result.get("title"), keyword) %>
                                    </a>
                                </h5>
                                <h6 class="card-subtitle mb-2 text-muted">
                                    <%= result.get("category") %> | <%= result.get("created_at") %>
                                </h6>
                                <p class="card-text">
                                    <%= highlight(result.get("description"), keyword) %>
                                </p>
                            </div>
                        </div>
                    </div>
                <% } %>
                </div>

                <!-- Pagination -->
                <nav>
                    <ul class="pagination justify-content-center">
                        <% for (int i = 1; i <= totalPages; i++) { %>
                            <li class="page-item <%= (i == pages) ? "active" : "" %>">
                                <a class="page-link" href="?keyword=<%= keyword %>&page=<%= i %>"><%= i %></a>
                            </li>
                        <% } %>
                    </ul>
                </nav>
            <% } else { %>
                <div class="alert alert-info">No results found for "<strong><%= keyword %></strong>"</div>
            <% } %>
        </div>
    </main>
</div>

<%@ include file="../../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
