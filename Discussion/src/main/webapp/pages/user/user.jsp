<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="java.sql.*, com.discussionhub.util.DBConnection"%>
<%@page session="true"%>
<%
    Integer loggedInUserIdObj = (Integer) session.getAttribute("user_id");
    if (loggedInUserIdObj == null) {
        response.sendRedirect("../../login.html");
        return;
    }
    int loggedInUserId = loggedInUserIdObj;
    int viewedUserId = loggedInUserId;
    boolean isOwnProfile = true;

    if (request.getParameter("id") != null) {
        viewedUserId = Integer.parseInt(request.getParameter("id"));
        if (viewedUserId != loggedInUserId) {
            isOwnProfile = false;
        }
    }

    String userUsername = "", userFullName = "", userEmail = "", userMobile = "", userProfilePic = "", userBio = "";
    try (Connection con = DBConnection.getConnection()) {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id = ?");
        ps.setInt(1, viewedUserId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            userUsername = rs.getString("username") != null ? rs.getString("username") : "";
            userFullName = rs.getString("full_name") != null ? rs.getString("full_name") : "";
            userEmail = rs.getString("email") != null ? rs.getString("email") : "";
            userMobile = rs.getString("mobile") != null ? rs.getString("mobile") : "";
            userProfilePic = rs.getString("profile_picture") != null ? rs.getString("profile_picture") : "";
            userBio = rs.getString("bio") != null ? rs.getString("bio") : "";
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <link href="../../assets/css/main.css" rel="stylesheet">
    <style>
        .profile-pic {
            width: 150px;
            height: 150px;
            object-fit: cover;
        }
        .empty-value {
            color: #6c757d;
            font-style: italic;
        }
    </style>
</head>
<body>
<%@ include file="../../includes/navbar.jsp" %>

<div style="display: flex; flex: 1; padding-top: 70px;">
    <%@ include file="../../includes/sidebar.jsp" %>
    <main style="flex: 1; overflow-y: auto; padding: 20px;">
        <div class="container">
            <div class="card mb-4 shadow-sm">
                <div class="card-body d-flex align-items-center">
                    <img src="<%= (!userProfilePic.isEmpty()) ? "uploads/" + userProfilePic : "uploads/default.png" %>" 
                         class="rounded-circle me-4 profile-pic" alt="Profile Picture">
                    <div>
                        <% if (!userFullName.isEmpty()) { %>
                            <h5 class="mb-1"><%= userFullName %> <% if (!userUsername.isEmpty()) { %><small class="text-muted">(@<%= userUsername %>)</small><% } %></h5>
                        <% } else if (!userUsername.isEmpty()) { %>
                            <h5 class="mb-1">@<%= userUsername %></h5>
                        <% } else { %>
                            <h5 class="mb-1 empty-value">No name provided</h5>
                        <% } %>

                        <% if (!userBio.isEmpty()) { %>
                            <p class="text-muted mb-1"><%= userBio %></p>
                        <% } else { %>
                            
                        <% } %>

                      <% if ((userEmail != null && !userEmail.trim().isEmpty()) || 
       (isOwnProfile && userMobile != null && !userMobile.trim().isEmpty())) { %>
    <p class="mb-0">
        <% if (userEmail != null && !userEmail.trim().isEmpty()) { %>
            <strong>Email:</strong> <%= userEmail %><br>
        <% } %>
        <% if (isOwnProfile && userMobile != null && !userMobile.trim().isEmpty()) { %>
            <strong>Mobile:</strong> <%= userMobile %><br>
        <% } %>
    </p>
<% } %>

                        <% if (isOwnProfile) { %>
                            <a href="editProfile.jsp" class="btn btn-sm btn-outline-primary mt-2"><i class="bi bi-pencil"></i> Edit Profile</a>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Tabs -->
            <ul class="nav nav-tabs mb-3" id="profileTabs">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#activityTab">Activity</button>
                </li>
                <% if (isOwnProfile) { %>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#savedTab">Saved</button>
                </li>
                <% } %>
            </ul>

            <div class="tab-content">
                <!-- Activity Tab -->
                <div class="tab-pane fade show active" id="activityTab">
                    <ul class="nav nav-pills mb-3">
                        <li class="nav-item">
                            <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#myQuestions">My Questions</button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link" data-bs-toggle="pill" data-bs-target="#answeredQuestions">Answered Questions</button>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- My Questions -->
                        <div class="tab-pane fade show active" id="myQuestions">
                            <div class="row">
                                <%
                                    try (Connection con = DBConnection.getConnection()) {
                                        PreparedStatement ps = con.prepareStatement("SELECT id, title, description FROM questions WHERE user_id = ? ORDER BY created_at DESC");
                                        ps.setInt(1, viewedUserId);
                                        ResultSet rs = ps.executeQuery();
                                        boolean hasData = false;
                                        while (rs.next()) {
                                            hasData = true;
                                            String title = rs.getString("title") != null ? rs.getString("title") : "Untitled Question";
                                            String description = rs.getString("description") != null ? rs.getString("description") : "No description provided";
                                %>
                                <div class="col-md-6 mb-3">
                                    <div class="card h-100">
                                        <div class="card-body">
                                            <h5 class="card-title"><%= title %></h5>
                                            <p class="card-text"><%= description %></p>
                                            <a href="questionDetails.jsp?id=<%= rs.getInt("id") %>" class="btn btn-sm btn-outline-primary">View</a>
                                        </div>
                                    </div>
                                </div>
                                <%
                                        }
                                        if (!hasData) {
                                %>
                                <div class="col-12"><div class="alert alert-info">No questions posted yet.</div></div>
                                <% }
                                    } catch (Exception e) { e.printStackTrace(); }
                                %>
                            </div>
                        </div>

                        <!-- Answered Questions -->
                        <div class="tab-pane fade" id="answeredQuestions">
                            <div class="row">
                                <%
                                    try (Connection con = DBConnection.getConnection()) {
                                        PreparedStatement ps = con.prepareStatement(
                                            "SELECT DISTINCT q.id, q.title, q.description FROM answers a JOIN questions q ON a.question_id = q.id WHERE a.user_id = ? ORDER BY a.created_at DESC");
                                        ps.setInt(1, viewedUserId);
                                        ResultSet rs = ps.executeQuery();
                                        boolean hasAnswered = false;
                                        while (rs.next()) {
                                            hasAnswered = true;
                                            String title = rs.getString("title") != null ? rs.getString("title") : "Untitled Question";
                                            String description = rs.getString("description") != null ? rs.getString("description") : "No description provided";
                                %>
                                <div class="col-md-6 mb-3">
                                    <div class="card h-100">
                                        <div class="card-body">
                                            <h5 class="card-title"><%= title %></h5>
                                            <p class="card-text"><%= description %></p>
                                            <a href="questionDetails.jsp?id=<%= rs.getInt("id") %>" class="btn btn-sm btn-outline-success">View</a>
                                        </div>
                                    </div>
                                </div>
                                <%
                                        }
                                        if (!hasAnswered) {
                                %>
                                <div class="col-12"><div class="alert alert-info">No questions answered yet.</div></div>
                                <% }
                                    } catch (Exception e) { e.printStackTrace(); }
                                %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Saved Tab -->
                <% if (isOwnProfile) { %>
                <div class="tab-pane fade" id="savedTab">
                    <div class="row">
                        <%
                            try (Connection con = DBConnection.getConnection()) {
                                PreparedStatement ps = con.prepareStatement(
                                    "SELECT q.id, q.title, q.description FROM saved_questions s JOIN questions q ON s.question_id = q.id WHERE s.user_id = ?");
                                ps.setInt(1, loggedInUserId);
                                ResultSet rs = ps.executeQuery();
                                boolean hasSaved = false;
                                while (rs.next()) {
                                    hasSaved = true;
                                    String title = rs.getString("title") != null ? rs.getString("title") : "Untitled Question";
                                    String description = rs.getString("description") != null ? rs.getString("description") : "No description provided";
                        %>
                        <div class="col-md-6 mb-3">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><%= title %></h5>
                                    <p class="card-text"><%= description %></p>
                                    <a href="questionDetails.jsp?id=<%= rs.getInt("id") %>" class="btn btn-sm btn-outline-warning">View</a>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                                if (!hasSaved) {
                        %>
                        <div class="col-12"><div class="alert alert-info">No saved questions.</div></div>
                        <% }
                            } catch (Exception e) { e.printStackTrace(); }
                        %>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </main>
</div>

<%@ include file="../../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>