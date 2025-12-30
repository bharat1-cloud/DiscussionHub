<%@ page import="java.sql.*" %>
<%
    int questionId = Integer.parseInt(request.getParameter("question_id"));
    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");

        // Delete from question_tags
        ps = conn.prepareStatement("DELETE FROM question_tags WHERE question_id = ?");
        ps.setInt(1, questionId);
        ps.executeUpdate();
        ps.close();

        // Delete from votes
        ps = conn.prepareStatement("DELETE FROM votes WHERE question_id = ?");
        ps.setInt(1, questionId);
        ps.executeUpdate();
        ps.close();

        // Delete from notifications
      
        // Delete from saves (make sure the correct table name is used)
        ps = conn.prepareStatement("DELETE FROM saved_questions WHERE question_id = ?");
        ps.setInt(1, questionId);
        ps.executeUpdate();
        ps.close();

        // Delete from comments
        ps = conn.prepareStatement("DELETE FROM comments WHERE question_id = ?");
        ps.setInt(1, questionId);
        ps.executeUpdate();
        ps.close();

        // Delete from answers
        ps = conn.prepareStatement("DELETE FROM answers WHERE question_id = ?");
        ps.setInt(1, questionId);
        ps.executeUpdate();
        ps.close();

        // Finally, delete the question
        ps = conn.prepareStatement("DELETE FROM questions WHERE id = ?");
        ps.setInt(1, questionId);
        ps.executeUpdate();
        ps.close();

        response.sendRedirect("adminQuestions.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error deleting question.</p>");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
