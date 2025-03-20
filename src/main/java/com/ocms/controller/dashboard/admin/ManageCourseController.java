package com.ocms.controller.dashboard.admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import java.io.IOException;
import com.ocms.dal.*;
import com.ocms.entity.*;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/manage-course")
public class ManageCourseController extends HttpServlet {
    

    private CourseDAO courseDAO;
    private SectionDAO sectionDAO;
    private LessonDAO lessonDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        sectionDAO = new SectionDAO();
        lessonDAO = new LessonDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/manage-course":
                doGetManageCourse(request, response);
                break;
        }
    }


    private void doGetManageCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //get id of course
        String id = request.getParameter("id");
        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/manage-course");
            return;
        }
        int courseId = Integer.parseInt(id);

        //get course by id
        Course course = courseDAO.findById(courseId);
        //get sections by course id
        List<Section> sections = sectionDAO.getByCourseId(courseId);
        //get lessons by section id
        List<Lesson> lessons = lessonDAO.getBySectionId(sections.get(0).getId());
        
        //hashmap to store lessons by section id
        Map<Integer, List<Lesson>> lessonsBySectionId = new HashMap<>();
        for (Section section : sections) {
            lessonsBySectionId.put(section.getId(), lessonDAO.getBySectionId(section.getId()));
        }

        request.setAttribute("course", course);
        request.setAttribute("sections", sections);
        request.setAttribute("lessonsBySectionId", lessonsBySectionId);
        request.getRequestDispatcher("/view/dashboard/admin/course-content.jsp").forward(request, response);
    }
    
}
