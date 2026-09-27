package com.ctms.service;

import com.ctms.dao.FoodDAO;

public class MenuService {
    private FoodDAO foodDAO;
    
    public MenuService() {
        foodDAO = new FoodDAO();
    }
    
    // insert food record
    public void insertFoodRecord(String foodName, float foodPrice, int quantity, int foodCategory) {
        // Calling foodDAO
        boolean foodAvailability = checkAvailability(quantity);
        
        if(foodDAO.insertFoodRecord(foodName, foodPrice, quantity, foodAvailability, foodCategory)) {
            System.out.println("Insert food record successfully. ");
        }
        
        System.out.println("Insert food record failed. ");
    }
    
    // Update food record
    public void updateFoodRecord(String foodId, String foodName, float foodPrice, int quantity, int foodCategory) {
        // Check for valid amount
        boolean foodAvailability = checkAvailability(quantity);
        
        if (quantity < 0) {
            System.out.println("Food stock cannot be negative. ");
        } else if (foodPrice < 0.0) {
            System.out.println("Food price cannot be negative. ");
        } else {
            foodDAO.updateFoodRecord(foodName, foodName, foodPrice, quantity, foodAvailability, foodCategory);
            System.out.println("Food record has been successfully update. ");
        }
    }
    
    // Update food record
    public void updateFoodStock(String foodId, int foodStock) {
        // Check for valid amount
        boolean foodAvailability = checkAvailability(foodStock);
        
        if (foodStock < 0) {
            System.out.println("Food stock cannot be negative. ");
        } else {
            foodDAO.updateFoodStock(foodId, foodStock, foodAvailability);
            System.out.println("Food stock has been successfully update. ");
        }
    }
    
    // delete food record
    public void deleteFoodRecord(String foodId) {
        if (foodDAO.deleteFoodRecrod(foodId)) {
            System.out.println("Delete food record success. ");
        }
    }
    
    // Check food status
    public boolean checkAvailability(int foodStock) {
        boolean availability = false;
        if (foodStock > 50) { availability = true; } else { availability = false; }
        
        return availability;
    }
    
}
