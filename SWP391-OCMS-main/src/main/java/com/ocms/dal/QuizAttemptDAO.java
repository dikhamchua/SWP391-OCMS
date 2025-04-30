package com.ocms.dal;

import com.ocms.entity.QuizAttempt;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class QuizAttemptDAO extends DBContext implements I_DAO<QuizAttempt> {

    public QuizAttemptDAO() {
        // Empty constructor - connection will be initialized in each method
    }

    /**
     * Get all quiz attempts from the database
     * @return List of QuizAttempt objects
     */
    @Override
    public List<QuizAttempt> findAll() {
        List<QuizAttempt> attemptList = new ArrayList<>();
        String sql = "SELECT * FROM quiz_attempt";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                attemptList.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all quiz attempts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return attemptList;
    }

    /**
     * Update an existing quiz attempt
     * @param attempt QuizAttempt object
     * @return True if successful, false otherwise
     */
    @Override
    public boolean update(QuizAttempt attempt) {
        String sql = "UPDATE quiz_attempt SET score = ?, passed = ?, end_time = ? WHERE id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setDouble(1, attempt.getScore());
            statement.setBoolean(2, attempt.getPassed());
            statement.setTimestamp(3, attempt.getEndTime());
            statement.setInt(4, attempt.getId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating quiz attempt: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Insert a new quiz attempt
     * @param attempt QuizAttempt object
     * @return ID of the inserted record, or -1 if failed
     */
    @Override
    public int insert(QuizAttempt attempt) {
        String sql = "INSERT INTO quiz_attempt (account_id, quiz_id, score, passed, start_time, end_time, lesson_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, attempt.getAccountId());
            statement.setInt(2, attempt.getQuizId());
            
            if (attempt.getScore() != null) {
                statement.setDouble(3, attempt.getScore());
            } else {
                statement.setNull(3, java.sql.Types.DECIMAL);
            }
            
            if (attempt.getPassed()!= null) {
                statement.setBoolean(4, attempt.getPassed());
            } else {
                statement.setNull(4, java.sql.Types.BOOLEAN);
            }
            
            statement.setTimestamp(5, attempt.getStartTime());
            
            if (attempt.getEndTime() != null) {
                statement.setTimestamp(6, attempt.getEndTime());
            } else {
                statement.setNull(6, java.sql.Types.TIMESTAMP);
            }
            
            if (attempt.getLessonId() != null) {
                statement.setInt(7, attempt.getLessonId());
            } else {
                statement.setNull(7, java.sql.Types.INTEGER);
            }
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected == 0) {
                return -1;
            }
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                return -1;
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting quiz attempt: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    /**
     * Delete a quiz attempt
     * @param attempt QuizAttempt object
     * @return True if successful, false otherwise
     */
    @Override
    public boolean delete(QuizAttempt attempt) {
        String sql = "DELETE FROM quiz_attempt WHERE id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attempt.getId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting quiz attempt: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Map a ResultSet row to a QuizAttempt entity
     * @param rs ResultSet
     * @return QuizAttempt object
     * @throws SQLException if a database error occurs
     */
    @Override
    public QuizAttempt getFromResultSet(ResultSet rs) throws SQLException {
        QuizAttempt attempt = new QuizAttempt();
        attempt.setId(rs.getInt("id"));
        attempt.setAccountId(rs.getInt("account_id"));
        attempt.setQuizId(rs.getInt("quiz_id"));
        
        // Handle nullable fields
        double score = rs.getDouble("score");
        if (!rs.wasNull()) {
            attempt.setScore(score);
        }
        
        boolean passed = rs.getBoolean("passed");
        if (!rs.wasNull()) {
            attempt.setPassed(passed);
        }
        
        attempt.setStartTime(rs.getTimestamp("start_time"));
        attempt.setEndTime(rs.getTimestamp("end_time"));
        
        int lessonId = rs.getInt("lesson_id");
        if (!rs.wasNull()) {
            attempt.setLessonId(lessonId);
        }
        
        return attempt;
    }
    
    /**
     * Get quiz attempts by student ID
     * @param accountId Student ID
     * @return List of QuizAttempt objects
     */
    public List<QuizAttempt> findByAccountId(int accountId) {
        List<QuizAttempt> attemptList = new ArrayList<>();
        String sql = "SELECT * FROM quiz_attempt WHERE account_id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                attemptList.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding quiz attempts by account ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return attemptList;
    }
    
    /**
     * Get quiz attempts by quiz ID
     * @param quizId Quiz ID
     * @return List of QuizAttempt objects
     */
    public List<QuizAttempt> findByQuizId(int quizId) {
        List<QuizAttempt> attemptList = new ArrayList<>();
        String sql = "SELECT * FROM quiz_attempt WHERE quiz_id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quizId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                attemptList.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding quiz attempts by quiz ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return attemptList;
    }
    
    /**
     * Get quiz attempts by student ID and quiz ID
     * @param accountId Student ID
     * @param quizId Quiz ID
     * @return List of QuizAttempt objects
     */
    public List<QuizAttempt> findByAccountIdAndQuizId(int accountId, int quizId) {
        List<QuizAttempt> attemptList = new ArrayList<>();
        String sql = "SELECT * FROM quiz_attempt WHERE account_id = ? AND quiz_id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            statement.setInt(2, quizId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                attemptList.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding quiz attempts by account ID and quiz ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return attemptList;
    }
    
    /**
     * Get latest quiz attempt by student ID and quiz ID
     * @param accountId Student ID
     * @param quizId Quiz ID
     * @return QuizAttempt object or null if not found
     */
    public QuizAttempt findLatestByAccountIdAndQuizId(int accountId, int quizId) {
        String sql = "SELECT * FROM quiz_attempt WHERE account_id = ? AND quiz_id = ? ORDER BY start_time DESC LIMIT 1";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            statement.setInt(2, quizId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding latest quiz attempt by account ID and quiz ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Check if student has passed a quiz
     * @param accountId Student ID
     * @param quizId Quiz ID
     * @return True if passed, false otherwise
     */
    public boolean hasPassedQuiz(int accountId, int quizId) {
        String sql = "SELECT * FROM quiz_attempt WHERE account_id = ? AND quiz_id = ? AND passed = true LIMIT 1";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            statement.setInt(2, quizId);
            resultSet = statement.executeQuery();
            return resultSet.next();
        } catch (SQLException ex) {
            System.out.println("Error checking if student has passed quiz: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
} 