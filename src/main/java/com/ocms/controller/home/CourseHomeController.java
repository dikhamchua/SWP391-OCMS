/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.ocms.controller.home;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import com.ocms.dal.AccountDAO;
import com.ocms.dal.CategoryDAO;
import com.ocms.entity.Category;
import com.ocms.dal.CourseDAO;
import com.ocms.entity.Course;

@WebServlet(name = "CourseHomeController", urlPatterns = { "/course-list" })
public class CourseHomeController extends HttpServlet {

    private static final String COURSE_LIST_HOME_PAGE = "view/homepage/course_list.jsp";
    private final CourseDAO courseDAO = new CourseDAO();
    private final AccountDAO accountDAO = new AccountDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageSize = 9;
        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            currentPage = Integer.parseInt(pageStr);
        }

        // Get filter parameters
        String keyword = request.getParameter("search");
        String categoriesParam = request.getParameter("categories");
        String ratingsParam = request.getParameter("ratings");
        String sort = request.getParameter("sort");


        List<Integer> categoryIds = new ArrayList<>();
        List<Integer> ratings = new ArrayList<>();

        // Parse category filters
        if (categoriesParam != null && !categoriesParam.isEmpty()) {
            categoryIds = Arrays.stream(categoriesParam.split(","))
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
        }

        // Parse rating filters
        if (ratingsParam != null && !ratingsParam.isEmpty()) {
            ratings = Arrays.stream(ratingsParam.split(","))
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
        }
        
        // Get filtered courses with pagination
        List<Course> courses;
        int totalRecords;

        courses = courseDAO.findWithFilters(categoryIds, ratings, keyword, sort, currentPage, pageSize);
        totalRecords = courseDAO.getTotalFilteredRecords(categoryIds, ratings, keyword);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Get author information
        Set<Integer> authorIds = courses.stream()
                .map(Course::getCreatedBy)
                .collect(Collectors.toSet());
        Map<Integer, String> authorNames = accountDAO.findFullNames(authorIds);

        // Get category names
        Set<Integer> courseCategoryIds = courses.stream()
                .map(Course::getCategoryId)
                .collect(Collectors.toSet());
        Map<Integer, String> categoryNames = categoryDAO.findNames(courseCategoryIds);

        // Get all categories for the sidebar
        List<Category> allCategories = categoryDAO.findAll();

        // Set attributes for JSP
        request.setAttribute("categoryNames", categoryNames);
        request.setAttribute("authorNames", authorNames);
        request.setAttribute("allCategories", allCategories);
        request.setAttribute("courses", courses);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategories", categoryIds);
        request.setAttribute("selectedRatings", ratings);

        request.getRequestDispatcher(COURSE_LIST_HOME_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CourseHomeController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseHomeController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

}
