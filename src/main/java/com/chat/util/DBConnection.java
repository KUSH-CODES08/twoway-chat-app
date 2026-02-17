package com.chat.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Read values from Environment Variables
    private static final String URL = System.getenv("DB_URL");
    private static final String USER = System.getenv("DB_USER");
    private static final String PASSWORD = System.getenv("DB_PASSWORD");

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            if (URL == null || USER == null || PASSWORD == null) {
                throw new RuntimeException("Database environment variables not set!");
            }

            return DriverManager.getConnection(URL, USER, PASSWORD);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
