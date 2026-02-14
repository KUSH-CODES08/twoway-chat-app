package com.chat.websocket;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;

import com.chat.util.DBConnection;

@ServerEndpoint("/chat")
public class OneToOneChatServer {

    private static Map<String, Session> users = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {

        String query = session.getQueryString();
        String username = query.split("=")[1];

        session.getUserProperties().put("username", username);
        users.put(username, session);

        // 🔥 Notify all users that someone came online
        broadcastStatus(username, "ONLINE");
    }

    @OnMessage
    public void onMessage(String message, Session senderSession) {

        try {
            String sender = (String) senderSession.getUserProperties().get("username");

            // 🔥 Special status check message
            if (message.startsWith("CHECK_STATUS:")) {
                String target = message.split(":")[1];
                boolean isOnline = users.containsKey(target);

                senderSession.getBasicRemote()
                        .sendText("STATUS:" + target + ":" + (isOnline ? "ONLINE" : "OFFLINE"));
                return;
            }

            String[] parts = message.split(":", 2);
            String receiver = parts[0];
            String msg = parts[1];

            // Save message to DB
            try (Connection con = DBConnection.getConnection()) {

                String sql = "INSERT INTO messages(sender, receiver, message) VALUES(?,?,?)";
                PreparedStatement ps = con.prepareStatement(sql);

                ps.setString(1, sender);
                ps.setString(2, receiver);
                ps.setString(3, msg);

                ps.executeUpdate();
            }

            Session receiverSession = users.get(receiver);

            if (receiverSession != null && receiverSession.isOpen()) {
                receiverSession.getBasicRemote()
                        .sendText(sender + ": " + msg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {

        String username = (String) session.getUserProperties().get("username");
        users.remove(username);

        broadcastStatus(username, "OFFLINE");
    }

    private void broadcastStatus(String user, String status) {

        for (Session s : users.values()) {
            try {
                s.getBasicRemote()
                        .sendText("STATUS:" + user + ":" + status);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
