package com.discussionhub.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class NotificationHelper {
	
	public static int getQuestionAuthorId(Connection conn, int questionId) throws SQLException {
	    PreparedStatement ps = conn.prepareStatement("SELECT user_id FROM questions WHERE id = ?");
	    ps.setInt(1, questionId);
	    ResultSet rs = ps.executeQuery();
	    int authorId = -1;
	    if (rs.next()) {
	        authorId = rs.getInt("user_id");
	    }
	    rs.close();
	    ps.close();
	    return authorId;
	}


    public static int getQuestionAuthorId1(Connection conn, int questionId) throws SQLException {
        PreparedStatement ps = null;
        ResultSet rs = null;
        int authorId = -1;
        try {
            String sql = "SELECT user_id FROM questions WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, questionId);
            rs = ps.executeQuery();
            if (rs.next()) {
                authorId = rs.getInt("user_id");
            }
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        }
        return authorId;
    }

    public static void sendNotification(Connection conn, int userId, String message, String link) throws SQLException {
        PreparedStatement ps = null;
        try {
            String sql = "INSERT INTO notification(user_id, message, link, is_read) VALUES (?, ?, ?, false)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.setString(3, link);
            ps.executeUpdate();
        } finally {
            if (ps != null) ps.close();
        }
    }
}
