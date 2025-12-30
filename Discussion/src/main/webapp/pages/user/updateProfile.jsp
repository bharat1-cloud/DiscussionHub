<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="java.sql.*, com.discussionhub.util.DBConnection"%>
<%@page import="java.io.*, javax.servlet.annotation.MultipartConfig"%>
<%@page session="true"%>
<%@page import="javax.servlet.http.Part"%>

<%
    String message = ""; // For error/success message

    // Get parameters from the form
    String newFullName = request.getParameter("full_name");
    String newBio = request.getParameter("bio");
    String newMobile = request.getParameter("mobile");
    String newEmail = request.getParameter("email");
    String newPassword = request.getParameter("password");
    Integer userId = (Integer) session.getAttribute("user_id");

    String profilePic = null; // Variable for profile picture

    // Handle profile picture upload
    Part filePart = request.getPart("profile_picture");
    if (filePart != null && filePart.getSize() > 0) {
        // Get the file name from the uploaded file
        String fileName = filePart.getSubmittedFileName();

        // Define the upload directory (ensure it exists)
        String uploadDir = getServletContext().getRealPath("/uploads");
        File uploadDirFile = new File(uploadDir);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdirs(); // Create the directory if it doesn't exist
        }

        // Save the file to the server
        File file = new File(uploadDir, fileName);
        filePart.write(file.getAbsolutePath()); // Save file

        profilePic = fileName; // Store the file name to update in the database
    }

    if (userId != null) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            // Connect to the database
            con = DBConnection.getConnection();

            // Build SQL query to update the user details
            StringBuilder updateSQL = new StringBuilder("UPDATE users SET ");
            updateSQL.append("full_name = ?, bio = ?, mobile = ?, email = ?");
            
            // Update the password if it's provided
            if (newPassword != null && !newPassword.isEmpty()) {
                updateSQL.append(", password = ?");
            }

            // Update the profile picture if it's provided
            if (profilePic != null) {
                updateSQL.append(", profile_pic = ?");
            }

            updateSQL.append(" WHERE id = ?");

            // Prepare the SQL statement
            ps = con.prepareStatement(updateSQL.toString());

            // Set the values for the prepared statement
            ps.setString(1, newFullName);
            ps.setString(2, newBio);
            ps.setString(3, newMobile);
            ps.setString(4, newEmail);

            // If password is provided, hash it and set it
            if (newPassword != null && !newPassword.isEmpty()) {
                String hashedPassword = newPassword; // Hash the password here if needed
                ps.setString(5, hashedPassword);
                ps.setString(6, profilePic);
            } else if (profilePic != null) {
                ps.setString(5, profilePic);
            }

            ps.setInt(6, userId); // Set the user ID to update

            // Execute the update
            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                // If the update is successful, update the session and redirect to the profile page
                session.setAttribute("username", newEmail); // Update session with new email
                message = "Profile updated successfully!";
                response.sendRedirect("user.jsp");
            } else {
                message = "Error: Unable to update profile.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    } else {
        // Redirect if user is not logged in
        message = "Please log in to update your profile.";
        response.sendRedirect("../../login.html");
    }
%>

<html>
<head>
    <title>Update Profile</title>
    <meta charset="UTF-8">
</head>
<body>
    <h1>Update Profile</h1>

    <!-- Display success or error message -->
    <% if (message != null && !message.isEmpty()) { %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>

    <!-- Profile Update Form -->
    <form action="updateProfile.jsp" method="post" enctype="multipart/form-data">
        <div>
            <label for="profile_picture">Profile Picture</label>
            <input type="file" name="profile_picture" id="profile_picture">
        </div>
        <div>
            <label for="full_name">Full Name</label>
            <input type="text" name="full_name" id="full_name" required>
        </div>
        <div>
            <label for="bio">Bio</label>
            <textarea name="bio" id="bio" rows="3" required></textarea>
        </div>
        <div>
            <label for="mobile">Mobile</label>
            <input type="text" name="mobile" id="mobile" required>
        </div>
        <div>
            <label for="email">Email Address</label>
            <input type="email" name="email" id="email" required>
        </div>
        <div>
            <label for="password">New Password (Optional)</label>
            <input type="password" name="password" id="password">
        </div>
        <button type="submit">Update Profile</button>
    </form>
</body>
</html>
