<%@ page import="java.sql.*" %>
<%@ page import="com.discussionhub.util.DBConnection" %>
<%
    String usernameOrEmail = request.getParameter("usernameOrEmail");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement("SELECT * FROM admins WHERE (username = ? OR email = ?) AND password = ?");
        ps.setString(1, usernameOrEmail);
        ps.setString(2, usernameOrEmail);
        ps.setString(3, password); // In production: use hashed password

        rs = ps.executeQuery();
        if (rs.next()) {
            session.setAttribute("admin_id", rs.getInt("id"));
            session.setAttribute("admin_username", rs.getString("username"));
           

            // Redirect to dashboard after successful login
            response.sendRedirect("adminDashboard.jsp");
        } else {
            // Set error message for invalid login attempt
            session.setAttribute("loginError", "Invalid username/email or password.");
            // Redirect back to login page to avoid form resubmission
            response.sendRedirect("index.jsp");
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
