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
import java.util.List;


@WebServlet("/my-registration")
public class MyRegistrationController extends HttpServlet{
    private static final long serialVersionUID = 1L;
    private RegistrationDAO registrationDAO;
    private CourseDAO courseDAO;
    
    public void init() throws ServletException {
        registrationDAO = new RegistrationDAO();
        courseDAO = new CourseDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        try {
            // Get filter parameters
            String status = request.getParameter("status");
            String search = request.getParameter("search");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            String courseId = request.getParameter("courseId");
            
            // Get pagination parameters
            int page = 1;
            int pageSize = 10;
            
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            String pageSizeStr = request.getParameter("pageSize");
            if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeStr);
                    if (pageSize < 1) pageSize = 10;
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }
            
            // Calculate pagination values
            int totalRegistrations = registrationDAO.getTotalRegistrationsByFilter(search, courseId, status, fromDate, toDate);
            int totalPages = (int) Math.ceil((double) totalRegistrations / pageSize);
            
            // Ensure current page is within valid range
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }
            
            // Calculate start and end record for display
            int startRecord = (page - 1) * pageSize + 1;
            int endRecord = Math.min(page * pageSize, totalRegistrations);
            
            // Calculate pagination range (show 5 pages at most)
            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, page + 2);
            
            // Adjust if we're near the start or end
            if (startPage <= 3) {
                endPage = Math.min(5, totalPages);
            }
            
            if (endPage >= totalPages - 2) {
                startPage = Math.max(1, totalPages - 4);
            }
            
            // Get registrations for current page - filter by student ID
            List<Registration> registrations = registrationDAO.getRegistrationsByFilter(
                    search, courseId, status, fromDate, toDate, page, pageSize);
            
            // Get all courses for filter dropdown
            List<Course> courseList = courseDAO.findAll();
            
            // Set attributes for the view
            request.setAttribute("registrations", registrations);
            request.setAttribute("courseList", courseList);
            request.setAttribute("totalRegistrations", totalRegistrations);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("startRecord", startRecord);
            request.setAttribute("endRecord", endRecord);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("search", search);
            request.setAttribute("status", status);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("courseId", courseId);
            request.setAttribute("courseDAO", courseDAO);
            
            // Forward to the JSP page
            request.getRequestDispatcher("/view/dashboard/student/my-registration.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching registrations: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
