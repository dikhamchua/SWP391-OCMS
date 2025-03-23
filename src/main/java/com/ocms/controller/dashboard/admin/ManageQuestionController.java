package com.ocms.controller.dashboard.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.ocms.dal.CourseDAO;
import com.ocms.dal.SectionDAO;
import com.ocms.dal.LessonDAO;
import com.ocms.dal.LessonQuizDAO;
import com.ocms.dal.QuestionDAO;
import com.ocms.dal.QuizAnswerDAO;
import com.ocms.entity.Course;
import com.ocms.entity.Section;
import com.ocms.entity.Lesson;
import com.ocms.entity.LessonQuiz;
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
            case "edit":
                // editQuiz(request, response);
                break;
            case "delete":
                // deleteQuiz(request, response);
                break;
            case "editQuestion":
                // editQuestion(request, response);
                break;
            case "newQuestion":
                // newQuestion(request, response);
                break;
            case "listQuestions":
                listQuestions(request, response);
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
            case "update":
                // updateQuiz(request, response);
                break;
            case "saveQuestion":
                // saveQuestion(request, response);
                break;
            default:
                listQuizzes(request, response);
                break;
        }
    }
    
    private void listQuizzes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String courseId = request.getParameter("courseId");
        String sectionId = request.getParameter("sectionId");
        String search = request.getParameter("search");
        
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
        int totalQuizzes = lessonQuizDAO.countQuizzes(courseId, sectionId, search);
        int totalPages = (int) Math.ceil((double) totalQuizzes / pageSize);
        
        // Ensure current page is within valid range
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        
        // Calculate start and end record for display
        int startRecord = (page - 1) * pageSize + 1;
        int endRecord = Math.min(page * pageSize, totalQuizzes);
        
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
        
        // Get quizzes for current page
        List<Map<String, Object>> quizList = lessonQuizDAO.getQuizzesPaginated(
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
        request.setAttribute("quizList", quizList);
        request.setAttribute("courseList", courseList);
        request.setAttribute("sectionList", sectionList);
        request.setAttribute("totalQuizzes", totalQuizzes);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startRecord", startRecord);
        request.setAttribute("endRecord", endRecord);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        
        // Forward to the view
        request.getRequestDispatcher("/view/dashboard/admin/quiz/quiz_list.jsp")
               .forward(request, response);
    }
    
    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            
            
            // Get questions for this quiz
            List<Question> questionsList = questionDAO.findAll();
            
            // Get answers for each question
            // Map<Question, List<QuizAnswer>> questionAnswersMap = new HashMap<>();
            // for (Question question : questionsList) {
            //     List<QuizAnswer> answers = quizAnswerDAO.getByQuestionId(question.getId());
            //     questionAnswersMap.put(question, answers);
            // }
            
            // Set attributes for JSP
            request.setAttribute("questionsList", questionsList);
            // request.setAttribute("questionAnswersMap", questionAnswersMap);
            request.setAttribute("courseDAO", courseDAO);
            request.setAttribute("sectionDAO", sectionDAO);
            request.setAttribute("lessonQuizDAO", lessonQuizDAO);
            
            // Forward to question list JSP
            request.getRequestDispatcher("/view/dashboard/admin/question/question_list.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid quiz ID");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-question");
        }
    }
} 