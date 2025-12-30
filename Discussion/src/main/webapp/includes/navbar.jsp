<%@page import="java.sql.*, com.discussionhub.util.DBConnection"%>
<%

Connection navConn = null;
Statement navStmt = null;
ResultSet navCategoryRs = null;

int unreadCount = 0;
Integer navUserId = (Integer) session.getAttribute("user_id");

try {
	navConn = DBConnection.getConnection();
	navStmt = navConn.createStatement();
	navCategoryRs = navStmt.executeQuery("SELECT * FROM category");
    
    if(navUserId != null) {
        PreparedStatement navPs = navConn.prepareStatement(
            "SELECT COUNT(*) AS count FROM notification WHERE user_id=? AND is_read=0");
        navPs.setInt(1, navUserId);
        ResultSet countRs = navPs.executeQuery();
        if(countRs.next()) unreadCount = countRs.getInt("count");
        countRs.close();
        navPs.close();
    }
%>
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid">
        <div class="d-flex align-items-center">
            <a class="navbar-brand text-white fw-bold" href="index.jsp">
                <i class="bi  me-2"></i>DiscussionHub
            </a>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link text-white" href="index.jsp">Home</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link text-white dropdown-toggle" href="#" data-bs-toggle="dropdown">
                        Categories
                    </a>
                    <ul class="dropdown-menu">
                        <% while(navCategoryRs.next()) { %>
                            <li><a class="dropdown-item" href="category.jsp?id=<%= navCategoryRs.getInt("id") %>">
                                <%= navCategoryRs.getString("name") %></a></li>
                        <% } %>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="about.jsp">About</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="contact.jsp">Contact</a>
                </li>
            </ul>
        </div>
<div>
     <form class="d-flex" action="search.jsp" method="GET">
   <input class="form-control me-2" type="search" name="keyword" placeholder="Search..." aria-label="Search" style="width: 500px;">

    <button class="btn btn-outline-light" type="submit">Search</button>
</form>

        </div>    

            <a href="notification.jsp" class="btn btn-light position-relative me-3">
                <i class="bi bi-bell"></i>
                <% if(unreadCount > 0) { %>
                    <span class="badge bg-danger notification-badge"><%= unreadCount %></span>
                <% } %>
            </a>

            <% if(navUserId != null) { %>
            <div class="dropdown">
                <a class="btn btn-light dropdown-toggle d-flex align-items-center" 
                   href="#" data-bs-toggle="dropdown">
                <%
    String profilePic = "uploads/default.png"; // default
    if (navUserId != null) {
        PreparedStatement picPs = navConn.prepareStatement("SELECT profile_picture FROM users WHERE id=?");
        picPs.setInt(1, navUserId);
        ResultSet picRs = picPs.executeQuery();
        if (picRs.next()) {
            String dbPic = picRs.getString("profile_picture");
            if (dbPic != null && !dbPic.trim().isEmpty()) {
                profilePic = "uploads/" + dbPic;
            }
        }
        picRs.close();
        picPs.close();
    }
%>
<img src="<%= profilePic %>" class="profile-pic me-2" style="width: 35px; height: 35px; border-radius: 50%; object-fit: cover;">

                    <strong><%= session.getAttribute("username") %></strong>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="user.jsp"><i class="bi bi-person me-2"></i>Profile</a></li>
                    <li><a class="dropdown-item" href="editProfile.jsp"><i class="bi bi-gear me-2"></i>Settings</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="../../pages/user/logout.jsp"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                </ul>
            </div>
            <% } else { %>
                <a href="../../login.html" class="btn btn-light">Login</a>
                
                <a href="../../register.html" class="btn btn-light">Register</a>
                
                
              
            <% } %>
        </div>
    </div>
</nav>
<%
} catch(Exception e) {
    e.printStackTrace();
} finally {
    try { if(navCategoryRs != null) navCategoryRs.close(); } catch(Exception e) {}
    try { if(navStmt != null) navStmt.close(); } catch(Exception e) {}
    try { if(navConn != null) navConn.close(); } catch(Exception e) {}
}
%>