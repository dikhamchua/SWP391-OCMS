package com.ocms.dal;

import com.ocms.entity.QuizQuestion;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for QuizQuestion entity
 */
public class QuizQuestionDAO extends DBContext {
    
    /**
     * Get a quiz question by its ID
     * @param id The ID of the question to retrieve
     * @return The QuizQuestion object if found, null otherwise
     */
    public QuizQuestion getById(int id) {
        String sql = "SELECT * FROM quiz_question WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting quiz question by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Get all questions for a specific quiz
     * @param quizId The quiz ID
     * @return List of questions for the specified quiz
     */
    public List<QuizQuestion> getByQuizId(int quizId) {
        List<QuizQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM quiz_question WHERE quiz_id = ? ORDER BY order_number ASC";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                questions.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting questions by quiz ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return questions;
    }
    
    /**
     * Get all active questions for a specific quiz
     * @param quizId The quiz ID
     * @return List of active questions for the specified quiz
     */
    public List<QuizQuestion> getActiveByQuizId(int quizId) {
        List<QuizQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM quiz_question WHERE quiz_id = ? AND status = 'active' ORDER BY order_number ASC";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                questions.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting active questions by quiz ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return questions;
    }
    
    /**
     * Get all quiz questions
     * @return List of all quiz questions
     */
    public List<QuizQuestion> getAll() {
        List<QuizQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM quiz_question";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                questions.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all quiz questions: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return questions;
    }
    
    /**
     * Insert a new quiz question
     * @param question The quiz question to insert
     * @return The ID of the inserted question, or -1 if insertion failed
     */
    public int insert(QuizQuestion question) {
        String sql = "INSERT INTO quiz_question (quiz_id, question_text, points, order_number, status) " +
                "VALUES (?, ?, ?, ?, ?)";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, question.getQuizId());
            statement.setString(2, question.getQuestionText());
            statement.setInt(3, question.getPoints() != null ? question.getPoints() : 1);
            statement.setInt(4, question.getOrderNumber() != null ? question.getOrderNumber() : 1);
            statement.setString(5, question.getStatus() != null ? question.getStatus() : "active");
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                return -1;
            }
            
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting quiz question: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Update an existing quiz question
     * @param question The quiz question with updated values
     * @return true if update was successful, false otherwise
     */
    public boolean update(QuizQuestion question) {
        String sql = "UPDATE quiz_question SET quiz_id = ?, question_text = ?, points = ?, " +
                "order_number = ?, status = ?, modified_date = CURRENT_TIMESTAMP WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, question.getQuizId());
            statement.setString(2, question.getQuestionText());
            statement.setInt(3, question.getPoints() != null ? question.getPoints() : 1);
            statement.setInt(4, question.getOrderNumber() != null ? question.getOrderNumber() : 1);
            statement.setString(5, question.getStatus() != null ? question.getStatus() : "active");
            statement.setInt(6, question.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating quiz question: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Delete a quiz question by its ID
     * @param id The ID of the question to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM quiz_question WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting quiz question: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Delete all questions for a specific quiz
     * @param quizId The quiz ID
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteByQuizId(int quizId) {
        String sql = "DELETE FROM quiz_question WHERE quiz_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting questions by quiz ID: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Update the status of a quiz question
     * @param id The ID of the question
     * @param status The new status ('active' or 'inactive')
     * @return true if update was successful, false otherwise
     */
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE quiz_question SET status = ?, modified_date = CURRENT_TIMESTAMP WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, id);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating quiz question status: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Count the number of questions in a quiz
     * @param quizId The quiz ID
     * @return The number of questions in the quiz
     */
    public int countQuestionsByQuizId(int quizId) {
        String sql = "SELECT COUNT(*) FROM quiz_question WHERE quiz_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting questions by quiz ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }
    
    /**
     * Get the total points for a quiz
     * @param quizId The quiz ID
     * @return The total points for the quiz
     */
    public int getTotalPointsByQuizId(int quizId) {
        String sql = "SELECT SUM(points) FROM quiz_question WHERE quiz_id = ? AND status = 'active'";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting total points by quiz ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }
    
    /**
     * Utility method to create a QuizQuestion object from a ResultSet
     * @param rs The ResultSet containing quiz question data
     * @return A QuizQuestion object populated with data from the ResultSet
     * @throws SQLException If there's an error accessing the ResultSet
     */
    public QuizQuestion getFromResultSet(ResultSet rs) throws SQLException {
        QuizQuestion question = new QuizQuestion();
        question.setId(rs.getInt("id"));
        question.setQuizId(rs.getInt("quiz_id"));
        question.setQuestionText(rs.getString("question_text"));
        question.setPoints(rs.getInt("points"));
        question.setOrderNumber(rs.getInt("order_number"));
        question.setStatus(rs.getString("status"));
        question.setCreatedDate(rs.getDate("created_date"));
        question.setModifiedDate(rs.getDate("modified_date"));
        return question;
    }
    
    /**
     * Main method for testing QuizQuestionDAO functionality
     * @param args Command line arguments (not used)
     */
    public static void main(String[] args) {
        QuizQuestionDAO questionDAO = new QuizQuestionDAO();
        
        // Test getting all questions
        System.out.println("=== All Quiz Questions ===");
        List<QuizQuestion> allQuestions = questionDAO.getAll();
        for (QuizQuestion question : allQuestions) {
            System.out.println("ID: " + question.getId() + 
                    ", Quiz ID: " + question.getQuizId() + 
                    ", Text: " + question.getQuestionText());
        }
        
        // Test getting questions by quiz ID (assuming quiz ID 1 exists)
        System.out.println("\n=== Questions for Quiz ID 1 ===");
        List<QuizQuestion> quizQuestions = questionDAO.getByQuizId(1);
        for (QuizQuestion question : quizQuestions) {
            System.out.println("ID: " + question.getId() + 
                    ", Points: " + question.getPoints() + 
                    ", Text: " + question.getQuestionText());
        }
        
        // Test getting question by ID (assuming ID 1 exists)
        System.out.println("\n=== Question with ID 1 ===");
        QuizQuestion questionById = questionDAO.getById(1);
        if (questionById != null) {
            System.out.println("Text: " + questionById.getQuestionText());
            System.out.println("Points: " + questionById.getPoints());
            System.out.println("Status: " + questionById.getStatus());
        } else {
            System.out.println("Question with ID 1 not found");
        }
        
        // Test counting questions in a quiz
        System.out.println("\n=== Count of Questions in Quiz ID 1 ===");
        int questionCount = questionDAO.countQuestionsByQuizId(1);
        System.out.println("Number of questions: " + questionCount);
        
        // Test getting total points for a quiz
        System.out.println("\n=== Total Points for Quiz ID 1 ===");
        int totalPoints = questionDAO.getTotalPointsByQuizId(1);
        System.out.println("Total points: " + totalPoints);
        
        // Uncomment to test insert, update, and delete operations
        /*
        // Test inserting a new question
        System.out.println("\n=== Inserting New Question ===");
        QuizQuestion newQuestion = new QuizQuestion();
        newQuestion.setQuizId(1);
        newQuestion.setQuestionText("What is the capital of France?");
        newQuestion.setPoints(2);
        newQuestion.setOrderNumber(10);
        newQuestion.setStatus("active");
        
        int newId = questionDAO.insert(newQuestion);
        System.out.println("New question inserted with ID: " + newId);
        
        // Test updating a question
        if (newId > 0) {
            System.out.println("\n=== Updating Question ===");
            QuizQuestion updatedQuestion = questionDAO.getById(newId);
            updatedQuestion.setQuestionText("What is the capital of France? (Paris)");
            updatedQuestion.setPoints(3);
            
            boolean updateSuccess = questionDAO.update(updatedQuestion);
            System.out.println("Question update " + (updateSuccess ? "successful" : "failed"));
            
            // Test updating status
            System.out.println("\n=== Updating Question Status ===");
            boolean statusUpdateSuccess = questionDAO.updateStatus(newId, "inactive");
            System.out.println("Status update " + (statusUpdateSuccess ? "successful" : "failed"));
            
            // Test deleting a question
            System.out.println("\n=== Deleting Question ===");
            boolean deleteSuccess = questionDAO.delete(newId);
            System.out.println("Question deletion " + (deleteSuccess ? "successful" : "failed"));
        }
        */
    }
} 