
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ocms.dal;

import com.ocms.config.GlobalConfig;
import com.ocms.entity.Account;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

/**
 *
 * @author ADMIN
 */
public class AccountDAO extends DBContext implements I_DAO<Account> {

    @Override
    public List<Account> findAll() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM Account";
        try (PreparedStatement statement = connection.prepareStatement(sql); ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                accounts.add(getFromResultSet(rs));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return accounts;
    }

    @Override
    public boolean update(Account account) {
        String sql = "UPDATE Account SET username = ?, password = ?, email = ?, phone = ?, " +
                "full_name = ?, gender = ?, avatar = ?, is_active = ?, role_id = ? WHERE id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
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

        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating account failed, no ID obtained.");
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting account: " + ex.getMessage());
            return -1; // Return -1 to indicate failure
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
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setObject(1, GlobalConfig.ROLE_ADMIN);
            statement.setInt(2, pageSize);
            statement.setInt(3, (page - 1) * pageSize);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    accounts.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error finding non-admin accounts: " + ex.getMessage());
        }
        return accounts;
    }

    public int getTotalNonAdminAccounts() {
        String sql = "SELECT COUNT(*) FROM Account WHERE role_id != ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql); 
            statement.setObject(1, GlobalConfig.ROLE_ADMIN);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting non-admin accounts: " + ex.getMessage());
        }
        return 0;
    }

    public Account findByEmailOrUsernameAndPass(Account t) {
        String sql = "SELECT * FROM Account WHERE (email = ? OR username = ?) AND password = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, t.getEmail());
            statement.setString(2, t.getUsername());
            statement.setString(3, t.getPassword());
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return null;
    }

    public Account findByEmail(Account t) {
        String sql = "SELECT * FROM Account WHERE email = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, t.getEmail());
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
        return null;
    }

    public boolean activateAccount(int accountId) {
        String sql = "UPDATE Account SET Status = 'Active' WHERE id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accountId);

            int affectedRows = statement.executeUpdate();

            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error activating account: " + ex.getMessage());
            return false;
        }
    }

    public boolean updatePassword(Account account) {
        String sql = "UPDATE Account SET Password = ? WHERE Email = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, account.getPassword());
            statement.setString(2, account.getEmail());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating password: " + ex.getMessage());
            return false;
        }
    }

    public boolean updateProfileImage(Account account) {
        String sql = "UPDATE Account SET avatar = ? WHERE id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, account.getAvatar());
            statement.setInt(2, account.getId());

            int affectedRows = statement.executeUpdate();

            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating profile image: " + ex.getMessage());
            return false;
        }
    }

    public Account findById(int accountId) {
        String sql = "SELECT * FROM Account WHERE id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accountId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error finding account by ID: " + ex.getMessage());
        }
        return null;
    }

    public boolean deactivateAccount(int accountId) {
        String sql = "UPDATE Account SET Status = 'Inactive' WHERE id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, accountId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deactivating account: " + ex.getMessage());
            return false;
        }
    }

    public static void main(String[] args) {
        AccountDAO accountDAO = new AccountDAO();

        // accountDAO.findAllNonAdminAccounts(1, 10).stream().forEach(item -> {
        // System.out.println(item);
        // });
        int page = 1; // Trang muốn lấy
        int pageSize = 10; // Số lượng bản ghi trên mỗi trang
        List<Account> accounts = accountDAO.findAllNonAdminAccounts(page, pageSize);

        // In kết quả
        System.out.println("Non-admin accounts on page " + page + ":");
        System.out.println(accounts.size());
        for (Account account : accounts) {
            System.out.println(account);
        }
    }

}
