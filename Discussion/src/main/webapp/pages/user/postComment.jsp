<%@ page import="java.sql.*, com.discussionhub.util.DBConnection, com.discussionhub.util.NotificationHelper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
request.setCharacterEncoding("UTF-8");

int userId = (Integer) session.getAttribute("user_id");
String content = request.getParameter("content");
int questionId = request.getParameter("question_id") != null ? Integer.parseInt(request.getParameter("question_id")) : 0;
int answerId = request.getParameter("answer_id") != null ? Integer.parseInt(request.getParameter("answer_id")) : 0;

Connection conn = null;
PreparedStatement ps = null;

try {
    conn = DBConnection.getConnection();

    String sql = "INSERT INTO comments (question_id, answer_id, user_id, content) VALUES (?, ?, ?, ?)";
    ps = conn.prepareStatement(sql);
    if (questionId != 0) {
        ps.setInt(1, questionId);
    } else {
        ps.setNull(1, Types.INTEGER);
    }

    if (answerId != 0) {
        ps.setInt(2, answerId);
    } else {
        ps.setNull(2, Types.INTEGER);
    }

    ps.setInt(3, userId);
    ps.setString(4, content);
    ps.executeUpdate();
    ps.close();

    // Send notification to question author
    int authorId = NotificationHelper.getQuestionAuthorId(conn, questionId);
    if (authorId != userId) {
        String message = "Someone commented under your question.";
        String link = "questionDetails.jsp?id=" + questionId;
        NotificationHelper.sendNotification(conn, authorId, message, link);
    }

    response.sendRedirect("questionDetails.jsp?id=" + questionId);
} catch (Exception e) {
    e.printStackTrace();
}
%>
