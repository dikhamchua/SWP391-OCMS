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
 * Filter để kiểm tra xem người dùng có phải là Admin không.
 * Nếu không phải Admin, chuyển hướng đến trang chủ với thông báo lỗi.
 */
@WebFilter(filterName = "AdminFilter", urlPatterns = {
    "/manage-account", "/manage-dashboard", "/manage-setting", "/manage-roles",
    "/admin/*", "/system-settings*"
})
public class AdminFilter implements Filter {

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
            
            if (account.getRoleId() == GlobalConfig.ROLE_ADMIN) {
                // Người dùng là Admin, cho phép truy cập
                chain.doFilter(request, response);
            } else {
                // Không phải Admin, chuyển hướng đến trang chủ với thông báo lỗi
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