/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ocms.controller.home;

import com.ocms.dal.AccountDAO;
import com.ocms.dal.BlogDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.ocms.dal.CategoryDAO;
import com.ocms.dal.CourseDAO;
import com.ocms.dal.SliderDAO;
import com.ocms.entity.Account;
import com.ocms.entity.Blog;
import com.ocms.entity.Category;
import com.ocms.entity.Course;
import com.ocms.entity.Slider;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.Date;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private SimpleDateFormat dateFormat; // Add this field

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // khai bao cac bien
        dateFormat = new SimpleDateFormat("dd MMM yyyy"); // Initialize date formatter
        CategoryDAO categoryDAO = new CategoryDAO();
        CourseDAO courseDAO = new CourseDAO();
        AccountDAO accountDAO = new AccountDAO();
        SliderDAO sliderDAO = new SliderDAO();
        BlogDAO blogDAO = new BlogDAO();
        //lay du lieu

        List<Category> listCategory = categoryDAO.findAll();
        List<Course> listCourse = courseDAO.findAll();
        List<Slider> activeSliders = sliderDAO.findActiveSliders();

        // Tạo HashMap để lưu trữ tên category theo ID
        Map<Integer, String> categoryMap = new HashMap<>();
        for (Category category : listCategory) {
            categoryMap.put(category.getId(), category.getName());
        }

        // Tạo HashMap để lưu trữ tên user theo ID
        Map<Integer, String> accountMap = new HashMap<>();
        List<Account> listAccount = accountDAO.findAll();
        for (Account account : listAccount) {
            accountMap.put(account.getId(), account.getFullName());
        }
        List<Blog> latestBlog = blogDAO.findLatestPosts();
        for (Blog blog : latestBlog) {
            if (blog.getCreatedDate() != null) {
                // Chuyển đổi LocalDateTime sang Date
                Date createdDate = Date.from(blog.getCreatedDate().atZone(ZoneId.systemDefault()).toInstant());
                blog.setCreatedDateAsDate(createdDate);

                // Vẫn giữ formattedDate nếu cần
                String formattedDate = dateFormat.format(createdDate);
                blog.setFormattedDate(formattedDate);
            }
        }

        // set attribute
        request.setAttribute("latestBlog", latestBlog);
        request.setAttribute("listCategory", listCategory);
        request.setAttribute("listCourse", listCourse);
        request.setAttribute("categoryMap", categoryMap);
        request.setAttribute("accountMap", accountMap);
        request.setAttribute("activeSliders", activeSliders);

        request.getRequestDispatcher("view/homepage/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/homepage/home.jsp").forward(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet HomeController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomeController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

}
