# DiscussionHub

DiscussionHub is a Stack Overflow–style discussion forum web application built using Java, JSP, MySQL, and Bootstrap.  
The platform allows users to ask questions, post answers, interact through comments and votes, and receive notifications.  
An admin panel is included to manage users and moderate content.

This project is developed as a full-stack learning and portfolio project, focusing on JSP-based backend development with real database integration.

---

## Project Overview

DiscussionHub simulates a real-world Q&A platform where community members share knowledge through questions and answers.  
The application demonstrates how frontend and backend logic work together using JSP without servlets.

Key goals of the project:
- Practical understanding of JSP and MySQL
- Session-based authentication
- Clean and reusable UI components
- Scalable database-driven design
- Beginner-friendly project structure

---

## Tech Stack

### Frontend
- HTML5
- CSS3 (external stylesheet)
- JavaScript
- Bootstrap (responsive UI)

### Backend
- Java
- JSP (Java Server Pages only)

### Database
- MySQL

### Tools
- Eclipse IDE
- Apache Tomcat Server
- Git & GitHub

---

## Key Features

### User Management
- User registration and login
- Session-based authentication
- Profile management
- Secure access to user-only pages

### Question & Answer System
- Users can post questions
- Other users can answer questions
- Questions and answers are linked to users
- View count tracking for questions

### Voting System
- Upvote and downvote questions and answers
- Prevents duplicate voting by the same user
- Highlights valuable content

### Tags and Categories
- Categories for broad classification
- Tags for detailed topic filtering
- Many-to-many relationship between questions and tags

### Search and Filtering
- Keyword-based search
- Filter questions by category or tag
- Sorting by recent activity or popularity

### Commenting System
- Comments on both questions and answers
- Encourages discussion and clarification

### Notification System
- Notifications for new answers, comments, votes, and saved questions
- Read and unread status support

### Saved Questions
- Users can bookmark questions
- Each question can be saved once per user

### Admin Panel
- Separate admin login
- Manage users, questions, answers, and comments
- Remove spam or irrelevant content

---

## Project Structure

DiscussionHub/
- Discussion/
  - pages/
    - user/
    - admin/
  - components/
  - assets/
  - db/
- discussionhub.sql
- README.md

---

## Database

Database name: discussionhub

Tables:
- users
- admins
- questions
- answers
- comments
- category
- tags
- question_tags
- votes
- saved_questions
- notification
- contact

---

## Database Setup

Create the database:

CREATE DATABASE discussionhub;

Import the schema:

SOURCE discussionhub.sql;

Update database credentials in:

/db/dbConnection.jsp

---

## How to Run the Project Locally

1. Clone the repository  
   git clone https://github.com/bharat1-cloud/DiscussionHub.git

2. Open the project in Eclipse IDE  
3. Configure Apache Tomcat Server  
4. Import discussionhub.sql into MySQL  
5. Run the project on the server  

Open in browser:

http://localhost:8081/Discussion/pages/user/index.jsp

(Port may vary based on server configuration)

---

## Learning Outcomes

- JSP-based backend development
- MySQL database integration
- Session handling and authentication
- Modular project structure
- Real-world forum application workflow
- GitHub documentation best practices

---

## Future Enhancements

- Private messaging between users
- Email-based notifications
- Reputation or point system
- Social media login (Google, GitHub)
- User badges and achievements

---

## Author

Bharat Yangandul  
MCA Graduate (2025)  
Aspiring Java Full Stack Developer  

GitHub: https://github.com/bharat1-cloud

---

## License

This project is developed for educational and learning purposes.


