<%@page import="java.sql.*, com.discussionhub.util.DBConnection"%>
<%
    // Get form data
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");

    // Initialize database objects
    Connection conn = null;
    PreparedStatement ps = null;
    
    try {
        // Validate password match
        if(!password.equals(confirmPassword)) {
            response.sendRedirect("../../register.html?error=Password mismatch");
            return;
        }

        // Get database connection
        conn = DBConnection.getConnection();
        
        // Check if username exists
        String checkUser = "SELECT id FROM users WHERE username=?";
        ps = conn.prepareStatement(checkUser);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        
        if(rs.next()) {
            response.sendRedirect("../../register.html?error=Username already exists");
            return;
        }
        ps.close();

        // Check if email exists
        String checkEmail = "SELECT id FROM users WHERE email=?";
        ps = conn.prepareStatement(checkEmail);
        ps.setString(1, email);
        rs = ps.executeQuery();
        
        if(rs.next()) {
            response.sendRedirect("../../register.html?error=Email already registered");
            return;
        }
        ps.close();

        // Insert new user
        String query = "INSERT INTO users(username, email, password) VALUES(?, ?, ?)";
        ps = conn.prepareStatement(query);
        ps.setString(1, username);
        ps.setString(2, email);
        ps.setString(3, password);
        
        int result = ps.executeUpdate();
        
        if(result > 0) {
            response.sendRedirect("../../login.html?success=Registration successful");
        } else {
            response.sendRedirect("../../register.html?error=Registration failed");
        }
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("../../register.html?error=Database error: " + e.getMessage());
    } finally {
        // Close resources
        try { if(ps != null) ps.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>