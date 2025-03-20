package com.ocms.controller.dashboard.admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import java.io.IOException;
import com.ocms.dal.*;
import com.ocms.entity.*;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import com.ocms.config.GlobalConfig;

@WebServlet({"/manage-course", "/lesson-edit"})
public class ManageCourseController extends HttpServlet {
    

    private CourseDAO courseDAO;
    private SectionDAO sectionDAO;
    private LessonDAO lessonDAO;
    private LessonVideoDAO lessonVideoDAO;
    private LessonQuizDAO lessonQuizDAO;
    private QuestionDAO questionDAO;
    private QuizAnswerDAO quizAnswerDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        sectionDAO = new SectionDAO();
        lessonDAO = new LessonDAO();
        lessonVideoDAO = new LessonVideoDAO();
        lessonQuizDAO = new LessonQuizDAO();
        questionDAO = new QuestionDAO();
        quizAnswerDAO = new QuizAnswerDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/manage-course":
                doGetManageCourse(request, response);
                break;
            case "/lesson-edit":
                doGetLessonEdit(request, response);
                break;
        }
    }


    private void doGetManageCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //get id of course
        String id = request.getParameter("id");
        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/manage-course");
            return;
        }
        int courseId = Integer.parseInt(id);

        //get course by id
        Course course = courseDAO.findById(courseId);
        //get sections by course id
        List<Section> sections = sectionDAO.getByCourseId(courseId);
        //get lessons by section id
        List<Lesson> lessons = lessonDAO.getBySectionId(sections.get(0).getId());
        
        //hashmap to store lessons by section id
        Map<Integer, List<Lesson>> lessonsBySectionId = new HashMap<>();
        for (Section section : sections) {
            lessonsBySectionId.put(section.getId(), lessonDAO.getBySectionId(section.getId()));
        }

        request.setAttribute("course", course);
        request.setAttribute("sections", sections);
        request.setAttribute("lessonsBySectionId", lessonsBySectionId);
        request.getRequestDispatcher("/view/dashboard/admin/course-content.jsp").forward(request, response);
    }
    
    /**
     * Handle GET request for editing a lesson
     * @param request The HTTP request
     * @param response The HTTP response
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void doGetLessonEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get lesson ID from request parameters
            String lessonIdParam = request.getParameter("id");
            
            if (lessonIdParam == null || lessonIdParam.isEmpty()) {
                // If no lesson ID is provided, redirect to course management
                response.sendRedirect(request.getContextPath() + "/manage-course");
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
            
            if (section == null) {
                // If section not found, show error
                request.setAttribute("errorMessage", "Section not found for this lesson");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Get course information
            Course course = courseDAO.findById(section.getCourseId());
            
            // Set attributes for the view
            request.setAttribute("lesson", lesson);
            request.setAttribute("section", section);
            request.setAttribute("course", course);
            
            // Get additional data based on lesson type
            switch (lesson.getType()) {
                case GlobalConfig.LESSON_TYPE_VIDEO:
                    getLessonVideoForEdit(request, response, lesson);
                    break;
                case GlobalConfig.LESSON_TYPE_QUIZ:
                    getLessonQuizForEdit(request, response, lesson);
                    break;
                case GlobalConfig.LESSON_TYPE_FILE:
                    // Get file information if needed
                    break;
                case GlobalConfig.LESSON_TYPE_DOCUMENT:
                    // Get document information if needed
                    break;
                case GlobalConfig.LESSON_TYPE_TEXT:
                    // Get text information if needed
                    break;
            }
            
            // Get all sections for the course for the dropdown
            List<Section> sections = sectionDAO.getByCourseId(course.getId());
            request.setAttribute("sections", sections);
            
            // Forward to the edit view
            request.getRequestDispatcher("/view/dashboard/admin/edit-lesson.jsp").forward(request, response);
            
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
     * Get video information for a lesson
     * @param request The HTTP request
     * @param response The HTTP response
     * @param lesson The lesson object
     */
    private void getLessonVideoForEdit(HttpServletRequest request, HttpServletResponse response, Lesson lesson) {
        LessonVideo lessonVideo = lessonVideoDAO.getByLessonId(lesson.getId());
        request.setAttribute("lessonVideo", lessonVideo);
    }

    /**
     * Get quiz information for a lesson
     * @param request The HTTP request
     * @param response The HTTP response
     * @param lesson The lesson object
     */
    private void getLessonQuizForEdit(HttpServletRequest request, HttpServletResponse response, Lesson lesson) {
        // Get quiz information
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
        request.setAttribute("questions", questions);
        request.setAttribute("questionAnswersMap", questionAnswersMap);
    }

    /**
     * Handle POST request for updating a lesson
     * @param request The HTTP request
     * @param response The HTTP response
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void doPostLessonEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get lesson ID from request parameters
            String lessonIdParam = request.getParameter("id");
            
            if (lessonIdParam == null || lessonIdParam.isEmpty()) {
                // If no lesson ID is provided, redirect to course management
                response.sendRedirect(request.getContextPath() + "/manage-course");
                return;
            }
            
            int lessonId = Integer.parseInt(lessonIdParam);
            
            // Get existing lesson
            Lesson lesson = lessonDAO.getById(lessonId);
            
            if (lesson == null) {
                // If lesson not found, show error
                request.setAttribute("errorMessage", "Lesson not found");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Update basic lesson information
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String sectionIdParam = request.getParameter("sectionId");
            String orderNumberParam = request.getParameter("orderNumber");
            String status = request.getParameter("status");
            
            if (title == null || title.trim().isEmpty() || 
                sectionIdParam == null || sectionIdParam.trim().isEmpty()) {
                // Required fields are missing
                request.setAttribute("errorMessage", "Title and section are required");
                doGetLessonEdit(request, response); // Redisplay the form with error
                return;
            }
            
            int sectionId = Integer.parseInt(sectionIdParam);
            int orderNumber = orderNumberParam != null && !orderNumberParam.trim().isEmpty() ? 
                              Integer.parseInt(orderNumberParam) : 1;
            
            // Update lesson object
            lesson.setTitle(title);
            lesson.setDescription(description);
            lesson.setSectionId(sectionId);
            lesson.setOrderNumber(orderNumber);
            lesson.setStatus(status != null ? status : "active");
            
            // Update lesson in database
            boolean updated = lessonDAO.update(lesson);
            
            if (!updated) {
                // If update failed, show error
                request.setAttribute("errorMessage", "Failed to update lesson");
                doGetLessonEdit(request, response); // Redisplay the form with error
                return;
            }
            
            // Update type-specific information
            switch (lesson.getType()) {
                case GlobalConfig.LESSON_TYPE_VIDEO:
                    updateLessonVideo(request, response, lesson);
                    break;
                case GlobalConfig.LESSON_TYPE_QUIZ:
                    updateLessonQuiz(request, response, lesson);
                    break;
                case GlobalConfig.LESSON_TYPE_FILE:
                    // Update file information if needed
                    break;
                case GlobalConfig.LESSON_TYPE_DOCUMENT:
                    // Update document information if needed
                    break;
                case GlobalConfig.LESSON_TYPE_TEXT:
                    // Update text information if needed
                    break;
            }
            
            // Add success message to session
            request.getSession().setAttribute("toastMessage", "Lesson updated successfully");
            request.getSession().setAttribute("toastType", "success");
            
            // Get section to redirect back to course content
            Section section = sectionDAO.getById(lesson.getSectionId());
            
            // Redirect to course content page
            response.sendRedirect(request.getContextPath() + "/manage-course?action=manage&id=" + section.getCourseId());
            
        } catch (NumberFormatException e) {
            // Handle invalid number format
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle other exceptions
            request.setAttribute("errorMessage", "Error updating lesson: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    /**
     * Update video information for a lesson
     * @param request The HTTP request
     * @param response The HTTP response
     * @param lesson The lesson object
     */
    private void updateLessonVideo(HttpServletRequest request, HttpServletResponse response, Lesson lesson) throws ServletException, IOException {
        String videoUrl = request.getParameter("videoUrl");
        String duration = request.getParameter("duration");
        
        if (videoUrl == null || videoUrl.trim().isEmpty()) {
            // Video URL is required
            request.setAttribute("errorMessage", "Video URL is required");
            doGetLessonEdit(request, response); // Redisplay the form with error
            return;
        }
        
        // Get existing video or create new one
        LessonVideo lessonVideo = lessonVideoDAO.getByLessonId(lesson.getId());
        
        if (lessonVideo == null) {
            lessonVideo = new LessonVideo();
            lessonVideo.setLessonId(lesson.getId());
        }
        
        lessonVideo.setVideoUrl(videoUrl);
        // lessonVideo.setDuration(duration);
        
        // Update or insert video
        // if (lessonVideo.getId() != null) {
        //     lessonVideoDAO.update(lessonVideo);
        // } else {
        //     lessonVideoDAO.insert(lessonVideo);
        // }
    }

    /**
     * Update quiz information for a lesson
     * @param request The HTTP request
     * @param response The HTTP response
     * @param lesson The lesson object
     */
    private void updateLessonQuiz(HttpServletRequest request, HttpServletResponse response, Lesson lesson) throws ServletException, IOException {
        String passPercentageParam = request.getParameter("passPercentage");
        String timeLimitParam = request.getParameter("timeLimit");
        String attemptsAllowedParam = request.getParameter("attemptsAllowed");
        
        // Get existing quiz or create new one
        LessonQuiz lessonQuiz = lessonQuizDAO.getByLessonId(lesson.getId());
        
        if (lessonQuiz == null) {
            lessonQuiz = new LessonQuiz();
            lessonQuiz.setLessonId(lesson.getId());
        }
        
        // Update quiz properties
        if (passPercentageParam != null && !passPercentageParam.trim().isEmpty()) {
            lessonQuiz.setPassPercentage(Integer.parseInt(passPercentageParam));
        }
        
        if (timeLimitParam != null && !timeLimitParam.trim().isEmpty()) {
            // lessonQuiz.setTimeLimit(Integer.parseInt(timeLimitParam));
        }
        
        if (attemptsAllowedParam != null && !attemptsAllowedParam.trim().isEmpty()) {
            lessonQuiz.setAttemptsAllowed(Integer.parseInt(attemptsAllowedParam));
        }
        
        // Update or insert quiz
        if (lessonQuiz.getId() != null) {
            lessonQuizDAO.update(lessonQuiz);
        } else {
            lessonQuizDAO.insert(lessonQuiz);
        }
        
        // Note: Updating questions and answers would be more complex
        // and would likely require a separate controller or method
    }
}
