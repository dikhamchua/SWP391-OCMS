package com.ocms.controller.dashboard.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import com.ocms.dal.CategoryDAO;
import com.ocms.dal.RegistrationDAO;
import com.ocms.dal.AccountDAO;
import com.ocms.entity.Category;
import com.ocms.entity.Registration;

import java.util.ArrayList;
import java.util.Arrays;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.sql.Timestamp;
import java.util.Date;
import java.text.ParseException;


@WebServlet(name="ManageRegistration", urlPatterns={"/manage-registration"})
public class ManageRegistration extends HttpServlet {
    private final RegistrationDAO registrationDAO = new RegistrationDAO();
    private final AccountDAO accountDAO = new AccountDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                searchByFilter(request, response);
                break;
            case "edit":
                editRegistration(request, response);
                break;
            case "delete":
                deleteRegistration(request, response);
                break;
            default:
                searchByFilter(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "update":
                updateRegistration(request, response);
                break;
            case "create":
                createRegistration(request, response);
                break;
            default:
                searchByFilter(request, response);
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

    private void searchByFilter(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get filter parameters
        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 10; // Changed default page size from 5 to 10

        // Handle page parameter
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                System.out.println("Invalid page number: " + pageStr);
            }
        }

        // Handle pageSize parameter
        String pageSizeStr = request.getParameter("pageSize");
        if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
            try {
                int newPageSize = Integer.parseInt(pageSizeStr);
                if (newPageSize > 0 && newPageSize <= 100) {
                    pageSize = newPageSize;
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid pageSize: " + pageSizeStr);
            }
        }

        // Get data with filters and pagination
        List<Registration> registrations = registrationDAO.getRegistrationsByFilter(
                search, category, status, fromDate, toDate, page, pageSize);

        // Get total records for pagination
        int totalRegistrations = registrationDAO.getTotalRegistrationsByFilter(
                search, category, status, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalRegistrations / pageSize);

        // Get additional data for display
        List<Category> categories = categoryDAO.findAll();

        // Create maps for additional information
        Map<Integer, String> accountNames = new HashMap<>();
        Map<Integer, String> accountEmails = new HashMap<>();
        Map<Integer, String> categoryNames = new HashMap<>();
        Map<Integer, String> lastUpdatedByNames = new HashMap<>();

        // Populate maps with data
        for (Registration reg : registrations) {
            int accountId = reg.getAccountId();
            int categoryId = reg.getCourseId();
            int lastUpdatedById = reg.getLastUpdateByPerson();

            if (!accountNames.containsKey(accountId)) {
                accountNames.put(accountId, accountDAO.getAccountName(accountId));
                accountEmails.put(accountId, accountDAO.getAccountEmail(accountId));
            }
            if (!categoryNames.containsKey(categoryId)) {
                categoryNames.put(categoryId, categoryDAO.getCategoryName(categoryId));
            }
            if (!lastUpdatedByNames.containsKey(lastUpdatedById)) {
                lastUpdatedByNames.put(lastUpdatedById, accountDAO.getAccountName(lastUpdatedById));
            }
        }

        // Handle column choices
        String[] optionChoice = request.getParameterValues("optionChoice");
        List<String> listColum = new ArrayList<>();
        
        if (optionChoice != null) {
            listColum.addAll(Arrays.asList(optionChoice));
        } else {
            // Default columns if none selected - include all fields
            listColum.addAll(Arrays.asList(
                "idChoice", "nameChoice", "emailChoice", "registrationTimeChoice",
                "categoryChoice", "packageChoice", "totalCostChoice", "statusChoice", 
                "validFromChoice", "validToChoice", "lastUpdatedByChoice", "actionChoice"
            ));
        }

