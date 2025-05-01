package com.ocms.controller.student;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.LessonDAO;
import com.ocms.dal.LessonProgressDAO;
import com.ocms.dal.LessonQuizDAO;
import com.ocms.dal.QuestionDAO;
import com.ocms.dal.QuizAnswerDAO;
import com.ocms.dal.QuizAttemptDAO;
import com.ocms.entity.Account;
import com.ocms.entity.Lesson;
import com.ocms.entity.LessonQuiz;
import com.ocms.entity.QuizAnswer;
import com.ocms.entity.QuizAttempt;
import com.ocms.entity.Question;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "QuizSubmissionController", urlPatterns = {"/submit-quiz"})
public class QuizSubmissionController extends HttpServlet {

    private QuizAttemptDAO quizAttemptDAO;
    private LessonQuizDAO lessonQuizDAO;
    private QuestionDAO questionDAO;
    private QuizAnswerDAO quizAnswerDAO;
    private LessonDAO lessonDAO;
    private LessonProgressDAO lessonProgressDAO;
    @Override
    public void init() throws ServletException {
        super.init();
        quizAttemptDAO = new QuizAttemptDAO();
        lessonQuizDAO = new LessonQuizDAO();
        questionDAO = new QuestionDAO();
        quizAnswerDAO = new QuizAnswerDAO();
        lessonDAO = new LessonDAO();
        lessonProgressDAO = new LessonProgressDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get user from session
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        // Check if user is logged in
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        try {
            // Get lesson quiz ID from request
            int lessonQuizId = Integer.parseInt(request.getParameter("lessonQuizId"));
            
            // Get the lesson quiz
            LessonQuiz lessonQuiz = lessonQuizDAO.getById(lessonQuizId);
            if (lessonQuiz == null) {
                setSessionMessage(session, "Quiz không tồn tại", "error");
                response.sendRedirect(request.getContextPath() + "/my-courses");
                return;
            }
            
            // Get the lesson associated with the quiz
            Lesson lesson = lessonDAO.getById(lessonQuiz.getLessonId());
            if (lesson == null) {
                setSessionMessage(session, "Bài học không tồn tại", "error");
                response.sendRedirect(request.getContextPath() + "/my-courses");
                return;
            }
            
            // Get all questions for the quiz
            List<Question> questions = questionDAO.getByLessonQuizId(lessonQuizId);
            if (questions.isEmpty()) {
                setSessionMessage(session, "Quiz không có câu hỏi nào", "error");
                response.sendRedirect(request.getContextPath() + "/lesson?action=view&id=" + lesson.getId());
                return;
            }
            
            // Calculate score
            double totalPoints = 0;
            double earnedPoints = 0;
            int correctAnswers = 0;
            
            // Store which answers are correct for each question
            Map<Integer, List<QuizAnswer>> correctAnswersMap = new HashMap<>();
            
            // Process each question
            for (Question question : questions) {
                totalPoints += question.getPoints();
                
                // Get correct answers for this question
                List<QuizAnswer> answers = quizAnswerDAO.getByQuestionId(question.getId());
                List<QuizAnswer> correctAnswersList = new ArrayList<>();
                
                for (QuizAnswer answer : answers) {
                    if (answer.getIsCorrect()) {
                        correctAnswersList.add(answer);
                    }
                }
                
                correctAnswersMap.put(question.getId(), correctAnswersList);
                
                // Get student's answer for this question
                String selectedAnswerParam = request.getParameter("question_" + question.getId());
                
                if (selectedAnswerParam != null && !selectedAnswerParam.isEmpty()) {
                    int selectedAnswerId = Integer.parseInt(selectedAnswerParam);
                    
                    // Check if the selected answer is correct
                    for (QuizAnswer correctAnswer : correctAnswersList) {
                        if (correctAnswer.getId() == selectedAnswerId) {
                            earnedPoints += question.getPoints();
                            correctAnswers++;
                            break;
                        }
                    }
                }
            }
            
            // Calculate percentage score (0-100)
            double percentageScore = totalPoints > 0 ? (earnedPoints / totalPoints) * 100 : 0;
            
            // Determine if student passed (>= passing score)
            boolean passed = percentageScore >= GlobalConfig.PASS_PERCENTAGE;
            
            // Create a new quiz attempt
            QuizAttempt attempt = new QuizAttempt();
            attempt.setAccountId(account.getId());
            attempt.setQuizId(lessonQuizId);
            attempt.setScore(percentageScore);
            attempt.setPassed(passed);
            attempt.setStartTime(new Timestamp(System.currentTimeMillis() - (30 * 60 * 1000))); // Assume started 30 minutes ago
            attempt.setEndTime(new Timestamp(System.currentTimeMillis()));
            attempt.setLessonId(lesson.getId());
            
            // Save the attempt
            int attemptId = quizAttemptDAO.insert(attempt);
            
            if (attemptId > 0) {
                // If student passed, mark the lesson as completed
                if (passed) {
                    lessonProgressDAO.markLessonAsCompleted(account.getId(), lesson.getId());
                    setSessionMessage(session, "Chúc mừng! Bạn đã hoàn thành bài kiểm tra với điểm số " + Math.round(percentageScore) + "%", "success");
                } else {
                    lessonProgressDAO.markLessonAsCompleted(account.getId(), lesson.getId());
                    setSessionMessage(session, "Bạn chưa đạt điểm đủ để hoàn thành bài kiểm tra. Điểm số của bạn: " + Math.round(percentageScore) + "%", "success");
                }
                
                // Set quiz result attributes
                // Tạo HashMap để lưu kết quả bài kiểm tra
                Map<String, Object> quizResultMap = new HashMap<>();
                quizResultMap.put("totalQuestions", questions.size());
                quizResultMap.put("correctAnswers", correctAnswers);
                quizResultMap.put("score", percentageScore);
                quizResultMap.put("passed", passed);
                quizResultMap.put("passingScore", GlobalConfig.PASS_PERCENTAGE);
                
                // Đặt kết quả vào session
                session.setAttribute("quizResult", quizResultMap);
                
                // Redirect to quiz result page
                response.sendRedirect(request.getContextPath() + "/lesson?action=view&id=" + lesson.getId() + "&showResult=true");
            } else {
                // Failed to save attempt
                setSessionMessage(session, "Lỗi khi lưu kết quả bài kiểm tra", "error");
                response.sendRedirect(request.getContextPath() + "/lesson?action=view&id=" + lesson.getId());
            }
            
        } catch (NumberFormatException e) {
            // Invalid parameters
            setSessionMessage(session, "Tham số không hợp lệ", "error");
            response.sendRedirect(request.getContextPath() + "/my-courses");
        } catch (Exception e) {
            // Other errors
            e.printStackTrace();
            setSessionMessage(session, "Đã xảy ra lỗi: " + e.getMessage(), "error");
            response.sendRedirect(request.getContextPath() + "/my-courses");
        }
    }
    
    /**
     * Set a message in the session to be displayed to the user
     * @param session HTTP session
     * @param message Message to display
     * @param type Message type (success, error, info, warning)
     */
    private void setSessionMessage(HttpSession session, String message, String type) {
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", type);
    }
}