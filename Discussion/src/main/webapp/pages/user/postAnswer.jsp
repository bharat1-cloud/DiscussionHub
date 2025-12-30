<%@ page import="java.sql.*, com.discussionhub.util.DBConnection, com.discussionhub.util.NotificationHelper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
request.setCharacterEncoding("UTF-8");

String content = request.getParameter("content");
String questionIdParam = request.getParameter("question_id");
Integer userId = (Integer) session.getAttribute("user_id");

if (content == null || questionIdParam == null || userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

int questionId = Integer.parseInt(questionIdParam);

Connection conn = null;
PreparedStatement ps = null;

try {
    conn = DBConnection.getConnection();

    String sql = "INSERT INTO answers (question_id, user_id, content) VALUES (?, ?, ?)";
    ps = conn.prepareStatement(sql);
    ps.setInt(1, questionId);
    ps.setInt(2, userId);
    ps.setString(3, content);
    ps.executeUpdate();
    ps.close();

    // Send notification to question author
    int authorId = NotificationHelper.getQuestionAuthorId(conn, questionId);
    if (authorId != userId) {
        String message = "Someone answered your question.";
        String link = "questionDetails.jsp?id=" + questionId;
        NotificationHelper.sendNotification(conn, authorId, message, link);
    }

    response.sendRedirect("questionDetails.jsp?id=" + questionId);
} catch (Exception e) {
    e.printStackTrace();
    out.println("❌ Error posting answer.");
} finally {
    try { if (ps != null) ps.close(); } catch (SQLException e) {}
    try { if (conn != null) conn.close(); } catch (SQLException e) {}
}
%>
