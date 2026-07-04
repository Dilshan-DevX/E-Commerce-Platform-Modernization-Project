package com.techmart.service;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.Resource;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Singleton
@Startup
public class InventoryCache {

    @Resource(lookup = "java:app/jdbc/TechMartDS")
    private DataSource dataSource;

    private Map<Integer, Integer> cache;
    private final long bootTime = System.currentTimeMillis();
    private java.util.concurrent.atomic.AtomicInteger cacheRefreshes = new java.util.concurrent.atomic.AtomicInteger(0);

    @PostConstruct
    public void init() {
        cache = new ConcurrentHashMap<>();
        loadInventoryFromDatabase();
    }

    public long getBootTime() {
        return bootTime;
    }

    public int getCacheRefreshes() {
        return cacheRefreshes.get();
    }

    public void loadInventoryFromDatabase() {
        String query = "SELECT item_id, quantity FROM inventory";

        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int itemId = rs.getInt("item_id");
                int quantity = rs.getInt("quantity");
                cache.put(itemId, quantity);
            }
            cacheRefreshes.incrementAndGet();
            System.out.println("TechMart Architecture: Inventory Cache loaded from MySQL Database successfully!");
        } catch (SQLException e) {
            System.err.println("Database Connection Error inside InventoryCache: " + e.getMessage());
        }
    }


    public int getAvailableQuantity(int itemId) {
        return cache.getOrDefault(itemId, 0);
    }


    public synchronized void updateStock(int itemId, int quantity) {
        cache.put(itemId, quantity);
        cacheRefreshes.incrementAndGet();

        String updateQuery = "UPDATE inventory SET quantity = ? WHERE item_id = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(updateQuery)) {

            ps.setInt(1, quantity);
            ps.setInt(2, itemId);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Error updating database: " + e.getMessage());
        }
    }

    public synchronized void updateMemoryOnly(int itemId, int quantity) {
        cache.put(itemId, quantity);
        cacheRefreshes.incrementAndGet();
        System.out.println("RAM Cache Synchronized (In-Memory Only) for Item ID: " + itemId + " | New Qty: " + quantity);
    }
}
