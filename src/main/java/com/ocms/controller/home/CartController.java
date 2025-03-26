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

        // Check if this is a return from VNPAY payment
        String action = request.getParameter("action");
        if (action != null && action.equals("complete-checkout")) {
            // Handle VNPAY return - process the checkout
            completeCheckout(request, response);
            return;
        }

        // Normal cart display logic
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

        // Get VNPAY payment response parameters
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_Amount = request.getParameter("vnp_Amount");
        String vnp_PayDate = request.getParameter("vnp_PayDate");
        String vnp_OrderInfo = request.getParameter("vnp_OrderInfo");
        

        
        // Verify the transaction was started by this session
        String sessionTxnRef = (String) session.getAttribute("vnp_TxnRef");
        String sessionAmount = (String) session.getAttribute("vnp_Amount");
        
        // Only proceed if we have a response from VNPAY or we're processing directly
        if (vnp_ResponseCode != null && vnp_TransactionStatus != null) {
            
            if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                // Verify transaction matches what we sent
                if (sessionTxnRef != null && sessionAmount != null) {
                    if (!sessionTxnRef.equals(vnp_TxnRef) || !sessionAmount.equals(vnp_Amount)) {
                        session.setAttribute("message", "Payment verification failed. Transaction details do not match.");
                        session.setAttribute("messageType", "error");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                }
                
                // Payment successful - process the order
                processSuccessfulOrder(account, cartItems, session, response, request);
            } else {
                // Payment failed
                session.setAttribute("message", "Payment was not successful. Response code: " + vnp_ResponseCode);
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } else {
            // Direct checkout without VNPAY (for testing or alternative payment methods)
            processSuccessfulOrder(account, cartItems, session, response, request);
        }
    }
    
    /**
     * Helper method to process a successful order
     */
    private void processSuccessfulOrder(Account account, List<CartItem> cartItems, 
                                       HttpSession session, HttpServletResponse response, 
                                       HttpServletRequest request) throws ServletException, IOException {
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
                registration.setStatus("Pending"); // Set as Pending since payment is confirmed
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
            session.setAttribute("message", "An error occurred while processing your order: " + e.getMessage());
            session.setAttribute("messageType", "error");
            request.getRequestDispatcher(CHECKOUT_JSP).forward(request, response);
            return;
        }
        
        if (allSuccess) {
            // Get user's cart
            Cart cart = cartDAO.findByAccountId(account.getId());
            
            // Clear the cart after successful checkout
            if (cart != null) {
                try {
                    // Use the efficient clearCart method to remove all items at once
                    boolean cartCleared = cartItemDAO.clearCart(cart.getId());
                    
                    if (!cartCleared) {
                        System.out.println("Warning: Failed to clear cart items");
                    } else {
                        System.out.println("Cart items successfully cleared");
                    }

                    //remove cart in DB
                    boolean cartRemoved = cartDAO.delete(cart);
                    if (!cartRemoved) {
                        System.out.println("Warning: Failed to remove cart");
                    } else {
                        System.out.println("Cart successfully removed");
                    }
                    
                } catch (Exception e) {
                    System.out.println("Error updating cart after checkout: " + e.getMessage());
                    // Continue with checkout process even if cart update fails
                    // The items have already been processed into registrations
                    //set message
                    session.setAttribute("message", "There was an error processing your order. Please contact support.");
                    session.setAttribute("messageType", "error");
                    request.getRequestDispatcher(CHECKOUT_JSP).forward(request, response);
                    return;
                }
            }
            
            // Clear checkout session attributes
            session.removeAttribute("checkoutCartItems");
            session.removeAttribute("checkoutCartTotal");
            session.removeAttribute("checkoutItemCount");
            session.removeAttribute("vnp_TxnRef");
            session.removeAttribute("vnp_Amount");
            
            session.setAttribute("message", "Payment successful! You can now access your courses.");
            session.setAttribute("messageType", "success");
            response.sendRedirect(request.getContextPath() + "/my-courses"); // Redirect to my courses page
        } else {
            session.setAttribute("message", "There was an error processing your order. Please contact support.");
            session.setAttribute("messageType", "error");
            request.getRequestDispatcher(CHECKOUT_JSP).forward(request, response);
        }
    }
}
