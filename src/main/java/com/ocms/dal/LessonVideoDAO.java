package com.ocms.dal;

import com.ocms.entity.LessonVideo;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for LessonVideo entity
 */
public class LessonVideoDAO extends DBContext {
    
    /**
     * Get a lesson video by lesson ID
     * @param lessonId The lesson ID
     * @return The LessonVideo object if found, null otherwise
     */
    public LessonVideo getByLessonId(int lessonId) {
        String sql = "SELECT * FROM lesson_video WHERE lesson_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, lessonId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting lesson video by lesson ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Get all lesson videos
     * @return List of all lesson videos
     */
    public List<LessonVideo> getAll() {
        List<LessonVideo> lessonVideos = new ArrayList<>();
        String sql = "SELECT * FROM lesson_video";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                lessonVideos.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all lesson videos: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return lessonVideos;
    }
    
    /**
     * Get lesson videos by provider
     * @param provider The video provider to filter by
     * @return List of lesson videos from the specified provider
     */
    public List<LessonVideo> getByProvider(String provider) {
        List<LessonVideo> lessonVideos = new ArrayList<>();
        String sql = "SELECT * FROM lesson_video WHERE video_provider = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, provider);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                lessonVideos.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting lesson videos by provider: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return lessonVideos;
    }
    
    /**
     * Insert a new lesson video record
     * @param lessonVideo The lesson video to insert
     * @return The ID of the inserted record, or -1 if insertion failed
     */
    public Integer insert(LessonVideo lessonVideo) {
        String sql = "INSERT INTO lesson_video (lesson_id, video_url, video_provider, video_duration) VALUES (?, ?, ?, ?)";
        Integer insertedId = -1;
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            statement.setInt(1, lessonVideo.getLessonId());
            statement.setString(2, lessonVideo.getVideoUrl());
            statement.setString(3, lessonVideo.getVideoProvider());
            
            // Handle null video duration
            if (lessonVideo.getVideoDuration() != null) {
                statement.setInt(4, lessonVideo.getVideoDuration());
            } else {
                statement.setNull(4, java.sql.Types.INTEGER);
            }
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows > 0) {
                // Get the generated ID
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    insertedId = resultSet.getInt(1);
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting lesson video: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return insertedId;
    }
    
    /**
     * Update an existing lesson video
     * @param lessonVideo The lesson video with updated values
     * @return true if update was successful, false otherwise
     */
    public boolean update(LessonVideo lessonVideo) {
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
    public boolean delete(int lessonId) {
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
     * Utility method to create a LessonVideo object from a ResultSet
     * @param rs The ResultSet containing lesson video data
     * @return A LessonVideo object populated with data from the ResultSet
     * @throws SQLException If there's an error accessing the ResultSet
     */
    public LessonVideo getFromResultSet(ResultSet rs) throws SQLException {
        LessonVideo lessonVideo = new LessonVideo();
        lessonVideo.setLessonId(rs.getInt("lesson_id"));
        lessonVideo.setVideoUrl(rs.getString("video_url"));
        lessonVideo.setVideoProvider(rs.getString("video_provider"));
        lessonVideo.setVideoDuration(rs.getInt("video_duration"));
        return lessonVideo;
    }
    
    /**
     * Main method for testing LessonVideoDAO functionality
     * @param args Command line arguments (not used)
     */
    public static void main(String[] args) {
        LessonVideoDAO lessonVideoDAO = new LessonVideoDAO();
        
        // Test getting all lesson videos
        System.out.println("=== All Lesson Videos ===");
        List<LessonVideo> allLessonVideos = lessonVideoDAO.getAll();
        for (LessonVideo video : allLessonVideos) {
            System.out.println("Lesson ID: " + video.getLessonId() + 
                    ", Provider: " + video.getVideoProvider() + 
                    ", URL: " + video.getVideoUrl());
        }
        
        // Test getting lesson video by lesson ID (assuming lesson ID 1 exists)
        System.out.println("\n=== Lesson Video for Lesson ID 1 ===");
        LessonVideo videoById = lessonVideoDAO.getByLessonId(1);
        if (videoById != null) {
            System.out.println("Provider: " + videoById.getVideoProvider());
            System.out.println("URL: " + videoById.getVideoUrl());
            System.out.println("Duration: " + videoById.getVideoDuration() + " minutes");
        } else {
            System.out.println("Lesson video for lesson ID 1 not found");
        }
        
        // Test getting lesson videos by provider
        System.out.println("\n=== YouTube Videos ===");
        List<LessonVideo> youtubeVideos = lessonVideoDAO.getByProvider("youtube");
        for (LessonVideo video : youtubeVideos) {
            System.out.println("Lesson ID: " + video.getLessonId() + 
                    ", URL: " + video.getVideoUrl());
        }
        
        // Uncomment to test insert, update, and delete operations
        /*
        // Test inserting a new lesson video
        System.out.println("\n=== Inserting New Lesson Video ===");
        LessonVideo newVideo = new LessonVideo();
        newVideo.setLessonId(999); // Use a test lesson ID
        newVideo.setVideoUrl("https://www.youtube.com/watch?v=test123");
        newVideo.setVideoProvider("youtube");
        newVideo.setVideoDuration(30);
        
        boolean insertSuccess = lessonVideoDAO.insert(newVideo);
        System.out.println("Lesson video insertion " + (insertSuccess ? "successful" : "failed"));
        
        // Test updating a lesson video
        if (insertSuccess) {
            System.out.println("\n=== Updating Lesson Video ===");
            LessonVideo updatedVideo = lessonVideoDAO.getByLessonId(999);
            updatedVideo.setVideoUrl("https://www.youtube.com/watch?v=updated123");
            updatedVideo.setVideoDuration(45);
            
            boolean updateSuccess = lessonVideoDAO.update(updatedVideo);
            System.out.println("Lesson video update " + (updateSuccess ? "successful" : "failed"));
            
            // Test deleting a lesson video
            System.out.println("\n=== Deleting Lesson Video ===");
            boolean deleteSuccess = lessonVideoDAO.delete(999);
            System.out.println("Lesson video deletion " + (deleteSuccess ? "successful" : "failed"));
        }
        */
    }
} 