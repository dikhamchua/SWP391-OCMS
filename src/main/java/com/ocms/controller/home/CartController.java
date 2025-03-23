package com.ocms.controller.home;

import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.CartDAO;
import com.ocms.dal.CartItemDAO;
import com.ocms.dal.CourseDAO;
import com.ocms.entity.Cart;
import com.ocms.entity.CartItem;
import com.ocms.entity.Account;
import com.ocms.entity.Course;
import jakarta.servlet.http.HttpSession;
import java.util.List;


@WebServlet("/cart")
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;
    private CourseDAO courseDAO;

    private static final String CART_JSP = "view/homepage/cart.jsp";

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();    
        cartItemDAO = new CartItemDAO();
        courseDAO = new CourseDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        // Get the user's cart
        Cart cart = cartDAO.getOrCreateCart(account.getId());
        
        // Get cart items with course details
        List<CartItem> cartItems = cartItemDAO.getCartItemsWithCourseDetails(cart.getId());
        
        // Calculate cart total
        BigDecimal cartTotal = cartItemDAO.getCartTotal(cart.getId());
        
        // Set attributes for the JSP
        request.setAttribute("cart", cart);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("itemCount", cartItems.size());
        
        request.getRequestDispatcher(CART_JSP).forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "add":
                    addToCart(request, response);
                    break;
                case "remove":
                    removeFromCart(request, response);
                    break;
                case "update":
                    // updateCart(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/cart");
                    break;
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        if (account == null) {
            // Redirect to login if not logged in
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        String courseId = request.getParameter("courseId");
        String priceStr = request.getParameter("price");
        
        if (courseId != null && priceStr != null) {
            try {
                int courseIdInt = Integer.parseInt(courseId);
                BigDecimal price = new BigDecimal(priceStr);
                
                // Get or create cart for the user
                Cart cart = cartDAO.getOrCreateCart(account.getId());
                
                // Check if course is already in cart
                if (!cartItemDAO.isInCart(cart.getId(), courseIdInt)) {
                    // Create new cart item
                    CartItem cartItem = new CartItem();
                    cartItem.setCartId(cart.getId());
                    cartItem.setCourseId(courseIdInt);
                    cartItem.setPrice(price);
                    
                    // Add to cart
                    int result = cartItemDAO.insert(cartItem);
                    
                    if (result > 0) {
                        session.setAttribute("message", "Course added to cart successfully!");
                        session.setAttribute("messageType", "success");
                    } else {
                        session.setAttribute("message", "Failed to add course to cart.");
                        session.setAttribute("messageType", "error");
                    }
                } else {
                    session.setAttribute("message", "This course is already in your cart.");
                    session.setAttribute("messageType", "info");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("message", "Invalid course or price information.");
                session.setAttribute("messageType", "error");
            }
        } else {
            session.setAttribute("message", "Missing required information.");
            session.setAttribute("messageType", "error");
        }
        
        // Redirect back to cart page
        response.sendRedirect(request.getContextPath() + "/cart");
    }
    
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        String courseId = request.getParameter("courseId");
        
        if (courseId != null) {
            try {
                int courseIdInt = Integer.parseInt(courseId);
                
                // Get user's cart
                Cart cart = cartDAO.findByAccountId(account.getId());
                
                if (cart != null) {
                    // Remove item from cart
                    boolean removed = cartItemDAO.removeFromCart(cart.getId(), courseIdInt);
                    
                    if (removed) {
                        session.setAttribute("message", "Course removed from cart successfully!");
                        session.setAttribute("messageType", "success");
                    } else {
                        session.setAttribute("message", "Failed to remove course from cart.");
                        session.setAttribute("messageType", "error");
                    }
                } else {
                    session.setAttribute("message", "Cart not found.");
                    session.setAttribute("messageType", "error");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("message", "Invalid course information.");
                session.setAttribute("messageType", "error");
            }
        } else {
            session.setAttribute("message", "Missing required information.");
            session.setAttribute("messageType", "error");
        }
        
        // Redirect back to cart page
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
