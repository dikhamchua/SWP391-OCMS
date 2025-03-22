package com.ocms.dal;

import com.ocms.entity.LessonQuiz;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * Data Access Object for LessonQuiz entity
 */
public class LessonQuizDAO extends DBContext {
    
    /**
     * Get a lesson quiz by its ID
     * @param id The ID of the quiz to retrieve
     * @return The LessonQuiz object if found, null otherwise
     */
    public LessonQuiz getById(int id) {
        String sql = "SELECT * FROM lesson_quiz WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting lesson quiz by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Get a lesson quiz by lesson ID
     * @param lessonId The lesson ID
     * @return The LessonQuiz object if found, null otherwise
     */
    public LessonQuiz getByLessonId(int lessonId) {
        String sql = "SELECT * FROM lesson_quiz WHERE lesson_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, lessonId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting lesson quiz by lesson ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Get all lesson quizzes
     * @return List of all lesson quizzes
     */
    public List<LessonQuiz> getAll() {
        List<LessonQuiz> quizzes = new ArrayList<>();
        String sql = "SELECT * FROM lesson_quiz";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                quizzes.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all lesson quizzes: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return quizzes;
    }
    
    /**
     * Insert a new lesson quiz
     * @param quiz The lesson quiz to insert
     * @return The ID of the inserted quiz, or -1 if insertion failed
     */
    public int insert(LessonQuiz quiz) {
        String sql = "INSERT INTO lesson_quiz (lesson_id) " +
                "VALUES (?)";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, quiz.getLessonId());
            
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
            System.out.println("Error inserting lesson quiz: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Update an existing lesson quiz
     * @param quiz The lesson quiz with updated values
     * @return true if update was successful, false otherwise
     */
    public boolean update(LessonQuiz quiz) {
        String sql = "UPDATE lesson_quiz SET lesson_id = ? WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, quiz.getLessonId());
            statement.setInt(2, quiz.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating lesson quiz: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Delete a lesson quiz by its ID
     * @param id The ID of the quiz to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM lesson_quiz WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting lesson quiz: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Delete a lesson quiz by lesson ID
     * @param lessonId The lesson ID
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteByLessonId(int lessonId) {
        String sql = "DELETE FROM lesson_quiz WHERE lesson_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, lessonId);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting lesson quiz by lesson ID: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Utility method to create a LessonQuiz object from a ResultSet
     * @param rs The ResultSet containing lesson quiz data
     * @return A LessonQuiz object populated with data from the ResultSet
     * @throws SQLException If there's an error accessing the ResultSet
     */
    public LessonQuiz getFromResultSet(ResultSet rs) throws SQLException {
        LessonQuiz quiz = new LessonQuiz();
        quiz.setId(rs.getInt("id"));
        
        int lessonId = rs.getInt("lesson_id");
        if (!rs.wasNull()) {
            quiz.setLessonId(lessonId);
        }
        
        return quiz;
    }
    
    /**
     * Main method for testing LessonQuizDAO functionality
     * @param args Command line arguments (not used)
     */
    public static void main(String[] args) {
        LessonQuizDAO quizDAO = new LessonQuizDAO();
        
        // Test getting all quizzes
        System.out.println("=== All Quizzes ===");
        List<LessonQuiz> allQuizzes = quizDAO.getAll();
        for (LessonQuiz quiz : allQuizzes) {
            System.out.println("ID: " + quiz.getId() + 
                    ", Lesson ID: " + quiz.getLessonId());
        }
        
        // Test getting quiz by ID (assuming ID 1 exists)
        System.out.println("\n=== Quiz with ID 1 ===");
        LessonQuiz quizById = quizDAO.getById(1);
        if (quizById != null) {
            System.out.println("Lesson ID: " + quizById.getLessonId());
        } else {
            System.out.println("Quiz with ID 1 not found");
        }
        
        // Test getting quiz by lesson ID (assuming lesson ID 1 has a quiz)
        System.out.println("\n=== Quiz for Lesson ID 1 ===");
        LessonQuiz quizByLessonId = quizDAO.getByLessonId(1);
        if (quizByLessonId != null) {
            System.out.println("Quiz ID: " + quizByLessonId.getId());
            System.out.println("Lesson ID: " + quizByLessonId.getLessonId());
        } else {
            System.out.println("No quiz found for lesson ID 1");
        }
        
        // Uncomment to test insert, update, and delete operations
        /*
        // Test inserting a new quiz
        System.out.println("\n=== Inserting New Quiz ===");
        LessonQuiz newQuiz = new LessonQuiz();
        newQuiz.setPassPercentage(75);
        newQuiz.setTimeLimitMinutes(30);
        newQuiz.setAttemptsAllowed(3);
        newQuiz.setLessonId(999); // Use a test lesson ID
        
        int newId = quizDAO.insert(newQuiz);
        System.out.println("New quiz inserted with ID: " + newId);
        
        // Test updating a quiz
        if (newId > 0) {
            System.out.println("\n=== Updating Quiz ===");
            LessonQuiz updatedQuiz = quizDAO.getById(newId);
            updatedQuiz.setPassPercentage(80);
            updatedQuiz.setTimeLimitMinutes(45);
            
            boolean updateSuccess = quizDAO.update(updatedQuiz);
            System.out.println("Quiz update " + (updateSuccess ? "successful" : "failed"));
            
            // Test deleting a quiz
            System.out.println("\n=== Deleting Quiz ===");
            boolean deleteSuccess = quizDAO.delete(newId);
            System.out.println("Quiz deletion " + (deleteSuccess ? "successful" : "failed"));
        }
        */
    }
    
    /**
     * Count total quizzes based on filter criteria
     * @param courseId Course ID filter (optional)
     * @param sectionId Section ID filter (optional)
     * @param search Search term for quiz title (optional)
     * @return Total count of quizzes matching the criteria
     */
    public int countQuizzes(String courseId, String sectionId, String search) {
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();
        
        sql.append("SELECT COUNT(*) FROM lesson l ");
        sql.append("JOIN lesson_quiz lq ON l.id = lq.lesson_id ");
        sql.append("JOIN section s ON l.section_id = s.id ");
        sql.append("JOIN course c ON s.course_id = c.id ");
        sql.append("WHERE l.type = 'quiz' ");
        
        // Add filters
        if (sectionId != null && !sectionId.isEmpty()) {
            sql.append("AND l.section_id = ? ");
            params.add(Integer.parseInt(sectionId));
        } else if (courseId != null && !courseId.isEmpty()) {
            sql.append("AND s.course_id = ? ");
            params.add(Integer.parseInt(courseId));
        }
        
        if (search != null && !search.isEmpty()) {
            sql.append("AND (l.title LIKE ? OR l.description LIKE ?) ");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting quizzes: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }
    
    /**
     * Get paginated list of quizzes with additional information
     * @param courseId Course ID filter (optional)
     * @param sectionId Section ID filter (optional)
     * @param search Search term for quiz title (optional)
     * @param page Page number (1-based)
     * @param pageSize Number of items per page
     * @return List of maps containing quiz information
     */
    public List<Map<String, Object>> getQuizzesPaginated(String courseId, String sectionId, String search, int page, int pageSize) {
        List<Map<String, Object>> quizList = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();
        
        // Calculate offset
        int offset = (page - 1) * pageSize;
        
        // Build base query
        sql.append("SELECT l.id as lesson_id, l.title as lesson_title, l.description as lesson_description, ");
        sql.append("l.status as lesson_status, l.section_id, s.title as section_title, ");
        sql.append("c.id as course_id, c.name as course_name, lq.id as quiz_id, ");
        sql.append("(SELECT COUNT(*) FROM quiz_question q WHERE q.quiz_id = lq.id) as question_count ");
        sql.append("FROM lesson l ");
        sql.append("JOIN lesson_quiz lq ON l.id = lq.lesson_id ");
        sql.append("JOIN section s ON l.section_id = s.id ");
        sql.append("JOIN course c ON s.course_id = c.id ");
        sql.append("WHERE l.type = 'quiz' ");
        
        // Add filters
        if (sectionId != null && !sectionId.isEmpty()) {
            sql.append("AND l.section_id = ? ");
            params.add(Integer.parseInt(sectionId));
        } else if (courseId != null && !courseId.isEmpty()) {
            sql.append("AND s.course_id = ? ");
            params.add(Integer.parseInt(courseId));
        }
        
        if (search != null && !search.isEmpty()) {
            sql.append("AND (l.title LIKE ? OR l.description LIKE ?) ");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        // Add order by and pagination
        sql.append("ORDER BY c.name, s.title, l.title ");
        sql.append("LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Map<String, Object> quizInfo = new HashMap<>();
                
                // Create lesson object
                com.ocms.entity.Lesson lesson = new com.ocms.entity.Lesson();
                lesson.setId(resultSet.getInt("lesson_id"));
                lesson.setTitle(resultSet.getString("lesson_title"));
                lesson.setDescription(resultSet.getString("lesson_description"));
                lesson.setStatus(resultSet.getString("lesson_status"));
                lesson.setSectionId(resultSet.getInt("section_id"));
                lesson.setType("quiz");
                quizInfo.put("lesson", lesson);
                
                // Create section object
                com.ocms.entity.Section section = new com.ocms.entity.Section();
                section.setId(resultSet.getInt("section_id"));
                section.setTitle(resultSet.getString("section_title"));
                quizInfo.put("section", section);
                
                // Create course object
                com.ocms.entity.Course course = new com.ocms.entity.Course();
                course.setId(resultSet.getInt("course_id"));
                course.setName(resultSet.getString("course_name"));
                quizInfo.put("course", course);
                
                // Create quiz object
                LessonQuiz quiz = new LessonQuiz();
                quiz.setId(resultSet.getInt("quiz_id"));
                quiz.setLessonId(resultSet.getInt("lesson_id"));
                quizInfo.put("quiz", quiz);
                
                // Add question count
                quizInfo.put("questionCount", resultSet.getInt("question_count"));
                
                quizList.add(quizInfo);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting paginated quizzes: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            closeResources();
        }
        
        return quizList;
    }
} 