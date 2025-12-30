<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.sql.*, com.discussionhub.util.DBConnection" %>
<%@page session="true" %>
<%
    Integer userIdObj = (Integer) session.getAttribute("user_id");
    if (userIdObj == null) {
        response.sendRedirect("../../login.html");
        return;
    }
    int userId = userIdObj;

    String fullName = "", email = "", mobile = "", bio = "", password = "", profilePics = "";
    String msg = "", picMsg = "", passwordMsg = "";

    // Redirect messages
    if ("1".equals(request.getParameter("success"))) {
        msg = "<div class='alert alert-success'>Profile updated successfully!</div>";
    }
    if ("1".equals(request.getParameter("picSuccess"))) {
        picMsg = "<div class='alert alert-success'>Profile picture updated successfully!</div>";
    }
    if ("1".equals(request.getParameter("passwordSuccess"))) {
        passwordMsg = "<div class='alert alert-success'>Password updated successfully!</div>";
    }

    // Handle POST for profile info
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("updateProfile") != null) {
        fullName = request.getParameter("full_name");
        bio = request.getParameter("bio");
        email = request.getParameter("email");
        mobile = request.getParameter("mobile");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE users SET full_name=?, bio=?, email=?, mobile=? WHERE id=?");
            ps.setString(1, fullName);
            ps.setString(2, bio);
            ps.setString(3, email);
            ps.setString(4, mobile);
            ps.setInt(5, userId);
            int updated = ps.executeUpdate();
            if (updated > 0) {
                // Redirect after profile update (Post-Redirect-Get pattern)
                response.sendRedirect("user.jsp");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Handle POST for password update
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("updatePassword") != null) {
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        // Check if passwords match
        if (newPassword.equals(confirmPassword)) {
            try (Connection con = DBConnection.getConnection()) {
                PreparedStatement ps = con.prepareStatement("UPDATE users SET password=? WHERE id=?");
                ps.setString(1, newPassword);
                ps.setInt(2, userId);
                int updated = ps.executeUpdate();
                if (updated > 0) {
                    // Redirect after password update
                    response.sendRedirect("editProfile.jsp?passwordSuccess=1");
                    return;
                } else {
                    passwordMsg = "<div class='alert alert-danger'>Failed to update password. Please try again.</div>";
                }
            } catch (Exception e) {
                e.printStackTrace();
                passwordMsg = "<div class='alert alert-danger'>Error updating password.</div>";
            }
        } else {
            passwordMsg = "<div class='alert alert-danger'>Passwords do not match.</div>";
        }
    }

    // Handle POST for profile picture
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("updatePicture") != null) {
        Part filePart = request.getPart("profile_picture");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = application.getRealPath("/") + "pages/user/uploads/" + fileName;
            filePart.write(uploadPath);

            try (Connection con = DBConnection.getConnection()) {
                PreparedStatement ps = con.prepareStatement("UPDATE users SET profile_picture=? WHERE id=?");
                ps.setString(1, fileName);
                ps.setInt(2, userId);
                int updated = ps.executeUpdate();
                if (updated > 0) {
                    // Redirect after profile picture update
                    response.sendRedirect("editProfile.jsp?picSuccess=1");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Load user data
    try (Connection con = DBConnection.getConnection()) {
        PreparedStatement ps = con.prepareStatement("SELECT full_name, bio, email, mobile, profile_picture FROM users WHERE id=?");
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            fullName = rs.getString("full_name");
            bio = rs.getString("bio");
            email = rs.getString("email");
            mobile = rs.getString("mobile");
            profilePics = rs.getString("profile_picture");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Handle null/empty values for display
    if (fullName == null || fullName.isEmpty()) fullName = "";
    if (bio == null || bio.isEmpty()) bio = "";
    if (email == null || email.isEmpty()) email = "";
    if (mobile == null || mobile.isEmpty()) mobile = "";
    if (profilePics == null || profilePics.isEmpty()) profilePics = "";
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <link href="../../assets/css/main.css" rel="stylesheet">
    <style>
        .form-section { background: #f8f9fa; padding: 20px; border-radius: 5px; }
        .form-section h5 { margin-bottom: 20px; }
        .img-thumbnail { width: 150px; height: 150px; object-fit: cover; }
    </style>
</head>
<body>
<%@ include file="../../includes/navbar.jsp" %>

<div style="display: flex; flex: 1; padding-top: 70px;">
    <%@ include file="../../includes/sidebar.jsp" %>
<div class="container py-5" style="padding-top: 80px;">
    <div class="row">
        <div class="col-md-8 mx-auto">

            <!-- Profile Info -->
            <div class="form-section mb-4">
                <h5>Edit Profile Info</h5>
                <%= msg %>  <!-- Success message will appear here -->
                <form method="post">
                    <input type="hidden" name="updateProfile" value="1">
                    <div class="mb-3">
                        <label>Full Name</label>
                        <input type="text" name="full_name" value="<%= fullName %>" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Bio</label>
                        <textarea name="bio" class="form-control"><%= bio %></textarea>
                    </div>
                    <div class="mb-3">
                        <label>Email</label>
                        <input type="email" name="email" value="<%= email %>" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Mobile</label>
                        <input type="text" name="mobile" value="<%= mobile %>" class="form-control">
                    </div>
                    <button type="submit" class="btn btn-primary">Update Profile</button>
                </form>
            </div>

            <!-- Password Update -->
            <div class="form-section mb-4">
                <h5>Change Password</h5>
                <%= passwordMsg %>  <!-- Success message for password update will appear here -->
                <form method="post">
                    <input type="hidden" name="updatePassword" value="1">
                    <div class="mb-3">
                        <label>New Password</label>
                        <input type="password" name="new_password" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Confirm Password</label>
                        <input type="password" name="confirm_password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Change Password</button>
                </form>
            </div>

            <!-- Profile Picture -->
            <div class="form-section text-center">
                <h5>Update Profile Picture</h5>
                <%= picMsg %>  <!-- Success message for picture update will appear here -->
                <img src="uploads/<%= (profilePics.isEmpty()) ? "default.png" : profilePics %>" class="img-thumbnail mb-3" />
                <form method="post" enctype="multipart/form-data">
                    <input type="hidden" name="updatePicture" value="1">
                    <input type="file" name="profile_picture" class="form-control" />
                    <button type="submit" class="btn btn-primary mt-2">Update Picture</button>
                </form>
            </div>

        </div>
    </div>
</div>
</div>
<%@ include file="../../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
