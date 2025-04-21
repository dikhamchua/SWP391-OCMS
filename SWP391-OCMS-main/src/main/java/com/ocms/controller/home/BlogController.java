package com.ocms.controller.home;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.text.SimpleDateFormat; // Add this import

import com.ocms.dal.BlogCategoryDAO;
import com.ocms.dal.BlogDAO;
import com.ocms.entity.Blog;
import com.ocms.entity.BlogCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;

@WebServlet(urlPatterns = { "/blog", "/blog-details" })
public class BlogController extends HttpServlet {

    private BlogDAO blogDAO;
    private BlogCategoryDAO blogCategoryDAO;
    private SimpleDateFormat dateFormat; // Add this field

    @Override
    public void init() {
        blogDAO = new BlogDAO();
        blogCategoryDAO = new BlogCategoryDAO();
        dateFormat = new SimpleDateFormat("dd MMM yyyy"); // Initialize date formatter
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/blog":
                listBlogs(request, response);
                break;
            case "/blog-details":
                showBlogDetails(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý form tìm kiếm
        String searchTerm = request.getParameter("search");
        String categoryId = request.getParameter("category");

        // Redirect về doGet với các tham số tìm kiếm
        String redirectURL = "blog?page=1";
        if (searchTerm != null && !searchTerm.isEmpty()) {
            redirectURL += "&search=" + java.net.URLEncoder.encode(searchTerm, "UTF-8");
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            redirectURL += "&category=" + categoryId;
        }

        response.sendRedirect(redirectURL);
    }

    private void listBlogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy các tham số phân trang và tìm kiếm
        String searchTerm = request.getParameter("search");
        Integer categoryId = null;
        int page = 1;
        int pageSize = 9;

        // Xử lý tham số tìm kiếm
        if (request.getParameter("category") != null && !request.getParameter("category").isEmpty()) {
            try {
                categoryId = Integer.parseInt(request.getParameter("category"));
            } catch (NumberFormatException e) {
                // Log error if needed
            }
        }

        if (request.getParameter("page") != null && !request.getParameter("page").isEmpty()) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1)
                    page = 1;
            } catch (NumberFormatException e) {
                // Log error if needed
            }
        }

        // Lấy danh sách blog với bộ lọc
        String status = "Active";
        List<Blog> blogs = blogDAO.findBlogsWithFilters(searchTerm, status, categoryId, page, pageSize);
        
        // Format dates for each blog
        Map<Integer, String> formattedDates = new HashMap<>();
        for (Blog blog : blogs) {
            if (blog.getCreatedDate() != null) {
                formattedDates.put(blog.getId(), dateFormat.format(blog.getCreatedDate()));
            }
        }
        
        int totalBlogs = blogDAO.getTotalBlogs(searchTerm, status, categoryId);

        // Lấy danh sách categories cho sidebar
        List<BlogCategory> blogCategories = blogCategoryDAO.findAll();
        Map<Integer, BlogCategory> blogCategoryMap = blogCategories.stream()
                .collect(Collectors.toMap(BlogCategory::getId, category -> category));

        // Lấy các bài viết mới nhất cho sidebar
        List<Blog> latestBlogs = blogDAO.findLatestPosts();

        // Tính toán phân trang
        int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);

        // Set attributes
        request.setAttribute("blogs", blogs);
        request.setAttribute("latestBlogs", latestBlogs);
        request.setAttribute("blogCategoryMap", blogCategoryMap);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("categoryId", categoryId);

        // Add formatted dates to request
        request.setAttribute("formattedDates", formattedDates);
        
        // Forward to JSP
        request.getRequestDispatcher("/view/homepage/blog.jsp").forward(request, response);
    }

    private void showBlogDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int blogId = Integer.parseInt(request.getParameter("id"));
            Blog blog = blogDAO.findById(blogId);
            
            if (blog == null || !"Active".equals(blog.getStatus())) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Format the date if needed
            if (blog.getCreatedDate() != null) {
                String formattedDate = dateFormat.format(blog.getCreatedDate());
                request.setAttribute("formattedDate", formattedDate);
            }

            // Lấy thông tin category của blog
            BlogCategory category = blogCategoryDAO.findById(blog.getCategoryId());
            
            // Set attributes
            request.setAttribute("blog", blog);
            request.setAttribute("category", category);
            
            // Thêm các thuộc tính sidebar chung
            setCommonSidebarAttributes(request);

            request.getRequestDispatcher("/view/homepage/blog-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void setCommonSidebarAttributes(HttpServletRequest request) {
        // Lấy danh sách categories cho sidebar
        List<BlogCategory> blogCategories = blogCategoryDAO.findAll();
        Map<Integer, BlogCategory> blogCategoryMap = blogCategories.stream()
                .collect(Collectors.toMap(BlogCategory::getId, category -> category));
        
        // Lấy các bài viết mới nhất cho sidebar
        List<Blog> latestBlogs = blogDAO.findLatestPosts();
        
        request.setAttribute("latestBlogs", latestBlogs);
        request.setAttribute("blogCategoryMap", blogCategoryMap);
    }
}
