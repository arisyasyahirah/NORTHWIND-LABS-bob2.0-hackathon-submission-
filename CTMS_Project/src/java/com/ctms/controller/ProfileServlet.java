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

/**
 *
 * @author user
 */
public class ProfileServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            AccountService accountService = new AccountService();
            // Get the user new info (customer / employee) from the URL
            String newName = request.getParameter("name");
            String newEmail = request.getParameter("email");
            String newPhoneNumber = request.getParameter("phoneNumber");

            // Verify process
            String userType = "";
            int restriction = 0;

            // Differentiate the action servlet will take action
            String action = request.getParameter("action");

            HttpSession session = request.getSession(false);

            // Only HQ can edit all employee & customer info
            switch (action) {
                case "saveCustomerProfile":
                    Customer customer = (Customer) session.getAttribute("customer");
                    // Check for restriction level (only HQ / manager can edit customer info)
                    userType = (String) session.getAttribute("userType");

                    // Call for update info function
                    // only HQ or customer itself can update customer info
                    accountService.updateCustomerInfo(customer.getId(), newName, newEmail, newPhoneNumber, userType, restriction);
                    break;
                case "saveEmployeeProfile":
                    Employee employee = (Employee) session.getAttribute("employee");

                    userType = (String) session.getAttribute("userType");
                    restriction = (int) session.getAttribute("restriction");

                    // Call for update info function
                    //accountService.updateEmployeeInfo(employee.getId(), newName, newEmail, newPhoneNumber, userType, restriction);
                    
                    System.out.println("Feature not properly implemented yet");
                    break;
            }

        } catch (Exception e) {
            System.out.println("(ProfileServlet) Error occur..." + e.getMessage());
            e.printStackTrace();
        }
    }

}
