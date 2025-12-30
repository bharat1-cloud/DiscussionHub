<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer adminId = (Integer) session.getAttribute("admin_id");
    if (adminId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String message = "";
    String dbURL = "jdbc:mysql://localhost:3306/discussionhub";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        String updatedFullName = request.getParameter("full_name");
        String updatedEmail = request.getParameter("email");
        String updatedPassword = request.getParameter("password");

        // Validate required fields
        if (updatedFullName == null || updatedFullName.trim().isEmpty()) {
            session.setAttribute("message", "Full name is required");
            response.sendRedirect("adminProfile.jsp");
            return;
        }
        
        if (updatedEmail == null || updatedEmail.trim().isEmpty()) {
            session.setAttribute("message", "Email address is required");
            response.sendRedirect("adminProfile.jsp");
            return;
        }
        
        if (!updatedEmail.matches("^[\\w.+'-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$")) {
            session.setAttribute("message", "Please enter a valid email address (e.g., user@example.com)");
            response.sendRedirect("adminProfile.jsp");
            return;
        }

        // Build and execute update query
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
        
        StringBuilder updateSQL = new StringBuilder("UPDATE admins SET full_name=?, email=?");
        if (updatedPassword != null && !updatedPassword.isEmpty()) {
            updateSQL.append(", password=?");
        }
        updateSQL.append(" WHERE id=?");

        ps = conn.prepareStatement(updateSQL.toString());
        int i = 1;
        ps.setString(i++, updatedFullName);
        ps.setString(i++, updatedEmail);
        if (updatedPassword != null && !updatedPassword.isEmpty()) {
            ps.setString(i++, updatedPassword);
        }
        ps.setInt(i, adminId);
        ps.executeUpdate();

        session.setAttribute("message", "Profile updated successfully!");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("message", "Error updating profile: " + e.getMessage());
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        response.sendRedirect("adminProfile.jsp");
    }
%>