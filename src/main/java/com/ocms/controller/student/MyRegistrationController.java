package com.ocms.controller.student;

import com.ocms.dal.RegistrationDAO;
import com.ocms.entity.Registration;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;


@WebServlet("/my-registration")
public class MyRegistrationController extends HttpServlet{
    private static final long serialVersionUID = 1L;
    private RegistrationDAO registrationDAO;
    
    public void init() throws ServletException {
        registrationDAO = new RegistrationDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get the student ID from the session
            HttpSession session = request.getSession();
            int studentId = (int) session.getAttribute("studentId");

            // Get the list of registrations for the student
            // List<Registration> registrations = registrationDAO.getRegistrationsByStudentId(studentId);
            List<Registration> registrations = null;

            // Store the registrations in the request
            request.setAttribute("registrations", registrations);

            // Forward to the JSP page
            request.getRequestDispatcher("/view/student/my-registration.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching registrations");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
