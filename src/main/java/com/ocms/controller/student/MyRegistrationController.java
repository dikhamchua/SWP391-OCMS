package com.ocms.controller.student;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.CourseDAO;
import com.ocms.dal.RegistrationDAO;
import com.ocms.dal.AccountDAO;
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
import java.util.Arrays;
import java.util.List;

/**
 * Controller for handling student's course registrations display and filtering
 * Displays a list of the student's course registrations with options for filtering, 
 * pagination, and column display customization.
 */
@WebServlet("/my-registration")
public class MyRegistrationController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RegistrationDAO registrationDAO;
    private CourseDAO courseDAO;
    private AccountDAO accountDAO;
    
    @Override
    public void init() throws ServletException {
        registrationDAO = new RegistrationDAO();
        courseDAO = new CourseDAO();
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            
            if (action == null) {
                handleRegistrationList(request, response, account);
            } else if (action.equals("view")) {
                handleRegistrationDetails(request, response, account);
            } else {
                handleRegistrationList(request, response, account);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Handle listing registrations with filtering and pagination
     * Processes filter parameters, pagination, and column display options
     * and retrieves the appropriate registrations for the logged-in student
     * 
     * @param request The HTTP request
     * @param response The HTTP response
     * @param account The currently logged-in student account
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void handleRegistrationList(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
        // Get filter parameters
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String courseId = request.getParameter("courseId");
        
        // Get display settings parameters
        String[] columns = request.getParameterValues("columns");
        List<String> selectedColumns = new ArrayList<>();
        if (columns != null && columns.length > 0) {
            selectedColumns = Arrays.asList(columns);
        }
        
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
        
        // Account ID filtering - ensure we only get this student's registrations
        int studentId = account.getId();
        
        // Calculate pagination values
        int totalRegistrations = registrationDAO.getTotalRegistrationsByFilter(search, courseId, status, fromDate, toDate, studentId);
        int totalPages = (int) Math.ceil((double) totalRegistrations / pageSize);
        
        // Ensure current page is within valid range
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        
        // Calculate start and end record for display
        int startRecord = totalRegistrations > 0 ? (page - 1) * pageSize + 1 : 0;
        int endRecord = Math.min(page * pageSize, totalRegistrations);
        
        // Simplified pagination range logic (show 5 pages at most)
        int paginationWidth = 5; // Number of page buttons to show
        int halfWidth = paginationWidth / 2;
        
        int startPage = Math.max(1, page - halfWidth);
        int endPage = Math.min(totalPages, startPage + paginationWidth - 1);
        
        // Adjust start page if we're near the end
        if (endPage - startPage + 1 < paginationWidth && startPage > 1) {
            startPage = Math.max(1, endPage - paginationWidth + 1);
        }
        
        // Get registrations for current page with all filters applied
        List<Registration> registrations = registrationDAO.getRegistrationsByFilter(
                search, courseId, status, fromDate, toDate, page, pageSize, studentId);
        
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
        request.setAttribute("selectedColumns", selectedColumns);
        
        // Forward to the JSP page
        request.getRequestDispatcher("/view/dashboard/student/my-registration.jsp").forward(request, response);
    }
    
    /**
     * Handle displaying details for a specific registration
     * Retrieves the registration details and additional information 
     * needed for displaying the full registration information
     * 
     * @param request The HTTP request
     * @param response The HTTP response
     * @param account The currently logged-in student account
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException If an I/O error occurs
     */
    private void handleRegistrationDetails(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
        // Get registration ID from request
        String idStr = request.getParameter("id");
        int id;
        
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            // Handle invalid ID
            request.getSession().setAttribute("toastMessage", "Invalid registration ID");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/my-registration");
            return;
        }
        
        // Get registration details
        Registration registration = registrationDAO.findById(id);
        
        if (registration == null) {
            // Handle registration not found
            request.getSession().setAttribute("toastMessage", "Registration not found");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/my-registration");
            return;
        }
        
        // Security check - verify this registration belongs to the current user
        if (registration.getAccountId() != account.getId()) {
            request.getSession().setAttribute("toastMessage", "You do not have permission to view this registration");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/my-registration");
            return;
        }
        
        // Capture query string parameters to return to the right page
        StringBuilder returnQueryStringBuilder = new StringBuilder();
        String pageSize = request.getParameter("pageSize");
        String page = request.getParameter("page");
        String courseId = request.getParameter("courseId");
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String[] columns = request.getParameterValues("columns");
        
        // Build the return query string
        boolean first = true;
        
        if (pageSize != null && !pageSize.isEmpty()) {
            returnQueryStringBuilder.append(first ? "" : "&").append("pageSize=").append(pageSize);
            first = false;
        }
        
        if (page != null && !page.isEmpty()) {
            returnQueryStringBuilder.append(first ? "" : "&").append("page=").append(page);
            first = false;
        }
        
        if (courseId != null && !courseId.isEmpty()) {
            returnQueryStringBuilder.append(first ? "" : "&").append("courseId=").append(courseId);
            first = false;
        }
        
        if (status != null && !status.isEmpty()) {
            returnQueryStringBuilder.append(first ? "" : "&").append("status=").append(status);
            first = false;
        }
        
        if (search != null && !search.isEmpty()) {
            returnQueryStringBuilder.append(first ? "" : "&").append("search=").append(search);
            first = false;
        }
        
        if (fromDate != null && !fromDate.isEmpty()) {
            returnQueryStringBuilder.append(first ? "" : "&").append("fromDate=").append(fromDate);
            first = false;
        }
        
        if (toDate != null && !toDate.isEmpty()) {
            returnQueryStringBuilder.append(first ? "" : "&").append("toDate=").append(toDate);
            first = false;
        }
        
        if (columns != null && columns.length > 0) {
            for (String column : columns) {
                returnQueryStringBuilder.append(first ? "" : "&").append("columns=").append(column);
                first = false;
            }
        }
        
        // Get additional data for display
        String accountName = accountDAO.getAccountName(registration.getAccountId());
        String accountEmail = accountDAO.getAccountEmail(registration.getAccountId());
        Course course = courseDAO.findById(registration.getCourseId());
        String courseName = course != null ? course.getName() : "Unknown Course";
        String lastUpdatedByName = accountDAO.getLastUpdatedByName(registration.getLastUpdateByPerson());
        
        // Set attributes for JSP
        request.setAttribute("registration", registration);
        request.setAttribute("accountName", accountName);
        request.setAttribute("accountEmail", accountEmail);
        request.setAttribute("courseName", courseName);
        request.setAttribute("course", course);
        request.setAttribute("lastUpdatedByName", lastUpdatedByName);
        request.setAttribute("returnQueryString", returnQueryStringBuilder.toString());
        
        // Forward to detail page
        request.getRequestDispatcher("/view/dashboard/student/registration-detail.jsp").forward(request, response);
    }
}
