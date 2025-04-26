package com.ocms.controller.filter;

import com.ocms.config.GlobalConfig;
import com.ocms.entity.Account;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter để kiểm tra xem người dùng có phải là Teacher không.
 * Chỉ cho phép Teacher và Admin truy cập.
 */
@WebFilter(filterName = "TeacherFilter", urlPatterns = {
    "/manage-course*", "/manage-lesson*", "/manage-quiz*", "/create-course*",
    "/edit-course*", "/view-course-detail*", "/teacher/*", "/teacher-dashboard*"
})
public class TeacherFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute(GlobalConfig.SESSION_ACCOUNT) != null);
        
        if (isLoggedIn) {
            Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
            
            // Cho phép cả Admin và Teacher truy cập
            if (account.getRoleId() == GlobalConfig.ROLE_TEACHER || account.getRoleId() == GlobalConfig.ROLE_ADMIN) {
                // Người dùng là Teacher hoặc Admin, cho phép truy cập
                chain.doFilter(request, response);
            } else {
                // Không phải Teacher hoặc Admin, chuyển hướng đến trang chủ với thông báo lỗi
                session.setAttribute("errorMessage", "Bạn không có quyền truy cập trang này");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
            }
        } else {
            // Chưa đăng nhập, chuyển hướng đến trang đăng nhập
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/authen?action=login");
        }
    }

    @Override
    public void destroy() {
        // Không cần dọn dẹp
    }
} 