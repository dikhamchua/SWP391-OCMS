package com.ocms.controller.dashboard.admin;

import java.io.IOException;
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
                case "edit":
                    doGetEditSection(request, response);
                    break;
                default:
                    // Handle default case
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

    private void doGetEditSection(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sectionId = request.getParameter("id");
        if (sectionId == null) {
            request.getSession().setAttribute("toastMessage", "Section ID is required");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-course");
            return;
        }
        
        try {
            int sectionIdInt = Integer.parseInt(sectionId);
            Section section = sectionDAO.getById(sectionIdInt);
            
            if (section == null) {
                request.getSession().setAttribute("toastMessage", "Section not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/manage-course");
                return;
            }
            
            request.setAttribute("section", section);
            request.getRequestDispatcher("/view/dashboard/admin/section/edit-section.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Invalid section ID");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-course");
        }
    }

    private void updateSection(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { 
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            
            //find section by id
            Section section = sectionDAO.getById(id);
            if (section == null) {
                request.getSession().setAttribute("toastMessage", "Section not found");
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/manage-course?action=manage&id=" + courseId);
                return;
            }
            
            section.setTitle(name);
            section.setDescription(description);
            section.setStatus(status);

            //update section
            sectionDAO.update(section);
            request.getSession().setAttribute("toastMessage", "Section updated successfully");
            request.getSession().setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/manage-course?action=manage&id=" + courseId);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("toastMessage", "Failed to update section: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-course?action=manage&id=" + courseId);
        }
    }

}
