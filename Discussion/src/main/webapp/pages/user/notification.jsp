<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="java.sql.*, com.discussionhub.util.DBConnection"%>
<%@page session="true"%>
<!DOCTYPE html>
<html>
<head>
    <title>Notifications</title>
       <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <link href="../../assets/css/main.css" rel="stylesheet">
</head>
<body>
<%@ include file="../../includes/navbar.jsp" %>

<div style="display: flex; flex: 1; padding-top: 70px;">
    <%@ include file="../../includes/sidebar.jsp" %>

    <main style="flex: 1; overflow-y: auto; padding: 20px;">
        <div class="container">
            <div class="card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">Your Notifications</h4>
                </div>

                <div class="card-body">
                    <div class="list-group">
                        <%
                        // Show message after marking as read or deleting
                        String msg = (String) session.getAttribute("notification_msg");
                        if (msg != null) {
                        %>
                        <div class="alert alert-info"><%= msg %></div>
                        <%
                            session.removeAttribute("notification_msg");
                        }

                        Connection con = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        ResultSet userRs = null;

                        try {
                            Integer userId = (Integer) session.getAttribute("user_id");
                            if (userId == null) {
                                response.sendRedirect("login.jsp");
                                return;
                            }

                            con = DBConnection.getConnection();
                            ps = con.prepareStatement("SELECT * FROM notification WHERE user_id=? ORDER BY created_at DESC");
                            ps.setInt(1, userId);
                            rs = ps.executeQuery();

                            boolean hasNotifications = false;
                            while (rs.next()) {
                                hasNotifications = true;
                                int notificationUserId = rs.getInt("user_id");

                                // Fetch the username associated with the notification
                                ps = con.prepareStatement("SELECT username FROM users WHERE id = ?");
                                ps.setInt(1, notificationUserId);
                                userRs = ps.executeQuery();
                                String username = "";
                                if (userRs.next()) {
                                    username = userRs.getString("username");
                                }
                        %>
                        <div class="list-group-item d-flex justify-content-between align-items-start">
                            <div class="w-75">
                                <h6 class="mb-1">
                                    <% if (rs.getString("link") != null ) { %>
                                        <a href="notificationActions.jsp?action=markAsReadAndRedirect&id=<%= rs.getInt("id") %>">
    <%= rs.getString("message") %>
</a>

                                    <% } else { %>
                                        <%= rs.getString("message") %>
                                    <% } %>
                                    <% if (!rs.getBoolean("is_read")) { %>
                                        <span class="badge bg-warning text-dark ms-2">New</span>
                                    <% } %>
                                </h6>
                                <small class="text-muted"><%= rs.getTimestamp("created_at") %></small>
                                <!-- Display username below the notification -->
                                <div class="mt-2">
                                    <strong>From:</strong> <%= username %>
                                </div>
                            </div>
                            <div class="d-flex gap-2 align-items-center">
                                <% if (!rs.getBoolean("is_read")) { %>
                                <form method="post" action="notificationActions.jsp" style="display: inline;">
                                    <input type="hidden" name="action" value="markAsRead">
                                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                    <button type="submit" class="btn btn-sm btn-outline-success">
                                        <i class="bi bi-check2-circle"></i>
                                    </button>
                                </form>
                                <% } %>
                                <form method="post" action="notificationActions.jsp" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                        <%
                            }

                            if (!hasNotifications) {
                        %>
                        <div class="text-center text-muted py-4">
                            <i class="bi bi-bell-slash" style="font-size: 2rem;"></i>
                            <p class="mt-2 mb-0">You have no notifications.</p>
                        </div>
                        <%
                            }
                        } catch(Exception e) {
                            e.printStackTrace();
                        } finally {
                            try { if(rs != null) rs.close(); } catch(Exception e) {}
                            try { if(userRs != null) userRs.close(); } catch(Exception e) {}
                            try { if(ps != null) ps.close(); } catch(Exception e) {}
                            try { if(con != null) con.close(); } catch(Exception e) {}
                        }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<%@ include file="../../includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
