package com.ocms.controller.dashboard.marketing;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.ocms.dal.AccountDAO;
import com.ocms.dal.SliderDAO;
import com.ocms.entity.Account;
import com.ocms.entity.Slider;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
@WebServlet(name = "ManageSliderController", urlPatterns = { "/manage-slider" })
public class ManageSliderController extends HttpServlet {

    private final SliderDAO sliderDAO = new SliderDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            handleListWithFilters(request, response);
        } else {
            switch (action) {
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "deactivate":
                    deactivateSlider(request, response);
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
            case "add":
                addSlider(request, response);
                break;
            case "update":
                updateSlider(request, response);
                break;
            default:
                handleListWithFilters(request, response);
                break;
        }
    }

    private void handleListWithFilters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");

        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Slider> sliders = sliderDAO.findSlidersWithFilters(
                searchFilter, statusFilter, page, pageSize);
        int totalSliders = sliderDAO.getTotalSliders(
                searchFilter, statusFilter);
        int totalPages = (int) Math.ceil((double) totalSliders / pageSize);

        //Get all account 
        List<Account> accounts = accountDAO.findAll();
        Map<Integer, Account> accountMap = accounts.stream()
                .collect(Collectors.toMap(Account::getId, item -> item));

        // Set attributes for JSP
        request.setAttribute("sliders", sliders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSliders", totalSliders);
        request.setAttribute("accountMap", accountMap);

        // Set filter values for maintaining state
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);

        request.getRequestDispatcher("view/dashboard/marketing/slider_list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sliderIdStr = request.getParameter("id");
        if (sliderIdStr != null && !sliderIdStr.isEmpty()) {
            int sliderId = Integer.parseInt(sliderIdStr);
            Slider slider = sliderDAO.findById(sliderId);
            if (slider != null) {
                request.setAttribute("slider", slider);
                request.getRequestDispatcher("view/dashboard/marketing/slider_details.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/manage-slider");
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/dashboard/marketing/slider_details.jsp").forward(request, response);
    }

    private void addSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String title = request.getParameter("title");
        String backlink = request.getParameter("backlink");
        String notes = request.getParameter("notes");
        String status = request.getParameter("status");

        Part filePart = request.getPart("image");
        String fileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
            String uploadPath = request.getServletContext().getRealPath("") + "assets/img/slider";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            filePart.write(uploadPath + File.separator + fileName);
        }

        Slider slider = Slider.builder()
                .title(title)
                .imageUrl(fileName != null ? "assets/img/slider/" + fileName : null)
                .backlink(backlink)
                .notes(notes)
                .status(status)
                .createdBy(account.getId())
                .build();

        int result = sliderDAO.insert(slider);
        if (result > 0) {
            session.setAttribute("toastMessage", "Slider added successfully!");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Failed to add slider!");
            session.setAttribute("toastType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/manage-slider");
    }

    private void updateSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer sliderId = Integer.parseInt(request.getParameter("id"));
        Slider slider = sliderDAO.findById(sliderId);

        String title = request.getParameter("title");
        String backlink = request.getParameter("backlink");
        String notes = request.getParameter("notes");
        String status = request.getParameter("status");

        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            // Delete old image if exists
            if (slider.getImageUrl() != null && !slider.getImageUrl().isEmpty()) {
                String oldImagePath = request.getServletContext().getRealPath("") + slider.getImageUrl();
                File oldImage = new File(oldImagePath);
                if (oldImage.exists()) {
                    oldImage.delete();
                }
            }

            // Save new image
            String fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
            String uploadPath = request.getServletContext().getRealPath("") + "assets/img/slider";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            filePart.write(uploadPath + File.separator + fileName);
            slider.setImageUrl("assets/img/slider/" + fileName);
        }

        slider.setTitle(title);
        slider.setBacklink(backlink);
        slider.setNotes(notes);
        slider.setStatus(status);

        boolean result = sliderDAO.update(slider);
        if (result) {
            session.setAttribute("toastMessage", "Slider updated successfully!");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Failed to update slider!");
            session.setAttribute("toastType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/manage-slider");
    }

    private void deactivateSlider(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String sliderIdStr = request.getParameter("id");
        if (sliderIdStr != null && !sliderIdStr.isEmpty()) {
            int sliderId = Integer.parseInt(sliderIdStr);
            Slider slider = sliderDAO.findById(sliderId);
            if (slider != null) {
                slider.setStatus("Inactive");
                boolean result = sliderDAO.update(slider);
                if (result) {
                    session.setAttribute("toastMessage", "Slider deactivated successfully!");
                    session.setAttribute("toastType", "success");
                } else {
                    session.setAttribute("toastMessage", "Failed to deactivate slider!");
                    session.setAttribute("toastType", "error");
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/manage-slider");
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
