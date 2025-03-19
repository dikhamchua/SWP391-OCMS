package com.ocms.dal;

import com.ocms.entity.Question;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO extends DBContext {
    
    public List<Question> getByLessonQuizId(Integer quizId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM quiz_question WHERE quiz_id = ? AND status = 'active' ORDER BY order_number";
        
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
    
    public Question getById(Integer id) {
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
            System.out.println("Error getting question by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return null;
    }
    
    public Integer insert(Question question) {
        String sql = "INSERT INTO quiz_question (quiz_id, question_text, points, order_number, status, created_date, modified_date) "
                + "VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, question.getQuizId());
            statement.setString(2, question.getQuestionText());
            statement.setInt(3, question.getPoints());
            statement.setInt(4, question.getOrderNumber());
            statement.setString(5, question.getStatus());
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating question failed, no rows affected.");
            }
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating question failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting question: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }
    
    public Question getFromResultSet(ResultSet rs) throws SQLException {
        Question question = new Question();
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
} 