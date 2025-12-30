<%
    session.removeAttribute("admin_id");
    session.removeAttribute("admin_username");
    session.invalidate();
    response.sendRedirect("index.jsp"); // Redirect back to admin login
%>
