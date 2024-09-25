<!DOCTYPE html>
<html>
<head>
    <title>Staff Login</title>
</head>
<body>
    <h2>Staff Login</h2>
    <form action="StaffLoginServlet" method="post">
        <label for="email">Email:</label>
        <input type="text" id="email" name="email" required><br><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>

        <input type="submit" value="Login">
    </form>
</body>
</html>
