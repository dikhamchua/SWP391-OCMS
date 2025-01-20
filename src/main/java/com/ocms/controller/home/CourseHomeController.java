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
import java.util.List;

import com.ocms.dal.CourseDAO;
import com.ocms.entity.Course;

@WebServlet(name="CourseHomeController", urlPatterns={"/course-list"})
public class CourseHomeController extends HttpServlet {
    
    private static final String COURSE_LIST_HOME_PAGE = "view/homepage/course_list.jsp";
    private final CourseDAO courseDAO = new CourseDAO();

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int pageSize = 9; // Show 9 courses per page
        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            currentPage = Integer.parseInt(pageStr);
        }
        
        // Get search parameter
        String keyword = request.getParameter("search");
        
        // Get courses with pagination
        List<Course> courses;
        int totalRecords;
        int totalPages;
        
        if (keyword != null && !keyword.isEmpty()) {
            // Search with pagination
            courses = courseDAO.searchWithPagination(keyword, currentPage, pageSize);
            totalRecords = courseDAO.getTotalSearchResults(keyword);
        } else {
            // Normal pagination
            courses = courseDAO.findWithPagination(currentPage, pageSize);
            totalRecords = courseDAO.getTotalRecords();
        }
        
        totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Set attributes for JSP
        request.setAttribute("courses", courses);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("keyword", keyword);
        
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
            out.println("<h1>Servlet CourseHomeController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

}
