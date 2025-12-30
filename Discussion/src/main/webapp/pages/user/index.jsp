<!DOCTYPE html>
<html>
<head>
     <meta charset="UTF-8" />
     <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
    
    <link href="../../assets/css/main.css" rel="stylesheet">

    <style>
        /* Hero Section Styles */
        .hero {
            background-color: #007bff; /* Blue background */
            color: white;
            padding: 80px 0;
            text-align: center;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .hero h1 {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        .hero p {
            font-size: 1.25rem;
            margin-bottom: 30px;
        }
        .hero .btn-custom {
            background-color: #0056b3;
            color: white;
            padding: 10px 30px;
            font-size: 1.1rem;
            margin: 10px;
            border-radius: 5px;
            text-decoration: none;
        }
        .hero .btn-custom:hover {
            background-color: #003f80;
        }
    </style>
</head>
<body>
    <%@include file="../../includes/navbar.jsp"%>
    
    <div class="main-container">
        <%@include file="../../includes/sidebar.jsp"%>
        
        <main class="main-content">
            <div class="container">
                <h1 class="mt-4">Welcome to DiscussionHub</h1>
                
                <!-- Hero Section -->
                <div class="card">
                    <div class="card-body">
                        <div class="hero">
                            <h1>Ask Questions. Get Answers.</h1>
                            <p>Join the DiscussionHub community to connect, share, and grow.</p>
                            <a href="askquestion.jsp" class="btn btn-custom">Ask Question</a>
                            <a href="questions.jsp" class="btn btn-custom">Browse Questions</a>
                        </div>
                    </div>
                </div>
                
            </div>
        </main>
    </div>

    <%@include file="../../includes/footer.jsp"%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
