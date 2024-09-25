<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Insert new degree program</title>
</head>
<body>
    <h2>Insert new degree program</h2>

    <form action="InsertProgramServlet" method="post">
        <label for="degreeName">Degree program name:</label>
        <input type="text" id="degreeName" name="degreeName" required><br><br>

        <label for="credits">Required credits:</label>
        <input type="number" id="credits" name="credits" required><br><br>

        <label for="internshipHours">Required internship hours:</label>
        <input type="number" id="internshipHours" name="internshipHours" required><br><br>

        <button type="submit">Insert degree program</button>
    </form>
</body>
</html>
