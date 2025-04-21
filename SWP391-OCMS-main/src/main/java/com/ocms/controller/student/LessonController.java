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
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

@WebServlet(name = "LessonController", urlPatterns = {"/lesson"})
public class LessonController extends HttpServlet {
    
    private LessonDAO lessonDAO;
    private LessonVideoDAO lessonVideoDAO;
    private LessonQuizDAO lessonQuizDAO;
    private QuestionDAO questionDAO;
    private QuizAnswerDAO quizAnswerDAO;
    private CourseDAO courseDAO;
    private SectionDAO sectionDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        lessonDAO = new LessonDAO();
        lessonVideoDAO = new LessonVideoDAO();
        lessonQuizDAO = new LessonQuizDAO();
        questionDAO = new QuestionDAO();
        quizAnswerDAO = new QuizAnswerDAO();
        courseDAO = new CourseDAO();
        sectionDAO = new SectionDAO();
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
            
            // Get section information
            Section section = sectionDAO.getById(lesson.getSectionId());
            if (section != null) {
                request.setAttribute("section", section);
                
                // Get course information
                Course course = courseDAO.findById(section.getCourseId());
                request.setAttribute("course", course);
                
                // Get all sections for this course
                List<Section> courseSections = sectionDAO.getByCourseId(section.getCourseId());
                request.setAttribute("courseSections", courseSections);
                
                // Get all lessons for each section
                Map<Integer, List<Lesson>> sectionLessons = new HashMap<>();
                for (Section sec : courseSections) {
                    List<Lesson> lessons = lessonDAO.getBySectionId(sec.getId());
                    sectionLessons.put(sec.getId(), lessons);
                }
                request.setAttribute("sectionLessons", sectionLessons);
                
                // Find previous and next lessons for navigation
                Lesson prevLesson = null;
                Lesson nextLesson = null;
                
                // Get all lessons in order
                List<Lesson> allLessons = new ArrayList<>();
                for (Section sec : courseSections) {
                    allLessons.addAll(lessonDAO.getBySectionId(sec.getId()));
                }
                
                // Sort lessons by order number
                Collections.sort(allLessons, Comparator.comparing(Lesson::getOrderNumber));
                
                // Find current lesson index
                int currentIndex = -1;
                for (int i = 0; i < allLessons.size(); i++) {
                    if (allLessons.get(i).getId().equals(lesson.getId())) {
                        currentIndex = i;
                        break;
                    }
                }
                
                // Get previous and next lessons
                if (currentIndex > 0) {
                    prevLesson = allLessons.get(currentIndex - 1);
                }
                
                if (currentIndex < allLessons.size() - 1) {
                    nextLesson = allLessons.get(currentIndex + 1);
                }
                
                request.setAttribute("prevLesson", prevLesson);
                request.setAttribute("nextLesson", nextLesson);
            }
            
            // Set lesson as request attribute
            request.setAttribute("lesson", lesson);
            
            // Forward to appropriate view based on lesson type
            String viewPath;
            switch (lesson.getType()) {
                case GlobalConfig.LESSON_TYPE_VIDEO:
                    getLessonVideo(request, response, lesson);
                    viewPath = "/view/dashboard/student/lesson-video-detail.jsp";
                    break;
                case GlobalConfig.LESSON_TYPE_DOCUMENT:
                    viewPath = "/view/dashboard/student/document-lesson.jsp";
                    break;
                case GlobalConfig.LESSON_TYPE_QUIZ:
                    getLessonQuiz(request, response, lesson);
                    viewPath = "/view/dashboard/student/lesson-quiz-detail.jsp";
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

    private void getLessonVideo(HttpServletRequest request, HttpServletResponse response, Lesson lesson) {
        LessonVideo lessonVideo = lessonVideoDAO.getByLessonId(lesson.getId());
        request.setAttribute("lessonVideo", lessonVideo);

    }

    private void getLessonQuiz(HttpServletRequest request, HttpServletResponse response, Lesson lesson) {
        LessonQuiz lessonQuiz = lessonQuizDAO.getByLessonId(lesson.getId());

        if (lessonQuiz == null) {
            request.setAttribute("errorMessage", "Quiz not found");
            return;
        }
        
        // Get list of questions
        List<Question> questions = questionDAO.getByLessonQuizId(lessonQuiz.getId());
        
        // Create a map to store questions and their answers
        Map<Question, List<QuizAnswer>> questionAnswersMap = new HashMap<>();
        
        // For each question, get its answers and add to the map
        for (Question question : questions) {
            List<QuizAnswer> answers = quizAnswerDAO.getByQuestionId(question.getId());
            questionAnswersMap.put(question, answers);
        }
        
        request.setAttribute("lessonQuiz", lessonQuiz);
        request.setAttribute("listQuestions", questions);
        request.setAttribute("questionAnswersMap", questionAnswersMap);
    }
}
