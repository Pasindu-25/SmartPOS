package com.smartpos.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class to manage database connections.
 * This class ensures a single point of access to the database across the application.
 */
public class DBConnection {

    // Database configuration constants
    private static final String URL = "jdbc:mysql://gateway01.ap-southeast-1.prod.aws.tidbcloud.com:4000/smart_pos_db?sslMode=VERIFY_IDENTITY";
    private static final String USER = "yuiUaiXyPXNpnAV.root"; // Replace with your DB username
    private static final String PASSWORD = "i5dsKtkLEZhUELzT"; // Replace with your DB password

    // Static block to load the MySQL JDBC Driver class only once
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("Error: MySQL JDBC Driver not found.");
            e.printStackTrace();
        }
    }

    /**
     * Establishes and returns a connection to the database.
     *
     * @return Connection object to interact with the database
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * Helper method to close the connection safely.
     *
     * @param conn The connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing the database connection.");
                e.printStackTrace();
            }
        }
    }
}