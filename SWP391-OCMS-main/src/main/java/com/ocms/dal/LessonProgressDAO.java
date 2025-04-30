package com.ocms.dal;

import com.ocms.entity.LessonProgress;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LessonProgressDAO extends DBContext implements I_DAO<LessonProgress> {

    public LessonProgressDAO() {
        // Empty constructor - connection will be initialized in each method
    }

    /**
     * Get all lesson progress records
     * @return List of LessonProgress objects
     */
    @Override
    public List<LessonProgress> findAll() {
        List<LessonProgress> progressList = new ArrayList<>();
        String sql = "SELECT * FROM lesson_progress";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                progressList.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all lesson progress: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return progressList;
    }

    /**
     * Update an existing lesson progress record
     * @param progress LessonProgress object
     * @return True if successful, false otherwise
     */
    @Override
    public boolean update(LessonProgress progress) {
        String sql = "UPDATE lesson_progress SET status = ?, progress_percent = ? WHERE account_id = ? AND lesson_id = ?";
        
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setString(1, progress.getStatus());
            statement.setInt(2, progress.getProgressPercent());
            statement.setInt(3, progress.getAccountId());
            statement.setInt(4, progress.getLessonId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating lesson progress: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Insert a new lesson progress record
     * @param progress LessonProgress object
     * @return ID of the inserted record, or -1 if failed
     */
    @Override
    public int insert(LessonProgress progress) {
        String sql = "INSERT INTO lesson_progress (account_id, lesson_id, status, progress_percent) VALUES (?, ?, ?, ?)";
        
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, progress.getAccountId());
            statement.setInt(2, progress.getLessonId());
            statement.setString(3, progress.getStatus());
            statement.setInt(4, progress.getProgressPercent());
            
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
            System.out.println("Error inserting lesson progress: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    /**
     * Delete a lesson progress record
     * @param progress LessonProgress object
     * @return True if successful, false otherwise
     */
    @Override
    public boolean delete(LessonProgress progress) {
        String sql = "DELETE FROM lesson_progress WHERE id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, progress.getId());

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting lesson progress: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Map a ResultSet row to a LessonProgress entity
     * @param rs ResultSet
     * @return LessonProgress object
     * @throws SQLException if a database error occurs
     */
    @Override
    public LessonProgress getFromResultSet(ResultSet rs) throws SQLException {
        return LessonProgress.builder()
                .id(rs.getInt("id"))
                .accountId(rs.getInt("account_id"))
                .lessonId(rs.getInt("lesson_id"))
                .status(rs.getString("status"))
                .progressPercent(rs.getInt("progress_percent"))
                .build();
    }

    /**
     * Get lesson progress by account ID and lesson ID
     * @param accountId Account ID
     * @param lessonId Lesson ID
     * @return LessonProgress object or null if not found
     */
    public LessonProgress findByAccountAndLesson(int accountId, int lessonId) {
        String sql = "SELECT * FROM lesson_progress WHERE account_id = ? AND lesson_id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            statement.setInt(2, lessonId);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding lesson progress by account and lesson: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Get all lesson progress for a specific account
     * @param accountId Account ID
     * @return List of LessonProgress objects
     */
    public List<LessonProgress> findByAccountId(int accountId) {
        List<LessonProgress> progressList = new ArrayList<>();
        String sql = "SELECT * FROM lesson_progress WHERE account_id = ?";
        
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                progressList.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding lesson progress by account ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return progressList;
    }

    /**
     * Get all completed lessons for a specific account and course
     * @param accountId Account ID
     * @param courseId Course ID
     * @return Map with lesson IDs as keys and boolean values indicating completion
     */
    public Map<Integer, Boolean> getCompletedLessonsForCourse(int accountId, int courseId) {
        Map<Integer, Boolean> completedLessonsMap = new HashMap<>();
        
        String sql = "SELECT lp.lesson_id, lp.status FROM lesson_progress lp " +
                     "JOIN lesson l ON lp.lesson_id = l.id " +
                     "JOIN section s ON l.section_id = s.id " +
                     "WHERE lp.account_id = ? AND s.course_id = ?";
        
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            statement.setInt(2, courseId);
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int lessonId = resultSet.getInt("lesson_id");
                String status = resultSet.getString("status");
                completedLessonsMap.put(lessonId, LessonProgress.Status.COMPLETED.equals(status));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting completed lessons for course: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return completedLessonsMap;
    }

    /**
     * Count completed lessons for a specific account and course
     * @param accountId Account ID
     * @param courseId Course ID
     * @return Number of completed lessons
     */
    public int countCompletedLessonsForCourse(int accountId, int courseId) {
        int count = 0;
        
        String sql = "SELECT COUNT(*) FROM lesson_progress lp " +
                     "JOIN lesson l ON lp.lesson_id = l.id " +
                     "JOIN section s ON l.section_id = s.id " +
                     "WHERE lp.account_id = ? AND s.course_id = ? AND lp.status = ?";
        
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            statement.setInt(2, courseId);
            statement.setString(3, LessonProgress.Status.COMPLETED);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting completed lessons for course: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return count;
    }

    /**
     * Create or update a lesson progress record
     * @param accountId Account ID
     * @param lessonId Lesson ID
     * @param status Status (Not Started, In Progress, Completed)
     * @param progressPercent Progress percentage (0-100)
     * @return True if successful, false otherwise
     */
    public boolean createOrUpdateProgress(int accountId, int lessonId, String status, int progressPercent) {
        // Check if progress already exists
        LessonProgress existingProgress = findByAccountAndLesson(accountId, lessonId);
        
        if (existingProgress == null) {
            // Create new progress
            LessonProgress newProgress = new LessonProgress();
            newProgress.setAccountId(accountId);
            newProgress.setLessonId(lessonId);
            newProgress.setStatus(status);
            newProgress.setProgressPercent(progressPercent);
            return insert(newProgress) > 0;
        } else {
            // Update existing progress
            existingProgress.setStatus(status);
            existingProgress.setProgressPercent(progressPercent);
            return update(existingProgress);
        }
    }

    /**
     * Mark a lesson as completed
     * @param accountId Account ID
     * @param lessonId Lesson ID
     * @return True if successful, false otherwise
     */
    public boolean markLessonAsCompleted(int accountId, int lessonId) {
        return createOrUpdateProgress(accountId, lessonId, LessonProgress.Status.COMPLETED, 100);
    }

    /**
     * Mark a lesson as in progress
     * @param accountId Account ID
     * @param lessonId Lesson ID
     * @param progressPercent Progress percentage (0-100)
     * @return True if successful, false otherwise
     */
    public boolean markLessonAsInProgress(int accountId, int lessonId, int progressPercent) {
        return createOrUpdateProgress(accountId, lessonId, LessonProgress.Status.IN_PROGRESS, progressPercent);
    }
} 