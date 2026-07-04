package com.techmart.service;

import jakarta.annotation.Resource;
import jakarta.ejb.ActivationConfigProperty;
import jakarta.ejb.MessageDriven;
import jakarta.jms.Message;
import jakarta.jms.MessageListener;
import jakarta.jms.TextMessage;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@MessageDriven(activationConfig = {
        @ActivationConfigProperty(propertyName = "destinationLookup", propertyValue = "jms/OrderQueue"),
        @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "jakarta.jms.Queue")
})
public class OrderProcessorMDB implements MessageListener {

    @Resource(lookup = "java:app/jdbc/TechMartDS")
    private DataSource dataSource;

    @Override
    public void onMessage(Message message) {
        try {
            if (message instanceof TextMessage) {
                String payload = ((TextMessage) message).getText();
                System.out.println("MDB Received Order Processing Request: " + payload);

                String[] orderData = payload.split(",");
                int itemId = Integer.parseInt(orderData[0]);
                int quantity = Integer.parseInt(orderData[1]);
                String email = orderData[2];

                saveOrderToDatabase(itemId, quantity, email);
            }
        } catch (Exception e) {
            System.err.println("Critical Error inside MDB processing: " + e.getMessage());
        }
    }

    private void saveOrderToDatabase(int itemId, int quantity, String email) {
        String insertOrderQuery = "INSERT INTO orders (customer_email, total_amount, status) VALUES (?, ?, 'PROCESSED')";
        String updateInventoryQuery = "UPDATE inventory SET quantity = quantity - ? WHERE item_id = ?";
        String priceLookupQuery = "SELECT price FROM inventory WHERE item_id = ?";

        try (Connection connection = dataSource.getConnection()) {
            connection.setAutoCommit(false);

            double dynamicUnitPrice = 0.0;

            try (PreparedStatement psPrice = connection.prepareStatement(priceLookupQuery)) {
                psPrice.setInt(1, itemId);
                try (ResultSet rs = psPrice.executeQuery()) {
                    if (rs.next()) {
                        dynamicUnitPrice = rs.getDouble("price");
                    }
                }
            }

            double dynamicallyComputedTotal = dynamicUnitPrice * quantity;

            try (PreparedStatement psOrder = connection.prepareStatement(insertOrderQuery)) {
                psOrder.setString(1, email);
                psOrder.setDouble(2, dynamicallyComputedTotal);
                psOrder.executeUpdate();
            }

            try (PreparedStatement psInv = connection.prepareStatement(updateInventoryQuery)) {
                psInv.setInt(1, quantity);
                psInv.setInt(2, itemId);
                psInv.executeUpdate();
            }

            connection.commit();
            System.out.println("Database Dynamic Update Complete for JMS asynchronously: " + email);
        } catch (SQLException e) {
            System.err.println("MDB Transaction Failed, Rolling back... " + e.getMessage());
        }
    }
}