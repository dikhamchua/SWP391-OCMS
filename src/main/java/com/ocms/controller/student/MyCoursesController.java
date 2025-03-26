package com.ocms.controller.student;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.CourseDAO;
import com.ocms.dal.RegistrationDAO;
import com.ocms.entity.Account;
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
import java.util.List;

@WebServlet(name = "MyCoursesController", urlPatterns = {"/my-courses"})
public class MyCoursesController extends HttpServlet {

    private CourseDAO courseDAO = new CourseDAO();
    private RegistrationDAO registrationDAO = new RegistrationDAO();

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
        
        // Get student's registered courses
        List<Registration> registrations = registrationDAO.findByStudentId(account.getId());
        
        // Set attributes for the JSP
        request.setAttribute("registrations", registrations);
        request.setAttribute("courseDAO", courseDAO);
        
        // Pagination parameters
        int page = 1;
        int pageSize = 10;
        
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
        
        // Calculate pagination
//        int totalCourses = myCourses.size();
        int totalCourses = 6;
        int totalPages = (int) Math.ceil((double) totalCourses / pageSize);
        
        // Ensure page is within valid range
        if (page < 1) {
            page = 1;
        } else if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        
        // Get the subset of courses for the current page
        List<Course> paginatedCourses = new ArrayList<>();
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalCourses);
        
        if (startIndex < totalCourses) {
//            paginatedCourses = myCourses.subList(startIndex, endIndex);
        }
        
        // Set attributes for the JSP
//        request.setAttribute("myCourses", myCourses);
        request.setAttribute("paginatedCourses", paginatedCourses);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        
        // Forward to the JSP page
        request.getRequestDispatcher("view/dashboard/student/my-courses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle any POST requests if needed
        doGet(request, response);
    }
} 