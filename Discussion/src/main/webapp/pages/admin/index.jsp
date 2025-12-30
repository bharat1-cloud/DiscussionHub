<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap CDN -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <style>
        body {
            background-color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 40px 30px;
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 0 25px rgba(0, 123, 255, 0.2);
        }

        .login-container h2 {
            color: #007bff;
            font-weight: 600;
            text-align: center;
            margin-bottom: 30px;
        }

        .form-control:focus {
            box-shadow: none;
            border-color: #007bff;
        }

        .btn-login {
            background-color: #007bff;
            color: #fff;
            font-weight: bold;
        }

        .btn-login:hover {
            background-color: #0056b3;
        }

        .text-danger {
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Admin Login</h2>
    <form action="adminLoginAction.jsp" method="post">
  <% if (session.getAttribute("loginError") != null) { %>
    <div class="alert alert-danger mt-3" role="alert">
        <%= session.getAttribute("loginError") %>
    </div>
    <% session.removeAttribute("loginError"); %> <!-- Clear the error after displaying it -->
<% } %>

    
        <div class="form-group">
            <label for="usernameOrEmail">Username or Email</label>
            <input type="text" id="usernameOrEmail" name="usernameOrEmail" class="form-control" placeholder="Enter username or email" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" class="form-control" placeholder="Enter password" required>
        </div>
        <button type="submit" class="btn btn-login btn-block">Login</button>

        <% String error = request.getParameter("error");
           if (error != null && error.equals("1")) { %>
            <p class="text-danger">Invalid credentials. Please try again.</p>
        <% } %>
    </form>
</div>

</body>
</html>
