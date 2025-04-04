package com.ocms.dal;

import com.ocms.entity.Category;

import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class CategoryDAO extends DBContext implements I_DAO<Category> {
    
    @Override
    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM category";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return categories;
    }

    @Override
    public boolean update(Category category) {
        String sql = "UPDATE category SET name = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, category.getName());
            statement.setInt(2, category.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating category: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(Category category) {
        String sql = "INSERT INTO category (name) VALUES (?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, category.getName());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating category failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating category failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting category: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Category category) {
        String sql = "DELETE FROM category WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, category.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting category: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public Category getFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        return category;
    }

    public Category findById(int categoryId) {
        String sql = "SELECT * FROM category WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding category by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public Category findByName(String categoryName) {
        String sql = "SELECT * FROM category WHERE name = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, categoryName);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding category by name: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public Map<Integer, String> findNames(Set<Integer> categoryIds) {
        Map<Integer, String> categoryNames = new HashMap<>();
        if (categoryIds.isEmpty()) {
            return categoryNames;
        }

        String sql = "SELECT id, name FROM category WHERE id IN (" + 
                    String.join(",", Collections.nCopies(categoryIds.size(), "?")) + ")";
        
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            int index = 1;
            for (Integer id : categoryIds) {
                statement.setInt(index++, id);
            }
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categoryNames.put(resultSet.getInt("id"), resultSet.getString("name"));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding category names: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return categoryNames;
    }

    public static void main(String[] args) {
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.findAll();
        for (Category category : categories) {
            System.out.println(category);
        }
    }
    public String getCategoryName(int categoryId) {
        String sql = "SELECT name FROM category WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("name");
            }
        } catch (SQLException ex) {
            System.out.println("Error getting category name: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
}