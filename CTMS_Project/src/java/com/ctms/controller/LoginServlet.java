// Login need to refactor the accountservice. add session user class
// create each connection for each DAO

package com.ctms.controller;

import com.ctms.model.Customer;
import com.ctms.model.Employee;
import com.ctms.service.AccountService;
import com.ctms.util.ConnectionDB;
import java.sql.*;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class LoginServlet extends HttpServlet {

   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the username and password
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Call the DAO to verify the username and password
        try {
            AccountService accountService = new AccountService();   
            
            String userType = accountService.verifyByEmail(email, password);

            // Store in the session
            HttpSession session = request.getSession();
            // Save the userID and userType in session
            session.setAttribute("email", email);
            session.setAttribute("userType", userType);
            
            System.out.println("------------------------- Login Section -----------------------------");
            System.out.println("Your role is: " + userType);
            System.out.println("Email: " + email);

            if (userType.equals("Employee")) {
                // Get the employee personal information
                Employee LoggedEmployee = accountService.getLoggedEmployee();

                // Pass the employee data to employeepage
                session.setAttribute("employee", LoggedEmployee);
                session.setAttribute("restriction", LoggedEmployee.getRestrictionLevel());
                
                System.out.println("Restriction level: " + LoggedEmployee.getRestrictionLevel());

                // Show as default user profile if user profile is null
                if (LoggedEmployee.getName() != null) {
                    String firstChar = String.valueOf(LoggedEmployee.getName().charAt(0));
                    session.setAttribute("firstCharacter", firstChar);
                }

                // Check the permission level of employee
                if (LoggedEmployee.getRestrictionLevel()== 3) {  // Highest level (3), HQ
                    response.sendRedirect(request.getContextPath() + "/HomeServlet");
                    return;
                } else if (LoggedEmployee.getRestrictionLevel() == 2) {  // medium level, manager
                    response.sendRedirect(request.getContextPath() + "/ShowtimeServlet");
                    return;
                } else if (LoggedEmployee.getRestrictionLevel() == 1) {  // lowest level, staff
                    response.sendRedirect(request.getContextPath() + "/HomeServlet");
                    return;
                }

                return;

                // Edith the customer profile path
            } else if (userType.equals("Customer")) {
                Customer LoggedCustomer = accountService.getLoggedCustomer();
                session.setAttribute("customer", LoggedCustomer);

                // Show as default user profile if user profile is null
                if (LoggedCustomer.getName() != null) {
                    String firstChar = String.valueOf(LoggedCustomer.getName().charAt(0));
                    session.setAttribute("firstCharacter", firstChar);
                }

                //response.sendRedirect(request.getContextPath() + "/customer/profile.jsp");
                response.sendRedirect(request.getContextPath() + "/index.jsp");

                return;
            } else {
                // Save the error message into session
                HttpSession errorSession = request.getSession(true);
                errorSession.setAttribute("loginFailed", "❌ Invalid usernmae or password. Please try again.");
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
            }

        } catch (Exception e) {
            System.out.println("(LoginServlet) Verify process failed..." + e.getMessage());
        }
    }
}
