<%@page import="java.sql.*, com.discussionhub.util.DBConnection"%>
<%
Connection sidebarConn = null;
PreparedStatement sidebarPs = null;
ResultSet sidebarRs = null;

try {
	sidebarConn = DBConnection.getConnection();
	sidebarPs = sidebarConn.prepareStatement(
        "SELECT t.name, COUNT(qt.question_id) AS usage_count " +
        "FROM tags t JOIN question_tags qt ON t.id = qt.tag_id " +
        "GROUP BY t.name ORDER BY usage_count DESC LIMIT 10");
	sidebarRs = sidebarPs.executeQuery();
%>
<div class="sidebar">
    <div class="mb-4">
        <a href="askquestion.jsp" class="btn btn-primary w-100">
            <i class="bi bi-plus-circle me-2"></i>Ask Question
        </a>
    </div>

    <div class="list-group mb-4">
        <a href="index.jsp" class="list-group-item list-group-item-action">
            <i class="bi bi-house-door me-2"></i>Home
        </a>
        <a href="questions.jsp" class="list-group-item list-group-item-action">
            <i class="bi bi-question-circle me-2"></i>All Questions
        </a>
        <a href="myquestions.jsp" class="list-group-item list-group-item-action">
            <i class="bi bi-person-lines-fill me-2"></i>My Questions
        </a>
        <a href="saved.jsp" class="list-group-item list-group-item-action">
            <i class="bi bi-bookmark me-2"></i>Saved
        </a>
        <a href="users.jsp" class="list-group-item list-group-item-action">
            <i class="bi bi-people me-2"></i>Users
        </a>
    </div>

    <div class="card">
        <div class="card-header bg-primary text-white">
            <i class="bi bi-tags me-2"></i>Popular Tags
        </div>
        <div class="card-body">
            <div class="d-flex flex-wrap gap-2">
                <% while(sidebarRs.next()) { %>
                    <a href="tag.jsp?name=<%= sidebarRs.getString("name") %>" class="badge">
                        <%= sidebarRs.getString("name") %> (<%= sidebarRs.getInt("usage_count") %>)
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</div>
<%
} catch(Exception e) {
    e.printStackTrace();
} finally {
    try { if(sidebarRs != null) sidebarRs.close(); } catch(Exception e) {}
    try { if(sidebarPs != null) sidebarPs.close(); } catch(Exception e) {}
    try { if(sidebarConn != null) sidebarConn.close(); } catch(Exception e) {}
}
%>
