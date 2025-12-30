<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>About Us - DiscussionHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <link href="../../assets/css/main.css" rel="stylesheet">    <style>
        .about-section {
            background: #f8f9fa;
            padding: 60px 30px;
        }
        .team-photo {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #198754;
        }
    </style>
 </head>
<body>
<%@ include file="../../includes/navbar.jsp" %>
 <div class="main-container">
        <%@include file="../../includes/sidebar.jsp"%>
<div class="container about-section mt-4">
    <h2 class="text-Primary mb-4">About DiscussionHub</h2>

    <p>
        Welcome to <strong>DiscussionHub</strong>, your go-to platform for asking questions, sharing knowledge, and connecting with a community of learners and experts.
        Our goal is to make knowledge sharing easy, accessible, and rewarding for everyone.
    </p>

    <h4 class="mt-5">Our Mission</h4>
    <p>
        We aim to provide a trusted space where users can ask and answer questions, engage in meaningful discussions, and build a community that values curiosity and collaboration.
    </p>

    <h4 class="mt-5">Why Choose Us?</h4>
    <ul>
        <li>Clean and user-friendly interface</li>
        <li>Ask questions and get answers in real time</li>
        <li>Vote, save, and follow content you care about</li>
        <li>Personalized user dashboard</li>
        <li>Admin moderation and analytics</li>
    </ul>

   
    <h4 class="mt-5">Contact Us</h4>
    <p>
        Have questions or suggestions? <a href="contact.jsp" class="text-Primary">Reach out to us here</a>.
    </p>
</div>
</div>
 <%@include file="../../includes/footer.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
