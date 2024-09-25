<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Exams info</title>
</head>
<body>
    <h2>Exams info</h2>

    <%
    String email = (String) session.getAttribute("email");
    String courseCode = request.getParameter("courseCode");
    %>

    <h3>Exams for the course: <%= courseCode %></h3>

    <table border="1">
        <tr>
            <th>Email</th>
            <th>Course code</th>
            <th>Course Name</th>
            <th>Exam date</th>
            <th>Mark</th>
            <th>Accepted</th>
        </tr>
        <%
            List<String[]> examDetails = (List<String[]>) request.getAttribute("examDetails");

            if (examDetails != null && !examDetails.isEmpty()) {
                for (String[] exam : examDetails) {
        %>
                    <tr>
                        <td><%= exam[0] %></td> <!-- Email -->
                        <td><%= exam[1] %></td> <!-- Codice del Corso -->
                        <td><%= exam[2] %></td> <!-- Titolo del Corso -->
                        <td><%= exam[3] %></td> <!-- Data Esame -->
                        <td><%= exam[4] %></td> <!-- Voto -->
                        <td><%= "t".equalsIgnoreCase(exam[5]) ? "Sì" : "No" %></td> <!-- Accettato ('t' -> Sì, 'f' -> No) -->
                    </tr>
        <%
                }
            } else {
        %>
                <tr>
                    <td colspan="6">No exams linked to this course.</td>
                </tr>
        <%
            }
        %>
    </table>

    <a href="UserAccess.jsp">Back</a>
</body>
</html>
