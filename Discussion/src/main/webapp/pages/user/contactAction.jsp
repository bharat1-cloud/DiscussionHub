<%@ page import="java.sql.*" %>
<%
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String subject = request.getParameter("subject");
    String message = request.getParameter("message");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", "");

        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO contact(full_name, email, subject, message) VALUES (?, ?, ?, ?)");
        ps.setString(1, fullName);
        ps.setString(2, email);
        ps.setString(3, subject);
        ps.setString(4, message);

        ps.executeUpdate();

        ps.close();
        conn.close();

        response.sendRedirect("contact.jsp?success=true");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
