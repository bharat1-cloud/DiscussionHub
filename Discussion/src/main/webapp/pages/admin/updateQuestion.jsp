<%@ page import="java.sql.*" %>
<%
    int questionId = Integer.parseInt(request.getParameter("question_id"));
    String title = request.getParameter("title");
    String description = request.getParameter("description");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");
        ps = conn.prepareStatement("UPDATE questions SET title=?, description=? WHERE id=?");
        ps.setString(1, title);
        ps.setString(2, description);
        ps.setInt(3, questionId);
        ps.executeUpdate();
        response.sendRedirect("questionDetails.jsp?id=" + questionId);
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Update failed.");
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
