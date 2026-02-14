package com.chat.servlet;

import com.chat.util.DBConnection;
import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String to = request.getParameter("to");

        try (Connection con = DBConnection.getConnection()) {

            String checkUser = "SELECT password FROM users WHERE username=?";
            PreparedStatement ps = con.prepareStatement(checkUser);
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                response.sendRedirect("signup.jsp?user=" + username);
                return;
            }

            String dbPassword = rs.getString("password");

            if (dbPassword.equals(password)) {

                HttpSession session = request.getSession();
                session.setAttribute("user", username);

                response.sendRedirect("chat.jsp?to=" + to);

            } else {
                response.sendRedirect("login.jsp?error=Wrong Password");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
