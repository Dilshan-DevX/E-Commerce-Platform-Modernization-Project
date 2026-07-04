package com.techmart.service;

import jakarta.annotation.Resource;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;

@Stateless
public class CheckOutService {

    @Resource(lookup = "java:app/jdbc/TechMartDS")
    private DataSource dataSource;

    @EJB
    private InventoryCache inventoryCache;

    public String checkoutCart(Map<Integer, Integer> cartItems, String customerEmail) {
        if (cartItems.isEmpty()) {
            return "FAILED: Cart is empty!";
        }

        try(Connection connection = dataSource.getConnection()) {
            connection.setAutoCommit(false);
            double totalCartAmount = 0.0;

            for (Map.Entry<Integer, Integer> entry : cartItems.entrySet()) {
                int itemId = entry.getKey();
                int requestQty = entry.getValue();

                String checkQuery = "SELECT quantity, version, price FROM inventory WHERE item_id = ?";
                int currentQty = 0;
                int currentVersion = 0;
                double unitPrice = 0.0;

                try(PreparedStatement psCheck = connection.prepareStatement(checkQuery)) {
                    psCheck.setInt(1, itemId);
                    try(ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next()) {
                            currentQty = rs.getInt("quantity");
                            currentVersion = rs.getInt("version");
                            unitPrice = rs.getDouble("price");
                        } else {
                            connection.rollback();
                            return "FAILED: Item ID " + itemId + " not found!";
                        }
                    }
                }

                if (currentQty < requestQty) {
                    connection.rollback();
                    return "FAILED: Insufficient stock for Item ID " + itemId + "! Available: " + currentQty;
                }

                totalCartAmount += (unitPrice * requestQty);

                String updateQuery = "UPDATE inventory SET quantity = quantity - ?, version = version + 1 WHERE item_id = ? AND version = ?";
                try (PreparedStatement psUpdate = connection.prepareStatement(updateQuery)) {
                    psUpdate.setInt(1, requestQty);
                    psUpdate.setInt(2, itemId);
                    psUpdate.setInt(3, currentVersion);

                    int rowsUpdated = psUpdate.executeUpdate();
                    if (rowsUpdated == 0) {
                        connection.rollback();
                        return "FAILED: Transaction conflict occurred. Please try again!";
                    }
                }
                inventoryCache.updateMemoryOnly(itemId, currentQty - requestQty);
            }

            String orderQuery = "INSERT INTO orders (customer_email, total_amount, status) VALUES (?, ?, 'COMPLETED')";
            try (PreparedStatement psOrder = connection.prepareStatement(orderQuery)) {
                psOrder.setString(1, customerEmail);
                psOrder.setDouble(2, totalCartAmount);
                psOrder.executeUpdate();
            }

            connection.commit();
            return "SUCCESS: Checkout completed successfully! Total: Rs." + totalCartAmount;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}