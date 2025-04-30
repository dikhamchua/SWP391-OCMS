package com.ocms.controller.student;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.CategoryDAO;
import com.ocms.dal.CourseDAO;
import com.ocms.dal.RegistrationDAO;
import com.ocms.dal.AccountDAO;
import com.ocms.dal.SectionDAO;
import com.ocms.dal.LessonDAO;
import com.ocms.dal.LessonProgressDAO;
import com.ocms.entity.Account;
import com.ocms.entity.Category;
import com.ocms.entity.Course;
import com.ocms.entity.Registration;
import com.ocms.entity.Section;
import com.ocms.entity.Lesson;

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
import java.util.Map;

@WebServlet(name = "MyCoursesController", urlPatterns = {"/my-courses"})
public class MyCoursesController extends HttpServlet {

    private CourseDAO courseDAO = new CourseDAO();
    private RegistrationDAO registrationDAO = new RegistrationDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private AccountDAO accountDAO = new AccountDAO();
    private SectionDAO sectionDAO = new SectionDAO();
    private LessonDAO lessonDAO = new LessonDAO();
    private LessonProgressDAO lessonProgressDAO = new LessonProgressDAO();

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
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action is to list all courses
        }
        
        switch (action) {
            case "details":
                showCourseDetails(request, response, account);
                break;
            case "list":
            default:
                listMyCourses(request, response, account);
                break;
        }
    }
    
    private void listMyCourses(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
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
    
    private void showCourseDetails(HttpServletRequest request, HttpServletResponse response, Account account)
            throws ServletException, IOException {
        // Get course ID from request parameter
        String courseIdParam = request.getParameter("id");
        if (courseIdParam == null || courseIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-courses");
            return;
        }
        
        try {
            int courseId = Integer.parseInt(courseIdParam);
            
            // Check if the student is registered for this course
            Registration registration = registrationDAO.findByStudentIdAndCourseId(account.getId(), courseId);
            if (registration == null) {
                // If not registered, redirect to my courses page
                response.sendRedirect(request.getContextPath() + "/my-courses");
                return;
            }
            
            // Get course details
            Course course = courseDAO.findById(courseId);
            if (course == null) {
                response.sendRedirect(request.getContextPath() + "/my-courses");
                return;
            }
            
            // Get sections and lessons for the course
            List<Section> sections = sectionDAO.getByCourseId(courseId);
            Map<Integer, List<Lesson>> lessonsBySectionId = new HashMap<>();
            
            // Calculate total lessons and create a map of completed lessons
            int totalLessons = 0;
            
            for (Section section : sections) {
                List<Lesson> sectionLessons = lessonDAO.getBySectionId(section.getId());
                
                // Thêm các bài học vào map
                totalLessons += sectionLessons.size();
                lessonsBySectionId.put(section.getId(), sectionLessons);
            }
            
            // Get lesson completion data
            Map<Integer, Boolean> completedLessonsMap = lessonProgressDAO.getCompletedLessonsForCourse(account.getId(), courseId);
            int completedLessons = lessonProgressDAO.countCompletedLessonsForCourse(account.getId(), courseId);
            
            // Calculate progress percentage
            int progressPercentage = 0;
            if (totalLessons > 0) {
                progressPercentage = (int) Math.round((double) completedLessons / totalLessons * 100);
            }
            
            // Get category information
            Category category = categoryDAO.findById(course.getCategoryId());
            Map<Integer, String> categoryMap = new HashMap<>();
            categoryMap.put(course.getCategoryId(), category != null ? category.getName() : "Uncategorized");
            
            // Get instructor information
            Account instructor = accountDAO.findById(course.getCreatedBy());
            Map<Integer, String> accountMap = new HashMap<>();
            accountMap.put(course.getCreatedBy(), instructor != null ? instructor.getFullName() : "Unknown Instructor");
            
            // Get registration status
            String registrationStatus = registration.getStatus();
            
            // Set attributes for the JSP
            request.setAttribute("course", course);
            request.setAttribute("sections", sections);
            request.setAttribute("lessonsBySectionId", lessonsBySectionId);
            request.setAttribute("categoryMap", categoryMap);
            request.setAttribute("accountMap", accountMap);
            request.setAttribute("registration", registration);
            request.setAttribute("registrationStatus", registrationStatus);
            request.setAttribute("totalLessons", totalLessons);
            request.setAttribute("completedLessons", completedLessons);
            request.setAttribute("completedLessonsMap", completedLessonsMap);
            request.setAttribute("progressPercentage", progressPercentage);
            
            // Forward to the course details page
            request.getRequestDispatcher("view/homepage/my-course-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-courses");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle any POST requests if needed
        doGet(request, response);
    }
}