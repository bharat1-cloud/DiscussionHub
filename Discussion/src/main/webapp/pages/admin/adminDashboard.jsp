<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String adminUsernames = (String) session.getAttribute("admin_username");
    if (adminUsernames == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<%@ page import="java.sql.*, javax.sql.*" %>
<%
    // Database connection
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int totalUsers = 0, totalQuestions = 0, totalAnswers = 0, totalCategories = 0, totalTags = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/discussionhub", "root", ""); // update credentials

        String[] queries = {
            "SELECT COUNT(*) FROM users",
            "SELECT COUNT(*) FROM questions",
            "SELECT COUNT(*) FROM answers",
            "SELECT COUNT(*) FROM category",
            "SELECT COUNT(*) FROM tags"
        };

        int[] counters = new int[5];
        for (int i = 0; i < queries.length; i++) {
            ps = conn.prepareStatement(queries[i]);
            rs = ps.executeQuery();
            if (rs.next()) counters[i] = rs.getInt(1);
            rs.close(); ps.close();
        }

        totalUsers = counters[0];
        totalQuestions = counters[1];
        totalAnswers = counters[2];
        totalCategories = counters[3];
        totalTags = counters[4];

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
     <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <link href="../../assets/css/main.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card {
            border-left: 5px solid #0d6efd;
            transition: transform 0.2s ease;
        }
        .card:hover {
            transform: scale(1.02);
        }
        .dashboard-container {
           
            padding: 2rem;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="main-container">
    <%@ include file="sidebar.jsp" %>
    <div class="main-content">
<div class="dashboard-container">
    <h3 class="mb-4 fw-bold">Admin Dashboard</h3>

    <div class="row g-4">
        <!-- Total Users -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Total Users</h5>
                    <p class="display-6"><%= totalUsers %></p>
                </div>
            </div>
        </div>

        <!-- Total Questions -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Total Questions</h5>
                    <p class="display-6"><%= totalQuestions %></p>
                </div>
            </div>
        </div>

        <!-- Total Answers -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Total Answers</h5>
                    <p class="display-6"><%= totalAnswers %></p>
                </div>
            </div>
        </div>

        <!-- Total Categories -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Total Categories</h5>
                    <p class="display-6"><%= totalCategories %></p>
                </div>
            </div>
        </div>

        <!-- Total Tags -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Total Tags</h5>
                    <p class="display-6"><%= totalTags %></p>
                </div>
            </div>
        </div>
    </div>
</div>
</div></div>
<%@ include file="footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
