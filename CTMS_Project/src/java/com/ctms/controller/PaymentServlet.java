package com.ctms.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.ctms.dao.PaymentDAO;
import com.ctms.util.ConnectionDB;
import com.ctms.service.PaymentService;
import com.ctms.model.Payment;
import java.sql.*;


public class PaymentServlet extends HttpServlet {
    private ConnectionDB connectionDB;
    private PaymentDAO paymentDAO;
    private PaymentService paymentService;
    
    public void init(){
        connectionDB = new ConnectionDB();
        Connection connection = connectionDB.getConnection();
        paymentDAO = new PaymentDAO(connection);
        paymentService = new PaymentService(paymentDAO);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try{
            //Retrive amount and currency
            long amount = Long.parseLong(request.getParameter("amount"));
            String currency = request.getParameter("currency");
            
            //Create payment
            Payment payment = paymentService.createPayment(amount, currency);
            
            request.setAttribute("clientSecret", payment.getClientSecret());
            request.getRequestDispatcher("checkout.jsp").forward(request, response); 
            
        }catch (Exception e){
            e.printStackTrace();
            throw new ServletException(e);
        }
    }



}
