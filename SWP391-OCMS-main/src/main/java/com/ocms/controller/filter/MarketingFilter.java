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
 * Filter để kiểm tra quyền truy cập các trang Marketing.
 * Chỉ cho phép Admin và nhân viên Marketing (có thể là Teacher được giao nhiệm vụ marketing) truy cập.
 */
@WebFilter(filterName = "MarketingFilter", urlPatterns = {
    "/manage-blog*", "/manage-slider*", "/manage-post*", "/marketing/*",
    "/edit-blog*", "/add-blog*", "/marketing-dashboard*"
})
public class MarketingFilter implements Filter {

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
            
            // Cho phép Admin truy cập trang Marketing
            // Để đơn giản, cho cả Teacher truy cập (có thể đổi thành role Marketing cụ thể trong tương lai)
            if (account.getRoleId() == GlobalConfig.ROLE_ADMIN || account.getRoleId() == GlobalConfig.ROLE_TEACHER) {
                // Người dùng là Admin hoặc Marketing, cho phép truy cập
                chain.doFilter(request, response);
            } else {
                // Không có quyền, chuyển hướng đến trang chủ với thông báo lỗi
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