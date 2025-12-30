<%@ page import="java.sql.*, java.io.*, javax.servlet.http.Part" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check admin session
    Integer adminId = (Integer) session.getAttribute("admin_id");
    if (adminId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String message = "";
    String dbURL = "jdbc:mysql://localhost:3306/discussionhub";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement ps = null;

    try {
    	
    	
        // Check if the request is multipart
        if (!request.getContentType().startsWith("multipart/form-data")) {
            session.setAttribute("message", "Invalid form enctype");
            response.sendRedirect("adminProfile.jsp");
            return;
        }

        // Get the uploaded file part - CORRECTED PARAMETER NAME
        Part filePart = request.getPart("profile_pic");
        
        if (filePart != null && filePart.getSize() > 0) {
            String submittedName = filePart.getSubmittedFileName();
            
            // Validate file has an extension
            if (submittedName == null || !submittedName.contains(".")) {
                session.setAttribute("message", "Invalid file name");
                response.sendRedirect("adminProfile.jsp");
                return;
            }
            
            String extension = submittedName.substring(submittedName.lastIndexOf('.') + 1).toLowerCase();
            
            // Validate file type
            if (!extension.matches("jpg|jpeg|png")) {
                session.setAttribute("message", "Only JPG, JPEG, PNG images allowed");
                response.sendRedirect("adminProfile.jsp");
                return;
            }
            
            // Validate file size (max 2MB)
            if (filePart.getSize() > 2097152) {
                session.setAttribute("message", "File too large. Max 2MB allowed");
                response.sendRedirect("adminProfile.jsp");
                return;
            }

            
            // Create uploads directory if it doesn't exist
            String uploadPath = application.getRealPath("") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs(); // Using mkdirs() instead of mkdir()
            }

            // Generate unique filename
            String fileName = adminId + "_" + System.currentTimeMillis() + "." + extension;
            String filePath = uploadPath + File.separator + fileName;
            
            // Debug output
            System.out.println("Attempting to save file to: " + filePath);
            
            // Save the file
            filePart.write(filePath);

            // Update database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            String relativePath = "uploads/" + fileName;
            String updateSQL = "UPDATE admins SET profile_pic = ? WHERE id = ?";
            ps = conn.prepareStatement(updateSQL);
            ps.setString(1, relativePath);
            ps.setInt(2, adminId);
            ps.executeUpdate();

            session.setAttribute("message", "Profile picture updated successfully!");
        } else {
            session.setAttribute("message", "Please select a file to upload");
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("message", "Upload error: " + e.getMessage());
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        response.sendRedirect("adminProfile.jsp");
    }
%>