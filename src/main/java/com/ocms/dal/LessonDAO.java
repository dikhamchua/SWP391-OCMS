package com.ocms.dal;

import com.ocms.entity.Lesson;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;

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
    public int insert(Lesson lesson) {
        String sql = "INSERT INTO lesson (section_id, title, description, type, order_number, " +
                "duration_minutes, status, created_date, modified_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
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
            
            if (affectedRows == 0) {
                throw new SQLException("Creating lesson failed, no rows affected.");
            }
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating lesson failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting lesson: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
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
        
        // Uncomment to test insert, update, and delete operations
        /*
        // Test inserting a new lesson
        System.out.println("\n=== Inserting New Lesson ===");
        Lesson newLesson = new Lesson();
        newLesson.setSectionId(1);
        newLesson.setTitle("Test Lesson");
        newLesson.setDescription("This is a test lesson");
        newLesson.setType("text");
        newLesson.setOrderNumber(999);
        newLesson.setDurationMinutes(30);
        newLesson.setStatus("active");
        newLesson.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));
        newLesson.setModifiedDate(new java.sql.Date(System.currentTimeMillis()));
        
        int newId = lessonDAO.insert(newLesson);
        System.out.println("New lesson inserted with ID: " + newId);
        
        // Test updating a lesson
        if (newId > 0) {
            System.out.println("\n=== Updating Lesson ===");
            Lesson updatedLesson = lessonDAO.getById(newId);
            updatedLesson.setTitle("Updated Test Lesson");
            updatedLesson.setModifiedDate(new java.sql.Date(System.currentTimeMillis()));
            
            boolean updateSuccess = lessonDAO.update(updatedLesson);
            System.out.println("Lesson update " + (updateSuccess ? "successful" : "failed"));
            
            // Test deleting a lesson
            System.out.println("\n=== Deleting Lesson ===");
            boolean deleteSuccess = lessonDAO.delete(newId);
            System.out.println("Lesson deletion " + (deleteSuccess ? "successful" : "failed"));
        }
        */
    }
} 