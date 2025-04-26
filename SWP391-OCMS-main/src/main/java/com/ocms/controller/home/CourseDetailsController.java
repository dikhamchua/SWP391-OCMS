package com.ocms.controller.home;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.ocms.dal.AccountDAO;
import com.ocms.dal.CategoryDAO;
import com.ocms.dal.CourseDAO;
import com.ocms.entity.Account;
import com.ocms.entity.Category;
import com.ocms.entity.Course;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CourseDetailsController", urlPatterns = { "/course-details" })
public class CourseDetailsController extends HttpServlet {

    private static final String COURSE_DETAILS_PAGE = "view/homepage/course_details.jsp";
    private final CourseDAO courseDAO = new CourseDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get course ID from request parameter
            String courseIdStr = request.getParameter("id");
            if (courseIdStr != null && !courseIdStr.isEmpty()) {
                int courseId = Integer.parseInt(courseIdStr);
                Course course = courseDAO.findById(courseId);

                if (course != null) {
                    // Tạo HashMap để lưu trữ tên category theo ID
                    Map<Integer, String> categoryMap = new HashMap<>();
                    List<Category> categories = categoryDAO.findAll();
                    for (Category category : categories) {
                        categoryMap.put(category.getId(), category.getName());
                    }
                    
                    // Tạo HashMap để lưu trữ tên user theo ID
                    Map<Integer, String> accountMap = new HashMap<>();
                    List<Account> accounts = accountDAO.findAll();
                    for (Account account : accounts) {
                        accountMap.put(account.getId(), account.getFullName());
                    }
                    
                    request.setAttribute("course", course);
                    request.setAttribute("categoryMap", categoryMap);
                    request.setAttribute("accountMap", accountMap);
                    
                    request.getRequestDispatcher(COURSE_DETAILS_PAGE).forward(request, response);
                } else {
                    // Handle course not found
                    response.sendRedirect("404.jsp");
                }
            } else {
                // Handle missing course ID
                response.sendRedirect("404.jsp");
            }
        } catch (NumberFormatException e) {
            // Handle invalid course ID format
            response.sendRedirect("404.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/homepage/home.jsp").forward(request, response);
    }

}
