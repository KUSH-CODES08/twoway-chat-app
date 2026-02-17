<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.chat.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String user = (String) session.getAttribute("user");
String to = request.getParameter("to");

if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

Connection con = DBConnection.getConnection();

String sql = "SELECT * FROM messages WHERE " +
             "(sender=? AND receiver=?) OR (sender=? AND receiver=?) " +
             "ORDER BY timestamp ASC";

PreparedStatement ps = con.prepareStatement(sql);
ps.setString(1, user);
ps.setString(2, to);
ps.setString(3, to);
ps.setString(4, user);

ResultSet rs = ps.executeQuery();
SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>NOVA CHAT</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

<style>
/* --- YOUR SAME STYLES --- */
*{margin:0;padding:0;box-sizing:border-box;font-family:'Inter', sans-serif;}

body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background: radial-gradient(circle at top left, #16222a, #0f2027 60%, #0b141c);
}

.chat-wrapper{
    width:460px;
    height:680px;
    background: rgba(255,255,255,0.05);
    backdrop-filter: blur(25px);
    border-radius:30px;
    border:1px solid rgba(255,255,255,0.15);
    box-shadow:0 0 60px rgba(0,255,255,0.25);
    display:flex;
    flex-direction:column;
    overflow:hidden;
}

.header{
    background: linear-gradient(90deg,#1fb6ff,#38bdf8);
    padding:18px 20px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    color:black;
}

.header-left{display:flex;flex-direction:column;}
.header-title{font-size:15px;font-weight:600;}
.status{font-size:12px;margin-top:4px;}
.online{color:#00ff88;}
.offline{color:#ff4d4d;}

.logout-btn{
    padding:6px 14px;
    border-radius:20px;
    border:none;
    background:black;
    color:#38bdf8;
    font-size:11px;
    cursor:pointer;
}

.chat-box{
    flex:1;
    padding:25px;
    overflow-y:auto;
    display:flex;
    flex-direction:column;
    gap:14px;
    background: linear-gradient(180deg, #1e2a3a, #182433);
}

.msg{
    padding:12px 18px;
    border-radius:18px;
    max-width:75%;
    font-size:13px;
    position:relative;
}

.sent{
    align-self:flex-end;
    background: linear-gradient(135deg,#38bdf8,#0ea5e9);
    color:black;
}

.received{
    align-self:flex-start;
    background: rgba(255,255,255,0.08);
    color:white;
    border:1px solid rgba(255,255,255,0.2);
}

.timestamp{
    font-size:10px;
    opacity:0.7;
    margin-top:6px;
    text-align:right;
}

/* 🔥 DELETE BUTTON STYLE */
.delete-btn{
    font-size:10px;
    margin-top:4px;
    cursor:pointer;
    color:#ff4d4d;
    text-align:right;
}

.input-area{
    padding:18px;
    display:flex;
    gap:12px;
    background: rgba(0,0,0,0.4);
}

.input-area input{
    flex:1;
    padding:14px;
    border-radius:25px;
    border:none;
    outline:none;
    background:rgba(255,255,255,0.08);
    color:white;
}

.input-area button{
    padding:14px 22px;
    border-radius:25px;
    border:none;
    background:linear-gradient(135deg,#38bdf8,#0ea5e9);
    color:black;
    font-weight:bold;
    cursor:pointer;
}
</style>
</head>

<body>

<div class="chat-wrapper">

    <div class="header">
        <div class="header-left">
            <div class="header-title">To | <%= to %></div>
            <div id="statusIndicator" class="status"></div>
        </div>

        <form action="logout" method="get">
            <button class="logout-btn">LOGOUT</button>
        </form>
    </div>

    <div id="chatBox" class="chat-box">

        <% 
        while(rs.next()){
            int id = rs.getInt("id");
            String sender = rs.getString("sender");
            String message = rs.getString("message");
            Timestamp ts = rs.getTimestamp("timestamp");

            boolean isSender = sender.equals(user);
            String type = isSender ? "sent" : "received";
        %>

            <div class="msg <%= type %>" id="msg-<%= id %>">
                <div><%= message %></div>
                <div class="timestamp"><%= sdf.format(ts) %></div>

                <% if(isSender){ %>
                    <div class="delete-btn"
                         onclick="deleteMessage(<%= id %>)">
                         Delete
                    </div>
                <% } %>
            </div>

        <% 
        }
        rs.close();
        ps.close();
        con.close();
        %>

    </div>

    <div class="input-area">
        <input type="text" id="msg" placeholder="Transmit message...">
        <button onclick="send()">SEND</button>
    </div>

</div>

<script>

var currentUser = "<%= user %>";
var chattingWith = "<%= to %>";

var socket = new WebSocket(
	    (location.protocol === "https:" ? "wss://" : "ws://") +
	    location.host +
	    "/chat?user=" + currentUser
	);


socket.onopen = function(){
    socket.send("CHECK_STATUS:" + chattingWith);
};

socket.onmessage = function(e){

    if(e.data.startsWith("STATUS:")){
        handleStatus(e.data);
        return;
    }

    handleIncomingMessage(e.data);
};

function handleStatus(data){
    var parts = data.split(":");
    var user = parts[1];
    var status = parts[2];

    if(user === chattingWith){
        var indicator = document.getElementById("statusIndicator");

        if(status === "ONLINE"){
            indicator.innerHTML = "<span class='online'>● Online</span>";
        } else {
            indicator.innerHTML = "<span class='offline'>● Offline</span>";
        }
    }
}

function send(){
    var input = document.getElementById("msg");
    var text = input.value.trim();
    if(text==="") return;

    socket.send(chattingWith + ":" + text);
    addMessage(text, "sent", getCurrentTime());
    input.value="";
}

function handleIncomingMessage(message){
    var sender = message.split(":")[0];
    var text = message.substring(message.indexOf(":") + 1).trim();
    var type = sender === currentUser ? "sent" : "received";
    addMessage(text, type, getCurrentTime());
}

function addMessage(text, type, time){
    var box = document.getElementById("chatBox");

    var div = document.createElement("div");
    div.classList.add("msg");
    div.classList.add(type);

    div.innerHTML = "<div>"+text+"</div><div class='timestamp'>"+time+"</div>";

    box.appendChild(div);

    box.scrollTo({
        top: box.scrollHeight,
        behavior: "smooth"
    });
}

/* 🔥 DELETE FUNCTION */
function deleteMessage(id){

    if(!confirm("Delete this message?")) return;

    fetch("deleteMessage", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: "id=" + id
    })
    .then(response => response.text())
    .then(data => {
        if(data === "SUCCESS"){
            document.getElementById("msg-" + id).remove();
        } else {
            alert("Cannot delete message.");
        }
    });
}

function getCurrentTime(){
    var now = new Date();
    return now.toLocaleTimeString([], {hour:'2-digit', minute:'2-digit'});
}

window.onload = function(){
    var box = document.getElementById("chatBox");
    box.scrollTop = box.scrollHeight;
};

document.getElementById("msg").addEventListener("keypress",function(e){
    if(e.key==="Enter") send();
});

</script>

</body>
</html>
