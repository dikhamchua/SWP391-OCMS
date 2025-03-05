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
        if (action == null || action.equals("list")) {
            searchByFilter(request, response);
        } else {

        }    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action == "list") {
            searchByFilter(request, response);
        } else {

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
            int categoryId = reg.getCategoryId();
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
}