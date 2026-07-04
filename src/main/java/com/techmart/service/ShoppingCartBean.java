package com.techmart.service;

import jakarta.ejb.Stateful;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

@Stateful
public class ShoppingCartBean implements Serializable {

    private Map<Integer, Integer> items = new HashMap<>();

    public void addItem(int itemId, int quantity) {
        items.put(itemId, items.getOrDefault(itemId, 0) + quantity);
        System.out.println("Stateful Cart: Item " + itemId + " added to cart. Current Qty: " + items.get(itemId));
    }

    public Map<Integer, Integer> getItems() {
        return items;
    }

    public void clearCart() {
        items.clear();
    }
}
