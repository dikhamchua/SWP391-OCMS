package com.ocms.controller.home;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.ocms.config.GlobalConfig;
import com.ocms.dal.CartDAO;
import com.ocms.dal.CartItemDAO;
import com.ocms.entity.Cart;
import com.ocms.entity.Account;
import jakarta.servlet.http.HttpSession;


@WebServlet("/cart")
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;

    private static final String CART_JSP = "view/homepage/cart.jsp";

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();    
        cartItemDAO = new CartItemDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
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
                    // removeFromCart(request, response);
                    break;
                case "update":
                    // updateCart(request, response);
                    break;
            }
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseId = request.getParameter("courseId");
        String quantity = request.getParameter("quantity");

        if (courseId != null && quantity != null) {
            int courseIdInt = Integer.parseInt(courseId);
            int quantityInt = Integer.parseInt(quantity);

            // Cart cart = cartDAO.getOrCreateCart(accountId);
            // cartItemDAO.addItem(cart.getId(), courseIdInt, quantityInt);
        }
    }
    
    
    

}
