<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Homepage</title>
</head>
<body>
<h2>Menu</h2>
    <form action="UserHomepageServlet" method="post">
        <button type="submit" name="action" value="courses">Your courses</button>
        <button type="submit" name="action" value="payments">Your payments</button>
    </form>
</body>
</html>