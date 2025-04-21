package com.ocms.dal;

import com.ocms.entity.Cart;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Cart entity
 */
public class CartDAO extends DBContext implements I_DAO<Cart> {

    @Override
    public List<Cart> findAll() {
        List<Cart> carts = new ArrayList<>();
        String sql = "SELECT * FROM cart";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                carts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all carts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return carts;
    }

    @Override
    public boolean update(Cart cart) {
        String sql = "UPDATE cart SET account_id = ?, modified_date = NOW(), status = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cart.getAccountId());
            statement.setInt(2, cart.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating cart: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Cart cart) {
        String sql = "DELETE FROM cart WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, cart.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting cart: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(Cart cart) {
        String sql = "INSERT INTO cart (account_id, created_date, modified_date) VALUES (?, NOW(), NOW())";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, cart.getAccountId());
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating cart failed, no rows affected.");
            }
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating cart failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting cart: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public Cart getFromResultSet(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setId(rs.getInt("id"));
        cart.setAccountId(rs.getInt("account_id"));
        cart.setCreatedDate(rs.getDate("created_date"));
        cart.setModifiedDate(rs.getDate("modified_date"));
        return cart;
    }
    
    /**
     * Find cart by account ID
     * @param accountId The account ID to search for
     * @return The cart for the specified account, or null if not found
     */
    public Cart findByAccountId(Integer accountId) {
        String sql = "SELECT * FROM cart WHERE account_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding cart by account ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
    
    /**
     * Get or create a cart for an account
     * @param accountId The account ID
     * @return The existing or newly created cart
     */
    public Cart getOrCreateCart(Integer accountId) {
        Cart cart = findByAccountId(accountId);
        if (cart == null) {
            cart = new Cart();
            cart.setAccountId(accountId);
            int cartId = insert(cart);
            if (cartId > 0) {
                cart.setId(cartId);
            }
        }
        return cart;
    }
} 