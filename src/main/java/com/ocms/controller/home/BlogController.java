package com.ocms.controller.home;

import java.io.IOException;
import java.util.List;

import com.ocms.dal.BlogDAO;
import com.ocms.entity.Blog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/blog")
public class BlogController extends HttpServlet {

    private BlogDAO blogDAO;

    @Override
    public void init() {
        blogDAO = new BlogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy các tham số phân trang
        int page = 1;
        int pageSize = 9; // Số blog hiển thị trên mỗi trang

        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Lấy các tham số tìm kiếm nếu có
        String searchTerm = request.getParameter("search");
        String status = "Active"; // Chỉ lấy các blog đang active
        Integer categoryId = null;
        if (request.getParameter("category") != null) {
            try {
                categoryId = Integer.parseInt(request.getParameter("category"));
            } catch (NumberFormatException e) {
                categoryId = null;
            }
        }

        // Lấy danh sách blog và tổng số blog
        List<Blog> blogs = blogDAO.findBlogsWithFilters(searchTerm, status, categoryId, page, pageSize);
        int totalBlogs = blogDAO.getTotalBlogs(searchTerm, status, categoryId);

        // Tính tổng số trang
        int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);

        // Set attributes cho JSP
        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("categoryId", categoryId);

        // Forward đến trang JSP
        request.getRequestDispatcher("/view/homepage/blog.jsp").forward(request, response);
    }
}
