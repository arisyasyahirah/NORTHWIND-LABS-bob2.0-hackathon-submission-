package com.ctms.service;

import com.stripe.*;
import com.ctms.dao.PaymentDAO;
import com.ctms.model.Payment;
import com.stripe.model.PaymentIntent;
import java.util.*;
import java.sql.*;


public class PaymentService {

    private PaymentDAO paymentDAO;

    //Constructor
    public PaymentService(PaymentDAO paymentDAO) {
        this.paymentDAO = paymentDAO;
        //Secret API key (STRIPE-BACK-END)
        Stripe.apiKey = "sk_test_placeholder_replace_me";
    }
    
    //Create payement
    public Payment createPayment(long amount, String currency) throws Exception {

        Map<String, Object> params = new HashMap<>();
        params.put("amount", amount);
        params.put("currency", currency);

        PaymentIntent intent = PaymentIntent.create(params);
        
        //Generate new payment id for Database
        String id = paymentDAO.generateId();
        
        //Create new payment
        Payment payment = new Payment(
                id, //Database payment id
                intent.getId(), //Stripe payment id
                intent.getClientSecret(),
                intent.getAmount(),
                intent.getCurrency(),
                "pending",
                new Timestamp(System.currentTimeMillis()) //Get current time 
        );
        
        //Insert payment into DB
        paymentDAO.insertPayment(payment);
        
        //Return payment object
        return payment;
    }
    
    //Mark payment as success
    public void markPaymentSucceeded(String paymentId) throws SQLException {
        paymentDAO.updatePaymentStatusByStripeId(paymentId, "succeeded");
    }
    
    //Mark payment as failure
    public void markPaymentFailed(String paymentId) throws SQLException {
        paymentDAO.updatePaymentStatusByStripeId(paymentId, "failed");
    }
}
