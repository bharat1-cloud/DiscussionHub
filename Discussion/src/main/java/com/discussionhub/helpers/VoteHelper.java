package com.discussionhub.helpers;

import java.sql.*;

public class VoteHelper {

    // Method to check if the user has already voted
    public static boolean hasUserVoted(Connection conn, int userId, int questionId, int answerId) throws SQLException {
        String checkSql = "SELECT id FROM votes WHERE user_id = ? AND " +
                (questionId != 0 ? "question_id = ?" : "answer_id = ?");

        try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, questionId != 0 ? questionId : answerId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Returns true if a record is found (user has voted)
            }
        }
    }

    // Method to add a vote (either on question or answer)
    public static void addVote(Connection conn, int userId, int questionId, int answerId, String type)
            throws SQLException {
        String insertSql = "INSERT INTO votes(user_id, question_id, answer_id, vote_type) VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setInt(1, userId);
            if (questionId != 0) {
                ps.setInt(2, questionId);
                ps.setNull(3, Types.INTEGER); // Use null for answer_id if it's a question vote
            } else {
                ps.setNull(2, Types.INTEGER); // Use null for question_id if it's an answer vote
                ps.setInt(3, answerId);
            }
            ps.setString(4, type);
            ps.executeUpdate();
        }
    }

    // Method to remove a vote (either from question or answer)
    public static void removeVote(Connection conn, int userId, int questionId, int answerId) throws SQLException {
        String deleteSql = "DELETE FROM votes WHERE user_id = ? AND " +
                (questionId != 0 ? "question_id = ?" : "answer_id = ?");

        try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, questionId != 0 ? questionId : answerId);
            ps.executeUpdate();
        }
    }

    // Method to get the author ID for a question
    public static int getQuestionAuthorId(Connection conn, int questionId) throws SQLException {
        String query = "SELECT user_id FROM questions WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, questionId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        }
        return -1; // Return -1 if no author found
    }

    public static String getUserVoteType(Connection conn, int userId, int questionId, int answerId)
            throws SQLException {
        String sql = "SELECT vote_type FROM votes WHERE user_id = ? AND " +
                (questionId != 0 ? "question_id = ?" : "answer_id = ?");
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.setInt(2, questionId != 0 ? questionId : answerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getString("vote_type"); // "up" or "down"
        }
        return null;
    }

    public static void updateVote(Connection conn, int userId, int questionId, int answerId, String newType)
            throws SQLException {
        String sql = "UPDATE votes SET vote_type = ? WHERE user_id = ? AND " +
                (questionId != 0 ? "question_id = ?" : "answer_id = ?");
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, newType);
        ps.setInt(2, userId);
        ps.setInt(3, questionId != 0 ? questionId : answerId);
        ps.executeUpdate();
    }

    public static int getQuestionIdByAnswerId(Connection conn, int answerId) throws SQLException {
        String query = "SELECT question_id FROM answers WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setInt(1, answerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt("question_id");
        }
        return 0;
    }

    public static String getExistingVoteType(Connection conn, int userId, int questionId, int answerId)
            throws SQLException {
        String sql = "SELECT vote_type FROM votes WHERE user_id = ? AND "
                + (questionId != 0 ? "question_id = ?" : "answer_id = ?");
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.setInt(2, questionId != 0 ? questionId : answerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getString("vote_type");
        }
        return null;
    }

    public static int getQuestionIdByAnswerId1(Connection conn, int answerId) throws SQLException {
        String query = "SELECT question_id FROM answers WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setInt(1, answerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt("question_id");
        }
        return 0;
    }

    // Method to get the author ID for an answer
    public static int getAnswerAuthorId(Connection conn, int answerId) throws SQLException {
        String query = "SELECT user_id FROM answers WHERE id = ?";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, answerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        }
        return -1; // Return -1 if no author found
    }
}
