<%
String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Nova Login</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Inter', sans-serif;
}

body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(135deg,#0f172a,#1e293b,#111827);
}

/* Card */
.card{
    width:400px;
    padding:45px 40px;
    border-radius:18px;
    background:rgba(255,255,255,0.05);
    backdrop-filter:blur(18px);
    border:1px solid rgba(255,255,255,0.08);
    box-shadow:0 25px 60px rgba(0,0,0,0.4);
}

/* Title */
.title{
    font-size:22px;
    font-weight:600;
    color:white;
    margin-bottom:8px;
}

.subtitle{
    font-size:14px;
    color:#94a3b8;
    margin-bottom:35px;
}

/* Input group */
.input-group{
    margin-bottom:22px;
    position:relative;
}

.input-group input{
    width:100%;
    padding:12px 0;
    border:none;
    border-bottom:1px solid rgba(255,255,255,0.2);
    background:transparent;
    color:white;
    font-size:14px;
    outline:none;
    transition:all 0.3s ease;
}

.input-group input::placeholder{
    color:#64748b;
}

.input-group input:focus{
    border-bottom:1px solid #38bdf8;
}

.input-group input:focus + .line{
    width:100%;
}

.line{
    position:absolute;
    bottom:0;
    left:0;
    height:2px;
    width:0;
    background:#38bdf8;
    transition:0.3s ease;
}

/* Button */
button{
    width:100%;
    margin-top:10px;
    padding:12px;
    border-radius:12px;
    border:none;
    background:#38bdf8;
    color:#0f172a;
    font-weight:600;
    font-size:14px;
    cursor:pointer;
    transition:all 0.25s ease;
}

button:hover{
    background:#0ea5e9;
    transform:translateY(-2px);
}

/* Error */
.error{
    background:rgba(255,0,0,0.15);
    color:#f87171;
    padding:10px;
    border-radius:8px;
    font-size:13px;
    margin-bottom:20px;
}
</style>
</head>

<body>

<div class="card">

    <div class="title">Welcome Back</div>
    <div class="subtitle">Sign in to continue to Nova</div>

    <% if(error != null){ %>
        <div class="error"><%= error %></div>
    <% } %>

    <form action="login" method="post">

        <div class="input-group">
            <input type="text" name="username" placeholder="Username" required>
            <div class="line"></div>
        </div>

        <div class="input-group">
            <input type="password" name="password" placeholder="Password" required>
            <div class="line"></div>
        </div>

        <div class="input-group">
            <input type="text" name="to" placeholder="Chat With" required>
            <div class="line"></div>
        </div>

        <button type="submit">Sign In</button>

    </form>

</div>

</body>
</html>
