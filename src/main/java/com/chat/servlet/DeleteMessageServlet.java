package com.chat.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.chat.util.DBConnection;

@WebServlet("/deleteMessage")
public class DeleteMessageServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String user = (String) request.getSession().getAttribute("user");

        try (Connection con = DBConnection.getConnection()) {

            // Only delete if current user is sender
            String sql = "DELETE FROM messages WHERE id=? AND sender=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, id);
            ps.setString(2, user);

            int rows = ps.executeUpdate();

            if(rows > 0){
                response.getWriter().write("SUCCESS");
            } else {
                response.getWriter().write("FAIL");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
