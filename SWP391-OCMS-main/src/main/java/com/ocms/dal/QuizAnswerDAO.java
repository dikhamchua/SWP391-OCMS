package com.ocms.dal;

import com.ocms.entity.QuizAnswer;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class QuizAnswerDAO extends DBContext {
    
    public List<QuizAnswer> getByQuestionId(Integer questionId) {
        List<QuizAnswer> answers = new ArrayList<>();
        String sql = "SELECT * FROM quiz_answer WHERE question_id = ? ORDER BY order_number";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, questionId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                answers.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting answers by question ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return answers;
    }
    
    public QuizAnswer getById(Integer id) {
        String sql = "SELECT * FROM quiz_answer WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting answer by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return null;
    }
    
    public Integer insert(QuizAnswer answer) {
        String sql = "INSERT INTO quiz_answer (question_id, answer_text, is_correct, order_number) "
                + "VALUES (?, ?, ?, ?)";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, answer.getQuestionId());
            statement.setString(2, answer.getAnswerText());
            statement.setBoolean(3, answer.getIsCorrect());
            statement.setInt(4, answer.getOrderNumber());
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating answer failed, no rows affected.");
            }
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating answer failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting answer: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }
    
    public boolean update(QuizAnswer answer) {
        String sql = "UPDATE quiz_answer SET question_id = ?, answer_text = ?, is_correct = ?, order_number = ? "
                + "WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, answer.getQuestionId());
            statement.setString(2, answer.getAnswerText());
            statement.setBoolean(3, answer.getIsCorrect());
            statement.setInt(4, answer.getOrderNumber());
            statement.setInt(5, answer.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating answer: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    public boolean delete(Integer id) {
        String sql = "DELETE FROM quiz_answer WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting answer: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    public QuizAnswer getFromResultSet(ResultSet rs) throws SQLException {
        QuizAnswer answer = new QuizAnswer();
        answer.setId(rs.getInt("id"));
        answer.setQuestionId(rs.getInt("question_id"));
        answer.setAnswerText(rs.getString("answer_text"));
        answer.setIsCorrect(rs.getBoolean("is_correct"));
        answer.setOrderNumber(rs.getInt("order_number"));
        return answer;
    }
} 