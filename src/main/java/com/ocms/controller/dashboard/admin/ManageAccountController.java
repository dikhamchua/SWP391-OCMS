/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ocms.controller.dashboard.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.ocms.dal.AccountDAO;
import com.ocms.entity.Account;
import java.util.List;

@WebServlet(name = "ManageAccountController", urlPatterns = {"/manage-account"})
public class ManageAccountController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "deactivate":
                deactivateAccount(request, response);
                break;
            case "list":
            default:
                listAccounts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "update":
                updateAccount(request, response);
                break;
            default:
                listAccounts(request, response);
                break;
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accountIdStr = request.getParameter("id");
        if (accountIdStr != null && !accountIdStr.isEmpty()) {
            int accountId = Integer.parseInt(accountIdStr);
            AccountDAO accountDAO = new AccountDAO();
            Account account = accountDAO.findById(accountId);
            if (account != null) {
                request.setAttribute("account", account);
                request.getRequestDispatcher("view/dashboard/admin/edit-account.jsp").forward(request, response);
                return;
            }
        }
        // If account not found, redirect to list
        response.sendRedirect(request.getContextPath() + "/manage-account");
    }

    private void listAccounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AccountDAO accountDAO = new AccountDAO();
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            page = Integer.parseInt(pageStr);
        }
        List<Account> nonAdminAccounts = accountDAO.findAllNonAdminAccounts(page, pageSize);
        int totalAccounts = accountDAO.getTotalNonAdminAccounts();
        int totalPages = (int) Math.ceil((double) totalAccounts / pageSize);
        request.setAttribute("nonAdminAccounts", nonAdminAccounts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("view/dashboard/admin/manage-account.jsp").forward(request, response);
    }

    private void updateAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer accountId = Integer.parseInt(request.getParameter("id"));
        String email = request.getParameter("email");
        //TODO: THEM VALIDATE ROLE
        Integer roleId = Integer.parseInt(request.getParameter("role"));
        //TODO: THEM VALIDATE STATUS
        Boolean status = Boolean.parseBoolean(request.getParameter("status"));
        boolean gender = Boolean.parseBoolean(request.getParameter("gender"));

        Account account = new Account();
        account.setId(accountId);
        account.setEmail(email);
        account.setRoleId(roleId);
        account.setIsActive(status);
        account.setGender(gender);

        AccountDAO accountDAO = new AccountDAO();
        boolean updated = accountDAO.update(account);

        if (updated) {
            setToastMessage(request, "Account updated successfully", "success");
            response.sendRedirect(request.getContextPath() + "/manage-account?action=edit&id=" + accountId);
        } else {
            setToastMessage(request, "Failed to update account", "error");
            request.setAttribute("account", account);
            request.getRequestDispatcher("view/dashboard/admin/edit-account.jsp").forward(request, response);
        }
    }
    
    private void deactivateAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accountIdStr = request.getParameter("id");
        if (accountIdStr != null && !accountIdStr.isEmpty()) {
            int accountId = Integer.parseInt(accountIdStr);
            AccountDAO accountDAO = new AccountDAO();
            boolean deactivated = accountDAO.deactivateAccount(accountId);
            
            if (deactivated) {
                setToastMessage(request, "Account deactivated successfully", "success");
            } else {
                setToastMessage(request, "Failed to deactivate account", "error");
            }
        } else {
            setToastMessage(request, "Invalid account ID", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/manage-account");
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }

}
