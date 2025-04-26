package com.ocms.controller.student;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.CategoryDAO;
import com.ocms.dal.CourseDAO;
import com.ocms.dal.RegistrationDAO;
import com.ocms.entity.Account;
import com.ocms.entity.Category;
import com.ocms.entity.Course;
import com.ocms.entity.Registration;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@WebServlet(name = "MyCoursesController", urlPatterns = {"/my-courses"})
public class MyCoursesController extends HttpServlet {

    private CourseDAO courseDAO = new CourseDAO();
    private RegistrationDAO registrationDAO = new RegistrationDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        // Check if user is logged in
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        // Get filter parameters
        String categoryId = request.getParameter("category");
        String search = request.getParameter("search");
        
        // Pagination parameters
        int page = 1;
        int pageSize = 6; // Hiển thị 6 khóa học mỗi trang
        
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            if (request.getParameter("pageSize") != null) {
                pageSize = Integer.parseInt(request.getParameter("pageSize"));
            }
        } catch (NumberFormatException e) {
            // Use default values if parsing fails
        }
        
        // Lấy danh sách khóa học đã đăng ký với bộ lọc
        List<Course> myCourses = courseDAO.findCourseByStudentIdWithFilters(
                account.getId(), categoryId, search, page, pageSize);
        
        // Tính tổng số khóa học và số trang
        int totalCourses = courseDAO.getTotalCoursesByStudentIdWithFilters(
                account.getId(), categoryId, search);
        int totalPages = (int) Math.ceil((double) totalCourses / pageSize);
        
        // Đảm bảo trang hiện tại nằm trong phạm vi hợp lệ
        if (page < 1) {
            page = 1;
        } else if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        
        // lấy thông tin đăng ký của sinh viên
        List<Registration> registrations = registrationDAO.findByStudentId(account.getId());
        HashMap<Integer, String> registrationMap = new HashMap<>();
        for (Registration registration : registrations) {
            registrationMap.put(registration.getCourseId(), registration.getStatus());
        }
        // Lấy danh sách danh mục để hiển thị trong bộ lọc
        List<Category> categories = categoryDAO.findAll();
        
        // Set attributes for the JSP
        request.setAttribute("registrationMap", registrationMap);
        request.setAttribute("myCourses", myCourses);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCourses", totalCourses);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("search", search);
        
        // Forward to the JSP page
        request.getRequestDispatcher("view/homepage/my-courses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle any POST requests if needed
        doGet(request, response);
    }
}