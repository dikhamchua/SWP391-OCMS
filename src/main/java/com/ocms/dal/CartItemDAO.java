package com.ocms.dal;

import com.ocms.entity.CartItem;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for CartItem entity
 */
public class CartItemDAO extends DBContext implements I_DAO<CartItem> {

    @Override
    public List<CartItem> findAll() {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT * FROM cart_item";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                cartItems.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all cart items: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return cartItems;
    }

    @Override
    public boolean update(CartItem cartItem) {
        String sql = "UPDATE cart_item SET cart_id = ?, course_id = ?, price = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartItem.getCartId());
            statement.setInt(2, cartItem.getCourseId());
            statement.setBigDecimal(3, cartItem.getPrice());
            statement.setInt(4, cartItem.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating cart item: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(CartItem cartItem) {
        String sql = "DELETE FROM cart_item WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartItem.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting cart item: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(CartItem cartItem) {
        String sql = "INSERT INTO cart_item (cart_id, course_id, price, added_date) VALUES (?, ?, ?, NOW())";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, cartItem.getCartId());
            statement.setInt(2, cartItem.getCourseId());
            statement.setBigDecimal(3, cartItem.getPrice());
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating cart item failed, no rows affected.");
            }
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating cart item failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting cart item: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public CartItem getFromResultSet(ResultSet rs) throws SQLException {
        CartItem cartItem = new CartItem();
        cartItem.setId(rs.getInt("id"));
        cartItem.setCartId(rs.getInt("cart_id"));
        cartItem.setCourseId(rs.getInt("course_id"));
        cartItem.setPrice(rs.getBigDecimal("price"));
        cartItem.setAddedDate(rs.getDate("added_date"));
        return cartItem;
    }
    
    /**
     * Find all cart items by cart ID
     * @param cartId The cart ID to search for
     * @return List of cart items for the specified cart
     */
    public List<CartItem> findByCartId(Integer cartId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT * FROM cart_item WHERE cart_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                cartItems.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding cart items by cart ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return cartItems;
    }
    
    /**
     * Check if a course is already in the cart
     * @param cartId The cart ID
     * @param courseId The course ID
     * @return true if the course is in the cart, false otherwise
     */
    public boolean isInCart(Integer cartId, Integer courseId) {
        String sql = "SELECT COUNT(*) FROM cart_item WHERE cart_id = ? AND course_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            statement.setInt(2, courseId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking if course is in cart: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }
    
    /**
     * Remove a course from the cart
     * @param cartId The cart ID
     * @param courseId The course ID
     * @return true if successful, false otherwise
     */
    public boolean removeFromCart(Integer cartId, Integer courseId) {
        String sql = "DELETE FROM cart_item WHERE cart_id = ? AND course_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            statement.setInt(2, courseId);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error removing course from cart: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    /**
     * Get the total price of all items in a cart
     * @param cartId The cart ID
     * @return The total price
     */
    public BigDecimal getCartTotal(Integer cartId) {
        String sql = "SELECT SUM(price) FROM cart_item WHERE cart_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                BigDecimal total = resultSet.getBigDecimal(1);
                return total != null ? total : BigDecimal.ZERO;
            }
        } catch (SQLException ex) {
            System.out.println("Error calculating cart total: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * Count the number of items in a cart
     * @param cartId The cart ID
     * @return The number of items
     */
    public int countCartItems(Integer cartId) {
        String sql = "SELECT COUNT(*) FROM cart_item WHERE cart_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting cart items: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }
    
    /**
     * Get cart items with course details
     * @param cartId The cart ID
     * @return List of cart items with course details
     */
    public List<CartItem> getCartItemsWithCourseDetails(Integer cartId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT ci.*, c.name as course_name, c.thumbnail as course_thumbnail " +
                     "FROM cart_item ci " +
                     "JOIN course c ON ci.course_id = c.id " +
                     "WHERE ci.cart_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cartId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                CartItem item = getFromResultSet(resultSet);
                // Additional course details could be added to a map or extended object if needed
                cartItems.add(item);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting cart items with course details: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return cartItems;
    }

    /**
     * Get cart item by ID
     * @param id The cart item ID
     * @return The cart item, or null if not found
     */
    public CartItem getById(Integer id) {
        String sql = "SELECT * FROM cart_item WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting cart item by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
} 