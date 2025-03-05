/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ocms.dal;

import com.ocms.entity.Setting;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;

/**
 *
 * @author ADMIN
 */
public class SettingDAO extends DBContext implements I_DAO<Setting> {

    @Override
    public List<Setting> findAll() {
        List<Setting> settings = new ArrayList<>();
        String sql = "SELECT * FROM setting";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                settings.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding settings: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return settings;
    }

    @Override
    public boolean update(Setting setting) {
        String sql = "UPDATE setting SET type = ?, value = ?, `order` = ?, status = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, setting.getType());
            statement.setString(2, setting.getValue());
            statement.setInt(3, setting.getOrder());
            statement.setString(4, setting.getStatus());
            statement.setInt(5, setting.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating setting: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Setting setting) {
        String sql = "DELETE FROM setting WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, setting.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting setting: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(Setting setting) {
        String sql = "INSERT INTO setting (type, value, `order`, status) VALUES (?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, setting.getType());
            statement.setString(2, setting.getValue());
            statement.setInt(3, setting.getOrder());
            statement.setString(4, setting.getStatus());

            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating setting failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating setting failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting setting: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public Setting getFromResultSet(ResultSet rs) throws SQLException {
        return Setting.builder()
                .id(rs.getInt("id"))
                .type(rs.getString("type"))
                .value(rs.getString("value"))
                .order(rs.getInt("order"))
                .status(rs.getString("status"))
                .createdAt(rs.getString("created_at"))
                .updatedAt(rs.getString("updated_at"))
                .build();
    }

    public List<Setting> findByType(String type) {
        List<Setting> settings = new ArrayList<>();
        String sql = "SELECT * FROM setting WHERE type = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, type);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                settings.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding settings by type: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return settings;
    }

    public Setting findById(int id) {
        String sql = "SELECT * FROM setting WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding setting by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<Setting> findSettingsWithFilters(String typeFilter, String statusFilter,
            String searchFilter, int page, int pageSize) {
        List<Setting> settings = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM setting WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // Add filters to query
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append("AND type = ? ");
            params.add(typeFilter);
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(statusFilter);
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND (value LIKE ? OR type LIKE ?) ");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Add pagination
        sql.append("ORDER BY `order` LIMIT ? OFFSET ?");
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
                settings.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding filtered settings: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return settings;
    }

    public int getTotalFilteredSettings(String typeFilter, String statusFilter, String searchFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM setting WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // Add filters to query
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql.append("AND type = ? ");
            params.add(typeFilter);
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(statusFilter);
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND (value LIKE ? OR type LIKE ?) ");
            String searchPattern = "%" + searchFilter.trim() + "%";
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
            System.out.println("Error counting filtered settings: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

}
