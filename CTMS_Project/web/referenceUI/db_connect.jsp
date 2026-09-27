<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%--
    ================================================================
    db_connect.jsp — CineOrder Database Connection
    ================================================================
    HOW TO USE:
        <%@ include file="db_connect.jsp" %>
    Then use the `conn` variable directly in your JSP.

    SETUP STEPS (phpMyAdmin):
    1. Open phpMyAdmin → create database named: cineorder_db
    2. Change DB_USER and DB_PASS below to match your MySQL login
    3. Make sure mysql-connector-j-x.x.x.jar is in:
           Web Pages/WEB-INF/lib/
    ================================================================
--%>
<%!
    // ── Change these to match your phpMyAdmin setup ──────────────
    static final String DB_URL  = "jdbc:mysql://localhost:3306/cineorder_db";
    static final String DB_USER = "root";      // your phpMyAdmin username
    static final String DB_PASS = "admin";          // your phpMyAdmin password (default is empty)
    static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";



%>
<%
    Connection conn = null;
    try {
        Class.forName(DB_DRIVER);
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    } catch (ClassNotFoundException e) {
        out.println("<div class='alert alert-error'>MySQL Driver not found. Add mysql-connector.jar to WEB-INF/lib/</div>");
    } catch (SQLException e) {
        out.println("<div class='alert alert-error'>Database connection failed: " + e.getMessage() + "</div>");
    }
%>
