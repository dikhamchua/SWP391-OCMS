package com.ocms.controller.home;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.ocms.dal.CourseDAO;
import com.ocms.entity.Course;

@WebServlet(name = "CourseDetailsController", urlPatterns = { "/course-details" })
public class CourseDetailsController extends HttpServlet {

    private static final String COURSE_DETAILS_PAGE = "view/homepage/course_details.jsp";
    private final CourseDAO courseDAO = new CourseDAO();

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
                    request.setAttribute("course", course);
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
