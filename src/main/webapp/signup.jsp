<%
String username = request.getParameter("user");
%>

<!DOCTYPE html>
<html>
<head>
<title>Create Account</title>
<style>
body{
    background:#111;
    color:white;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
    font-family:sans-serif;
}
.container{
    background:#222;
    padding:40px;
    border-radius:15px;
    width:350px;
    text-align:center;
}
input{
    width:100%;
    padding:10px;
    margin:10px 0;
}
button{
    width:100%;
    padding:10px;
    background:#00f2fe;
    border:none;
    font-weight:bold;
}
</style>
</head>
<body>

<div class="container">
<h2>Sign Up</h2>
<p>Username "<%= username %>" not found.</p>

<form action="signup" method="post">
    <input type="text" name="username"
           value="<%= username != null ? username : "" %>" required>

    <input type="password" name="password"
           placeholder="Create Password" required>

    <button type="submit">Create Account</button>
</form>

</div>

</body>
</html>
