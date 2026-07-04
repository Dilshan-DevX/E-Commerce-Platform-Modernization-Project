package com.techmart.api;

import com.techmart.service.*;
import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/test-search")
public class ProductSearchTestServlet extends HttpServlet {

    @EJB
    private CheckOutService cartCheckoutService;

    @EJB
    private ProductSearchService productService;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        ShoppingCartBean cart = (ShoppingCartBean) session.getAttribute("cart");

        if (cart == null) {
            cart = new ShoppingCartBean();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        String searchKeyword = request.getParameter("search");

        out.println("<html><body>");
        out.println("<h1>TechMart Online Enterprise Portal</h1>");


        out.println("<form method='GET' action='test-search'>");
        out.println("Search Products: <input type='text' name='search' value='" + (searchKeyword != null ? searchKeyword : "") + "'/>");
        out.println("<input type='submit' value='Search'/>");
        out.println("</form>");

        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            List<Product> results = productService.searchProducts(searchKeyword);
            out.println("<h3>Search Results:</h3><ul>");
            for (Product p : results) {
                out.println("<li>" + p + " - <a href='test-search?action=add&item=1'>Add to Cart</a></li>");
            }
            out.println("</ul><hr/>");
        }


        if ("add".equals(action)) {
            cart.addItem(2, 1);
            out.println("<p style='color:green;'>Item added to cart successfully!</p>");
        } else if ("checkout".equals(action)) {
            String res = cartCheckoutService.checkoutCart(cart.getItems(), "nimsara@techmart.com");
            out.println("<h3 style='color:blue;'>Checkout Status: " + res + "</h3>");
            if (res.contains("SUCCESS")) cart.clearCart();
        }


        out.println("<h2>Your Shopping Cart (Stateful Session)</h2>");
        out.println("<p>Total Items in Cart: <b>" + cart.getItems().getOrDefault(2, 0) + "</b></p>");
        out.println("<a href='test-order?action=checkout'><b>[ Proceed to Checkout ]</b></a>");

        out.println("</body></html>");
    }
}