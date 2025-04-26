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
 * Filter để kiểm tra xem người dùng đã đăng nhập chưa.
 * Nếu chưa đăng nhập, chuyển hướng đến trang đăng nhập.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
    "/dashboard*", "/manage-*", "/my-*", "/course-detail*", "/checkout*",
    "/profile*", "/dashboard-profile"
})
public class AuthenticationFilter implements Filter {

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
            // Người dùng đã đăng nhập, tiếp tục xử lý request
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