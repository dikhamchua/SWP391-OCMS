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
    private QuizQuestionDAO quizQuestionDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        sectionDAO = new SectionDAO();
        lessonDAO = new LessonDAO();
        lessonVideoDAO = new LessonVideoDAO();
        lessonQuizDAO = new LessonQuizDAO();
        questionDAO = new QuestionDAO();
        quizAnswerDAO = new QuizAnswerDAO();
        quizQuestionDAO = new QuizQuestionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String action = request.getParameter("action");
        
        switch (path) {
            case "/manage-course":
                doGetManageCourse(request, response);
                break;
            case "/lesson-edit":
                if ("add".equals(action)) {
                    doGetLessonAdd(request, response);
                } else {
                    doGetLessonEdit(request, response);
                }
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
            } else if ("add".equals(action)) {
                doPostLessonAdd(request, response);
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
        // List<Lesson> lessons = lessonDAO.getBySectionId(sections.get(0).getId());
        
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
            // String baseUrl = url.substring(0, url.lastIndexOf("/") + 1);
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
     * Get quiz data for editing
     * @param request The HTTP request
     * @param response The HTTP response
     * @param lesson The lesson object
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void getLessonQuizForEdit(HttpServletRequest request, HttpServletResponse response, Lesson lesson) throws ServletException, IOException {
        // Get quiz information
        LessonQuiz quiz = lessonQuizDAO.getByLessonId(lesson.getId());
        
        if (quiz != null) {
            // Get questions for this quiz
            List<QuizQuestion> questions = quizQuestionDAO.getByQuizId(quiz.getId());
            
            // Get answers for each question
            Map<Integer, List<QuizAnswer>> answersByQuestionId = new HashMap<>();
            for (QuizQuestion question : questions) {
                List<QuizAnswer> answers = quizAnswerDAO.getByQuestionId(question.getId());
                answersByQuestionId.put(question.getId(), answers);
            }
            
            // Set attributes for the view
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.setAttribute("answersByQuestionId", answersByQuestionId);
        }
        
        // Forward to the quiz edit page
        request.getRequestDispatcher("view/dashboard/admin/lesson-detail-quiz.jsp").forward(request, response);
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

    /**
     * Handle GET request for adding a new lesson
     * @param request The HTTP request
     * @param response The HTTP response
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void doGetLessonAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get course ID from request parameters
            String courseIdParam = request.getParameter("courseId");
            String type = request.getParameter("type");
            
            if (courseIdParam == null || courseIdParam.isEmpty()) {
                // If no course ID is provided, redirect to course management
                response.sendRedirect(request.getContextPath() + "/manage-course");
                return;
            }
            
            Integer courseId = Integer.parseInt(courseIdParam);
            
            // Get course information
            Course course = courseDAO.findById(courseId);
            
            if (course == null) {
                // If course not found, show error
                request.setAttribute("errorMessage", "Course not found");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Get all sections for the course for the dropdown
            List<Section> sections = sectionDAO.getByCourseId(courseId);
            
            if (sections.isEmpty()) {
                // If no sections found, redirect to course management with message
                request.getSession().setAttribute("toastMessage", "Please add a section before adding lessons");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/manage-course?action=manage&id=" + courseId);
                return;
            }
            
            // Set attributes for the view
            request.setAttribute("course", course);
            request.setAttribute("sections", sections);
            
            // Determine which view to forward to based on lesson type
            String url = "view/dashboard/admin/lesson-add-video.jsp";
            if (type != null) {
                switch (type) {
                    case GlobalConfig.LESSON_TYPE_VIDEO:
                        url = "view/dashboard/admin/lesson-add-video.jsp";
                        break;
                    case GlobalConfig.LESSON_TYPE_QUIZ:
                        url = "view/dashboard/admin/lesson-add-quiz.jsp";
                        break;
                    // Add other types as needed
                }
            }
            
            // Forward to the add view
            request.getRequestDispatcher(url).forward(request, response);
            
        } catch (NumberFormatException e) {
            // Handle invalid course ID format
            request.setAttribute("errorMessage", "Invalid course ID format");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle other exceptions
            request.setAttribute("errorMessage", "Error loading course: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    /**
     * Handle POST request for adding a new lesson
     * @param request The HTTP request
     * @param response The HTTP response
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void doPostLessonAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get basic lesson information from form
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            Integer sectionId = Integer.parseInt(request.getParameter("sectionId"));
            String type = request.getParameter("type");
            Integer durationMinutes = 0;
            
            try {
                durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
            } catch (NumberFormatException e) {
                // Use default value if parsing fails
            }
            
            String status = request.getParameter("status");
            
            // Get the next available order number for this section
            Integer orderNumber = getNextOrderNumber(sectionId);
            
            // Create new lesson object
            Lesson lesson = new Lesson();
            lesson.setTitle(title);
            lesson.setDescription(description);
            lesson.setSectionId(sectionId);
            lesson.setType(type);
            lesson.setDurationMinutes(durationMinutes);
            lesson.setOrderNumber(orderNumber);
            lesson.setStatus(status);
            
            // Set creation and modification dates
            java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());
            lesson.setCreatedDate(currentDate);
            lesson.setModifiedDate(currentDate);
            
            // Insert the lesson into database
            Integer lessonId = lessonDAO.insert(lesson);
            
            if (lessonId <= 0) {
                request.setAttribute("errorMessage", "Failed to add lesson");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Handle type-specific data
            if (GlobalConfig.LESSON_TYPE_VIDEO.equals(type)) {
                // Handle video file upload
                String videoUrl = null;
                
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
                
                // Create new lesson video object
                LessonVideo lessonVideo = new LessonVideo();
                lessonVideo.setLessonId(lessonId);
                lessonVideo.setVideoProvider("local");
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
                
                // Insert video information
                Integer videoInserted = lessonVideoDAO.insert(lessonVideo);
                
                if (videoInserted <= 0) {
                    // Log the error but continue
                    System.out.println("Warning: Failed to add video information");
                }
            } else if (GlobalConfig.LESSON_TYPE_QUIZ.equals(type)) {
                // Handle quiz data
                Integer passingScore = 70; // Default value
                Integer attemptsAllowed = 3; // Default value
                try {
                    passingScore = Integer.parseInt(request.getParameter("passingScore"));
                    attemptsAllowed = Integer.parseInt(request.getParameter("attemptsAllowed"));
                } catch (NumberFormatException e) {
                    // Use default values if parsing fails
                }
                
                // Create new quiz object
                LessonQuiz quiz = new LessonQuiz();
                quiz.setLessonId(lessonId);
                quiz.setPassPercentage(passingScore);
                quiz.setTimeLimitMinutes(durationMinutes);
                quiz.setAttemptsAllowed(attemptsAllowed);
                
                // Insert quiz into database
                Integer quizId = lessonQuizDAO.insert(quiz);
                
                if (quizId <= 0) {
                    // Log the error but continue
                    System.out.println("Warning: Failed to add quiz information");
                } else {
                    // Get the number of questions
                    Integer questionCount = Integer.parseInt(request.getParameter("questionCount"));
                    
                    // Process each question
                    for (int i = 1; i <= questionCount; i++) {
                        String questionText = request.getParameter("question_text_" + i);
                        String correctAnswerStr = request.getParameter("correct_answer_" + i);
                        
                        if (questionText == null || correctAnswerStr == null) {
                            System.out.println("Warning: Missing data for question " + i);
                            continue;
                        }
                        
                        Integer correctAnswerIndex = Integer.parseInt(correctAnswerStr);
                        
                        // Create new question
                        QuizQuestion quizQuestion = new QuizQuestion();
                        quizQuestion.setQuizId(quizId);
                        quizQuestion.setQuestionText(questionText);
                        quizQuestion.setOrderNumber(i);
                        quizQuestion.setPoints(1); // Default points value
                        quizQuestion.setStatus("active");
                        
                        // Insert question into database
                        Integer questionId = quizQuestionDAO.insert(quizQuestion);
                        
                        if (questionId <= 0) {
                            // Log the error but continue
                            System.out.println("Warning: Failed to add question " + i);
                            continue;
                        }
                        
                        // Process each answer for this question
                        for (int j = 1; j <= 4; j++) {
                            String answerText = request.getParameter("answer_text_" + i + "_" + j);
                            
                            if (answerText == null) {
                                System.out.println("Warning: Missing answer text for question " + i + ", answer " + j);
                                continue;
                            }
                            
                            Boolean isCorrect = (j == correctAnswerIndex);
                            
                            // Create new answer
                            QuizAnswer answer = new QuizAnswer();
                            answer.setQuestionId(questionId);
                            answer.setAnswerText(answerText);
                            answer.setIsCorrect(isCorrect);
                            answer.setOrderNumber(j);
                            
                            // Insert answer into database
                            Integer answerId = quizAnswerDAO.insert(answer);
                            
                            if (answerId <= 0) {
                                // Log the error but continue
                                System.out.println("Warning: Failed to add answer " + j + " for question " + i);
                            }
                        }
                    }
                }
            }
            
            // Add success message
            request.getSession().setAttribute("toastMessage", "Lesson added successfully");
            request.getSession().setAttribute("toastType", "success");
            
            // Get course ID from section
            Section section = sectionDAO.getById(sectionId);
            Integer courseId = section.getCourseId();
            
            // Redirect back to course content
            response.sendRedirect(request.getContextPath() + "/manage-course?action=manage&id=" + courseId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error adding lesson: " + e.getMessage());
            e.printStackTrace();
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    /**
     * Get the next available order number for a section
     * @param sectionId The section ID
     * @return The next available order number
     */
    private Integer getNextOrderNumber(Integer sectionId) {
        List<Lesson> lessons = lessonDAO.getBySectionId(sectionId);
        
        if (lessons.isEmpty()) {
            return 1; // If no lessons exist, start with 1
        }
        
        // Find the maximum order number
        Integer maxOrderNumber = 0;
        for (Lesson lesson : lessons) {
            if (lesson.getOrderNumber() > maxOrderNumber) {
                maxOrderNumber = lesson.getOrderNumber();
            }
        }
        
        // Return the next order number
        return maxOrderNumber + 1;
    }
}
