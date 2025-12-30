<%@ page import="java.sql.*, java.io.*, javax.servlet.http.Part" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Clear any existing messages
    session.removeAttribute("message");
    
    Integer adminId = (Integer) session.getAttribute("admin_id");
    if (adminId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String fullName = "", username = "", email = "", profilePics = "uploads/default.png", message = "";

    String dbURL = "jdbc:mysql://localhost:3306/discussionhub";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Load current admin info
        ps = conn.prepareStatement("SELECT * FROM admins WHERE id = ?");
        ps.setInt(1, adminId);
        rs = ps.executeQuery();
        if (rs.next()) {
            username = rs.getString("username");
            fullName = rs.getString("full_name") != null ? rs.getString("full_name") : "";
            email = rs.getString("email") != null ? rs.getString("email") : "";
            profilePics = rs.getString("profile_pic") != null ? rs.getString("profile_pic") : "uploads/default.png";
        }

        if (session.getAttribute("message") != null) {
            message = (String) session.getAttribute("message");
        }

    } catch (Exception e) {
        e.printStackTrace();
        message = "Error: " + e.getMessage();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Profile</title>
     <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <link href="../../assets/css/main.css" rel="stylesheet">
    <style>
        .profile-img {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #dee2e6;
        }
        .nav-tabs .nav-link.active {
            background-color: #198754 !important;
            color: #fff !important;
        }
        .tab-content {
            border: 1px solid #dee2e6;
            border-top: none;
            padding: 20px;
        }
        th {
            width: 150px;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="main-container d-flex">
    <%@ include file="sidebar.jsp" %>

    <div class="container mt-4">
        <h3 class="mb-4">Admin Profile</h3>

        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <ul class="nav nav-tabs" id="profileTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile"
                        type="button" role="tab">Profile</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="settings-tab" data-bs-toggle="tab" data-bs-target="#settings"
                        type="button" role="tab">Settings</button>
            </li>
          
        </ul>

        <div class="tab-content" id="profileTabContent">
            <!-- Profile Tab -->
            <div class="tab-pane fade show active" id="profile" role="tabpanel">
                <div class="text-center mb-3">
                    <img src="<%= profilePics %>" class="profile-img" alt="Profile Picture">
                </div>
                <table class="table table-striped">
                    <tr><th>Username</th><td><%= username %></td></tr>
                    <tr><th>Full Name</th><td><%= fullName %></td></tr>
                    <tr><th>Email</th><td><%= email %></td></tr>
                </table>
            </div>

            <!-- Settings Tab -->
            <div class="tab-pane fade" id="settings" role="tabpanel">
                <form method="post" action="updateProfile.jsp" class="row g-3" onsubmit="return validateProfileForm()">
                    <div class="col-md-6">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="full_name" value="<%= fullName %>" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" value="<%= email %>" class="form-control" id="email" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">New Password</label>
                        <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current">
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-check-circle"></i> Update Profile</button>
                    </div>
                </form>
                <form method="post" action="uploadPhoto.jsp" enctype="multipart/form-data" class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">Profile Picture</label>
                        <input type="file" name="profile_pic" class="form-control" accept="image/*" required>
                        <small class="text-muted">Only JPG, JPEG, PNG files allowed (Max 2MB)</small>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-upload"></i> Upload Photo</button>
                    </div>
                </form>
            </div>

            <!-- Upload Photo Tab 
            <div class="tab-pane fade" id="upload" role="tabpanel">
                <form method="post" action="uploadPhoto.jsp" enctype="multipart/form-data" class="row g-3">
                    <div class="col-md-12">
                        <label class="form-label">Profile Picture</label>
                        <input type="file" name="profile_pic" class="form-control" accept="image/*" required>
                        <small class="text-muted">Only JPG, JPEG, PNG files allowed (Max 2MB)</small>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-upload"></i> Upload Photo</button>
                    </div>
                </form>
            </div>-->
        </div>
    </div>
</div>


    <%@include file="footer.jsp"%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function validateProfileForm() {
        const email = document.getElementById('email').value;
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        
        if (!emailRegex.test(email)) {
            alert('Please enter a valid email address');
            return false;
        }
        return true;
    }
</script>
</body>
</html>