package com.ocms.controller.filter;

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
 * Filter để xử lý và hiển thị thông báo lỗi từ các filter khác.
 * Filter này chạy trước tất cả các filter khác để đặt thông báo lỗi từ session vào request attribute.
 */
@WebFilter(filterName = "ErrorHandlerFilter", urlPatterns = {"/*"})
public class ErrorHandlerFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);

        if (session != null) {
            // Kiểm tra xem có thông báo lỗi trong session không
            String errorMessage = (String) session.getAttribute("errorMessage");
            if (errorMessage != null) {
                // Chuyển thông báo lỗi từ session sang request attribute để JSP có thể hiển thị
                request.setAttribute("errorMessage", errorMessage);
                // Xóa thông báo lỗi khỏi session để không hiển thị lại
                session.removeAttribute("errorMessage");
            }
            
            // Kiểm tra xem có thông báo thành công trong session không
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
                // Chuyển thông báo thành công từ session sang request attribute
                request.setAttribute("successMessage", successMessage);
                // Xóa thông báo khỏi session
                session.removeAttribute("successMessage");
            }
        }

        // Tiếp tục xử lý request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Không cần dọn dẹp
    }
} 