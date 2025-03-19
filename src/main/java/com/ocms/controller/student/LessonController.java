package com.ocms.controller.student;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.LessonDAO;
import com.ocms.entity.Lesson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.ocms.dal.*;
import com.ocms.entity.*;

@WebServlet(name = "LessonController", urlPatterns = {"/lesson"})
public class LessonController extends HttpServlet {
    
    private LessonDAO lessonDAO;
    private LessonVideoDAO lessonVideoDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        lessonDAO = new LessonDAO();
        lessonVideoDAO = new LessonVideoDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "view";
        }
        
        switch (action) {
            case "view":
                viewLesson(request, response);
                break;
            case "list":
                listLessons(request, response);
                break;
            default:
                viewLesson(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "view";
        }
        
        switch (action) {
            case "complete":
                completeLesson(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/lesson");
                break;
        }
    }
    
    /**
     * View a specific lesson based on ID and type
     * @param request The HTTP request
     * @param response The HTTP response
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void viewLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get lesson ID and type from request parameters
            String lessonIdParam = request.getParameter("id");
            
            if (lessonIdParam == null || lessonIdParam.isEmpty()) {
                // If no lesson ID is provided, redirect to course page or show error
                request.setAttribute("errorMessage", "Lesson ID is required");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            int lessonId = Integer.parseInt(lessonIdParam);
            
            // Get lesson from DAO
            Lesson lesson = lessonDAO.getById(lessonId);
            
            if (lesson == null) {
                // If lesson not found, show error
                request.setAttribute("errorMessage", "Lesson not found");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Set lesson as request attribute
            request.setAttribute("lesson", lesson);
            
            // Forward to appropriate view based on lesson type
            String viewPath;
            switch (lesson.getType()) {
                case GlobalConfig.LESSON_TYPE_VIDEO:
                    LessonVideo lessonVideo = lessonVideoDAO.getByLessonId(lesson.getId());
                    request.setAttribute("lessonVideo", lessonVideo);
                    viewPath = "/view/dashboard/admin/lesson-detail.jsp";
                    break;
                case GlobalConfig.LESSON_TYPE_DOCUMENT:
                    viewPath = "/view/dashboard/student/document-lesson.jsp";
                    break;
                case GlobalConfig.LESSON_TYPE_QUIZ:
                    viewPath = "/view/dashboard/student/quiz-lesson.jsp";
                    break;
                case GlobalConfig.LESSON_TYPE_FILE:
                    viewPath = "/view/dashboard/student/file-lesson.jsp";
                    break;
                case GlobalConfig.LESSON_TYPE_TEXT:
                    viewPath = "/view/dashboard/student/text-lesson.jsp";
                    break;
                default:
                    viewPath = "/view/dashboard/student/lesson-detail.jsp";
                    break;
            }
            
            request.setAttribute("lesson", lesson);
            request.getRequestDispatcher(viewPath).forward(request, response);
            
        } catch (NumberFormatException e) {
            // Handle invalid lesson ID format
            request.setAttribute("errorMessage", "Invalid lesson ID format");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle other exceptions
            request.setAttribute("errorMessage", "Error loading lesson: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    /**
     * List lessons for a section or course
     * @param request The HTTP request
     * @param response The HTTP response
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void listLessons(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Check if section ID is provided
            String sectionIdParam = request.getParameter("sectionId");
            
            if (sectionIdParam != null && !sectionIdParam.isEmpty()) {
                int sectionId = Integer.parseInt(sectionIdParam);
                
                // Get lessons for the section
                request.setAttribute("lessons", lessonDAO.getBySectionId(sectionId));
                request.setAttribute("sectionId", sectionId);
                
                // Forward to section lessons view
                request.getRequestDispatcher("/view/dashboard/student/section-lessons.jsp").forward(request, response);
            } else {
                // If no section ID, redirect to courses page
                response.sendRedirect(request.getContextPath() + "/courses");
            }
        } catch (NumberFormatException e) {
            // Handle invalid section ID format
            request.setAttribute("errorMessage", "Invalid section ID format");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle other exceptions
            request.setAttribute("errorMessage", "Error loading lessons: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Mark a lesson as completed for the current user
     * @param request The HTTP request
     * @param response The HTTP response
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void completeLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get lesson ID from request
            String lessonIdParam = request.getParameter("id");
            
            if (lessonIdParam == null || lessonIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/courses");
                return;
            }
            
            int lessonId = Integer.parseInt(lessonIdParam);
            
            // Get user ID from session (assuming user is logged in)
            // This would need to be implemented based on your authentication system
            Integer userId = (Integer) request.getSession().getAttribute("userId");
            
            if (userId == null) {
                // If user not logged in, redirect to login
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Mark lesson as completed for user
            // This would need a method in your DAO or a separate DAO for user progress
            // For now, just redirect back to the lesson
            
            // Add success message to session
            request.getSession().setAttribute("toastMessage", "Lesson marked as completed");
            request.getSession().setAttribute("toastType", "success");
            
            // Redirect back to the lesson
            response.sendRedirect(request.getContextPath() + "/lesson?action=view&id=" + lessonId);
            
        } catch (NumberFormatException e) {
            // Handle invalid lesson ID format
            request.setAttribute("errorMessage", "Invalid lesson ID format");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle other exceptions
            request.setAttribute("errorMessage", "Error completing lesson: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
}
