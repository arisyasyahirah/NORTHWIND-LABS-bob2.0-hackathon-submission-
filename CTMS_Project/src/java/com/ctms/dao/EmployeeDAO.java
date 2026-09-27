package com.ctms.dao;

import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import com.ctms.model.Employee;
import java.sql.*;
import com.ctms.util.ConnectionDB;

public class EmployeeDAO {

    private Connection conn;
    private Employee employee;

    public EmployeeDAO() {
        this.conn = new ConnectionDB().getConnection();
    }

    String idPrefix = "A";
    int idPostfix = 0;

    // Find the match user id
    public Employee findEmployeeByEmail(String userEmail) {
        String SQL = "SELECT * FROM employee WHERE emp_email = ?";  // placehoder of sql, start from 1

        try {
            // Creating prepared statement
            PreparedStatement ps = conn.prepareStatement(SQL);
            ps.setString(1, userEmail);  // Replace the ? in SQL statement (at index 1)

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Setting the employee information
                    String id = rs.getString("emp_id");
                    String email = rs.getString("emp_email");
                    String password = rs.getString("emp_password");
                    String name = rs.getString("emp_name");
                    String ph_number = rs.getString("emp_ph_number");
                    String position = rs.getString("emp_position");
                    String cinemaId = rs.getString("cinema_id"); //Syamil
                    int restriction = rs.getInt("restriction_level"); //Syamil

                    System.out.println("Employee ID: " + id);
                    System.out.println("Employee email: " + email);

                    if (email.equals(userEmail)) {
                        employee = new Employee(id, email, password, name, ph_number, position, cinemaId, restriction);
                    }
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }

            return employee;
        } catch (SQLException e) {
            System.out.println("Getting employee database data error..." + e.getMessage());
        }

        return null;
    }

    // Find the match user id
    public Employee findEmployeeById(String employeeId) {
        String SQL = "SELECT * FROM employee WHERE emp_id = ?";  // placehoder of sql, start from 1

        try {
            // Creating prepared statement
            PreparedStatement ps = conn.prepareStatement(SQL);
            ps.setString(1, employeeId);  // Replace the ? in SQL statement (at index 1)

            ResultSet rs = ps.executeQuery();  // for command that will return result set

            if (rs.next()) {
                // Setting the employee information
                String id = rs.getString("emp_id");
                String email = rs.getString("emp_email");
                String password = rs.getString("emp_password");
                String name = rs.getString("emp_name");
                String ph_number = rs.getString("emp_ph_number");
                String position = rs.getString("emp_position");
                String cinemaId = rs.getString("cinema_id"); //Syamil
                int restriction = rs.getInt("restriction_level"); //Syamil

                System.out.println("Employee ID: " + id);
                System.out.println("Employee email: " + email);

                if (employeeId.equals(id)) {
                    employee = new Employee(id, email, password, name, ph_number, position, cinemaId, restriction);
                }
            }

            return employee;
        } catch (SQLException e) {
            System.out.println("Getting employee database data error..." + e.getMessage());
        }

        return null;
    }

    public void updateEmployee(String id, String newName, String newEmail, String newPosition, String newPhoneNumber, String cinemaId, int restriction) {
        String SQL = "UPDATE employee SET emp_name = ?, emp_email = ?,  emp_position = ?, emp_ph_number = ?, cinema_id = ? ,restriction_level= ? WHERE emp_id = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);
            ps.setString(1, newName);
            ps.setString(2, newEmail);
            ps.setString(3, newPosition);
            ps.setString(4, newPhoneNumber);
            ps.setString(5, cinemaId);
            ps.setInt(6, restriction);
            ps.setString(7, id);
            ps.executeUpdate();  // use for sql commands such as update, insert or delete that do not return result set

            System.out.println("Employee info update successful. ");
        } catch (Exception e) {
            System.out.println("Update employee info failed..." + e.getMessage());
        }
    }

    public void insertEmployee(String name, String phoneNumber, String email, String password, String position, String cinemaId, int restriction) {
        String SQL = "INSERT INTO employee (emp_id, emp_name, emp_ph_number, emp_email, emp_password, emp_position, cinema_id ,restriction_level) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);

            String id = generateNewEmployeeId();

            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, phoneNumber);
            ps.setString(4, email);
            ps.setString(5, password);
            ps.setString(6, position);
            ps.setString(7, cinemaId);
            ps.setInt(8, restriction);
            ps.executeUpdate();

            System.out.println("Create employee account successfully. ");
        } catch (Exception e) {
            System.out.println("Create employee account failed.... " + e.getMessage());
        }
    }

    public void deleteEmployee(String id) {
        String SQL = "DELETE FROM TABLE employee WHERE emp_id = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(SQL);
            ps.setString(1, id);
            ps.executeUpdate();

            System.out.println("Delete employee account successfully.");
        } catch (Exception e) {
            System.out.println("Delete employee account failed...." + e.getMessage());
        }
    }

    private String generateNewEmployeeId() throws SQLException {
        String sql = "SELECT counter FROM id_counter WHERE table_name = 'employee'";
        try (PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet result = pstmt.executeQuery()) {
            if (result.next()) {
                int counter = result.getInt("counter") + 1;
                return "E" + String.format("%03d", counter);
            }
        }
        return null;
    }
}