        // Set additional attributes
        request.setAttribute("listColum", listColum);
        request.setAttribute("pageSize", pageSize);
        // Set attributes for JSP
        request.setAttribute("registrations", registrations);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRegistrations", totalRegistrations);
        request.setAttribute("accountNames", accountNames);
        request.setAttribute("accountEmails", accountEmails);
        request.setAttribute("categoryNames", categoryNames);
        request.setAttribute("lastUpdatedByNames", lastUpdatedByNames);
        request.setAttribute("search", search);
        request.setAttribute("category", category);
        request.setAttribute("status", status);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        // Forward to JSP
        request.getRequestDispatcher("/view/dashboard/admin/registration_list.jsp").forward(request, response);
    }

    private void editRegistration(HttpServletRequest request, HttpServletResponse response) 
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
            response.sendRedirect(request.getContextPath() + "/manage-registration");
            return;
        }
        
        // Get registration details
        Registration registration = registrationDAO.findById(id);
        
        if (registration == null) {
            // Handle registration not found
            request.getSession().setAttribute("toastMessage", "Registration not found");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-registration");
            return;
        }
        
        // Get additional data for display
        String accountName = accountDAO.getAccountName(registration.getAccountId());
        String accountEmail = accountDAO.getAccountEmail(registration.getAccountId());
        String categoryName = categoryDAO.getCategoryName(registration.getCourseId());
        String lastUpdatedByName = accountDAO.getAccountName(registration.getLastUpdateByPerson());
        
        // Get all categories for dropdown
        List<Category> categories = categoryDAO.findAll();
        
        // Set attributes for JSP
        request.setAttribute("registration", registration);
        request.setAttribute("accountName", accountName);
        request.setAttribute("accountEmail", accountEmail);
        request.setAttribute("categoryName", categoryName);
        request.setAttribute("lastUpdatedByName", lastUpdatedByName);
        request.setAttribute("categories", categories);
        
        // Forward to edit page
        request.getRequestDispatcher("/view/dashboard/admin/registration_edit.jsp").forward(request, response);
    }
    
    private void updateRegistration(HttpServletRequest request, HttpServletResponse response) 
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
            response.sendRedirect(request.getContextPath() + "/manage-registration");
            return;
        }
        
        // Get existing registration
        Registration registration = registrationDAO.findById(id);
        
        if (registration == null) {
            // Handle registration not found
            request.getSession().setAttribute("toastMessage", "Registration not found");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/manage-registration");
            return;
        }
        
        // Get form data
        String status = request.getParameter("status");
        String packages = request.getParameter("package");
        String categoryIdStr = request.getParameter("courseId");
        String validFromStr = request.getParameter("validFrom");
        String validToStr = request.getParameter("validTo");
        String totalCostStr = request.getParameter("totalCost");
        String notes = request.getParameter("notes");
        
        try {
            // Update registration object
            if (status != null && !status.isEmpty()) {
                registration.setStatus(status);
            }
            
            if (packages != null && !packages.isEmpty()) {
                registration.setPackages(packages);
            }
            
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                int categoryId = Integer.parseInt(categoryIdStr);
                registration.setCourseId(categoryId);
            }
            
            if (totalCostStr != null && !totalCostStr.isEmpty()) {
                BigDecimal totalCost = new BigDecimal(totalCostStr);
                registration.setTotalCost(totalCost);
            }
            
            if (validFromStr != null && !validFromStr.isEmpty()) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                Date validFromDate = dateFormat.parse(validFromStr);
                registration.setValidFrom(new Timestamp(validFromDate.getTime()));
            }
            
            if (validToStr != null && !validToStr.isEmpty()) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                Date validToDate = dateFormat.parse(validToStr);
                registration.setValidTo(new Timestamp(validToDate.getTime()));
            }
            
            // Set last updated by to current user (for now using ID 1)
            registration.setLastUpdateByPerson(1);
            
            // Update registration in database
            boolean success = registrationDAO.update(registration);
            
            if (success) {
                request.getSession().setAttribute("toastMessage", "Registration updated successfully");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to update registration");
                request.getSession().setAttribute("toastType", "error");
            }
            
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error updating registration: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }
        
        // Redirect back to registration list
        response.sendRedirect(request.getContextPath() + "/manage-registration");
    }

    private void createRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Extract form data
        String email = request.getParameter("email");
        int accountId = Integer.parseInt(request.getParameter("accountId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));  // Changed from categoryId to courseId
        String packages = request.getParameter("packages");
        BigDecimal totalCost = new BigDecimal(request.getParameter("totalCost"));
        String status = request.getParameter("status");
        int lastUpdateByPerson = Integer.parseInt(request.getParameter("lastUpdateByPerson"));
        
        // Parse dates
        Timestamp registrationTime = new Timestamp(System.currentTimeMillis());
        Timestamp validFrom = null;
        Timestamp validTo = null;
        
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date validFromDate = dateFormat.parse(request.getParameter("validFrom"));
            Date validToDate = dateFormat.parse(request.getParameter("validTo"));
            
            validFrom = new Timestamp(validFromDate.getTime());
            validTo = new Timestamp(validToDate.getTime());
        } catch (ParseException e) {
            request.setAttribute("errorMessage", "Invalid date format");
            request.getRequestDispatcher("/view/dashboard/admin/registration_create.jsp").forward(request, response);
            return;
        }
        
        // Create Registration object
        Registration registration = new Registration();
        registration.setEmail(email);
        registration.setAccountId(accountId);
        registration.setRegistrationTime(registrationTime);
        registration.setCourseId(courseId);  // Changed from setCategoryId to setCourseId
        registration.setPackages(packages);
        registration.setTotalCost(totalCost);
        registration.setStatus(status);
        registration.setValidFrom(validFrom);
        registration.setValidTo(validTo);
        registration.setLastUpdateByPerson(lastUpdateByPerson);
        
        // Insert into database
        int newId = registrationDAO.insert(registration);
        
        if (newId > 0) {
            request.setAttribute("successMessage", "Registration created successfully");
            response.sendRedirect(request.getContextPath() + "/manage-registration?action=edit&id=" + newId);
        } else {
            request.setAttribute("errorMessage", "Failed to create registration");
            request.getRequestDispatcher("/view/dashboard/admin/registration_create.jsp").forward(request, response);
        }
    }

    private void deleteRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        // boolean success = registrationDAO.delete(id);
        boolean success = 1 == 1;
        
        
        if (success) {
            request.setAttribute("successMessage", "Registration deleted successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to delete registration");
        }
        
        searchByFilter(request, response);
    }
}