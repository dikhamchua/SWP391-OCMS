package com.ocms.dal;

import com.ocms.entity.Section;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SectionDAO extends DBContext {
    
    public List<Section> getByCourseId(Integer courseId) {
        List<Section> sections = new ArrayList<>();
        String sql = "SELECT * FROM section WHERE course_id = ? AND status = 'active' ORDER BY order_number";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, courseId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                sections.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting sections by course ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return sections;
    }
    
    public Section getById(Integer id) {
        String sql = "SELECT * FROM section WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting section by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return null;
    }
    
    public Integer insert(Section section) {
        String sql = "INSERT INTO section (course_id, title, description, order_number, status, created_date, modified_date) "
                + "VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, section.getCourseId());
            statement.setString(2, section.getTitle());
            statement.setString(3, section.getDescription());
            statement.setInt(4, section.getOrderNumber());
            statement.setString(5, section.getStatus());
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating section failed, no rows affected.");
            }
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating section failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting section: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }
    
    public boolean update(Section section) {
        String sql = "UPDATE section SET course_id = ?, title = ?, description = ?, order_number = ?, "
                + "status = ?, modified_date = NOW() WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, section.getCourseId());
            statement.setString(2, section.getTitle());
            statement.setString(3, section.getDescription());
            statement.setInt(4, section.getOrderNumber());
            statement.setString(5, section.getStatus());
            statement.setInt(6, section.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating section: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    public boolean delete(Integer id) {
        String sql = "UPDATE section SET status = 'inactive', modified_date = NOW() WHERE id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting section: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    public Section getFromResultSet(ResultSet rs) throws SQLException {
        Section section = new Section();
        section.setId(rs.getInt("id"));
        section.setCourseId(rs.getInt("course_id"));
        section.setTitle(rs.getString("title"));
        section.setDescription(rs.getString("description"));
        section.setOrderNumber(rs.getInt("order_number"));
        section.setStatus(rs.getString("status"));
        section.setCreatedDate(rs.getDate("created_date"));
        section.setModifiedDate(rs.getDate("modified_date"));
        return section;
    }
    
    public int countSectionsByCourseId(Integer courseId) {
        String sql = "SELECT COUNT(*) FROM section WHERE course_id = ? AND status = 'active'";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, courseId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting sections: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }
    
    public int getMaxOrderNumberByCourseId(Integer courseId) {
        String sql = "SELECT MAX(order_number) FROM section WHERE course_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, courseId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting max order number: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }
} 