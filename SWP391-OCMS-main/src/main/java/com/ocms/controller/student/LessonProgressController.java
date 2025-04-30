package com.ocms.controller.student;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.LessonProgressDAO;
import com.ocms.dal.LessonDAO;
import com.ocms.entity.Account;
import com.ocms.entity.Lesson;
import com.ocms.entity.LessonProgress;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import org.json.JSONObject;

@WebServlet(name = "LessonProgressController", urlPatterns = {"/lesson-progress"})
public class LessonProgressController extends HttpServlet {

    private LessonProgressDAO lessonProgressDAO;
    private LessonDAO lessonDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        lessonProgressDAO = new LessonProgressDAO();
        lessonDAO = new LessonDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set response content type
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Get the JSON output writer
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        
        // Get user from session
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        // Check if user is logged in
        if (account == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "User not logged in");
            out.print(jsonResponse.toString());
            return;
        }
        
        // Get parameters
        String action = request.getParameter("action");
        String lessonIdParam = request.getParameter("lessonId");
        
        if (lessonIdParam == null || lessonIdParam.isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Lesson ID is required");
            out.print(jsonResponse.toString());
            return;
        }
        
        try {
            int lessonId = Integer.parseInt(lessonIdParam);
            
            // Get the lesson
            Lesson lesson = lessonDAO.getById(lessonId);
            if (lesson == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Lesson not found");
                out.print(jsonResponse.toString());
                return;
            }
            
            boolean success = false;
            
            if ("start".equals(action)) {
                // Mark lesson as started (in progress)
                success = lessonProgressDAO.markLessonAsInProgress(account.getId(), lessonId, 0);
                jsonResponse.put("message", "Lesson marked as in progress");
            } else if ("progress".equals(action)) {
                // Update progress percentage
                String progressParam = request.getParameter("progress");
                if (progressParam == null || progressParam.isEmpty()) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Progress percentage is required");
                    out.print(jsonResponse.toString());
                    return;
                }
                
                try {
                    int progressPercent = Integer.parseInt(progressParam);
                    // Ensure progress is between 0 and 100
                    progressPercent = Math.max(0, Math.min(100, progressPercent));
                    
                    success = lessonProgressDAO.markLessonAsInProgress(account.getId(), lessonId, progressPercent);
                    jsonResponse.put("message", "Progress updated");
                } catch (NumberFormatException e) {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Invalid progress value");
                    out.print(jsonResponse.toString());
                    return;
                }
            } else if ("complete".equals(action)) {
                // Mark lesson as completed
                success = lessonProgressDAO.markLessonAsCompleted(account.getId(), lessonId);
                jsonResponse.put("message", "Lesson marked as completed");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Invalid action");
                out.print(jsonResponse.toString());
                return;
            }
            
            jsonResponse.put("success", success);
            out.print(jsonResponse.toString());
            
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Invalid lesson ID");
            out.print(jsonResponse.toString());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get user from session
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        // Check if user is logged in
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        String action = request.getParameter("action");
        String lessonIdParam = request.getParameter("lessonId");
        
        if ("complete".equals(action) && lessonIdParam != null && !lessonIdParam.isEmpty()) {
            try {
                int lessonId = Integer.parseInt(lessonIdParam);
                boolean success = lessonProgressDAO.markLessonAsCompleted(account.getId(), lessonId);
                
                // Get the redirect URL
                String courseId = request.getParameter("courseId");
                String redirectUrl = request.getContextPath() + "/my-courses";
                
                if (courseId != null && !courseId.isEmpty()) {
                    redirectUrl += "?action=details&id=" + courseId;
                }
                
                // Set a message in the session
                if (success) {
                    request.getSession().setAttribute("message", "Lesson marked as completed!");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    request.getSession().setAttribute("message", "Failed to mark lesson as completed");
                    request.getSession().setAttribute("messageType", "error");
                }
                
                // Redirect back
                response.sendRedirect(redirectUrl);
                
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/my-courses");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/my-courses");
        }
    }
} 