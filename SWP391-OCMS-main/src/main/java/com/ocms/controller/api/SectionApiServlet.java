package com.ocms.controller.api;

import com.ocms.dal.SectionDAO;
import com.ocms.entity.Section;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

@WebServlet(name = "SectionApiServlet", urlPatterns = {"/api/sections"})
public class SectionApiServlet extends HttpServlet {
    
    private SectionDAO sectionDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        sectionDAO = new SectionDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String courseId = request.getParameter("courseId");
        
        if (courseId == null || courseId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Course ID is required\"}");
            return;
        }
        
        try {
            int courseIdInt = Integer.parseInt(courseId);
            List<Section> sections = sectionDAO.getByCourseId(courseIdInt);
            
            JSONArray jsonArray = new JSONArray();
            for (Section section : sections) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("id", section.getId());
                jsonObject.put("title", section.getTitle());
                jsonArray.add(jsonObject);
            }
            
            PrintWriter out = response.getWriter();
            out.print(jsonArray.toJSONString());
            out.flush();
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid course ID\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
} 