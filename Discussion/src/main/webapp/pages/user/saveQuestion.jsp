<%@ page import="java.sql.*, com.discussionhub.util.DBConnection, com.discussionhub.util.NotificationHelper" %>
<%
int questionId = Integer.parseInt(request.getParameter("question_id"));
Integer userId = (Integer) session.getAttribute("user_id");

if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

Connection conn = null;
try {
    conn = DBConnection.getConnection();

    // Check if already saved
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM saved_questions WHERE question_id = ? AND user_id = ?");
    ps.setInt(1, questionId);
    ps.setInt(2, userId);
    ResultSet rs = ps.executeQuery();

    if (!rs.next()) {
        rs.close();
        ps.close();

        // Save question
        ps = conn.prepareStatement("INSERT INTO saved_questions (question_id, user_id) VALUES (?, ?)");
        ps.setInt(1, questionId);
        ps.setInt(2, userId);
        ps.executeUpdate();
        ps.close();

        // Notify question author
        int authorId = NotificationHelper.getQuestionAuthorId(conn, questionId);
        if (authorId != userId) {
            String msg = "Someone saved your question.";
            String link = "questionDetails.jsp?id=" + questionId;
            NotificationHelper.sendNotification(conn, authorId, msg, link);
        }

        session.setAttribute("save_msg", "Question saved.");
    } else {
        rs.close();
        ps.close();

        // Unsave question
        ps = conn.prepareStatement("DELETE FROM saved_questions WHERE question_id = ? AND user_id = ?");
        ps.setInt(1, questionId);
        ps.setInt(2, userId);
        ps.executeUpdate();
        ps.close();

        session.setAttribute("save_msg", "Question unsaved.");
    }

} catch (Exception e) {
    e.printStackTrace();
    session.setAttribute("save_msg", "Error saving question.");
} finally {
    if (conn != null) try { conn.close(); } catch (Exception e) {}
    response.sendRedirect("questionDetails.jsp?id=" + questionId);
}
%>
