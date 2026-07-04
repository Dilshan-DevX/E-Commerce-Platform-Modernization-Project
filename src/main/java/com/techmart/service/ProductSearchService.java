package com.techmart.service;

import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Stateless
public class ProductSearchService {

    @Resource(lookup = "java:app/jdbc/TechMartDS")
    private DataSource dataSource;

    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT item_id, product_name, price FROM inventory WHERE product_name LIKE ?";

        try(Connection connection = dataSource.getConnection();
            PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(new Product(
                            rs.getInt("item_id"),
                            rs.getString("product_name"),
                            rs.getDouble("price")
                    ));
                }
            }
            System.out.println("Search Optimization: Found " + products.size() + " components mapped.");
        } catch (Exception e) {
            System.err.println("Search Error: " + e.getMessage());
        }
        return products;
    }
}