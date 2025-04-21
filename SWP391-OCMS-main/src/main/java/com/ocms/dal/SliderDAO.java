package com.ocms.dal;

import com.ocms.entity.Slider;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;
import java.time.LocalDateTime;

public class SliderDAO extends DBContext implements I_DAO<Slider> {

    @Override
    public List<Slider> findAll() {
        List<Slider> sliders = new ArrayList<>();
        String sql = "SELECT * FROM slider";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                sliders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding sliders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return sliders;
    }

    @Override
    public boolean update(Slider slider) {
        String sql = "UPDATE slider SET title = ?, image_url = ?, backlink = ?, "
                + "status = ?, notes = ?, updated_at = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, slider.getTitle());
            statement.setString(2, slider.getImageUrl());
            statement.setString(3, slider.getBacklink());
            statement.setString(4, slider.getStatus());
            statement.setString(5, slider.getNotes());
            statement.setObject(6, LocalDateTime.now());
            statement.setInt(7, slider.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating slider: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Slider slider) {
        String sql = "DELETE FROM slider WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, slider.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting slider: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(Slider slider) {
        String sql = "INSERT INTO slider (title, image_url, backlink, status, notes, "
                + "created_by, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            LocalDateTime now = LocalDateTime.now();

            statement.setString(1, slider.getTitle());
            statement.setString(2, slider.getImageUrl());
            statement.setString(3, slider.getBacklink());
            statement.setString(4, slider.getStatus() != null ? slider.getStatus() : "Active");
            statement.setString(5, slider.getNotes());
            statement.setInt(6, slider.getCreatedBy());
            statement.setObject(7, now);
            statement.setObject(8, now);

            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating slider failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating slider failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting slider: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public Slider getFromResultSet(ResultSet rs) throws SQLException {
        return Slider.builder()
                .id(rs.getInt("id"))
                .title(rs.getString("title"))
                .imageUrl(rs.getString("image_url"))
                .backlink(rs.getString("backlink"))
                .status(rs.getString("status"))
                .notes(rs.getString("notes"))
                .createdBy(rs.getInt("created_by"))
                .createdAt(rs.getObject("created_at", LocalDateTime.class))
                .updatedAt(rs.getObject("updated_at", LocalDateTime.class))
                .build();
    }

    public Slider findById(int id) {
        String sql = "SELECT * FROM slider WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding slider by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<Slider> findActiveSliders() {
        List<Slider> sliders = new ArrayList<>();
        String sql = "SELECT * FROM slider WHERE status = 'Active' ORDER BY created_at DESC";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                sliders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding active sliders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return sliders;
    }

    public List<Slider> findSlidersWithFilters(String searchFilter, String statusFilter, int page, int pageSize) {
        List<Slider> sliders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM slider WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Add search filter
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR notes LIKE ?)");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(statusFilter);
        }

        // Add pagination
        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
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
                sliders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding sliders with filters: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return sliders;
    }

    public int getTotalSliders(String searchFilter, String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM slider WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Add search filter
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR notes LIKE ?)");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(statusFilter);
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
            System.out.println("Error getting total sliders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }
}
