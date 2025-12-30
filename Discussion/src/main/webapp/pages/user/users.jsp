<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="java.sql.*, java.util.*, com.discussionhub.util.DBConnection"%>
<%@page session="true"%>
<%
    Integer userIdObj = (Integer) session.getAttribute("user_id");
    if (userIdObj == null) {
        response.sendRedirect("../../login.html");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>All Users</title>
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
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">All Users</h4>
                </div>
                <div class="card-body">
                    <div class="row">
                        <%
                            try (Connection con = DBConnection.getConnection()) {
                                PreparedStatement ps = con.prepareStatement("SELECT id, username, full_name, profile_picture FROM users");
                                ResultSet rs = ps.executeQuery();
                                boolean hasUsers = false;
                                while (rs.next()) {
                                    hasUsers = true;
                                    int id = rs.getInt("id");
                                    String username = rs.getString("username");
                                    String fullName = rs.getString("full_name");
                                    String profilePic = rs.getString("profile_picture");
                                    String displayName = (fullName != null && !fullName.isEmpty()) ? fullName : username;
                                    String picUrl = (profilePic != null && !profilePic.isEmpty()) ? "uploads/" + profilePic : "uploads/default.png";
                        %>
                        <div class="col-md-3 mb-4">
                            <a href="user.jsp?id=<%= id %>" style="text-decoration: none; color: inherit;">
                                <div class="card h-100 text-center">
                                    <img src="<%= picUrl %>" class="card-img-top mx-auto mt-3 rounded-circle" alt="Profile Picture" style="width: 100px; height: 100px;">
                                    <div class="card-body">
                                        <h5 class="card-title"><%= displayName %></h5>
                                        <p class="text-muted">@<%= username %></p>
                                    </div>
                                </div>
                            </a>
                        </div>
                        <%
                                }
                                if (!hasUsers) {
                        %>
                        <div class="col-12">
                            <div class="alert alert-info">No users found.</div>
                        </div>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                        %>
                        <div class="col-12">
                            <div class="alert alert-danger">An error occurred while loading users.</div>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<%@ include file="../../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
