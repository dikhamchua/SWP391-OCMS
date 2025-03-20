package com.ocms.dal;

import com.ocms.entity.Lesson;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;
import com.ocms.entity.*;

public class LessonDAO extends DBContext {
    
    /**
     * Get a lesson by its ID
     * @param id The ID of the lesson to retrieve
     * @return The Lesson object if found, null otherwise
     */
    public Lesson getById(int id) {
        String sql = "SELECT * FROM lesson WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting lesson by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Get all lessons
     * @return List of all lessons
     */
    public List<Lesson> getAll() {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM lesson";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                lessons.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all lessons: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return lessons;
    }
    
    /**
     * Get lessons by section ID
     * @param sectionId The section ID to filter by
     * @return List of lessons in the specified section
     */
    public List<Lesson> getBySectionId(int sectionId) {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM lesson WHERE section_id = ? ORDER BY order_number ASC";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, sectionId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                lessons.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting lessons by section ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return lessons;
    }
    
    /**
     * Insert a new lesson
     * @param lesson The lesson to insert
     * @return The ID of the inserted lesson, or -1 if insertion failed
     */
    public Integer insert(Lesson lesson) {
        String sql = "INSERT INTO lesson (section_id, title, description, type, order_number, duration_minutes, status, created_date, modified_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Integer insertedId = -1;
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            statement.setInt(1, lesson.getSectionId());
            statement.setString(2, lesson.getTitle());
            statement.setString(3, lesson.getDescription());
            statement.setString(4, lesson.getType());
            statement.setInt(5, lesson.getOrderNumber());
            statement.setInt(6, lesson.getDurationMinutes());
            statement.setString(7, lesson.getStatus());
            statement.setDate(8, lesson.getCreatedDate());
            statement.setDate(9, lesson.getModifiedDate());
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows > 0) {
                // Get the generated ID
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    insertedId = resultSet.getInt(1);
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting lesson: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return insertedId;
    }
    
    /**
     * Update an existing lesson
     * @param lesson The lesson with updated values
     * @return true if update was successful, false otherwise
     */
    public boolean update(Lesson lesson) {
        String sql = "UPDATE lesson SET section_id = ?, title = ?, description = ?, " +
                "type = ?, order_number = ?, duration_minutes = ?, status = ?, " +
                "modified_date = ? WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, lesson.getSectionId());
            statement.setString(2, lesson.getTitle());
            statement.setString(3, lesson.getDescription());
            statement.setString(4, lesson.getType());
            statement.setInt(5, lesson.getOrderNumber());
            statement.setInt(6, lesson.getDurationMinutes());
            statement.setString(7, lesson.getStatus());
            statement.setDate(8, lesson.getModifiedDate());
            statement.setInt(9, lesson.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating lesson: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Delete a lesson by its ID
     * @param id The ID of the lesson to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM lesson WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting lesson: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Utility method to create a Lesson object from a ResultSet
     * @param rs The ResultSet containing lesson data
     * @return A Lesson object populated with data from the ResultSet
     * @throws SQLException If there's an error accessing the ResultSet
     */
    public Lesson getFromResultSet(ResultSet rs) throws SQLException {
        Lesson lesson = new Lesson();
        lesson.setId(rs.getInt("id"));
        lesson.setSectionId(rs.getInt("section_id"));
        lesson.setTitle(rs.getString("title"));
        lesson.setDescription(rs.getString("description"));
        lesson.setType(rs.getString("type"));
        lesson.setOrderNumber(rs.getInt("order_number"));
        lesson.setDurationMinutes(rs.getInt("duration_minutes"));
        lesson.setStatus(rs.getString("status"));
        lesson.setCreatedDate(rs.getDate("created_date"));
        lesson.setModifiedDate(rs.getDate("modified_date"));
        return lesson;
    }

    /**
     * Update an existing lesson video
     * @param lessonVideo The lesson video with updated values
     * @return true if update was successful, false otherwise
     */
    public boolean updateLessonVideo(LessonVideo lessonVideo) {
        String sql = "UPDATE lesson_video SET video_url = ?, video_provider = ?, " +
                "video_duration = ? WHERE lesson_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, lessonVideo.getVideoUrl());
            statement.setString(2, lessonVideo.getVideoProvider());
            statement.setInt(3, lessonVideo.getVideoDuration());
            statement.setInt(4, lessonVideo.getLessonId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating lesson video: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Delete a lesson video by lesson ID
     * @param lessonId The lesson ID
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteLessonVideo(int lessonId) {
        String sql = "DELETE FROM lesson_video WHERE lesson_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, lessonId);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting lesson video: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    



    /**
     * Main method for testing LessonDAO functionality
     * @param args Command line arguments (not used)
     */
    public static void main(String[] args) {
        LessonDAO lessonDAO = new LessonDAO();
        
        // Test getting all lessons
        System.out.println("=== All Lessons ===");
        List<Lesson> allLessons = lessonDAO.getAll();
        for (Lesson lesson : allLessons) {
            System.out.println("ID: " + lesson.getId() + ", Title: " + lesson.getTitle());
        }
        
        // Test getting lesson by ID (assuming ID 1 exists)
        System.out.println("\n=== Lesson with ID 1 ===");
        Lesson lessonById = lessonDAO.getById(1);
        if (lessonById != null) {
            System.out.println("Title: " + lessonById.getTitle());
            System.out.println("Description: " + lessonById.getDescription());
            System.out.println("Type: " + lessonById.getType());
        } else {
            System.out.println("Lesson with ID 1 not found");
        }
        
        // Test getting lessons by section ID (assuming section ID 1 exists)
        System.out.println("\n=== Lessons in Section 1 ===");
        List<Lesson> sectionLessons = lessonDAO.getBySectionId(1);
        for (Lesson lesson : sectionLessons) {
            System.out.println("ID: " + lesson.getId() + ", Title: " + lesson.getTitle());
        }
        
        
    }
} 