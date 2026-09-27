package com.ctms.dao;

import java.sql.*;
import java.util.*;
import com.ctms.model.Payment;
import com.ctms.util.ConnectionDB;

public class PaymentDAO {

    private Connection connection;

    public PaymentDAO(Connection connnection) {
        this.connection = new ConnectionDB().getConnection();
    }

    //Search payment by Id
    public Payment findById(String id) throws SQLException {
        String sql = "SELECT * FROM payment WHERE id = ?";

        //Prepare sql
        PreparedStatement pstmt = connection.prepareStatement(sql);
        pstmt.setString(1, id);

        //Execute query
        ResultSet result = pstmt.executeQuery();

        //Check if payment exist
        if (result.next()) {
            //Create new admin object and return it
            String paymentId = result.getString("id");
            String stripePaymentId = result.getString("payment_id");
            String clientSecret = result.getString("client_secret");
            long amount = result.getLong("amount");
            String currency = result.getString("currency");
            String status = result.getString("status");
            Timestamp createdAt = result.getTimestamp("timestamp");

            return new Payment(paymentId, stripePaymentId, clientSecret, amount, currency, status, createdAt);
        }

        return null;
    }

    //Insert Payment into DB.
    public boolean insertPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO payment VALUE(?, ?, ?, ?, ?, ?, ?)";

        //Prepare sql
        PreparedStatement pstmt = connection.prepareStatement(sql);
        pstmt.setString(1, payment.getId());
        pstmt.setString(2, payment.getPaymentId());
        pstmt.setString(3, payment.getClientSecret());
        pstmt.setLong(4, payment.getAmount());
        pstmt.setString(5, payment.getCurrency());
        pstmt.setString(6, payment.getStatus());
        pstmt.setTimestamp(7, payment.getCreatedAt());

        //Execute query
        int rows = pstmt.executeUpdate();
        
         //If row is 1 or more, payment succesfully added into DB (return true) else payment failed added into DB (return false)
        return rows > 0;
    }

    //Delete Payment (id from db not id from stripe)
    public boolean deletePaymentByid(String paymentId) throws SQLException {
        String sql = "DELETE FROM payment WHERE id = ?";

        //Prepare sql
        PreparedStatement pstmt = connection.prepareStatement(sql);
        pstmt.setString(1, paymentId);

        //Execute query
        int rows = pstmt.executeUpdate();

       //If row is 1 or more, payment succesfully deleted from DB (return true) else payment failed from  DB (return false)
        return rows > 0;
    }

    //Update status payment
    public boolean updatePaymentStatusByStripeId(String paymentId, String status) throws SQLException {
        String sql = "UPDATE payment SET status=? WHERE payment_id=?";

        //Prepare sql
        PreparedStatement pstmt = connection.prepareStatement(sql);
        pstmt.setString(1, status);
        pstmt.setString(2, paymentId);

        //Execute query
        int rows = pstmt.executeUpdate();
        
       //If row is 1 or more, payment succesfully updated into DB (return true) else payment failed into DB (return false)
        return rows > 0;
    }

    //Get all payments
    public ArrayList<Payment> getAllPayments() throws SQLException {
        String sql = "SELECT * FROM payment";

        //Prepare sql
        PreparedStatement pstmt = connection.prepareStatement(sql);

        //Get result
        ResultSet result = pstmt.executeQuery();

        ArrayList<Payment> payments = new ArrayList<>();
        while (result.next()) {
            String paymentId = result.getString("id");
            String stripePaymentId = result.getString("payment_id");
            String clientSecret = result.getString("client_secret");
            long amount = result.getLong("amount");
            String currency = result.getString("currency");
            String status = result.getString("status");
            Timestamp createdAt = result.getTimestamp("timestamp");

            payments.add(new Payment(paymentId, stripePaymentId, clientSecret, amount, currency, status, createdAt));
        }

        return payments;
    }

    //Generate payment id
    public String generateId() throws SQLException {
        String sql = "SELECT counter FROM id_counter WHERE table_name = 'payment'";

        PreparedStatement pstmt = connection.prepareStatement(sql);
        ResultSet result = pstmt.executeQuery();

        if (result.next()) {
            int counter = result.getInt("counter") + 1;
            return "P" + String.format("%03d", counter);
        }

        return null;
    }
}
