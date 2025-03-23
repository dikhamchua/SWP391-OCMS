package com.ocms.dal;

import com.ocms.entity.Question;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO extends DBContext implements I_DAO<Question> {
    
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
    
    public Integer insert02(Question question) {
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

    @Override
    public List<Question> findAll() {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM quiz_question";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                questions.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all questions: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return questions;
    }

    @Override
    public boolean update(Question t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(Question t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(Question t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    /**
     * Count total questions with filters
     */
    public int countQuestions(String courseId, String sectionId, String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM quiz_question q");
        
        // Add joins if filtering by course or section
        if ((courseId != null && !courseId.isEmpty()) || (sectionId != null && !sectionId.isEmpty())) {
            sql.append(" JOIN lesson_quiz lq ON q.quiz_id = lq.id");
            sql.append(" JOIN lesson l ON lq.lesson_id = l.id");
            
            if (sectionId != null && !sectionId.isEmpty()) {
                sql.append(" AND l.section_id = ?");
            } else if (courseId != null && !courseId.isEmpty()) {
                sql.append(" JOIN section s ON l.section_id = s.id AND s.course_id = ?");
            }
        }
        
        // Add search condition if provided
        if (search != null && !search.isEmpty()) {
            if (sql.toString().contains("WHERE")) {
                sql.append(" AND q.question_text LIKE ?");
            } else {
                sql.append(" WHERE q.question_text LIKE ?");
            }
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Set parameters for course or section filter
            if (sectionId != null && !sectionId.isEmpty()) {
                statement.setInt(paramIndex++, Integer.parseInt(sectionId));
            } else if (courseId != null && !courseId.isEmpty()) {
                statement.setInt(paramIndex++, Integer.parseInt(courseId));
            }
            
            // Set parameter for search
            if (search != null && !search.isEmpty()) {
                statement.setString(paramIndex, "%" + search + "%");
            }
            
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting questions: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }

    /**
     * Get paginated questions with filters
     */
    public List<Question> getQuestionsPaginated(String courseId, String sectionId, String search, int page, int pageSize) {
        List<Question> questions = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("SELECT q.* FROM quiz_question q");
        
        // Add joins if filtering by course or section
        if ((courseId != null && !courseId.isEmpty()) || (sectionId != null && !sectionId.isEmpty())) {
            sql.append(" JOIN lesson_quiz lq ON q.quiz_id = lq.id");
            sql.append(" JOIN lesson l ON lq.lesson_id = l.id");
            
            if (sectionId != null && !sectionId.isEmpty()) {
                sql.append(" WHERE l.section_id = ?");
            } else if (courseId != null && !courseId.isEmpty()) {
                sql.append(" JOIN section s ON l.section_id = s.id WHERE s.course_id = ?");
            }
        }
        
        // Add search condition if provided
        if (search != null && !search.isEmpty()) {
            if (sql.toString().contains("WHERE")) {
                sql.append(" AND q.question_text LIKE ?");
            } else {
                sql.append(" WHERE q.question_text LIKE ?");
            }
        }
        
        // Add order by and limit
        sql.append(" ORDER BY q.id DESC LIMIT ?, ?");
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Set parameters for course or section filter
            if (sectionId != null && !sectionId.isEmpty()) {
                statement.setInt(paramIndex++, Integer.parseInt(sectionId));
            } else if (courseId != null && !courseId.isEmpty()) {
                statement.setInt(paramIndex++, Integer.parseInt(courseId));
            }
            
            // Set parameter for search
            if (search != null && !search.isEmpty()) {
                statement.setString(paramIndex++, "%" + search + "%");
            }
            
            // Set pagination parameters
            statement.setInt(paramIndex++, (page - 1) * pageSize);
            statement.setInt(paramIndex, pageSize);
            
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                questions.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting paginated questions: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return questions;
    }
} 