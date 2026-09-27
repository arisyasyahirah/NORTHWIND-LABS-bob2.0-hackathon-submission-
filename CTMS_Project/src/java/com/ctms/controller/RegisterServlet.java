package com.ctms.controller;

import com.ctms.service.AccountService;
import java.sql.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.ctms.model.Customer;
import com.ctms.model.Employee;
import com.ctms.util.ConnectionDB;


public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AccountService account = new AccountService();
        
        try {
            String name = request.getParameter("userName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phoneNumber = request.getParameter("phoneNumber");
            String dob = request.getParameter("dob");
            
            if (account.createNewCustomerAccount(name, email, password, phoneNumber, dob)) {
                response.sendRedirect("login.jsp");
            } else {
                response.sendRedirect("register.jsp?error=1");
            }
            
            
        } catch (Exception e) {
            System.out.println("(register servlet) Error in...." + e.getMessage());
        }
    }
}
