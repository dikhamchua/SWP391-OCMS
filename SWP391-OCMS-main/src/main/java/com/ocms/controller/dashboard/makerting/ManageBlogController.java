package com.ocms.controller.dashboard.makerting;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.AccountDAO;
import com.ocms.dal.BlogCategoryDAO;
import com.ocms.dal.BlogDAO;
import com.ocms.entity.Account;
import com.ocms.entity.Blog;
import com.ocms.entity.BlogCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
@WebServlet(name = "ManageBlogController", urlPatterns = { "/manage-blog" })
public class ManageBlogController extends HttpServlet {

    private final BlogDAO blogDAO = new BlogDAO();
    private final BlogCategoryDAO blogCategoryDAO = new BlogCategoryDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            handleListWithFilters(request, response);
        } else {
            switch (action) {
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "deactivate":
                    deactivateBlog(request, response);
                    break;
                case "activate":
                    activateBlog(request, response);
                    break;
                default:
                    handleListWithFilters(request, response);
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }
        switch (action) {
            case "add":
                addBlog(request, response);
                break;
            case "update":
                updateBlog(request, response);
                break;
            default:
                handleListWithFilters(request, response);
                break;
        }
    }

    private void handleListWithFilters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin người dùng từ session
        HttpSession session = request.getSession();
        Account loggedInUser = (Account) session.getAttribute("account");
        
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        // Get filter parameters
        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        Integer categoryId = null;
        String categoryIdStr = request.getParameter("categoryId");
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                categoryId = null;
            }
        }

        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Blog> blogs;
        int totalBlogs;
        
        // Chỉ Admin mới xem được tất cả blog, user khác chỉ xem được blog của mình
        if (loggedInUser.getRoleId() == GlobalConfig.ROLE_ADMIN) {
            // Admin - lấy tất cả blog
            blogs = blogDAO.findBlogsWithFilters(
                    searchFilter, statusFilter, categoryId, page, pageSize);
            totalBlogs = blogDAO.getTotalBlogs(
                    searchFilter, statusFilter, categoryId);
        } else {
            // User khác - chỉ lấy blog của mình
            blogs = blogDAO.findBlogsByAuthorWithFilters(
                    loggedInUser.getId(), searchFilter, statusFilter, categoryId, page, pageSize);
            totalBlogs = blogDAO.getTotalBlogsByAuthor(
                    loggedInUser.getId(), searchFilter, statusFilter, categoryId);
        }
        
        int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);

        // Get all blog categories
        List<BlogCategory> blogCategories = blogCategoryDAO.findAll();
        Map<Integer, BlogCategory> blogCategoryMap = blogCategories.stream()
                .collect(Collectors.toMap(BlogCategory::getId, item -> item));

        //Get all account 
        List<Account> accounts = accountDAO.findAll();
        Map<Integer, Account> accountMap = accounts.stream()
                .collect(Collectors.toMap(Account::getId, item -> item));

        // Set attributes for JSP
        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBlogs", totalBlogs);
        request.setAttribute("blogCategoryMap", blogCategoryMap);
        request.setAttribute("accountMap", accountMap);
        
        // Set user role for UI customization
        request.setAttribute("isAdmin", loggedInUser.getRoleId() == GlobalConfig.ROLE_ADMIN);

        // Set filter values for maintaining state
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);

        request.getRequestDispatcher("view/dashboard/marketing/blog_list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin người dùng từ session
        HttpSession session = request.getSession();
        Account loggedInUser = (Account) session.getAttribute("account");
        
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        String blogIdStr = request.getParameter("id");
        if (blogIdStr != null && !blogIdStr.isEmpty()) {
            int blogId = Integer.parseInt(blogIdStr);
            Blog blog = blogDAO.findById(blogId);
            
            // Kiểm tra quyền: chỉ admin hoặc tác giả mới có quyền sửa
            if (blog != null && (loggedInUser.getRoleId() == GlobalConfig.ROLE_ADMIN || blog.getAuthor() == loggedInUser.getId())) {
                List<BlogCategory> blogCategories = blogCategoryDAO.findAll();
                Map<Integer, BlogCategory> blogCategoryMap = blogCategories.stream()
                        .collect(Collectors.toMap(BlogCategory::getId, item -> item));
                request.setAttribute("blogCategoryMap", blogCategoryMap);
                request.setAttribute("blog", blog);
                request.getRequestDispatcher("view/dashboard/marketing/blog_details.jsp").forward(request, response);
                return;
            } else if (blog != null) {
                // Người dùng không có quyền sửa blog này
                setToastMessage(request, "You don't have permission to edit this blog", "error");
            } else {
                // Blog không tồn tại
                setToastMessage(request, "Blog not found", "error");
            }
        }
        response.sendRedirect(request.getContextPath() + "/manage-blog");
    }

    private void updateBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        Integer blogId = Integer.parseInt(request.getParameter("id"));
        Blog blog = blogDAO.findById(blogId);
        
        // Kiểm tra quyền: chỉ admin hoặc tác giả mới có quyền cập nhật
        if (blog == null || (account.getRoleId() != GlobalConfig.ROLE_ADMIN && blog.getAuthor() != account.getId())) {
            setToastMessage(request, "You don't have permission to update this blog", "error");
            response.sendRedirect(request.getContextPath() + "/manage-blog");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String briefInfo = request.getParameter("brief_info");
        Integer categoryId = Integer.parseInt(request.getParameter("category_id"));
        String status = request.getParameter("status");
        Integer author = blog.getAuthor(); // Giữ nguyên tác giả
        Part filePart = request.getPart("thumbnail");
        if (filePart != null && filePart.getSize() > 0) {
            // Delete old thumbnail if exists
            if (blog.getThumbnail() != null && !blog.getThumbnail().isEmpty()) {
                String oldThumbnailPath = request.getServletContext().getRealPath("/assets/img/blog/") 
                    + File.separator + blog.getThumbnail();
                File oldFile = new File(oldThumbnailPath);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }
            // Process and save new thumbnail
            String newThumbnail = processFileUpload(filePart, request);
            blog.setThumbnail(newThumbnail);
        }

        blog.setTitle(title);
        blog.setContent(content);
        blog.setBriefInfo(briefInfo);
        blog.setCategoryId(categoryId);
        blog.setStatus(status);
        blog.setUpdatedDate(LocalDateTime.now());

        boolean updated = blogDAO.update(blog);

        if (updated) {
            setToastMessage(request, "Blog updated successfully", "success");
            response.sendRedirect(request.getContextPath() + "/manage-blog?action=edit&id=" + blogId);
        } else {
            setToastMessage(request, "Failed to update blog", "error");
            request.setAttribute("blog", blog);
            request.getRequestDispatcher("view/dashboard/marketing/blog_details.jsp").forward(request, response);
        }
    }

    private void deactivateBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account loggedInUser = (Account) session.getAttribute("account");
        
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        String blogIdStr = request.getParameter("id");
        if (blogIdStr != null && !blogIdStr.isEmpty()) {
            int blogId = Integer.parseInt(blogIdStr);
            Blog blog = blogDAO.findById(blogId);
            
            // Kiểm tra quyền: chỉ admin hoặc tác giả mới có quyền vô hiệu hóa
            if (blog != null && (loggedInUser.getRoleId() == GlobalConfig.ROLE_ADMIN || blog.getAuthor() == loggedInUser.getId())) {
                blog.setStatus("Inactive");
                boolean deactivated = blogDAO.update(blog);
                if (deactivated) {
                    setToastMessage(request, "Blog deactivated successfully", "success");
                } else {
                    setToastMessage(request, "Failed to deactivate blog", "error");
                }
            } else if (blog != null) {
                // Người dùng không có quyền vô hiệu hóa blog này
                setToastMessage(request, "You don't have permission to deactivate this blog", "error");
            } else {
                // Blog không tồn tại
                setToastMessage(request, "Blog not found", "error");
            }
        } else {
            setToastMessage(request, "Invalid blog ID", "error");
        }
        response.sendRedirect(request.getContextPath() + "/manage-blog");
    }

    private void activateBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account loggedInUser = (Account) session.getAttribute("account");
        
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        // Chỉ Admin mới có quyền kích hoạt lại blog
        if (loggedInUser.getRoleId() != GlobalConfig.ROLE_ADMIN) {
            setToastMessage(request, "Only administrators can activate blogs", "error");
            response.sendRedirect(request.getContextPath() + "/manage-blog");
            return;
        }
        
        String blogIdStr = request.getParameter("id");
        if (blogIdStr != null && !blogIdStr.isEmpty()) {
            int blogId = Integer.parseInt(blogIdStr);
            Blog blog = blogDAO.findById(blogId);
            
            if (blog != null) {
                blog.setStatus("Active");
                boolean activated = blogDAO.update(blog);
                if (activated) {
                    setToastMessage(request, "Blog activated successfully", "success");
                } else {
                    setToastMessage(request, "Failed to activate blog", "error");
                }
            } else {
                setToastMessage(request, "Blog not found", "error");
            }
        } else {
            setToastMessage(request, "Invalid blog ID", "error");
        }
        response.sendRedirect(request.getContextPath() + "/manage-blog");
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all blog categories for the dropdown
        List<BlogCategory> blogCategories = blogCategoryDAO.findAll();
        Map<Integer, BlogCategory> blogCategoryMap = blogCategories.stream()
                .collect(Collectors.toMap(BlogCategory::getId, item -> item));
        request.setAttribute("blogCategoryMap", blogCategoryMap);

        request.getRequestDispatcher("view/dashboard/marketing/add_blog.jsp").forward(request, response);
    }

    private void addBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");
            if (account == null) {
                response.sendRedirect(request.getContextPath() + "/authen?action=login");
                return;
            }
            // Get form data
            String title = request.getParameter("title");
            String briefInfo = request.getParameter("briefInfo");
            String content = request.getParameter("content");
            Integer categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String status = request.getParameter("status");

            // Handle file upload for thumbnail
            Part filePart = request.getPart("thumbnail");
            String fileName = null;
            if (filePart != null && filePart.getSize() > 0) {
                fileName = processFileUpload(filePart, request);
            }

            // Create new blog object
            Blog blog = Blog.builder()
                    .title(title)
                    .briefInfo(briefInfo)
                    .content(content)
                    .categoryId(categoryId)
                    .status(status)
                    .thumbnail(fileName)
                    .author(account.getId()) // Người đăng nhập hiện tại là tác giả
                    .createdDate(LocalDateTime.now())
                    .updatedDate(LocalDateTime.now())
                    .build();

            // Save to database
            int blogId = blogDAO.insert(blog);

            if (blogId > 0) {
                setToastMessage(request, "Blog created successfully", "success");
                response.sendRedirect(request.getContextPath() + "/manage-blog");
            } else {
                setToastMessage(request, "Failed to create blog", "error");
                request.getRequestDispatcher("view/dashboard/marketing/add_blog.jsp").forward(request, response);
            }
        } catch (Exception e) {
            setToastMessage(request, "Error creating blog: " + e.getMessage(), "error");
            response.sendRedirect(request.getContextPath() + "/manage-blog?action=add");
        }
    }

    private String processFileUpload(Part filePart, HttpServletRequest request) throws IOException {
        String fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(filePart);
        String uploadPath = request.getServletContext().getRealPath("/assets/img/blog/");
        
        // In ra đường dẫn tuyệt đối trên máy
        System.out.println("Đường dẫn tuyệt đối để lưu file: " + uploadPath);

        // Create directory if it doesn't exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Save file
        filePart.write(uploadPath + File.separator + fileName);
        return fileName;
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }
}
