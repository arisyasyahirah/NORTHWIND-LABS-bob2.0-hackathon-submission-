package com.ctms.dao;

import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import com.ctms.model.Customer;
import java.sql.*;
import com.ctms.util.ConnectionDB;

public class CustomerDAO {

    private Connection conn;
    private Customer customer;

    public CustomerDAO() {
        this.conn = new ConnectionDB().getConnection();
    }

    String idPrefix = "C";
    int idPostfix = 000;

    // Find the match user id
    public Customer findCustomerByEmail(String userEmail) {
        String SQL = "SELECT * FROM customer WHERE cust_email = ?";  // placehoder of sql, start from 1

        try {
            // Creating prepared statement
            PreparedStatement ps = conn.prepareStatement(SQL);
            ps.setString(1, userEmail);  // Replace the ? in SQL statement (at index 1)

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Setting the employee information
                String id = rs.getString("cust_id");
                String email = rs.getString("cust_email");
                String password = rs.getString("cust_password");
                String name = rs.getString("cust_name");
                String ph_number = rs.getString("cust_phone");

                System.out.println("Customer ID: " + id);

                if (email.equals(userEmail)) {
                    customer = new Customer(id, email, password, name, ph_number);
                } else {
                    return null;
                }
            }

            return customer;
        } catch (SQLException e) {
            System.out.println("Getting customer database data error..." + e.getMessage());
        }

        return null;
    }

    // add boolean
    public void updateCustomer(String id, String newName, String newEmail, String newPhoneNumber) {
        String SQL = "UPDATE customer SET cust_name = ?, cust_email = ?, cust_phone = ? WHERE cust_id = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);
            ps.setString(1, newName);
            ps.setString(2, newEmail);
            ps.setString(3, newPhoneNumber);
            ps.setString(4, id);
            ps.executeUpdate();  // use for sql commands such as update, insert or delete that do not return result set

            System.out.println("Customer info update successful. ");
        } catch (Exception e) {
            System.out.println("Update customer info failed..." + e.getMessage());
        }
    }

    // change to boolean
    public boolean insertCustomer(String name, String email, String password, String phoneNumber, String dob) {
        String SQL = "INSERT INTO customer(cust_id, cust_name, cust_email, cust_password, cust_phone) VALUES(?, ?, ?, ?, ?)";
        idPostfix++;

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);

            // Get the latest id from database and update it
            String id = generateNewCustomerId();
            
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, phoneNumber);

            int result = ps.executeUpdate();

            System.out.println("Succesfull create new customer account...");
            
            return result > 0;
        } catch (Exception e) {
            System.out.println("Create new customer account failed..." + e.getMessage());
            return false;
        }
    }

    // change to boolean
    public boolean deleteCustomer(String id) {
        String SQL = "DELETE FROM TABLE customer WHERE cust_id = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);
            ps.setString(1, id);
            int result = ps.executeUpdate();
            
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get the latest id from mysql database, then increase by 1
    private String generateNewCustomerId() {
        String SQL = "SELECT cust_id FROM customer ORDER BY cust_id DESC LIMIT 1";
        String finalId = "";
        
        try {
            PreparedStatement ps = conn.prepareStatement(SQL);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                String lastId = rs.getString("cust_id");
                String numericPart = lastId.substring(1);
                int newId = Integer.parseInt(numericPart) + 1;
                // Set the id to minimum 3 digits
                finalId = String.format("C%03d", newId);   
            }
            
            // Set the minimum id if system record is null
            if (!rs.next()) { finalId = String.format("C%03d", 1); }
            
            return finalId;
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
}
