<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Access Page</title>
</head>
<body>
    <h2>Select your access type</h2>
    <form action="AccessServlet" method="post">
        <button type="submit" name="action" value="student">Access as Student</button>
        <button type="submit" name="action" value="staff">Access as Staff</button>
    </form>
</body>
</html>
