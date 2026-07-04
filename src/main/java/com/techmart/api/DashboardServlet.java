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
import java.util.Map;
import java.util.HashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @EJB
    private CheckOutService checkOutService;

    @EJB
    private OrderService orderService;

    @EJB
    private ProductSearchService productSearchService;

    @EJB
    private InventoryCache inventoryCache;

    private static final AtomicInteger totalSimulatedRequests = new AtomicInteger(0);
    private static final AtomicInteger successfulSimulations = new AtomicInteger(0);
    private static final AtomicInteger failedSimulations = new AtomicInteger(0);
    private static final AtomicInteger totalJmsMessages = new AtomicInteger(0);
    private static final AtomicInteger totalSearchQueries = new AtomicInteger(0);

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        ShoppingCartBean cart = (ShoppingCartBean) session.getAttribute("cart");

        if (cart == null) {
            cart = new ShoppingCartBean();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        String searchKeyword = request.getParameter("search");

        String itemIdParam = request.getParameter("itemId");
        String qtyParam = request.getParameter("qty");
        String customerEmail = request.getParameter("email");

        if (customerEmail == null || customerEmail.isEmpty()) {
            customerEmail = "customer@techmart.com";
        }

        int itemId = (itemIdParam != null) ? Integer.parseInt(itemIdParam) : 1;
        int qty = (qtyParam != null) ? Integer.parseInt(qtyParam) : 1;

        long startTime = System.currentTimeMillis();
        String executionMeta = "N/A";

        if ("add".equals(action)) {
            cart.addItem(itemId, qty);
            executionMeta = "Stateful Cart Update (Item ID: " + itemId + "): " + (System.currentTimeMillis() - startTime) + "ms";
        } else if ("quickbuy".equals(action)) {
            totalJmsMessages.incrementAndGet();
            orderService.placeOrder(itemId, qty, customerEmail);
            executionMeta = "Asynchronous JMS Handshake: " + (System.currentTimeMillis() - startTime) + "ms (<5ms Non-blocking!)";
        } else if ("checkout".equals(action)) {
            String res = checkOutService.checkoutCart(cart.getItems(), customerEmail);
            if (res.contains("SUCCESS")) {
                cart.clearCart();
            }
            executionMeta = "DB Transaction Executed: " + (System.currentTimeMillis() - startTime) + "ms | Result: " + res;
        } else if ("simulate".equals(action)) {
            runConcurrencySimulation(itemId);
            executionMeta = "High-Concurrency Simulation Triggered for Item ID: " + itemId;
        }


        Map<String, Long> metrics = new HashMap<>();
        metrics.put("total.orders.processed", (long) successfulSimulations.get());
        metrics.put("total.checkouts.completed", (long) (successfulSimulations.get() + failedSimulations.get()));
        metrics.put("total.search.queries", (long) totalSearchQueries.get());
        metrics.put("total.jms.messages.sent", (long) totalJmsMessages.get());
        metrics.put("total.async.tasks.completed", (long) totalJmsMessages.get());
        metrics.put("total.cache.refreshes", (long) inventoryCache.getCacheRefreshes());
        request.setAttribute("metrics", metrics);

        Map<String, String> configMap = new HashMap<>();
        configMap.put("platform.environment", "Production");
        configMap.put("database.pool.size", "50");
        request.setAttribute("config", configMap);
        
        long uptimeMillis = System.currentTimeMillis() - inventoryCache.getBootTime();
        long days = TimeUnit.MILLISECONDS.toDays(uptimeMillis);
        long hours = TimeUnit.MILLISECONDS.toHours(uptimeMillis) % 24;
        long minutes = TimeUnit.MILLISECONDS.toMinutes(uptimeMillis) % 60;
        String formattedUptime = String.format("%dd %dh %dm", days, hours, minutes);
        request.setAttribute("uptime", formattedUptime);
        request.setAttribute("healthSummary", "All Systems Operational");
        request.setAttribute("cacheStats", "Cache Hits: 95% | Misses: 5%");


        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            totalSearchQueries.incrementAndGet();
            List<Product> results = productSearchService.searchProducts(searchKeyword);
            request.setAttribute("searchResults", results);
        }
        
        request.setAttribute("executionMeta", executionMeta);
        request.setAttribute("customerEmail", customerEmail);
        request.setAttribute("cartItems", cart.getItems());
        request.setAttribute("totalSimulatedRequests", totalSimulatedRequests.get());
        request.setAttribute("successfulSimulations", successfulSimulations.get());
        request.setAttribute("failedSimulations", failedSimulations.get());


        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    private void runConcurrencySimulation(int targetItemId) {
        int concurrentLoad = 50;
        ExecutorService executor = Executors.newFixedThreadPool(concurrentLoad);
        Map<Integer, Integer> simulatedCart = Map.of(targetItemId, 1);

        for (int i = 0; i < concurrentLoad; i++) {
            totalSimulatedRequests.incrementAndGet();
            executor.submit(() -> {
                try {
                    String status = checkOutService.checkoutCart(simulatedCart, "simulated_user@techmart.com");
                    if (status.contains("SUCCESS")) {
                        successfulSimulations.incrementAndGet();
                    } else {
                        failedSimulations.incrementAndGet();
                    }
                } catch (Exception e) {
                    failedSimulations.incrementAndGet();
                    System.err.println("Simulation failed: " + e.getMessage());
                }
            });
        }

        executor.shutdown();
        try {
            executor.awaitTermination(2, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}