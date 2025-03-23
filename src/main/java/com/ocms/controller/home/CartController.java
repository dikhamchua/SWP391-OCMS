package com.ocms.controller.home;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.CartDAO;
import com.ocms.dal.CartItemDAO;
import com.ocms.dal.CourseDAO;
import com.ocms.dal.RegistrationDAO;
import com.ocms.entity.Cart;
import com.ocms.entity.CartItem;
import com.ocms.entity.Account;
import com.ocms.entity.Registration;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Calendar;

@WebServlet("/cart")
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;
    private CourseDAO courseDAO;
    private RegistrationDAO registrationDAO;

    private static final String CART_JSP = "view/homepage/cart.jsp";
    private static final String CHECKOUT_JSP = "view/homepage/checkout.jsp";

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        cartItemDAO = new CartItemDAO();
        courseDAO = new CourseDAO();
        registrationDAO = new RegistrationDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        request.setAttribute("courseDAO", courseDAO);

        request.getRequestDispatcher(CART_JSP).forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null) {
            switch (action) {
                case "add":
                    addToCart(request, response);
                    break;
                case "remove":
                    removeFromCart(request, response);
                    break;
                case "checkout":
                    processCheckout(request, response);
                    break;
                case "complete-checkout":
                    completeCheckout(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/cart");
                    break;
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        // Get the item ID from the request
        String itemId = request.getParameter("itemId");

        if (itemId != null && !itemId.isEmpty()) {
            try {
                int itemIdInt = Integer.parseInt(itemId);

                // Get user's cart
                Cart cart = cartDAO.findByAccountId(account.getId());

                if (cart != null) {
                    // Get the cart item to verify it belongs to this user's cart
                    CartItem cartItem = cartItemDAO.getById(itemIdInt);

                    if (cartItem != null && cartItem.getCartId().equals(cart.getId())) {
                        // Remove item from cart
                        boolean removed = cartItemDAO.delete(cartItem);

                        if (removed) {
                            session.setAttribute("message", "Course removed from cart successfully!");
                            session.setAttribute("messageType", "success");
                        } else {
                            session.setAttribute("message", "Failed to remove course from cart.");
                            session.setAttribute("messageType", "error");
                        }
                    } else {
                        session.setAttribute("message", "Item not found in your cart.");
                        session.setAttribute("messageType", "error");
                    }
                } else {
                    session.setAttribute("message", "Cart not found.");
                    session.setAttribute("messageType", "error");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("message", "Invalid item information.");
                session.setAttribute("messageType", "error");
            }
        } else {
            session.setAttribute("message", "Missing required information.");
            session.setAttribute("messageType", "error");
        }

        // Redirect back to cart page
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        // Get user's cart
        Cart cart = cartDAO.findByAccountId(account.getId());
        
        if (cart == null || cartItemDAO.countCartItems(cart.getId()) == 0) {
            session.setAttribute("message", "Your cart is empty. Please add courses before checkout.");
            session.setAttribute("messageType", "warning");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Get all items in the cart
        List<CartItem> cartItems = cartItemDAO.getCartItemsWithCourseDetails(cart.getId());
        
        // Calculate cart total
        BigDecimal cartTotal = cartItemDAO.getCartTotal(cart.getId());
        
        // Store cart information in session for checkout page
        session.setAttribute("checkoutCartItems", cartItems);
        session.setAttribute("checkoutCartTotal", cartTotal);
        session.setAttribute("checkoutItemCount", cartItems.size());
        request.setAttribute("courseDAO", courseDAO);
        
        // Redirect to checkout page
        request.getRequestDispatcher(CHECKOUT_JSP).forward(request, response);
    }

    private void completeCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        // Get checkout information from session
        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("checkoutCartItems");
        
        if (cartItems == null || cartItems.isEmpty()) {
            session.setAttribute("message", "Your checkout session has expired. Please try again.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Get form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String paymentMethod = request.getParameter("paymentMethod");
        String notes = request.getParameter("notes");
        
        // Validate required fields
        if (firstName == null || lastName == null || phone == null || paymentMethod == null) {
            session.setAttribute("message", "Please fill out all required fields.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/view/homepage/checkout.jsp");
            return;
        }
        
        // Current timestamp for registration
        Timestamp currentTime = new Timestamp(System.currentTimeMillis());
        
        // Calculate valid from and valid to dates (1 year validity)
        Calendar calendar = Calendar.getInstance();
        Timestamp validFrom = new Timestamp(calendar.getTimeInMillis());
        
        calendar.add(Calendar.YEAR, 1);
        Timestamp validTo = new Timestamp(calendar.getTimeInMillis());
        
        boolean allSuccess = true;
        
        try {
            // Process each cart item as a registration
            for (CartItem item : cartItems) {
                Registration registration = new Registration();
                registration.setEmail(account.getEmail());
                registration.setAccountId(account.getId());
                registration.setRegistrationTime(currentTime);
                registration.setCourseId(item.getCourseId());
                registration.setPackages("Standard"); // Default package
                registration.setTotalCost(item.getPrice());
                registration.setStatus("Pending");
                registration.setValidFrom(validFrom);
                registration.setValidTo(validTo);
                registration.setLastUpdateByPerson(account.getId());
                
                // Insert registration
                int registrationId = registrationDAO.insert(registration);
                
                if (registrationId <= 0) {
                    allSuccess = false;
                    break;
                }
            }
        } catch (Exception e) {
            session.setAttribute("message", "An error occurred while processing your checkout. Please try again.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/view/homepage/checkout.jsp");
            return;
        }
        
        if (allSuccess) {
            // Get user's cart
            Cart cart = cartDAO.findByAccountId(account.getId());
            
            // Clear the cart after successful checkout
            if (cart != null) {
                List<CartItem> userCartItems = cartItemDAO.findByCartId(cart.getId());
                for (CartItem item : userCartItems) {
                    cartItemDAO.delete(item);
                }
            }
            
            // Clear checkout session attributes
            session.removeAttribute("checkoutCartItems");
            session.removeAttribute("checkoutCartTotal");
            session.removeAttribute("checkoutItemCount");
            
            session.setAttribute("message", "Checkout completed successfully! You can now access your courses.");
            session.setAttribute("messageType", "success");
            response.sendRedirect(request.getContextPath() + "/my-courses"); // Redirect to my courses page
        } else {
            session.setAttribute("message", "There was an error processing your checkout. Please try again.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/view/homepage/checkout.jsp");
        }
    }
}
