package com.ocms.dal;

import com.ocms.entity.Blog;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;
import java.time.LocalDateTime;

public class BlogDAO extends DBContext implements I_DAO<Blog> {

    @Override
    public List<Blog> findAll() {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blog";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                blogs.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding blogs: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return blogs;
    }

    @Override
    public boolean update(Blog blog) {
        String sql = "UPDATE blog SET title = ?, thumbnail = ?, brief_info = ?, content = ?, "
                + "category_id = ?, author = ?, updated_date = ?, status = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, blog.getTitle());
            statement.setString(2, blog.getThumbnail());
            statement.setString(3, blog.getBriefInfo());
            statement.setString(4, blog.getContent());
            statement.setInt(5, blog.getCategoryId());
            statement.setObject(6, blog.getAuthor());
            statement.setObject(7, LocalDateTime.now());
            statement.setString(8, blog.getStatus());
            statement.setInt(9, blog.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating blog: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Blog blog) {
        String sql = "DELETE FROM blog WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, blog.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting blog: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(Blog blog) {
        String sql = "INSERT INTO blog (title, thumbnail, brief_info, content, category_id, "
                + "author, created_date, updated_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            LocalDateTime now = LocalDateTime.now();

            statement.setString(1, blog.getTitle());
            statement.setString(2, blog.getThumbnail());
            statement.setString(3, blog.getBriefInfo());
            statement.setString(4, blog.getContent());
            statement.setInt(5, blog.getCategoryId());
            statement.setObject(6, blog.getAuthor());
            statement.setObject(7, now);
            statement.setObject(8, now);
            statement.setString(9, blog.getStatus() != null ? blog.getStatus() : "Active");

            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating blog failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating blog failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting blog: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public Blog getFromResultSet(ResultSet rs) throws SQLException {
        return Blog.builder()
                .id(rs.getInt("id"))
                .title(rs.getString("title"))
                .thumbnail(rs.getString("thumbnail"))
                .briefInfo(rs.getString("brief_info"))
                .content(rs.getString("content"))
                .categoryId(rs.getInt("category_id"))
                .author(rs.getInt("author"))
                .createdDate(rs.getObject("created_date", LocalDateTime.class))
                .updatedDate(rs.getObject("updated_date", LocalDateTime.class))
                .status(rs.getString("status"))
                .build();
    }

    public Blog findById(int id) {
        String sql = "SELECT * FROM blog WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding blog by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<Blog> findByCategory(int categoryId) {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blog WHERE category_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                blogs.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding blogs by category: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return blogs;
    }

    public List<Blog> findBlogsWithFilters(String searchTerm, String status, Integer categoryId,
            int page, int pageSize) {
        List<Blog> blogs = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM blog WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (title LIKE ? OR brief_info LIKE ? OR content LIKE ?) ");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(status);
        }

        if (categoryId != null) {
            sql.append("AND category_id = ? ");
            params.add(categoryId);
        }

        sql.append("ORDER BY created_date DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                blogs.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error searching blogs: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return blogs;
    }

    public int getTotalBlogs(String searchTerm, String status, Integer categoryId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM blog WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (title LIKE ? OR brief_info LIKE ? OR content LIKE ?) ");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(status);
        }

        if (categoryId != null) {
            sql.append("AND category_id = ? ");
            params.add(categoryId);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting blogs: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }
}
