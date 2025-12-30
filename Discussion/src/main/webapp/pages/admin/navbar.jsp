<%
String adminUsername = (String) session.getAttribute("admin_username");
String profilePic = "uploads/default.png"; // Default picture

// If a profile picture path is stored in session, use it
String sessionPic = (String) session.getAttribute("admin_profile_picture");
if (sessionPic != null && !sessionPic.trim().isEmpty()) {
    profilePic = "uploads/" + sessionPic;
}
%>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid justify-content-between">
        <!-- Left: Brand -->
        <a class="navbar-brand text-white fw-bold" href="adminDashboard.jsp">
            <i class="bi bi-speedometer2 me-2"></i>DiscussionHub Admin
        </a>

        <!-- Right: Admin Info -->
        <div class="dropdown">
            <a class="btn btn-light dropdown-toggle d-flex align-items-center" href="#" data-bs-toggle="dropdown">
                <img src="<%= profilePic %>" class="profile-pic me-2">
                <strong><%= adminUsername %></strong>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="adminProfile.jsp"><i class="bi bi-person me-2"></i>Profile</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="adminLogout.jsp"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
            </ul>
        </div>
    </div>
</nav>
