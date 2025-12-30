<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Us</title>
 <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <link href="../../assets/css/main.css" rel="stylesheet"></head></head>
<body>
<%@ include file="../../includes/navbar.jsp" %>
 <div class="main-container">
        <%@include file="../../includes/sidebar.jsp"%>

<div class="container mt-5">
    <h3>Contact Us</h3>

    <% if (request.getParameter("success") != null) { %>
        <div class="alert alert-success">Message sent successfully!</div>
    <% } %>

    <form method="post" action="contactAction.jsp" class="row g-3">
        <div class="col-md-6">
            <label class="form-label">Full Name</label>
            <input type="text" name="full_name" class="form-control" required>
        </div>
        <div class="col-md-6">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="col-12">
            <label class="form-label">Subject</label>
            <input type="text" name="subject" class="form-control">
        </div>
        <div class="col-12">
            <label class="form-label">Message</label>
            <textarea name="message" class="form-control" rows="5" required></textarea>
        </div>
        <div class="col-12">
            <button class="btn btn-primary" type="submit">Send Message</button>
        </div>
    </form>
</div>
</div>
    <%@include file="../../includes/footer.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
