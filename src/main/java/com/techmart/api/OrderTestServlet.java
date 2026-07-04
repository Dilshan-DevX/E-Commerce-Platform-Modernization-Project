package com.techmart.api;

import com.techmart.service.OrderService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

@WebServlet("/test-order")
public class OrderTestServlet extends HttpServlet {

    @EJB
    private OrderService orderService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();

        try {
            Future<String> futureResult = orderService.placeOrder(1,5,"nimsara@gmail.com");
            String result = futureResult.get();
            out.println("<h1>TechMart Modernization Test</h1>");
            out.println("<p>Result: <b>" + result + "</b></p>");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }
}
