package com.ocms.dal;

import com.ocms.entity.BlogCategory;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;
import java.time.LocalDateTime;

public class BlogCategoryDAO extends DBContext implements I_DAO<BlogCategory> {

    @Override
    public List<BlogCategory> findAll() {
        List<BlogCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM blog_category";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding blog categories: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return categories;
    }

    @Override
    public boolean update(BlogCategory category) {
        String sql = "UPDATE blog_category SET name = ?, description = ?, updated_at = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setObject(3, LocalDateTime.now());
            statement.setObject(4, category.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating blog category: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(BlogCategory category) {
        String sql = "DELETE FROM blog_category WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setObject(1, category.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting blog category: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(BlogCategory category) {
        String sql = "INSERT INTO blog_category (name, description, created_at, updated_at) VALUES (?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            LocalDateTime now = LocalDateTime.now();
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setObject(3, now);
            statement.setObject(4, now);

            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating blog category failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating blog category failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting blog category: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public BlogCategory getFromResultSet(ResultSet rs) throws SQLException {
        return BlogCategory.builder()
                .id(rs.getInt("id"))
                .name(rs.getString("name"))
                .description(rs.getString("description"))
                .createdAt(rs.getObject("created_at", LocalDateTime.class))
                .updatedAt(rs.getObject("updated_at", LocalDateTime.class))
                .build();
    }

    public BlogCategory findById(Long id) {
        String sql = "SELECT * FROM blog_category WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setObject(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding blog category by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<BlogCategory> findByName(String name) {
        List<BlogCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM blog_category WHERE name LIKE ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, "%" + name + "%");
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding blog categories by name: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return categories;
    }
}
