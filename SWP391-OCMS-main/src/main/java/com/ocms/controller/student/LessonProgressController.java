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
                // First check if the lesson is already in progress or completed
                LessonProgress existingProgress = lessonProgressDAO.findByAccountAndLesson(account.getId(), lessonId);
                
                // If there's no existing progress or the lesson isn't completed, mark it as started
                if (existingProgress == null || !LessonProgress.Status.COMPLETED.equals(existingProgress.getStatus())) {
                    success = lessonProgressDAO.markLessonAsInProgress(account.getId(), lessonId, 0);
                    jsonResponse.put("message", "Lesson marked as started");
                } else {
                    // Lesson is already completed, so we'll consider this a success without changing status
                    success = true;
                    jsonResponse.put("message", "Lesson already tracked");
                    jsonResponse.put("status", existingProgress.getStatus());
                    jsonResponse.put("progress", existingProgress.getProgressPercent());
                }
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
                    
                    // First check if the lesson is already completed
                    LessonProgress existingProgress = lessonProgressDAO.findByAccountAndLesson(account.getId(), lessonId);
                    
                    // Only update if not already completed or if the new progress is 100%
                    if (existingProgress == null || !LessonProgress.Status.COMPLETED.equals(existingProgress.getStatus()) 
                            || progressPercent == 100) {
                        success = lessonProgressDAO.markLessonAsInProgress(account.getId(), lessonId, progressPercent);
                        jsonResponse.put("message", "Progress updated to " + progressPercent + "%");
                    } else {
                        // Lesson is already completed, so we'll consider this a success without changing status
                        success = true;
                        jsonResponse.put("message", "Lesson already completed");
                    }
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
                
                // Get updated progress
                LessonProgress updatedProgress = lessonProgressDAO.findByAccountAndLesson(account.getId(), lessonId);
                if (updatedProgress != null) {
                    jsonResponse.put("status", updatedProgress.getStatus());
                    jsonResponse.put("progress", updatedProgress.getProgressPercent());
                }
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
        } else if ("status".equals(action) && lessonIdParam != null && !lessonIdParam.isEmpty()) {
            // Get status of a lesson for the current user
            try {
                int lessonId = Integer.parseInt(lessonIdParam);
                
                // Set response content type
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                // Get the JSON output writer
                PrintWriter out = response.getWriter();
                JSONObject jsonResponse = new JSONObject();
                
                // Get lesson progress
                LessonProgress progress = lessonProgressDAO.findByAccountAndLesson(account.getId(), lessonId);
                
                if (progress != null) {
                    jsonResponse.put("success", true);
                    jsonResponse.put("status", progress.getStatus());
                    jsonResponse.put("progress", progress.getProgressPercent());
                } else {
                    jsonResponse.put("success", true);
                    jsonResponse.put("status", LessonProgress.Status.NOT_STARTED);
                    jsonResponse.put("progress", 0);
                }
                
                out.print(jsonResponse.toString());
                
            } catch (NumberFormatException e) {
                response.setContentType("application/json");
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Invalid lesson ID");
                response.getWriter().print(jsonResponse.toString());
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/my-courses");
        }
    }
} 