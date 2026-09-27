package com.ctms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import com.ctms.model.Food;
import com.ctms.util.ConnectionDB;

public class FoodDAO {

    private Connection conn;
    private ArrayList<Food> food_list = new ArrayList<>();

    public FoodDAO() {
        conn = new ConnectionDB().getConnection();
    }

    String idPrefix = "F";

    // Select all food record
    // return this to menuServlet to be display
    
    public ArrayList<Food> getFoodList() {
        String SQL = "SELECT * FROM fooditem";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Food food = new Food(
                        rs.getString("food_id"),
                        rs.getString("food_name"),
                        rs.getFloat("food_price"),
                        rs.getInt("quantity"),
                        rs.getBoolean("food_availability"),
                        rs.getInt("food_type_id")
                );

                food_list.add(food);

                System.out.println("Gain food record success. ");
            }
            
            return food_list;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Inert new food record
    public boolean insertFoodRecord(String food_name, float food_price, int quantity, boolean food_availability, int food_type_id) {
        String SQL = "INSERT INTO fooditem (food_id, food_name, food_price, quantity, food_availability, food_type_id) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);

            String food_id = generateNewFoodRecordId();
            System.out.println("Food id: " + food_id);

            ps.setString(1, food_id);
            ps.setString(2, food_name);
            ps.setFloat(3, food_price);
            ps.setInt(4, quantity);
            ps.setBoolean(5, food_availability);
            ps.setInt(6, food_type_id);

            ps.executeUpdate();
            
            food_list.add(new Food(food_id, food_name, food_price, quantity, food_availability, food_type_id));

            System.out.println("Insert food record success. ");
            System.out.println("Food quantity: " + quantity);
            
            ps.close();

            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Update current food record
    public boolean updateFoodRecord(String food_id, String food_name, float food_price, int quantity, boolean food_availability, int food_type_id) {
        String SQL = "UPDATE fooditem SET food_name = ?, food_price = ?, quantity = ?, food_availability = ?, food_type_id = ? WHERE food_id = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);
            ps.setString(1, food_name);
            ps.setFloat(2, food_price);
            ps.setInt(3, quantity);
            ps.setBoolean(4, food_availability);
            ps.setInt(5, food_type_id);
            ps.setString(6, food_id);
            ps.executeUpdate();

            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    // Update food stock
    public boolean updateFoodStock(String food_id, int quantity, boolean food_availability) {
        String SQL = "UPDATE fooditem SET quantity = ?, food_availability = ? WHERE food_id = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);
            ps.setInt(1, quantity);
            ps.setBoolean(2, food_availability);
            ps.setString(3, food_id);
            ps.executeUpdate();

            System.out.println("Food Id: " + food_id);
            System.out.println("Food Stock: " + quantity);
            System.out.println("Food Availability: " + food_availability);
            
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Delete target food record
    public boolean deleteFoodRecrod(String food_id) {
        String SQL = "DELETE FROM TABLE fooditem WHERE food_id = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);
            ps.setString(1, food_id);
            ps.executeUpdate();

            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    // Get the latest id from mysql database, then increase by 1
    private String generateNewFoodRecordId() {
        String SQL = "SELECT food_id FROM fooditem ORDER BY food_id DESC LIMIT 1";
        String finalId = "";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);
            ResultSet rs = ps.executeQuery();

             while (rs.next()) {
                String lastId = rs.getString("food_id");
                String numericPart = lastId.substring(1);
                int newId = Integer.parseInt(numericPart) + 1;
                // Set the id to minimum 3 digits
                finalId = String.format("F%03d", newId);
            }
            
            ps.close();
            
            System.out.println("Food id in generateNewFoodRecord: " + finalId);

            return finalId;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
