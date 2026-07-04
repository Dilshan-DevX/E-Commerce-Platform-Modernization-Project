package com.techmart.service;

import jakarta.annotation.Resource;
import jakarta.ejb.AsyncResult;
import jakarta.ejb.Asynchronous;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.jms.JMSContext;
import jakarta.jms.Queue;

import java.util.concurrent.Future;

@Stateless
public class OrderService {

    @EJB
    private InventoryCache inventoryCache;

    @Inject
    private JMSContext jmsContext;

    @Resource(lookup = "jms/OrderQueue")
    private Queue orderQueue;

    @Asynchronous
    public Future<String> placeOrder(int itemId, int quantity, String customerEmail) {
        int availableStock = inventoryCache.getAvailableQuantity(itemId);

        if (availableStock >= quantity) {
            int newStock = availableStock - quantity;
            inventoryCache.updateStock(itemId, newStock);


            try {
                String orderPayload = itemId + "," +quantity + "," + customerEmail;
                jmsContext.createProducer().send(orderQueue, orderPayload);
                System.out.println("JMS Success: Order message sent to Queue safely.");
            } catch (Exception e) {
                System.err.println("JMS Error: " + e.getMessage());
            }

            return new AsyncResult<>("SUCCESS: Order accepted for " + customerEmail);
        } else {
            return new AsyncResult<>("FAILED: Out of stock or insufficient quantity!");
        }
    }
}
