<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.discussionhub.util.DBConnection" %>
<%@ page import="com.discussionhub.helpers.VoteHelper" %>
<%@ page session="true" %>

<%
int userId = (Integer) session.getAttribute("user_id");
int questionId = request.getParameter("question_id") != null ? Integer.parseInt(request.getParameter("question_id")) : 0;
int answerId = request.getParameter("answer_id") != null ? Integer.parseInt(request.getParameter("answer_id")) : 0;
String newType = request.getParameter("type"); // "up" or "down"

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
String message = "";

try {
    conn = DBConnection.getConnection();

    String existingVoteType = VoteHelper.getUserVoteType(conn, userId, questionId, answerId);

    if (existingVoteType != null) {
        if (existingVoteType.equals(newType)) {
            VoteHelper.removeVote(conn, userId, questionId, answerId);
            message = "Your " + newType + "vote has been removed.";
        } else {
            VoteHelper.updateVote(conn, userId, questionId, answerId, newType);
            message = "Your vote was updated to " + newType + "vote.";
        }
    } else {
        VoteHelper.addVote(conn, userId, questionId, answerId, newType);
        message = "Your " + newType + "vote has been recorded.";
    }

    int authorId = (questionId != 0) ? VoteHelper.getQuestionAuthorId(conn, questionId) : VoteHelper.getAnswerAuthorId(conn, answerId);
    if (authorId != userId) {
        String notificationSql = "INSERT INTO notification(user_id, message, link) VALUES (?, ?, ?)";
        ps = conn.prepareStatement(notificationSql);
        ps.setInt(1, authorId);
        ps.setString(2, "Your question received a vote.");
        ps.setString(3, "questionDetails.jsp?id=" + questionId);
        ps.executeUpdate();
    }
%>
    <script>
        window.location.href = "questionDetails.jsp?id=<%= questionId %>&msg=" + encodeURIComponent("<%= message %>");
    </script>
<%
} catch(Exception e) {
%>
    <script>
        window.location.href = "questionDetails.jsp?id=<%= questionId %>&msg=" + encodeURIComponent("An error occurred while processing your vote.");
    </script>
<%
} finally {
    if(rs != null) try { rs.close(); } catch(Exception ex) {}
    if(ps != null) try { ps.close(); } catch(Exception ex) {}
    if(conn != null) try { conn.close(); } catch(Exception ex) {}
}
%>
