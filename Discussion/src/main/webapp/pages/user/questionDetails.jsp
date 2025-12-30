<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.ArrayList, java.util.regex.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.discussionhub.util.DBConnection" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Question Details</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <link href="../../assets/css/main.css" rel="stylesheet">
    <style>
        .comment-box { margin-top: 15px; }
        .comment-toggle { cursor: pointer; color: #0d6efd; }
        .comment-section { display: none; margin-top: 10px; }
        .voted { color: green; }
        .saved { color: blue; }
    </style>
    
</head>
<body>

<%@ include file="../../includes/navbar.jsp" %>
<div style="display: flex; flex: 1; padding-top: 70px;">
    <%@ include file="../../includes/sidebar.jsp" %>


    <main style="flex: 1; overflow-y: auto; padding: 20px;">
 <!--   
<%// voting message
String msg = (String) session.getAttribute("vote_msg");
if (msg != null) {
%>
    <div style="margin: 20px 0; padding: 12px; background-color: #e8f5e9; color: #2e7d32; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
        <%= msg %>
    </div>
<%
    session.removeAttribute("vote_msg"); // Ensures message disappears on refresh
}
%>

<% // save message
    String voteMsg = (String) session.getAttribute("vote_msg");
    String saveMsg = (String) session.getAttribute("save_msg");
    if (voteMsg != null || saveMsg != null) {
%>
    <div style="margin: 10px; padding: 10px; background-color: #e0f7fa; border: 1px solid #00acc1; color: #006064; border-radius: 5px;">
        <%= voteMsg != null ? voteMsg : saveMsg %>
    </div>
<%
        session.removeAttribute("vote_msg");
        session.removeAttribute("save_msg");
    }
%>
-->


        <div class="container">
            <%
                String questionIdParam = request.getParameter("id");
                if (questionIdParam == null) {
            %>
                <div class="alert alert-danger">Invalid Question ID.</div>
            <%
                    return;
                }

                int questionId = Integer.parseInt(questionIdParam);
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                Integer sessionUserId = (Integer) session.getAttribute("user_id");

                try {
                    conn = DBConnection.getConnection();

                    // Fetch question, user info, and vote/save status
                    String qSql = "SELECT q.*, u.username, c.name AS category_name, " +
                                  "(SELECT COUNT(*) FROM votes WHERE question_id=q.id AND vote_type='up') AS upvotes, " +
                                  "(SELECT COUNT(*) FROM votes WHERE question_id=q.id AND vote_type='down') AS downvotes, " +
                                  "EXISTS(SELECT 1 FROM saved_questions WHERE question_id=q.id AND user_id=?) AS is_saved, " +
                                  "(SELECT vote_type FROM votes WHERE question_id=q.id AND user_id=?) AS user_vote " +
                                  "FROM questions q JOIN users u ON q.user_id=u.id LEFT JOIN category c ON q.category_id=c.id WHERE q.id=?";

                    ps = conn.prepareStatement(qSql);
                    ps.setInt(1, sessionUserId);
                    ps.setInt(2, sessionUserId);
                    ps.setInt(3, questionId);
                    rs = ps.executeQuery();

                    if (!rs.next()) {
            %>
                        <div class="alert alert-warning">Question not found.</div>
            <%
                        return;
                    }

                    int questionUserId = rs.getInt("user_id");
                    String questionTitle = rs.getString("title");
                    String questionDescription = rs.getString("description");
                    String questionCategory = rs.getString("category_name");
                    String questionUsername = rs.getString("username");
                    int upvotes = rs.getInt("upvotes");
                    int downvotes = rs.getInt("downvotes");
                    boolean isSaved = rs.getBoolean("is_saved");
                    String userVote = rs.getString("user_vote");
                    Timestamp questionCreatedAt = rs.getTimestamp("created_at");
                    int questionViews = rs.getInt("views");
                    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
            %>
            <div class="card mb-4 shadow-sm">
                <div class="card-body">
                    <span class="badge bg-primary mb-2"><i class="bi bi-collection me-1"></i> <%= questionCategory %></span>
                    <h4 class="card-title"><%= questionTitle %></h4>
                    <p class="card-text"><%= questionDescription %></p>

                    <!-- Tags -->
                    <div class="mb-3">
                        <%
                            PreparedStatement tagStmt = conn.prepareStatement("SELECT t.name FROM tags t JOIN question_tags qt ON t.id = qt.tag_id WHERE qt.question_id = ?");
                            tagStmt.setInt(1, questionId);
                            ResultSet tagRs = tagStmt.executeQuery();
                            while (tagRs.next()) {
                        %>
                        <span class="badge bg-secondary me-1"><%= tagRs.getString("name") %></span>
                        <% } tagRs.close(); tagStmt.close(); %>
                    </div>

                    <!-- Meta Info -->
                    <div class="d-flex justify-content-between small text-muted">
                        <span><i class="bi bi-eye"></i> <%= questionViews %> views</span>
                        <span><i class="bi bi-clock"></i> <%= sdf.format(questionCreatedAt) %></span>
                        <span><i class="bi bi-person-fill"></i> <%= questionUsername %></span>
                    </div>

                    <!-- Voting and Save -->
                    <form action="vote.jsp" method="post" class="d-inline">
                        <input type="hidden" name="question_id" value="<%= questionId %>" />
                        <input type="hidden" name="type" value="up" />
                        <button class="btn btn-sm <%= "up".equals(userVote) ? "btn-success" : "btn-outline-success" %>">
                            <i class="bi bi-hand-thumbs-up"></i> <%= upvotes %>
                        </button>
                    </form>

                    <form action="vote.jsp" method="post" class="d-inline">
                        <input type="hidden" name="question_id" value="<%= questionId %>" />
                        <input type="hidden" name="type" value="down" />
                        <button class="btn btn-sm <%= "down".equals(userVote) ? "btn-danger" : "btn-outline-danger" %>">
                            <i class="bi bi-hand-thumbs-down"></i> <%= downvotes %>
                        </button>
                    </form>

                    <form action="saveQuestion.jsp" method="post" class="d-inline">
                        <input type="hidden" name="question_id" value="<%= questionId %>" />
                        <button class="btn btn-sm <%= isSaved ? "btn-primary" : "btn-outline-primary" %>">
                            <i class="bi bi-bookmark<%= isSaved ? "-fill" : "" %>"></i> Save
                        </button>
                    </form>

                    <!-- Comments Toggle -->
                    <div class="comment-box">
                        <span class="comment-toggle" onclick="toggleComments('q-<%= questionId %>')">💬 Show/Hide Comments</span>
                        <div class="comment-section" id="comments-q-<%= questionId %>">
                         <ul class="list-unstyled">
                            <%
                                ps = conn.prepareStatement("SELECT c.*, u.username FROM comments c JOIN users u ON c.user_id = u.id WHERE c.question_id = ? ORDER BY c.created_at ASC");
                                ps.setInt(1, questionId);
                                rs = ps.executeQuery();
                                while (rs.next()) {
                            %>
                            
                                <li><strong><i class="bi bi-person"> </i><%= rs.getString("username") %></strong>   :  <%= rs.getString("content") %></li>
                            <% } rs.close(); ps.close(); %>
                            </ul>
                            <form action="postComment.jsp" method="post" class="mt-2">
                                <input type="hidden" name="question_id" value="<%= questionId %>" />
                                <textarea name="content" class="form-control mb-2" placeholder="Add a comment" required></textarea>
                                <button type="submit" class="btn btn-sm btn-secondary">Post Comment</button>
                            </form>
                            <hr/>
                           
                        </div>
                    </div>
                </div>
            </div>

            <!-- Answers -->
            <h5>Answers</h5>
            <%
                ps = conn.prepareStatement("SELECT a.*, u.username, " +
                                           "(SELECT COUNT(*) FROM votes WHERE answer_id=a.id AND vote_type='up') AS upvotes, " +
                                           "(SELECT COUNT(*) FROM votes WHERE answer_id=a.id AND vote_type='down') AS downvotes, " +
                                           "(SELECT vote_type FROM votes WHERE answer_id=a.id AND user_id=?) AS user_vote " +
                                           "FROM answers a JOIN users u ON a.user_id=u.id WHERE a.question_id=? ORDER BY a.created_at DESC");
                ps.setInt(1, sessionUserId);
                ps.setInt(2, questionId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    int answerId = rs.getInt("id");
                    String answerVote = rs.getString("user_vote");
            %>
            <div class="card mb-3">
                <div class="card-body">
                    <p><%= rs.getString("content") %></p>
                    <div class="text-muted small d-flex justify-content-between">
                        <span><i class="bi bi-clock"></i> <%= sdf.format(rs.getTimestamp("created_at")) %></span>
                        <span><i class="bi bi-person-fill"></i> <%= rs.getString("username") %></span>
                    </div>
                    <!-- Voting -->
                  <!--   <form action="vote.jsp" method="post" class="d-inline">
                        <input type="hidden" name="answer_id" value="<%= answerId %>" />
                        <input type="hidden" name="type" value="up" />
                        <button class="btn btn-sm <%= "up".equals(answerVote) ? "btn-success" : "btn-outline-success" %>">
                            <i class="bi bi-hand-thumbs-up"></i> <%= rs.getInt("upvotes") %>
                        </button>
                    </form>
                    <form action="vote.jsp" method="post" class="d-inline">
                        <input type="hidden" name="answer_id" value="<%= answerId %>" />
                        <input type="hidden" name="type" value="down" />
                        <button class="btn btn-sm <%= "down".equals(answerVote) ? "btn-danger" : "btn-outline-danger" %>">
                            <i class="bi bi-hand-thumbs-down"></i> <%= rs.getInt("downvotes") %>
                        </button>
                    </form>

                    Comments -->
                    <div class="comment-box">
                    
                        <span class="comment-toggle" onclick="toggleComments('a-<%= answerId %>')">💬 Show/Hide Comments</span>
                        
                        <div class="comment-section" id="comments-a-<%= answerId %>">
                        <ul class="list-unstyled">
                            <%
                                PreparedStatement ansCommentStmt = conn.prepareStatement("SELECT c.*, u.username FROM comments c JOIN users u ON c.user_id = u.id WHERE c.answer_id = ? ORDER BY c.created_at ASC");
                                ansCommentStmt.setInt(1, answerId);
                                ResultSet ansCommentRs = ansCommentStmt.executeQuery();
                                while (ansCommentRs.next()) {
                            %>
                                <li><strong><i class="bi bi-person-fill"></i><%= ansCommentRs.getString("username") %></strong>: <%= ansCommentRs.getString("content") %></li>
                            <% } ansCommentRs.close(); ansCommentStmt.close(); %>
                            </ul>
                            <form action="postComment.jsp" method="post" class="mt-2">
                                <input type="hidden" name="answer_id" value="<%= answerId %>" />
                                <input type="hidden" name="q_id" value="<%= questionId %>" />
                                <textarea name="content" class="form-control mb-2" placeholder="Add a comment" required></textarea>
                                <button type="submit" class="btn btn-sm btn-secondary">Post Comment</button>
                            </form>
                            <hr/>
                            
                        </div>
                    </div>
                </div>
            </div>
            <% } rs.close(); ps.close(); %>

            <!-- Answer Form -->
            <%
                if (sessionUserId != null && sessionUserId != questionUserId) {
            %>
            <div class="card">
                <div class="card-body">
                    <h6>Post Your Answer</h6>
                    <form action="postAnswer.jsp" method="post">
                        <input type="hidden" name="question_id" value="<%= questionId %>">
                        <textarea name="content" class="form-control mb-2" rows="5" required></textarea>
                        <button type="submit" class="btn btn-primary">Submit Answer</button>
                    </form>
                </div>
            </div>
            <% } else if (sessionUserId == null) { %>
                <p><em><a href="login.jsp">Login</a> to post an answer.</em></p>
            <% } else { %>
                <p><em>You can't answer your own question.</em></p>
            <% } %>
        </div>
    </main>
</div>
<%@ include file="../../includes/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleComments(id) {
        const elem = document.getElementById("comments-" + id);
        if (elem) {
            elem.style.display = elem.style.display === 'none' ? 'block' : 'none';
        }
    }
    
    function handleVote(questionId, answerId, type) {
        $.ajax({
            url: 'vote.jsp',
            type: 'GET',
            data: {
                question_id: questionId,
                answer_id: answerId,
                type: type
            },
            success: function(response) {
                if (response.success) {
                    alert(response.message);
                    // Update the vote count or UI dynamically here, based on the response.
                    // For example, you could update the vote count display:
                    updateVoteCountDisplay(questionId, answerId);
                } else {
                    alert(response.message); // Show error message
                }
            },
            error: function() {
                alert('An error occurred. Please try again.');
            }
        });
    }

    function updateVoteCountDisplay(questionId, answerId) {
        // Update the vote count display based on the new vote count for the question/answer.
        // Example: Refresh the vote count or toggle button states based on the vote.
        // You can also refresh other elements like the "Upvote" or "Downvote" buttons.
    }

    
</script>
</body>
</html>

<% 
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException e) {}
    if (ps != null) try { ps.close(); } catch (SQLException e) {}
    if (conn != null) try { conn.close(); } catch (SQLException e) {}
}
%>

