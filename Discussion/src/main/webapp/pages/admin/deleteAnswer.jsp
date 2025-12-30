<%@ page import="java.sql.*" %>
<%
    int answerId = Integer.parseInt(request.getParameter("answer_id"));
    String questionId = request.getParameter("question_id");
    Connection conn = null;
    PreparedStatement ps = null;

    try {
        // Ensure the parameters are not null or empty
        if (answerId == 0 || questionId == null || questionId.isEmpty()) {
            out.println("<p>Error: Missing answer_id or question_id parameters.</p>");
            return;
        }

        // Establish database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");

        // Delete the answer from the database
        String deleteQuery = "DELETE FROM answers WHERE id = ?";
        ps = conn.prepareStatement(deleteQuery);
        ps.setInt(1, answerId);

        int rowsAffected = ps.executeUpdate();
        ps.close();

        // Check if any rows were affected (i.e., answer was found and deleted)
        if (rowsAffected > 0) {
            // Redirect to question details page
            response.sendRedirect("questionDetails.jsp?id=" + questionId);
        } else {
            out.println("<p>No answer found with the provided ID. Deletion failed.</p>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error deleting answer: " + e.getMessage() + "</p>");
    } finally {
        // Close resources
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
