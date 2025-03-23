package com.ocms.controller.dashboard.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import com.ocms.dal.CourseDAO;
import com.ocms.dal.SectionDAO;
import com.ocms.dal.LessonDAO;
import com.ocms.dal.LessonQuizDAO;
import com.ocms.dal.QuestionDAO;
import com.ocms.dal.QuizAnswerDAO;
import com.ocms.entity.Course;
import com.ocms.entity.Section;
import com.ocms.entity.Question;
import com.ocms.entity.QuizAnswer;

@WebServlet(name = "ManageQuestionController", urlPatterns = {"/manage-question"})
public class ManageQuestionController extends HttpServlet {
    
    private CourseDAO courseDAO;
    private SectionDAO sectionDAO;
    private LessonDAO lessonDAO;
    private LessonQuizDAO lessonQuizDAO;
    private QuestionDAO questionDAO;
    private QuizAnswerDAO quizAnswerDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
        sectionDAO = new SectionDAO();
        lessonDAO = new LessonDAO();
        lessonQuizDAO = new LessonQuizDAO();
        questionDAO = new QuestionDAO();
        quizAnswerDAO = new QuizAnswerDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listQuestions(request, response);
                break;
            case "viewQuestion":
                editQuestion(request, response);
                break;
            case "delete":
                deleteQuestion(request, response);
                break;
            case "new":
                newQuestion(request, response);
                break;
            default:
                listQuestions(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "save":
                saveQuestion(request, response);
                break;
            default:
                listQuestions(request, response);
                break;
        }
    }
    
    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String courseId = request.getParameter("courseId");
        String sectionId = request.getParameter("sectionId");
        String search = request.getParameter("search");
        if (search != null && !search.isEmpty()) {
            search = search.trim();
        }
        
        // Handle column selection
        String[] selectedColumns = request.getParameterValues("columns");
        if (selectedColumns != null) {
            request.getSession().setAttribute("selectedColumns", selectedColumns);
        } else if (request.getSession().getAttribute("selectedColumns") != null) {
            selectedColumns = (String[]) request.getSession().getAttribute("selectedColumns");
        }
        request.setAttribute("selectedColumns", selectedColumns);
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        String pageSizeStr = request.getParameter("pageSize");
        if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeStr);
                if (pageSize < 1) pageSize = 10;
            } catch (NumberFormatException e) {
                pageSize = 10;
            }
        }
        
        // Calculate pagination values
        int totalQuestions = questionDAO.countQuestions(courseId, sectionId, search);
        int totalPages = (int) Math.ceil((double) totalQuestions / pageSize);
        
        // Ensure current page is within valid range
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        
        // Calculate start and end record for display
        int startRecord = (page - 1) * pageSize + 1;
        int endRecord = Math.min(page * pageSize, totalQuestions);
        
        // Calculate pagination range (show 5 pages at most)
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        
        // Adjust if we're near the start or end
        if (startPage <= 3) {
            endPage = Math.min(5, totalPages);
        }
        
        if (endPage >= totalPages - 2) {
            startPage = Math.max(1, totalPages - 4);
        }
        
        // Get questions for current page
        List<Question> questionsList = questionDAO.getQuestionsPaginated(
                courseId, sectionId, search, page, pageSize);
        
        // Get all courses for filter dropdown
        List<Course> courseList = courseDAO.findAll();
        
        // Get sections for selected course
        List<Section> sectionList = null;
        if (courseId != null && !courseId.isEmpty()) {
            try {
                int courseIdInt = Integer.parseInt(courseId);
                sectionList = sectionDAO.getByCourseId(courseIdInt);
            } catch (NumberFormatException e) {
                // Invalid course ID, ignore
            }
        }
        
        // Set attributes for the view
        request.setAttribute("questionsList", questionsList);
        request.setAttribute("courseList", courseList);
        request.setAttribute("sectionList", sectionList);
        request.setAttribute("totalQuestions", totalQuestions);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startRecord", startRecord);
        request.setAttribute("endRecord", endRecord);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("search", search);
        request.setAttribute("courseId", courseId);
        request.setAttribute("sectionId", sectionId);
        request.setAttribute("courseDAO", courseDAO);
        request.setAttribute("sectionDAO", sectionDAO);
        
        // Forward to the view
        request.getRequestDispatcher("/view/dashboard/admin/question/question_list.jsp")
               .forward(request, response);
    }
    
    private void editQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String questionId = request.getParameter("questionId");
        
        if (questionId == null || questionId.isEmpty()) {
            request.getSession().setAttribute("toastMessage", "Question ID is required");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-question");
            return;
        }
        
        try {
            int questionIdInt = Integer.parseInt(questionId);
            Question question = questionDAO.getById(questionIdInt);
            
            if (question == null) {
                request.getSession().setAttribute("toastMessage", "Question not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/manage-question");
                return;
            }
            
            // Get answers for this question
            List<QuizAnswer> answers = quizAnswerDAO.getByQuestionId(questionIdInt);
            
            // Set attributes for JSP
            request.setAttribute("question", question);
            request.setAttribute("answers", answers);
            
            // Forward to question editor JSP
            request.getRequestDispatcher("/view/dashboard/admin/quiz/question_editor.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid question ID");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-question");
        }
    }
    
    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String questionId = request.getParameter("id");
        
        if (questionId == null || questionId.isEmpty()) {
            request.getSession().setAttribute("toastMessage", "Question ID is required");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-question");
            return;
        }
        
        try {
            int questionIdInt = Integer.parseInt(questionId);
            
            // Delete answers first
            // quizAnswerDAO.deleteByQuestionId(questionIdInt);
            
            // Then delete question
            // questionDAO.delete(questionIdInt);
            
            request.getSession().setAttribute("toastMessage", "Question deleted successfully");
            request.getSession().setAttribute("toastType", "success");
            
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error deleting question: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/manage-question");
    }
    
    private void newQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Create empty question object for the form
        Question question = new Question();
        question.setId(0); // Indicate this is a new question
        
        // Set attributes for JSP
        request.setAttribute("question", question);
        request.setAttribute("answers", new ArrayList<QuizAnswer>());
        
        // Forward to question editor JSP
        request.getRequestDispatcher("/view/dashboard/admin/quiz/question_editor.jsp").forward(request, response);
    }
    
    private void saveQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String questionId = request.getParameter("questionId");
        String questionText = request.getParameter("questionText");
        String explanation = request.getParameter("explanation");
        String correctAnswerStr = request.getParameter("correctAnswer");
        
        if (questionText == null || questionText.isEmpty()) {
            request.getSession().setAttribute("toastMessage", "Question text is required");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-question");
            return;
        }
        
        try {
            int questionIdInt = Integer.parseInt(questionId);
            int correctAnswer = Integer.parseInt(correctAnswerStr);
            
            // Get or create question
            Question question;
            boolean isNewQuestion = questionIdInt == 0;
            
            if (isNewQuestion) {
                // Create new question
                question = new Question();
                question.setStatus("active");
            } else {
                // Get existing question
                question = questionDAO.getById(questionIdInt);
                if (question == null) {
                    throw new Exception("Question not found");
                }
            }
            
            // Update question fields
            question.setQuestionText(questionText);
            if (explanation != null && !explanation.isEmpty()) {
                // question.setExplanation(explanation);
            }
            
            // Save question
            if (isNewQuestion) {
                // questionIdInt = questionDAO.create(question);
                question.setId(questionIdInt);
            } else {
                questionDAO.update(question);
            }
            
            // Get the total number of answers from the form
            String answerCountStr = request.getParameter("answerCount");
            int answerCount = 4; // Default to 4 if not specified
            
            if (answerCountStr != null && !answerCountStr.isEmpty()) {
                try {
                    answerCount = Integer.parseInt(answerCountStr);
                } catch (NumberFormatException e) {
                    // Use default if parsing fails
                }
            }
            
            // Process answers
            for (int i = 1; i <= answerCount; i++) {
                String answerText = request.getParameter("answerText_" + i);
                String answerIdStr = request.getParameter("answerId_" + i);
                
                // Skip if this answer doesn't exist in the form
                if (answerText == null || answerIdStr == null) {
                    continue;
                }
                
                if (answerText != null && !answerText.isEmpty()) {
                    int answerId = Integer.parseInt(answerIdStr);
                    boolean isCorrect = i == correctAnswer;
                    
                    QuizAnswer answer;
                    if (answerId == 0) {
                        // Create new answer
                        answer = new QuizAnswer();
                        answer.setQuestionId(questionIdInt);
                    } else {
                        // Get existing answer
                        answer = quizAnswerDAO.getById(answerId);
                        if (answer == null) {
                            // If answer not found, create a new one
                            answer = new QuizAnswer();
                            answer.setQuestionId(questionIdInt);
                        }
                    }
                    
                    // Update answer fields
                    answer.setAnswerText(answerText);
                    answer.setIsCorrect(isCorrect);
                    
                    // Save answer
                    if (answerId == 0) {
                        // quizAnswerDAO.create(answer);
                    } else {
                        quizAnswerDAO.update(answer);
                    }
                }
            }
            
            request.getSession().setAttribute("toastMessage", "Question saved successfully");
            request.getSession().setAttribute("toastType", "success");
            
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error saving question: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/manage-question");
    }
} 