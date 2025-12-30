<%@ page import="java.sql.*" %>
<%@ page import="com.discussionhub.util.DBConnection" %>
<%@ page session="true" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    int categoryId = Integer.parseInt(request.getParameter("category"));
    String existingTag = request.getParameter("existingTag");
    String newTag = request.getParameter("newTag");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int questionId = 0;

    try {
        conn = DBConnection.getConnection();

        // 1. Insert Question
        String insertQ = "INSERT INTO questions (user_id, title, description, category_id) VALUES (?, ?, ?, ?)";
        ps = conn.prepareStatement(insertQ, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, userId);
        ps.setString(2, title);
        ps.setString(3, description);
        ps.setInt(4, categoryId);
        ps.executeUpdate();
        rs = ps.getGeneratedKeys();

        if (rs.next()) {
            questionId = rs.getInt(1);
        }

        // 2. Insert tag if new
        if (newTag != null && !newTag.trim().isEmpty()) {
            // Check if it already exists
            String tagCheck = "SELECT id FROM tags WHERE name = ?";
            ps = conn.prepareStatement(tagCheck);
            ps.setString(1, newTag);
            ResultSet checkRs = ps.executeQuery();

            if (!checkRs.next()) {
                String insertTag = "INSERT INTO tags (name) VALUES (?)";
                ps = conn.prepareStatement(insertTag);
                ps.setString(1, newTag);
                ps.executeUpdate();
            }
        }

        // You can optionally link tags to questions with a linking table later.

        // 3. Redirect to "My Questions" or Questions Page
        response.sendRedirect("questions.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
