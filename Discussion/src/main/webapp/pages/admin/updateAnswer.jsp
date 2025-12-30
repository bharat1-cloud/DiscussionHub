<%@ page import="java.sql.*" %>
<%
    int answerId = Integer.parseInt(request.getParameter("answer_id"));
    String content = request.getParameter("content");
    String questionId = request.getParameter("question_id");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");
        ps = conn.prepareStatement("UPDATE answers SET content=? WHERE id=?");
        ps.setString(1, content);
        ps.setInt(2, answerId);
        ps.executeUpdate();
        response.sendRedirect("questionDetails.jsp?id=" + questionId);
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Answer update failed.");
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
