package com.ocms.dal;

import com.ocms.entity.Registration;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegistrationDAO extends DBContext implements I_DAO<Registration> {

    @Override
    public List<Registration> findAll() {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT * FROM registration";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                registrations.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return registrations;
    }

    @Override
    public boolean update(Registration registration) {
        String sql = "UPDATE registration SET email = ?, account_id = ?, registration_time = ?, category_id = ?, " +
                "package = ?, total_cost = ?, status = ?, valid_from = ?, valid_to = ?, last_updated_by = ? WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, registration.getEmail());
            ps.setInt(2, registration.getAccountId());
            ps.setTimestamp(3, registration.getRegistrationTime());
            ps.setInt(4, registration.getCategoryId());
            ps.setString(5, registration.getPackages());
            ps.setObject(6, registration.getTotalCost());
            ps.setString(7, registration.getStatus());
            ps.setTimestamp(8, registration.getValidFrom());
            ps.setTimestamp(9, registration.getValidTo());
            ps.setInt(10, registration.getLastUpdateByPerson());
            ps.setInt(11, registration.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(Registration registration) {
        String sql = "DELETE FROM registration WHERE id = ?";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, registration.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public int insert(Registration registration) {
        String sql = "INSERT INTO registration (email, account_id, registration_time, category_id, package, " +
                "total_cost, status, valid_from, valid_to, last_updated_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, registration.getEmail());
            ps.setInt(2, registration.getAccountId());
            ps.setTimestamp(3, registration.getRegistrationTime());
            ps.setInt(4, registration.getCategoryId());
            ps.setString(5, registration.getPackages());
            ps.setBigDecimal(6, registration.getTotalCost());
            ps.setString(7, registration.getStatus());
            ps.setTimestamp(8, registration.getValidFrom());
            ps.setTimestamp(9, registration.getValidTo());
            ps.setInt(10, registration.getLastUpdateByPerson());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public Registration getFromResultSet(ResultSet resultSet) throws SQLException {
        Registration registration = new Registration();
        registration.setId(resultSet.getInt("id"));
        registration.setEmail(resultSet.getString("email"));
        registration.setAccountId(resultSet.getInt("account_id"));
        registration.setRegistrationTime(resultSet.getTimestamp("registration_time"));
        registration.setCategoryId(resultSet.getInt("category_id"));
        registration.setPackages(resultSet.getString("package"));
        registration.setTotalCost(resultSet.getBigDecimal("total_cost"));
        registration.setStatus(resultSet.getString("status"));
        registration.setValidFrom(resultSet.getTimestamp("valid_from"));
        registration.setValidTo(resultSet.getTimestamp("valid_to"));
        registration.setLastUpdateByPerson(resultSet.getInt("last_updated_by"));
        return registration;
    }

     public static void main(String[] args) {
            // Tạo đối tượng RegistrationDAO để thao tác với cơ sở dữ liệu
            RegistrationDAO registrationDAO = new RegistrationDAO();

            // 1. Thêm mới một bản ghi (Insert)
            Registration newRegistration = new Registration();
            newRegistration.setEmail("john.doe@example.com");
            newRegistration.setAccountId(1);
            newRegistration.setRegistrationTime(new Timestamp(System.currentTimeMillis()));
            newRegistration.setCategoryId(2);
            newRegistration.setPackages("Standard");
            newRegistration.setTotalCost(new BigDecimal("199.99"));
            newRegistration.setStatus("Active");
            newRegistration.setValidFrom(new Timestamp(System.currentTimeMillis()));
            newRegistration.setValidTo(new Timestamp(System.currentTimeMillis() + 10000000));  // Một khoảng thời gian giả
            newRegistration.setLastUpdateByPerson(1);

            int insertedId = registrationDAO.insert(newRegistration);
            System.out.println("Inserted new registration with ID: " + insertedId);

            // 2. Lấy tất cả bản ghi (Find All)
            List<Registration> registrations = registrationDAO.findAll();
            System.out.println("All registrations: ");
            for (Registration reg : registrations) {
                System.out.println(reg);
            }

            // 3. Cập nhật một bản ghi (Update)
            if (!registrations.isEmpty()) {
                Registration regToUpdate = registrations.get(0); // Lấy bản ghi đầu tiên để cập nhật
                regToUpdate.setEmail("new.email@example.com");
                regToUpdate.setTotalCost(new BigDecimal("299.99"));

                boolean isUpdated = registrationDAO.update(regToUpdate);
                if (isUpdated) {
                    System.out.println("Updated registration with ID: " + regToUpdate.getId());
                } else {
                    System.out.println("Update failed for registration with ID: " + regToUpdate.getId());
                }
            }

            // 4. Xóa một bản ghi (Delete)
            if (!registrations.isEmpty()) {
                Registration regToDelete = registrations.get(0); // Lấy bản ghi đầu tiên để xóa
                boolean isDeleted = registrationDAO.delete(regToDelete);
                if (isDeleted) {
                    System.out.println("Deleted registration with ID: " + regToDelete.getId());
                } else {
                    System.out.println("Delete failed for registration with ID: " + regToDelete.getId());
                }
            }
        }

    public List<Registration> getRegistrationsByFilter(String search, String category, 
            String status, String fromDate, String toDate, int page, int pageSize) {
        List<Registration> registrations = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.* FROM registration r " +
            "LEFT JOIN account a ON r.account_id = a.id " +
            "WHERE 1=1"
        );
        
        List<Object> parameters = new ArrayList<>();

        // Add search condition
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (a.full_name LIKE ? OR a.email LIKE ?)");
            parameters.add("%" + search + "%");
            parameters.add("%" + search + "%");
        }

        // Add category condition
        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND r.category_id = ?");
            parameters.add(Integer.parseInt(category));
        }

        // Add status condition
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.status = ?");
            parameters.add(status);
        }

        // Add date range conditions
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND r.valid_from >= ?");
            parameters.add(fromDate + " 00:00:00");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND r.valid_to <= ?");
            parameters.add(toDate + " 23:59:59");
        }

        // Add pagination
        sql.append(" ORDER BY r.registration_time DESC LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    registrations.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error executing query: " + e.getMessage());
            e.printStackTrace();
        }
        return registrations;
    }

    // Helper methods to get related information
    

    public int getTotalRegistrationsByFilter(String search, String category, String status, String fromDate,
            String toDate) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM registration r " +
            "LEFT JOIN account a ON r.account_id = a.id " +
            "WHERE 1=1"
        );
        
        List<Object> parameters = new ArrayList<>();

        // Add search condition
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (a.full_name LIKE ? OR a.email LIKE ?)");
            parameters.add("%" + search + "%");
            parameters.add("%" + search + "%");
        }

        // Add category condition
        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND r.category_id = ?");
            parameters.add(Integer.parseInt(category));
        }

        // Add status condition
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.status = ?");
            parameters.add(status);
        }

        // Add date range conditions
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND r.valid_from >= ?");
            parameters.add(fromDate + " 00:00:00");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND r.valid_to <= ?");
            parameters.add(toDate + " 23:59:59");
        }

        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Find a registration by its ID
     * @param id The ID of the registration to find
     * @return The Registration object if found, null otherwise
     */
    public Registration findById(int id) {
        String sql = "SELECT * FROM registration WHERE id = ?";
        
        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error finding registration by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

}