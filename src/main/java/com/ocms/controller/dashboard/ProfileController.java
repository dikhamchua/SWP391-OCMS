package com.ocms.controller.dashboard;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.AccountDAO;
import com.ocms.entity.Account;
import com.ocms.utils.MD5PasswordEncoderUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet(name = "ProfileController", urlPatterns = {"/dashboard-profile"})
@MultipartConfig
public class ProfileController extends HttpServlet {

    private AccountDAO accountDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        accountDAO = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") == null
                ? ""
                : request.getParameter("action");
        String url = "view/dashboard/profile.jsp";
        switch (action) {
            case "change-pw":
                url = "view/dashboard/change-password.jsp";
                break;
            case "view-profile":
                url = viewProfile(request, response);
                break;
            default:
                url = viewProfile(request, response);
        }
        
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen");
            return;
        }
        String url = "view/dashboard/profile.jsp";
        String action = request.getParameter("action");
        switch (action) {
            case "changePassword" -> url = handleChangePassword(request, response, account);
            case "updateProfile" -> url = handleUpdateProfile(request, response, account);
            case "uploadProfileImage" -> url = handleProfileImageUpload(request, response, account);
            default -> {
                request.setAttribute("toastMessage", "Invalid action.");
                request.setAttribute("toastType", "error");
            }
        }

        // Refresh account details and forward to profile page
        refreshAccountDetails(request, account);
        request.getRequestDispatcher(url).forward(request, response);
    }

    private String handleChangePassword(HttpServletRequest request, HttpServletResponse response, Account account) {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!account.getPassword().equals(MD5PasswordEncoderUtils.encodeMD5(currentPassword))) {
            setToastMessage(request, "Current password is incorrect.", "error");
        } else if (!newPassword.equals(confirmPassword)) {
            setToastMessage(request, "New password and confirm password do not match.", "error");
        } else {
            account.setPassword(MD5PasswordEncoderUtils.encodeMD5(newPassword));
            boolean updateSuccess = accountDAO.updatePassword(account);
            if (updateSuccess) {
                request.getSession().setAttribute(GlobalConfig.SESSION_ACCOUNT, account);
                setToastMessage(request, "Password changed successfully!", "success");
            } else {
                setToastMessage(request, "Failed to change password. Please try again.", "error");
            }
        }
        return "view/dashboard/profile.jsp";
    }

    private String handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, Account account) {
        String gender = request.getParameter("gender");
        account.setGender(Boolean.parseBoolean(gender));
        account.setFullName(request.getParameter("fullName"));
        account.setPhone(request.getParameter("phone"));

        boolean updateSuccess = accountDAO.update(account);
        if (updateSuccess) {
            request.getSession().setAttribute(GlobalConfig.SESSION_ACCOUNT, account);
            setToastMessage(request, "Profile updated successfully!", "success");
        } else {
            setToastMessage(request, "Failed to update profile. Please try again.", "error");
        }
        return "view/dashboard/profile.jsp";
    }

    private void refreshAccountDetails(HttpServletRequest request, Account account) {
        Account updatedAccount = accountDAO.findByEmail(account);
        request.setAttribute("accountDetails", updatedAccount != null ? updatedAccount : account);
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.setAttribute("toastMessage", message);
        request.setAttribute("toastType", type);
    }

    private String viewProfile(HttpServletRequest request, HttpServletResponse response) {
        String url;
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        if (account == null) {
            url = "authen";
            return url;
        }

        Account detailedAccount = accountDAO.findByEmail(account);
        request.setAttribute("accountDetails", detailedAccount != null ? detailedAccount : account);
        return "view/dashboard/profile.jsp";
    }

    private String handleProfileImageUpload(HttpServletRequest request, HttpServletResponse response, Account account) 
            throws IOException, ServletException {
        try {
            Part filePart = request.getPart("profileImage");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            // Generate a unique file name to prevent overwriting
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);

            // Update account with new image path
            account.setAvatar("/uploads/" + uniqueFileName);
            boolean updateSuccess = accountDAO.updateProfileImage(account);
            
            if (updateSuccess) {
                request.getSession().setAttribute(GlobalConfig.SESSION_ACCOUNT, account);
                setToastMessage(request, "Profile image updated successfully!", "success");
            } else {
                setToastMessage(request, "Failed to update profile image. Please try again.", "error");
            }
        } catch (Exception e) {
            setToastMessage(request, "Error uploading image: " + e.getMessage(), "error");
        }
        
        return "view/dashboard/profile.jsp";
    }
}
