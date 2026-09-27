package com.ctms.service;

import com.ctms.model.Customer;
import com.ctms.model.Employee;
import com.ctms.dao.EmployeeDAO;
import com.ctms.dao.CustomerDAO;
import java.sql.Connection;

/**
 *
 * @author Simon
 */
public class AccountService {

    private EmployeeDAO empDAO;
    private Employee loggedEmployee;

    private CustomerDAO cusDAO;
    private Customer loggedCustomer;

    public AccountService() {
        empDAO = new EmployeeDAO();  // create new empDAO object at the constructor
        cusDAO = new CustomerDAO();
    }

    /*
        - preform account checking progress
        - RETURN a string that state the role of user that try to login
        - "employee" will be return for employee user
        - "customer" will be return for customer user
     */
    public String verifyByEmail(String email, String password) {
        loggedEmployee = empDAO.findEmployeeByEmail(email);
        loggedCustomer = cusDAO.findCustomerByEmail(email);
        
        // Verify the username and account
        if (loggedEmployee != null && loggedEmployee.getPassword().equals(password)) {
            return "Employee";
        } else if (loggedCustomer != null && loggedCustomer.getPassword().equals(password)) {
            return "Customer";
        }

        return "Not verified user";
    }

    // Maybe need to change the function name to verifyUserPermission...
    // change to boolean
    public void updateCustomerInfo(String id, String newName, String newEmail, String newPhoneNumber, String userType, int restriction) {
        if (hasPermission(userType, restriction)) {
            System.out.println("Permission granted. Updating customer info...");
            cusDAO.updateCustomer(id, newName, newEmail, newPhoneNumber);
        } else {
            System.out.println("Permission denied. Customer info not updated...");
        }
    }

    public void updateEmployeeInfo(String id, String newName, String newEmail, String position ,String newPhoneNumber, String userType, String cinemaId ,int restriction) {
        if (hasPermission(userType, restriction)) {
            // if is HQ, can edit all people (include staff, manager and customer)
            System.out.println("Permission granted. Updating employee info....");
            empDAO.updateEmployee(id, newName, newEmail, position, newPhoneNumber, cinemaId, restriction);
        } else {
            System.out.println("Permission denied. Employee info not updated...");
        }
    }

    // Check user permission
    private boolean hasPermission(String userType, int restriction) {
        // customer dont got restriction property, so set to 0 as custoemr's restriction
        if (userType.equals("customer") && restriction == 0) {
            return true;
        } else if (userType.equals("employee") && restriction == 3) {
            return true;
        } else {
            return false;
        }
    }

    // Create new customer
    public boolean createNewCustomerAccount(String name, String email, String password, String phoneNumber, String dob) {
        // Double check the new customer record is not duplicate

        if (cusDAO.findCustomerByEmail(email) == null) {
            System.out.println("No duplication found, creating new customer account. ");
            cusDAO.insertCustomer(name, email, password, phoneNumber, dob);
            return true;
        } else {
            System.out.println("Customer account are duplicate, creating new customer account fail. ");
            return false;
        }
    }

    // Create new employee
    public void createNewEmployeeAccount(String name, String phoneNumber, String email, String password, String position, String cinemaId ,int restriction) {
        empDAO.insertEmployee(name, phoneNumber, email, password, position, cinemaId ,restriction);
    }

    // Delete customer account
    public void deleteCustomerAccont(String id) {
        if (cusDAO.deleteCustomer(id)) {
            System.out.println("Delete customer account success...");
        } else {
            System.out.println("Delete customer account failed...");
        }
    }

    // Delete employee account
    public void deleteEmployeeAccount(String id) {
        empDAO.deleteEmployee(id);
    }

    // Get the employee personal information
    public Employee getLoggedEmployee() {
        return loggedEmployee;
    }

    public Customer getLoggedCustomer() {
        return loggedCustomer;
    }
}
