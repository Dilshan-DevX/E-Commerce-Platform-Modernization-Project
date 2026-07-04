package com.techmart.api;

import com.techmart.service.CheckOutService;
import com.techmart.service.OrderService;
import com.techmart.service.ShoppingCartBean;
import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/test-checkout")
public class CheckOutTestServlet extends HttpServlet {

    @EJB
    private CheckOutService checkOutService;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        ShoppingCartBean cart = (ShoppingCartBean) session.getAttribute("cart");

        if (cart == null) {
            cart = new ShoppingCartBean();
            session.setAttribute("cart", cart);
            out.println("<p style='color:blue;'>New Shopping Cart Session Initialized!</p>");
        }

        String action = request.getParameter("action");

        if ("checkout".equals(action)) {
            String result = checkOutService.checkoutCart(cart.getItems(), "nimsara@techmart.com");
            out.println("<h2>Checkout Result: " + result + "</h2>");
            if (result.contains("SUCCESS")) {
                cart.clearCart();
            }
        } else {
            cart.addItem(1, 2);
            out.println("<h1>TechMart Shopping Cart</h1>");
            out.println("<p>Item ID: 1 added to cart. Total Qty in Cart: <b>" + cart.getItems().getOrDefault(1, 0)
                    + "</b></p>");
            out.println("<br><a href='test-checkout'>Add More (Refresh)</a> | ");
            out.println("<a href='test-checkout?action=checkout'><b>Checkout Now!</b></a>");
        }
    }
}