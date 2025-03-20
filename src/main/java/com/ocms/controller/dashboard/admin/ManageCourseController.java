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
import java.io.File;
import java.io.PrintWriter;
import jakarta.servlet.http.Part;
import jakarta.servlet.annotation.MultipartConfig;

@WebServlet({"/manage-course", "/lesson-edit"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 5, // 5MB
                 maxFileSize = 1024 * 1024 * 50,      // 50MB
                 maxRequestSize = 1024 * 1024 * 100)  // 100MB
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String action = request.getParameter("action");
        
        if (path.equals("/lesson-edit")) {
            if ("update".equals(action)) {
                doPostLessonUpdate(request, response);
            } else if ("upload".equals(action)) {
                doPostVideoUpload(request, response);
            }
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
            
            String url = request.getRequestURL().toString();
            String baseUrl = url.substring(0, url.lastIndexOf("/") + 1);
            // Get additional data based on lesson type
            switch (lesson.getType()) {
                case GlobalConfig.LESSON_TYPE_VIDEO:
                    getLessonVideoForEdit(request, response, lesson);
                    url = "view/dashboard/admin/lesson-detail-video.jsp";
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
            request.getRequestDispatcher(url).forward(request, response);
            
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
    private void doPostLessonUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get lesson ID and basic information
            Integer lessonId = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            Integer sectionId = Integer.parseInt(request.getParameter("sectionId"));
            Integer durationMinutes = 0;
            Integer orderNumber = 1;
            
            try {
                durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
            } catch (NumberFormatException e) {
                // Use default value if parsing fails
            }
            
            try {
                orderNumber = Integer.parseInt(request.getParameter("orderNumber"));
            } catch (NumberFormatException e) {
                // Use default value if parsing fails
            }
            
            String status = request.getParameter("status");
            
            // Get the lesson from database
            Lesson lesson = lessonDAO.getById(lessonId);
            
            if (lesson == null) {
                request.setAttribute("errorMessage", "Lesson not found");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Update lesson basic information
            lesson.setTitle(title);
            lesson.setDescription(description);
            lesson.setSectionId(sectionId);
            lesson.setDurationMinutes(durationMinutes);
            lesson.setOrderNumber(orderNumber);
            lesson.setStatus(status);
            
            // Update the lesson in database
            Boolean lessonUpdated = lessonDAO.update(lesson);
            
            if (!lessonUpdated) {
                request.setAttribute("errorMessage", "Failed to update lesson");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Handle video file upload
            String videoUrl = request.getParameter("videoUrl"); // Get existing URL if any
            
            // Check if there's a file upload
            Part filePart = request.getPart("videoFile");
            
            if (filePart != null && filePart.getSize() > 0) {
                // Process the uploaded file
                String fileName = getFileName(filePart);
                
                if (fileName != null && !fileName.isEmpty()) {
                    // Generate a unique filename
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    
                    // Create upload directory if it doesn't exist
                    String uploadPath = getServletContext().getRealPath("/uploads/videos/");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // Write the file to the server
                    String filePath = uploadPath + File.separator + uniqueFileName;
                    filePart.write(filePath);
                    
                    // Set the video URL
                    videoUrl = request.getContextPath() + "/uploads/videos/" + uniqueFileName;
                }
            }
            
            // Get existing video or create new one
            LessonVideo lessonVideo = lessonVideoDAO.getByLessonId(lessonId);
            
            if (lessonVideo == null) {
                lessonVideo = new LessonVideo();
                lessonVideo.setLessonId(lessonId);
            }
            
            // Update video information
            lessonVideo.setVideoProvider("local"); // Always set to local
            lessonVideo.setVideoUrl(videoUrl);
            
            // Try to parse video duration if provided
            String videoDurationStr = request.getParameter("videoDuration");
            if (videoDurationStr != null && !videoDurationStr.isEmpty()) {
                try {
                    Integer videoDuration = Integer.parseInt(videoDurationStr);
                    lessonVideo.setVideoDuration(videoDuration);
                } catch (NumberFormatException e) {
                    // Ignore if parsing fails
                }
            }
            
            // Update or insert video information
            Boolean videoUpdated;
            if (lessonVideoDAO.getByLessonId(lessonId) != null) {
                videoUpdated = lessonVideoDAO.update(lessonVideo);
            } else {
                Integer insertedId = lessonVideoDAO.insert(lessonVideo);
                videoUpdated = insertedId > 0;
            }
            
            if (!videoUpdated) {
                // Log the error but continue
                System.out.println("Warning: Failed to update video information");
            }
            
            // Add success message
            request.getSession().setAttribute("toastMessage", "Lesson updated successfully");
            request.getSession().setAttribute("toastType", "success");
            
            // Redirect back to course content
            Section section = sectionDAO.getById(sectionId);
            response.sendRedirect(request.getContextPath() + "/manage-course?action=manage&id=" + section.getCourseId());
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating lesson: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    /**
     * Handle video file upload using Part API
     * @param request The HTTP request
     * @param response The HTTP response
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void doPostVideoUpload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        // Create JSON response object manually
        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("{");
        
        try {
            // Get the file part from the request
            Part filePart = request.getPart("videoFile");
            
            if (filePart == null) {
                jsonResponse.append("\"success\": false,");
                jsonResponse.append("\"message\": \"No file found in the request\"");
                jsonResponse.append("}");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Get file name from part
            String fileName = getFileName(filePart);
            
            if (fileName == null || fileName.isEmpty()) {
                jsonResponse.append("\"success\": false,");
                jsonResponse.append("\"message\": \"Invalid file name\"");
                jsonResponse.append("}");
                out.print(jsonResponse.toString());
                return;
            }
            
            // Generate a unique filename to prevent overwriting
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            
            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("/uploads/videos/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Write the file to the server
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            // Return the file URL
            String fileUrl = request.getContextPath() + "/uploads/videos/" + uniqueFileName;
            
            jsonResponse.append("\"success\": true,");
            jsonResponse.append("\"fileUrl\": \"").append(fileUrl).append("\",");
            jsonResponse.append("\"fileName\": \"").append(uniqueFileName).append("\"");
            
        } catch (Exception e) {
            jsonResponse.append("\"success\": false,");
            jsonResponse.append("\"message\": \"Error uploading file: ").append(e.getMessage()).append("\"");
            e.printStackTrace();
        }
        
        jsonResponse.append("}");
        out.print(jsonResponse.toString());
    }

    /**
     * Extract filename from Part header
     * @param part The Part containing the file
     * @return The filename
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");
        
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                return element.substring(element.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        
        return null;
    }
}
