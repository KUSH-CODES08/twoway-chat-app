package com.chat.servlet;

import com.chat.util.DBConnection;
import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {

            String insert = "INSERT INTO users(username, password) VALUES(?,?)";
            PreparedStatement ps = con.prepareStatement(insert);

            ps.setString(1, username);
            ps.setString(2, password);

            ps.executeUpdate();

            response.sendRedirect("login.jsp?error=Account Created! Please Login");

        } catch (SQLIntegrityConstraintViolationException e) {
            response.sendRedirect("login.jsp?error=Username already exists");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
