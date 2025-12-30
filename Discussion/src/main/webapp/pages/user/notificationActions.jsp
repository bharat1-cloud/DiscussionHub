<%@page import="com.discussionhub.util.DBConnection"%>
<%@page import="java.sql.*"%>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String action = request.getParameter("action");
String idParam = request.getParameter("id");
Integer userId = (Integer) session.getAttribute("user_id");

if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

try {
    if (idParam == null || idParam.isEmpty()) {
        session.setAttribute("notification_msg", "Invalid notification ID.");
        response.sendRedirect("notification.jsp");
        return;
    }

    int id = Integer.parseInt(idParam);
    con = DBConnection.getConnection();

    int result = 0;

    if ("markAsRead".equals(action)) {
        ps = con.prepareStatement("UPDATE notification SET is_read = 1 WHERE id = ? AND user_id = ?");
        ps.setInt(1, id);
        ps.setInt(2, userId);
        result = ps.executeUpdate();
        session.setAttribute("notification_msg", result > 0 ? "Notification marked as read." : "Notification not found.");

    } else if ("delete".equals(action)) {
        ps = con.prepareStatement("DELETE FROM notification WHERE id = ? AND user_id = ?");
        ps.setInt(1, id);
        ps.setInt(2, userId);
        result = ps.executeUpdate();
        session.setAttribute("notification_msg", result > 0 ? "Notification deleted." : "Notification not found.");

    } else if ("markAsReadAndRedirect".equals(action)) {
        String link = null;
        ps = con.prepareStatement("SELECT link FROM notification WHERE id = ? AND user_id = ?");
        ps.setInt(1, id);
        ps.setInt(2, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            link = rs.getString("link");
        }

        if (link != null && !link.isEmpty()) {
            // Mark as read
            ps = con.prepareStatement("UPDATE notification SET is_read = 1 WHERE id = ? AND user_id = ?");
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ps.executeUpdate();

            response.sendRedirect(link); // Redirect to the actual content
            return;
        } else {
            session.setAttribute("notification_msg", "Notification link not found.");
            response.sendRedirect("notification.jsp");
            return;
        }

    } else {
        session.setAttribute("notification_msg", "Invalid action.");
        response.sendRedirect("notification.jsp");
        return;
    }

    response.sendRedirect("notification.jsp");

} catch (Exception e) {
    e.printStackTrace();
    session.setAttribute("notification_msg", "Error: " + e.getMessage());
    response.sendRedirect("notification.jsp");
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (ps != null) ps.close(); } catch (Exception e) {}
    try { if (con != null) con.close(); } catch (Exception e) {}
}
%>
