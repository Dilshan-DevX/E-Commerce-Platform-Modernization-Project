package com.techmart.service;

public class Product {
    private int itemId;
    private String itemName;
    private double price;

    public Product(int itemId, String itemName, double price) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.price = price;
    }


    public int getItemId() { return itemId; }
    public String getItemName() { return itemName; }
    public double getPrice() { return price; }
}