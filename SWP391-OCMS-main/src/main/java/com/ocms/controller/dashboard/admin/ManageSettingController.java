package com.ocms.controller.dashboard.admin;

import java.io.IOException;
import java.util.List;

import com.ocms.dal.SettingDAO;
import com.ocms.entity.Setting;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ManageSettingController", urlPatterns = { "/manage-setting" })
public class ManageSettingController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            handleListWithFilters(request, response);
        } else {
            switch (action) {
                case "edit":
                    showEditForm(request, response);
                    break;
                case "deactivate":
                    deactivateSetting(request, response);
                    break;
            }
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
                updateSetting(request, response);
                break;
            default:
                handleListWithFilters(request, response);
                break;
        }
    }

    private void handleListWithFilters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String typeFilter = request.getParameter("type");
        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");

        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        SettingDAO settingDAO = new SettingDAO();
        List<Setting> settings = settingDAO.findSettingsWithFilters(
                typeFilter, statusFilter, searchFilter, page, pageSize);

        int totalSettings = settingDAO.getTotalFilteredSettings(
                typeFilter, statusFilter, searchFilter);
        int totalPages = (int) Math.ceil((double) totalSettings / pageSize);

        // Set attributes for JSP
        request.setAttribute("settings", settings);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSettings", totalSettings);

        // Set filter values for maintaining state
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);

        request.getRequestDispatcher("view/dashboard/admin/setting_list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String settingIdStr = request.getParameter("id");
        if (settingIdStr != null && !settingIdStr.isEmpty()) {
            int settingId = Integer.parseInt(settingIdStr);
            SettingDAO settingDAO = new SettingDAO();
            Setting setting = settingDAO.findById(settingId);
            if (setting != null) {
                request.setAttribute("setting", setting);
                request.getRequestDispatcher("view/dashboard/admin/setting_details.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/manage-setting");
    }

    private void updateSetting(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer settingId = Integer.parseInt(request.getParameter("id"));
        Setting setting = new SettingDAO().findById(settingId);

        String type = request.getParameter("type");
        String value = request.getParameter("value");
        Integer order = Integer.parseInt(request.getParameter("order"));
        String status = request.getParameter("status");

        setting.setType(type);
        setting.setValue(value);
        setting.setOrder(order);
        setting.setStatus(status);

        SettingDAO settingDAO = new SettingDAO();
        boolean updated = settingDAO.update(setting);

        if (updated) {
            setToastMessage(request, "Setting updated successfully", "success");
            response.sendRedirect(request.getContextPath() + "/manage-setting?action=edit&id=" + settingId);
        } else {
            setToastMessage(request, "Failed to update setting", "error");
            request.setAttribute("setting", setting);
            request.getRequestDispatcher("view/dashboard/admin/setting_details.jsp").forward(request, response);
        }
    }

    private void deactivateSetting(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String settingIdStr = request.getParameter("id");
        if (settingIdStr != null && !settingIdStr.isEmpty()) {
            int settingId = Integer.parseInt(settingIdStr);
            SettingDAO settingDAO = new SettingDAO();
            Setting setting = settingDAO.findById(settingId);
            if (setting != null) {
                setting.setStatus("Inactive");
                boolean deactivated = settingDAO.update(setting);
                if (deactivated) {
                    setToastMessage(request, "Setting deactivated successfully", "success");
                } else {
                    setToastMessage(request, "Failed to deactivate setting", "error");
                }
            }
        } else {
            setToastMessage(request, "Invalid setting ID", "error");
        }
        response.sendRedirect(request.getContextPath() + "/manage-setting");
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }
}
