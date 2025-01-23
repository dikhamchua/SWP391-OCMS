
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ocms.dal;

import com.ocms.config.GlobalConfig;
import com.ocms.entity.Account;
import java.sql.*;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author ADMIN
 */
public class AccountDAO extends DBContext implements I_DAO<Account> {

    @Override
    public List<Account> findAll() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM Account";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                accounts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return accounts;
    }

    @Override
    public boolean update(Account account) {
        String sql = "UPDATE Account SET username = ?, password = ?, email = ?, phone = ?, " +
                "full_name = ?, gender = ?, avatar = ?, is_active = ?, role_id = ? WHERE id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, account.getUsername());
            statement.setString(2, account.getPassword());
            statement.setString(3, account.getEmail());
            statement.setString(4, account.getPhone());
            statement.setString(5, account.getFullName());
            statement.setBoolean(6, account.getGender());
            statement.setString(7, account.getAvatar());
            statement.setBoolean(8, account.getIsActive());
            statement.setInt(9, account.getRoleId());
            statement.setInt(10, account.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating account: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Account t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
        // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(Account account) {
        String sql = "INSERT INTO Account (username, password, email, phone, full_name, " +
                "gender, avatar, is_active, role_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, account.getUsername());
            statement.setString(2, account.getPassword());
            statement.setString(3, account.getEmail());
            statement.setString(4, account.getPhone());
            statement.setString(5, account.getFullName());
            statement.setBoolean(6, account.getGender());
            statement.setString(7, account.getAvatar());
            statement.setBoolean(8, account.getIsActive());
            statement.setInt(9, account.getRoleId());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating account failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating account failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting account: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public Account getFromResultSet(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setId(rs.getInt("id"));
        account.setUsername(rs.getString("username"));
        account.setPassword(rs.getString("password"));
        account.setEmail(rs.getString("email"));
        account.setPhone(rs.getString("phone"));
        account.setFullName(rs.getString("full_name"));
        account.setGender(rs.getBoolean("gender"));
        account.setAvatar(rs.getString("avatar"));
        account.setIsActive(rs.getBoolean("is_active"));
        account.setRoleId(rs.getInt("role_id"));
        return account;
    }

    public List<Account> findAllNonAdminAccounts(int page, int pageSize) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM account WHERE role_id != ? ORDER BY id LIMIT ? OFFSET ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setObject(1, GlobalConfig.ROLE_ADMIN);
            statement.setInt(2, pageSize);
            statement.setInt(3, (page - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                accounts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding non-admin accounts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return accounts;
    }

    public int getTotalNonAdminAccounts() {
        String sql = "SELECT COUNT(*) FROM Account WHERE role_id != ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setObject(1, GlobalConfig.ROLE_ADMIN);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting non-admin accounts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public Account findByEmailOrUsernameAndPass(Account t) {
        String sql = "SELECT * FROM Account WHERE (email = ? OR username = ?) AND password = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getEmail());
            statement.setString(2, t.getUsername());
            statement.setString(3, t.getPassword());
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public Account findByEmail(Account t) {
        String sql = "SELECT * FROM Account WHERE email = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getEmail());
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public boolean activateAccount(int accountId) {
        String sql = "UPDATE Account SET Status = 'Active' WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error activating account: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean updatePassword(Account account) {
        String sql = "UPDATE Account SET Password = ? WHERE Email = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, account.getPassword());
            statement.setString(2, account.getEmail());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating password: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean updateProfileImage(Account account) {
        String sql = "UPDATE Account SET avatar = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, account.getAvatar());
            statement.setInt(2, account.getId());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating profile image: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Account findById(int accountId) {
        String sql = "SELECT * FROM Account WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding account by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public boolean deactivateAccount(int accountId) {
        String sql = "UPDATE Account SET Status = 'Inactive' WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deactivating account: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Map<Integer, String> findFullNames(Set<Integer> accountIds) {
        String sql = "SELECT id, full_name FROM Account WHERE id IN (" +
                accountIds.stream().map(String::valueOf).collect(Collectors.joining(",")) + ")";
        Map<Integer, String> authorNames = new HashMap<>();

        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                authorNames.put(resultSet.getInt("id"), resultSet.getString("full_name"));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting full names: " + ex.getMessage());
        } finally {
            closeResources();
        }

        return authorNames;
    }

    public List<Account> findAccountsWithFilters(String roleFilter, String genderFilter,
            String statusFilter, String searchFilter, int page, int pageSize) {
        List<Account> accounts = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Account WHERE role_id != ? ");
        List<Object> params = new ArrayList<>();
        params.add(GlobalConfig.ROLE_ADMIN);

        // Add filters to query
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append("AND role_id = ? ");
            params.add(Integer.parseInt(roleFilter));
        }

        if (genderFilter != null && !genderFilter.isEmpty()) {
            sql.append("AND gender = ? ");
            params.add(genderFilter.equals("2")); // 2 for male, 3 for female
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND is_active = ? ");
            params.add(Boolean.parseBoolean(statusFilter));
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND (email LIKE ? OR username LIKE ? OR full_name LIKE ?) ");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Add pagination
        sql.append("ORDER BY id LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                accounts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding filtered accounts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return accounts;
    }

    public int getTotalFilteredAccounts(String roleFilter, String genderFilter, 
            String statusFilter, String searchFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Account WHERE role_id != ? ");
        List<Object> params = new ArrayList<>();
        params.add(GlobalConfig.ROLE_ADMIN);

        // Add filters to query
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append("AND role_id = ? ");
            params.add(Integer.parseInt(roleFilter));
        }
        
        if (genderFilter != null && !genderFilter.isEmpty()) {
            sql.append("AND gender = ? ");
            params.add(genderFilter.equals("2")); // 2 for male, 3 for female
        }
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND is_active = ? ");
            params.add(Boolean.parseBoolean(statusFilter));
        }
        
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND (email LIKE ? OR username LIKE ? OR full_name LIKE ?) ");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
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
            System.out.println("Error counting filtered accounts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public static void main(String[] args) {
        AccountDAO accountDAO = new AccountDAO();

    }

}
