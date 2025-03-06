package com.ocms.dal;

import com.ocms.entity.Course;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.sql.Statement;

public class CourseDAO extends DBContext implements I_DAO<Course> {

    @Override
    public List<Course> findAll() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM course";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                courses.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return courses;
    }

    @Override
    public boolean update(Course course) {
        String sql = "UPDATE course SET name = ?, description = ?, thumbnail = ?, "
                + "rating = ?, price = ?, status = ?, modified_date = ?, category_id = ? WHERE id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setString(1, course.getName());
            statement.setString(2, course.getDescription());
            statement.setString(3, course.getThumbnail());
            statement.setInt(4, course.getRating());
            statement.setFloat(5, course.getPrice());
            statement.setString(6, course.getStatus());
            statement.setObject(7, course.getModifiedDate());
            statement.setInt(8, course.getCategoryId());
            statement.setInt(9, course.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating course: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(Course course) {
        String sql = "INSERT INTO course (name, description, thumbnail, rating, price, status, "
                + "created_date, modified_date, created_by, category_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, course.getName());
            statement.setString(2, course.getDescription());
            statement.setString(3, course.getThumbnail());
            statement.setInt(4, course.getRating());
            statement.setFloat(5, course.getPrice());
            statement.setString(6, course.getStatus());
            statement.setObject(7, course.getCreatedDate());
            statement.setObject(8, course.getModifiedDate());
            statement.setInt(9, course.getCreatedBy());
            statement.setInt(10, course.getCategoryId());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating course failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating course failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting course: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Course course) {
        String sql = "DELETE FROM course WHERE id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, course.getId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting course: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public Course getFromResultSet(ResultSet rs) throws SQLException {
        return Course.builder()
                .id(rs.getInt("id"))
                .name(rs.getString("name"))
                .description(rs.getString("description"))
                .thumbnail(rs.getString("thumbnail"))
                .rating(rs.getInt("rating"))
                .price(rs.getFloat("price"))
                .status(rs.getString("status"))
                .createdDate(rs.getTimestamp("created_date").toLocalDateTime()) // Chuyển đổi từ Timestamp
                .modifiedDate(rs.getTimestamp("modified_date").toLocalDateTime()) // Chuyển đổi từ Timestamp
                .createdBy(rs.getInt("created_by"))
                .categoryId(rs.getInt("category_id"))
                .build();
    }

    public Course findById(int courseId) {
        String sql = "SELECT * FROM course WHERE id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, courseId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding course by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<Course> findByCategoryId(int categoryId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM course WHERE category_id = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                courses.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding courses by category ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return courses;
    }

    public List<Course> findByCreator(int creatorId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM course WHERE created_by = ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(1, creatorId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                courses.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding courses by creator ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return courses;
    }

    public List<Course> findWithPagination(int pageNumber, int pageSize) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM course ORDER BY id LIMIT ? OFFSET ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setInt(2, (pageNumber - 1) * pageSize);
            statement.setInt(1, pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                courses.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error in pagination: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return courses;
    }

    public int getTotalRecords() {
        String sql = "SELECT COUNT(*) as total FROM course";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("total");
            }
        } catch (SQLException ex) {
            System.out.println("Error getting total records: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public int getTotalPages(int pageSize) {
        int totalRecords = getTotalRecords();
        return (int) Math.ceil((double) totalRecords / pageSize);
    }

    public List<Course> searchWithPagination(String keyword, int pageNumber, int pageSize) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM course WHERE name LIKE ? OR description LIKE ? "
                + "ORDER BY id LIMIT ? OFFSET ?";
        try {
            // Mở kết nối đến cơ sở dữ liệu
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);

            // Set các tham số
            statement.setString(1, "%" + keyword + "%"); // Tìm kiếm từ khóa trong name
            statement.setString(2, "%" + keyword + "%"); // Tìm kiếm từ khóa trong description
            statement.setInt(3, pageSize); // Số lượng bản ghi trên mỗi trang (LIMIT)
            statement.setInt(4, (pageNumber - 1) * pageSize); // OFFSET (bỏ qua số bản ghi)

            // Thực thi câu lệnh truy vấn
            resultSet = statement.executeQuery();

            // Lặp qua kết quả và chuyển đổi thành đối tượng Course
            while (resultSet.next()) {
                courses.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error in search with pagination: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return courses;
    }

    public int getTotalSearchResults(String keyword) {
        String sql = "SELECT COUNT(*) as total FROM course WHERE name LIKE ? OR description LIKE ?";
        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql);
            statement.setString(1, "%" + keyword + "%");
            statement.setString(2, "%" + keyword + "%");
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("total");
            }
        } catch (SQLException ex) {
            System.out.println("Error getting total search results: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public List<Course> findWithFilters(List<Integer> categoryIds, List<Integer> ratings,
            String keyword, String sort, int pageNumber, int pageSize) {
        List<Course> courses = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM course WHERE 1=1");
        List<Object> params = new ArrayList<>();
        String orderBy = "id";

        if (sort != null) {
            switch (sort) {
                // case "popularity":
                //     orderBy = "enroll_count DESC";
                //     break;
                case "average rating desc":
                    orderBy = "rating DESC";
                    break;
                case "average rating asc":
                    orderBy = "rating ASC";
                    break;
                case "latest":
                    orderBy = "created_date DESC";
                    break;
                case "earliest":
                    orderBy = "created_date ASC";
                    break;
            }
        }

        // Add category filter
        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql.append(" AND category_id IN (")
                    .append(String.join(",", Collections.nCopies(categoryIds.size(), "?")))
                    .append(")");
            params.addAll(categoryIds);
        }

        // Add rating filter
        if (ratings != null && !ratings.isEmpty()) {
            sql.append(" AND rating IN (")
                    .append(String.join(",", Collections.nCopies(ratings.size(), "?")))
                    .append(")");
            params.addAll(ratings);
        }

        // Add keyword search
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        // Add pagination
        sql.append(" ORDER BY ").append(orderBy).append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((pageNumber - 1) * pageSize);

        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                if (params.get(i) instanceof Integer) {
                    statement.setInt(i + 1, (Integer) params.get(i));
                } else {
                    statement.setString(i + 1, (String) params.get(i));
                }
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                courses.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error in filtered search: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return courses;
    }

    public int getTotalFilteredRecords(List<Integer> categoryIds, List<Integer> ratings, String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) as total FROM course WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Add filters similar to findWithFilters method
        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql.append(" AND category_id IN (")
                    .append(String.join(",", Collections.nCopies(categoryIds.size(), "?")))
                    .append(")");
            params.addAll(categoryIds);
        }

        if (ratings != null && !ratings.isEmpty()) {
            sql.append(" AND rating IN (")
                    .append(String.join(",", Collections.nCopies(ratings.size(), "?")))
                    .append(")");
            params.addAll(ratings);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        try {
            connection = new DBContext().connection;
            statement = connection.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                if (params.get(i) instanceof Integer) {
                    statement.setInt(i + 1, (Integer) params.get(i));
                } else {
                    statement.setString(i + 1, (String) params.get(i));
                }
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("total");
            }
        } catch (SQLException ex) {
            System.out.println("Error getting total filtered records: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public static void main(String[] args) {
        CourseDAO courseDAO = new CourseDAO();
        List<Course> courses = courseDAO.findAll();
        for (Course course : courses) {
            System.out.println(course);
        }
    }
}
