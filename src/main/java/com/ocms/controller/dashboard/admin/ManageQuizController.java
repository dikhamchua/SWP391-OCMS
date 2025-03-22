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

@WebServlet(name = "ManageQuizController", urlPatterns = {"/manage-quiz"})
public class ManageQuizController extends HttpServlet {
    
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
                listQuizzes(request, response);
                break;
            case "view":
                viewQuiz(request, response);
                break;
            case "edit":
                editQuiz(request, response);
                break;
            case "delete":
                deleteQuiz(request, response);
                break;
            default:
                listQuizzes(request, response);
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
                updateQuiz(request, response);
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
    
    private void viewQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String lessonId = request.getParameter("id");
        
        if (lessonId == null || lessonId.isEmpty()) {
            request.getSession().setAttribute("toastMessage", "Quiz ID is required");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-quiz");
            return;
        }
        
        try {
            int lessonIdInt = Integer.parseInt(lessonId);
            Lesson lesson = lessonDAO.getById(lessonIdInt);
            
            if (lesson == null || !"quiz".equals(lesson.getType())) {
                request.getSession().setAttribute("toastMessage", "Quiz not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/manage-quiz");
                return;
            }
            
            // Get section and course info
            Section section = sectionDAO.getById(lesson.getSectionId());
            Course course = null;
            if (section != null) {
                course = courseDAO.findById(section.getCourseId());
            }
            
            // Get quiz details
            LessonQuiz quiz = lessonQuizDAO.getByLessonId(lessonIdInt);
            
            if (quiz == null) {
                request.getSession().setAttribute("toastMessage", "Quiz details not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/manage-quiz");
                return;
            }
            
            // Get questions and answers
            List<Question> questions = questionDAO.getByLessonQuizId(quiz.getId());
            Map<Question, List<QuizAnswer>> questionAnswersMap = new HashMap<>();
            
            for (Question question : questions) {
                List<QuizAnswer> answers = quizAnswerDAO.getByQuestionId(question.getId());
                questionAnswersMap.put(question, answers);
            }
            
            // Set attributes for JSP
            request.setAttribute("lesson", lesson);
            request.setAttribute("section", section);
            request.setAttribute("course", course);
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.setAttribute("questionAnswersMap", questionAnswersMap);
            
            // Forward to JSP
            request.getRequestDispatcher("/view/dashboard/admin/quiz_view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid quiz ID");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-quiz");
        }
    }
    
    private void editQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Similar to viewQuiz but forward to edit page
        String lessonId = request.getParameter("id");
        
        if (lessonId == null || lessonId.isEmpty()) {
            request.getSession().setAttribute("toastMessage", "Quiz ID is required");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-quiz");
            return;
        }
        
        try {
            int lessonIdInt = Integer.parseInt(lessonId);
            Lesson lesson = lessonDAO.getById(lessonIdInt);
            
            if (lesson == null || !"quiz".equals(lesson.getType())) {
                request.getSession().setAttribute("toastMessage", "Quiz not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/manage-quiz");
                return;
            }
            
            // Get section and course info
            Section section = sectionDAO.getById(lesson.getSectionId());
            Course course = null;
            if (section != null) {
                course = courseDAO.findById(section.getCourseId());
            }
            
            // Get quiz details
            LessonQuiz quiz = lessonQuizDAO.getByLessonId(lessonIdInt);
            
            if (quiz == null) {
                request.getSession().setAttribute("toastMessage", "Quiz details not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/manage-quiz");
                return;
            }
            
            // Get questions and answers
            List<Question> questions = questionDAO.getByLessonQuizId(quiz.getId());
            Map<Question, List<QuizAnswer>> questionAnswersMap = new HashMap<>();
            
            for (Question question : questions) {
                List<QuizAnswer> answers = quizAnswerDAO.getByQuestionId(question.getId());
                questionAnswersMap.put(question, answers);
            }
            
            // Set attributes for JSP
            request.setAttribute("lesson", lesson);
            request.setAttribute("section", section);
            request.setAttribute("course", course);
            request.setAttribute("quiz", quiz);
            request.setAttribute("questions", questions);
            request.setAttribute("questionAnswersMap", questionAnswersMap);
            
            // Forward to edit JSP
            request.getRequestDispatcher("/view/dashboard/admin/quiz_edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid quiz ID");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-quiz");
        }
    }
    
    private void updateQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String lessonId = request.getParameter("lessonId");
        String quizId = request.getParameter("quizId");
        
        if (lessonId == null || lessonId.isEmpty() || quizId == null || quizId.isEmpty()) {
            request.getSession().setAttribute("toastMessage", "Quiz and lesson IDs are required");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-quiz");
            return;
        }
        
        try {
            int lessonIdInt = Integer.parseInt(lessonId);
            int quizIdInt = Integer.parseInt(quizId);
            
            // Update lesson details
            Lesson lesson = lessonDAO.getById(lessonIdInt);
            if (lesson != null) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                String status = request.getParameter("status");
                
                lesson.setTitle(title);
                lesson.setDescription(description);
                lesson.setStatus(status);
                
                lessonDAO.update(lesson);
            }
            
            // Process questions
            String[] questionIds = request.getParameterValues("questionId");
            String[] questionTexts = request.getParameterValues("questionText");
            String[] questionStatuses = request.getParameterValues("questionStatus");
            
            if (questionIds != null && questionTexts != null && questionStatuses != null) {
                for (int i = 0; i < questionIds.length; i++) {
                    int questionId = Integer.parseInt(questionIds[i]);
                    String questionText = questionTexts[i];
                    String questionStatus = questionStatuses[i];
                    
                    Question question = questionDAO.getById(questionId);
                    if (question != null) {
                        question.setQuestionText(questionText);
                        question.setStatus(questionStatus);
//                        questionDAO.(question);
                        
                        // Process answers for this question
                        String[] answerIds = request.getParameterValues("answerId_" + questionId);
                        String[] answerTexts = request.getParameterValues("answerText_" + questionId);
                        String[] isCorrect = request.getParameterValues("isCorrect_" + questionId);
                        
                        if (answerIds != null && answerTexts != null) {
                            for (int j = 0; j < answerIds.length; j++) {
                                int answerId = Integer.parseInt(answerIds[j]);
                                String answerText = answerTexts[j];
                                boolean correct = isCorrect != null && j < isCorrect.length && 
                                                 Integer.parseInt(isCorrect[0]) == j;
                                
                                QuizAnswer answer = quizAnswerDAO.getById(answerId);
                                if (answer != null) {
                                    answer.setAnswerText(answerText);
                                    answer.setIsCorrect(correct);
                                    quizAnswerDAO.update(answer);
                                }
                            }
                        }
                    }
                }
            }
            
            request.getSession().setAttribute("toastMessage", "Quiz updated successfully");
            request.getSession().setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/manage-quiz?action=view&id=" + lessonId);
            
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error updating quiz: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-quiz?action=edit&id=" + lessonId);
        }
    }
    
    private void deleteQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String lessonId = request.getParameter("id");
        
        if (lessonId == null || lessonId.isEmpty()) {
            request.getSession().setAttribute("toastMessage", "Quiz ID is required");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-quiz");
            return;
        }
        
        try {
            int lessonIdInt = Integer.parseInt(lessonId);
            Lesson lesson = lessonDAO.getById(lessonIdInt);
            
            if (lesson == null || !"quiz".equals(lesson.getType())) {
                request.getSession().setAttribute("toastMessage", "Quiz not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/manage-quiz");
                return;
            }
            
            // Get quiz details
            LessonQuiz quiz = lessonQuizDAO.getByLessonId(lessonIdInt);
            
            if (quiz != null) {
                // Get questions
                List<Question> questions = questionDAO.getByLessonQuizId(quiz.getId());
                
                // Delete answers for each question
                for (Question question : questions) {
//                    quizAnswerDAO.deleteByQuestionId(question.getId());
                }
                
                // Delete questions
//                questionDAO.deleteByLessonQuizId(quiz.getId());
                
                // Delete quiz
                lessonQuizDAO.delete(quiz.getId());
            }
            
            // Update lesson status to inactive instead of deleting
            lesson.setStatus("inactive");
            lessonDAO.update(lesson);
            
            request.getSession().setAttribute("toastMessage", "Quiz deleted successfully");
            request.getSession().setAttribute("toastType", "success");
            
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error deleting quiz: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/manage-quiz");
    }
} 