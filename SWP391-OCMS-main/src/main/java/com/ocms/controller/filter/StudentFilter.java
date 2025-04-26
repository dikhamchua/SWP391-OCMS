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
 * Filter để kiểm tra xem người dùng có quyền truy cập các trang dành cho Student không.
 * Cho phép Student, Teacher và Admin truy cập.
 */
@WebFilter(filterName = "StudentFilter", urlPatterns = {
    "/my-courses", "/my-quiz*", "/my-learning*", "/student-wishlist*",
    "/student-review*", "/student-attempts*", "/student/*", "/course-content*"
})
public class StudentFilter implements Filter {

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
            
            // Tất cả người dùng đã đăng nhập đều có thể truy cập
            // Trang đăng ký và học dành cho tất cả mọi người
            chain.doFilter(request, response);
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