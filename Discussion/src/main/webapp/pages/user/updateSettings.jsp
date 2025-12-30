<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="java.sql.*, java.io.*, com.discussionhub.util.DBConnection"%>
<%@page session="true"%>
<%
    String fullName = request.getParameter("full_name");
    String bio = request.getParameter("bio");
    String mobile = request.getParameter("mobile");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    Part profilePicturePart = request.getPart("profile_picture");
    String profilePicture = "default.png"; // Default picture

    // Ensure the email is not empty or null
    if (email == null || email.isEmpty()) {
        out.println("Email cannot be empty");
        return;
    }

    Integer userId = (Integer) session.getAttribute("user_id");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    try {
        con = DBConnection.getConnection();
        
        // Handle file upload
        if (profilePicturePart != null && profilePicturePart.getSize() > 0) {
            String fileName = profilePicturePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + "uploads" + File.separator + fileName;
            File fileSaveDir = new File(uploadPath);
            if (!fileSaveDir.exists()) {
                fileSaveDir.mkdirs();
            }
            profilePicturePart.write(uploadPath);
            profilePicture = fileName; // Save the new file name
        }

        // Hash the password if it's provided
        
        // Update user information in the database
        String updateSQL = "UPDATE users SET full_name = ?, bio = ?, mobile = ?, email = ?, password = ?, profile_picture = ? WHERE id = ?";
        ps = con.prepareStatement(updateSQL);
        ps.setString(1, fullName);
        ps.setString(2, bio);
        ps.setString(3, mobile);
        ps.setString(4, email); // Ensure email is being set
        ps.setString(5, password);
        ps.setString(6, profilePicture);
        ps.setInt(7, userId);

        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
            session.setAttribute("username", email); // Update session with new data
            response.sendRedirect("userDashboard.jsp");
        } else {
            out.println("Error updating profile.");
        }

    } catch (SQLException | IOException e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    } finally {
        try { if (ps != null) ps.close(); } catch (SQLException e) {}
        try { if (con != null) con.close(); } catch (SQLException e) {}
    }
%>
