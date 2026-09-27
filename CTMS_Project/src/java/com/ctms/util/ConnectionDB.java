package com.ctms.util;

import java.sql.*;

public class ConnectionDB {
    //Database config

    private static final String JDBC_URL
            = "jdbc:postgresql://aws-1-ap-southeast-2.pooler.supabase.com:5432/postgres?sslmode=require";

    private static final String JDBC_USERNAME
            = "postgres.spobivcidctnoosrllqm";

    private static final String JDBC_PASSWORD
            = "Tingismine#1";

    private Connection connection;

//Construct and initialize database connection
    public ConnectionDB() {
        try {
            Class.forName("org.postgresql.Driver");
            this.connection = DriverManager.getConnection(
                    JDBC_URL,
                    JDBC_USERNAME,
                    JDBC_PASSWORD
            );
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Failed to connect to database: " + e.getMessage(), e);
        }
    }

    //Self explanatory
    public Connection getConnection() {
        System.out.println(connection);
        return connection;
    }

    //Close database connection. Avoid memory leaks
    public void close() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
