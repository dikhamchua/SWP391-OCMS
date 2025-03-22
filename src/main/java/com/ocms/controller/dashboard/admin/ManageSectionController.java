package com.ocms.controller.dashboard.admin;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import com.ocms.dal.SectionDAO;
import com.ocms.entity.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/manage-section")
public class ManageSectionController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SectionDAO sectionDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        sectionDAO = new SectionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "add":
                    doGetAddSection(request, response);
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if (action != null) {
                switch (action) {
                    case "add":
                        doPostAddSection(request, response);
                        break;
                    case "update":
                        updateSection(request, response);
                        break;
                    case "delete":
                        // deleteSection(request, response);
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void doPostAddSection(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        //get last order number
        int lastOrderNumber = sectionDAO.getLastOrderNumber(courseId);

        Section section = Section.builder()
            .title(name)
            .description(description)
            .courseId(courseId)
            .status(status)
            .orderNumber(lastOrderNumber + 1)
            .build();
        
        try {
            sectionDAO.insert(section);
            request.getSession().setAttribute("toastMessage", "Section added successfully");
            request.getSession().setAttribute("toastType", "success");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "Failed to add section: " +e.getMessage() );
            request.getSession().setAttribute("toastType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/manage-course?action=manage&id=" + courseId);
    }

    private void doGetAddSection(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       //get course id
       String courseId = request.getParameter("courseId");
       if (courseId == null) {
           request.getSession().setAttribute("toastMessage", "Course ID is required");
           request.getSession().setAttribute("toastType", "error");
           response.sendRedirect(request.getContextPath() + "/manage-course?action=manage&id=" + courseId);
           return;
       }
       int courseIdInt = Integer.parseInt(courseId);
       request.setAttribute("courseId", courseIdInt);
       
       request.getRequestDispatcher("/view/dashboard/admin/section/add-section.jsp").forward(request, response);
    }

    private void updateSection(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { 
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        
        Section section = Section.builder()
            .id(id)
            .title(name)
            .description(description)
            .courseId(courseId)
            .status(status)
            .build();
        
        sectionDAO.update(section);
        response.sendRedirect(request.getContextPath() + "/manage-course?action=manage&id=" + courseId);
    }

}
