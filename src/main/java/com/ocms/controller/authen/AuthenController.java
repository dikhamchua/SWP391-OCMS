/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ocms.controller.authen;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.AccountDAO;
import com.ocms.entity.Account;
import com.ocms.utils.EmailUtils;
import com.ocms.utils.MD5PasswordEncoderUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AuthenController", urlPatterns = { "/authen" })
public class AuthenController extends HttpServlet {

    AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // get ve action
        String action = request.getParameter("action") != null
                ? request.getParameter("action")
                : "";
        // dua theo action set URL trang can chuyen den
        String url;
        switch (action) {
            case "login":
                // url = "view/authen/login.jsp";
                url = fakeLogin(request, response);
                break;
            case "logout":
                url = logOut(request, response);
                break;
            case "sign-up":
                url = "view/authen/register.jsp";
                break;
            case "enter-email":
                url = "view/authen/enterEmailForgotPassword.jsp";
                break;
            default:
                url = "view/authen/login.jsp";
        }

        // chuyen trang
        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // get ve action
        String action = request.getParameter("action") != null
                ? request.getParameter("action")
                : "";
        // dựa theo action để xử lí request
        String url;
        switch (action) {
            case "login":
                url = loginDoPost(request, response);
                break;
            case "sign-up":
                url = signUp(request, response);
                break;
            case "verify-otp":
                url = verifyOTP(request, response);
                break;
            case "forgot-password":
                url = forgotPassword(request, response);
                break;
            case "reset-password":
                url = resetPassword(request, response);
                break;
            default:
                url = "home";
        }
        request.getRequestDispatcher(url).forward(request, response);

    }

    private String logOut(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().removeAttribute(GlobalConfig.SESSION_ACCOUNT);
        return "home";
    }

    private String loginDoPost(HttpServletRequest request, HttpServletResponse response) {
        String url = null;
        // get về các thong tin người dufg nhập
        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");
        // kiểm tra thông tin có tồn tại trong DB ko
        Account account = Account.builder()
                .username(usernameOrEmail)
                .email(usernameOrEmail)
                .password(MD5PasswordEncoderUtils.encodeMD5(password))
                .build();
        Account accFoundByUsernamePass = accountDAO.findByEmailOrUsernameAndPass(account);
        // true => trang home ( set account vao trong session )
        if (accFoundByUsernamePass != null) {
            request.getSession().setAttribute(GlobalConfig.SESSION_ACCOUNT,
                    accFoundByUsernamePass);
            url = "home";
            // false => quay tro lai trang login ( set them thong bao loi )
        } else {
            request.setAttribute("error", "Username or password incorrect!!");
            url = "view/authen/login.jsp";
        }
        return url;
    }

    private String signUp(HttpServletRequest request, HttpServletResponse response) {
        String url;
        // Lấy thông tin người dùng nhập
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu và xác nhận mật khẩu có khớp không
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Password and confirm password not matching");
            return "view/authen/register.jsp";
        }

        // Kiểm tra xem email đã tồn tại trong db chưa
        Account account = Account.builder()
                .username(username)
                .email(email)
                .password(MD5PasswordEncoderUtils.encodeMD5(password))
                .roleId(GlobalConfig.ROLE_STUDENT)
                .isActive(false) // Đặt trạng thái ban đầu là "Inactive"
                .gender(true)
                .build();
        Account accountFoundByEmail = accountDAO.findByEmail(account);

        if (accountFoundByEmail != null) {
            if (accountFoundByEmail.getUsername().equalsIgnoreCase(username)) {
                request.setAttribute("error", "Username already exist!!");
            } else {
                request.setAttribute("error", "Email already exists!");
            }
            url = "view/authen/register.jsp";
        } else {
            // Lưu tài khoản vào database
            int accountId = accountDAO.insert(account);
            if (accountId > 0) {
                // Tạo session cho việc kích hoạt tài khoản sau này
                HttpSession session = request.getSession();
                account.setId(accountId);
                session.setAttribute(GlobalConfig.SESSION_ACCOUNT, account);
                session.setAttribute("email", email);
                session.setMaxInactiveInterval(300);

                // Gửi OTP
                String otp = EmailUtils.sendOTPMail(email);
                session.setAttribute("otp", otp);
                session.setAttribute("otp_purpose", "activation"); // Thêm mục đích OTP

                url = "view/authen/verifyOTP.jsp";
            } else {
                request.setAttribute("error", "Failed to create account. Please try again.");
                url = "view/authen/register.jsp";
            }
        }
        return url;
    }

    private String verifyOTP(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String storedOTP = (String) session.getAttribute("otp");
        String email = (String) session.getAttribute("email");
        String enteredOTP = request.getParameter("otp");
        String purpose = (String) session.getAttribute("otp_purpose");

        if (storedOTP != null && storedOTP.equals(enteredOTP)) {
            // OTP is correct
            session.removeAttribute("otp");

            if ("activation".equals(purpose)) {
                return handleAccountActivation(request, session);
            } else if ("password_reset".equals(purpose)) {
                return handlePasswordReset(request, session);
            } else {
                request.setAttribute("error", "Invalid OTP purpose.");
                return "view/authen/otp-verification.jsp";
            }
        } else {
            // Incorrect OTP
            request.setAttribute("error", "Incorrect OTP. Please try again.");
            return "view/authen/otp-verification.jsp";
        }
    }

    private String forgotPassword(HttpServletRequest request, HttpServletResponse response) {
        String url;
        String email = request.getParameter("email");

        // Kiểm tra xem email có tồn tại trong cơ sở dữ liệu không
        Account account = Account.builder().email(email).build();
        Account foundAccount = accountDAO.findByEmail(account);

        if (foundAccount == null) {
            // Email không tìm thấy trong cơ sở dữ liệu
            request.setAttribute("error", "No account found with this email address.");
            url = "view/authen/enterEmailForgotPassword.jsp";
            return url;
        }

        // Gửi OTP
        HttpSession session = request.getSession();
        String otp = EmailUtils.sendOTPMail(email);

        // Lưu thông tin vào session
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);
        session.setAttribute("otp_purpose", "password_reset");
        session.setAttribute("account_id", foundAccount.getId());

        // Đặt thời gian hết hạn cho session (ví dụ: 15 phút)
        session.setMaxInactiveInterval(15 * 60);

        url = "view/authen/verifyOTP.jsp";
        return url;
    }

    private String handleAccountActivation(HttpServletRequest request, HttpSession session) {
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        if (account != null) {
            account.setIsActive(true);
            accountDAO.activateAccount(account.getId());
            request.setAttribute("message", "Your account has been successfully activated!");
            return "home";
        } else {
            request.setAttribute("error", "Session expired. Please sign up again.");
            return "view/authen/register.jsp";
        }
    }

    private String handlePasswordReset(HttpServletRequest request, HttpSession session) {
        // Redirect to password reset page
        return "view/authen/resetPassword.jsp";
    }

    private String resetPassword(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            return "view/authen/resetPassword.jsp";
        }

        Account account = Account.builder()
                .email(email)
                .password(MD5PasswordEncoderUtils.encodeMD5(newPassword))
                .build();

        boolean updated = accountDAO.updatePassword(account);
        if (updated) {
            request.setAttribute("message", "Your password has been successfully reset.");
            return "view/authen/login.jsp";
        } else {
            request.setAttribute("error", "Failed to reset password. Please try again.");
            return "view/authen/resetPassword.jsp";
        }
    }

    private String fakeLogin(HttpServletRequest request, HttpServletResponse response) {
        String url = null;
        // get về các thong tin người dufg nhập
        String email = "admin";
        String password = "1";
        // kiểm tra thông tin có tồn tại trong DB ko
        Account account = Account.builder()
                .username(email)
                .email(email)
                .password(MD5PasswordEncoderUtils.encodeMD5(password))
                .build();
        Account accFoundByUsernamePass = accountDAO.findByEmailOrUsernameAndPass(account);
        // true => trang home ( set account vao trong session )
        if (accFoundByUsernamePass != null) {
            request.getSession().setAttribute(GlobalConfig.SESSION_ACCOUNT,
                    accFoundByUsernamePass);
            url = "home";
            // false => quay tro lai trang login ( set them thong bao loi )
        } else {
            request.setAttribute("error", "Username or password incorrect!!");
            url = "view/authen/login.jsp";
        }
        return url;
    }

}
