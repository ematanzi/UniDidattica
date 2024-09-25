<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Enrollment</title>
</head>
<body>
    <h2>Course registrations</h2>

    <%
    String email = (String) session.getAttribute("email");
%>

<table border="1">
    <tr>
        <th>Code</th>
        <th>Title</th>
        <th>Credits</th>
        <th>Actions</th>
    </tr>
    <%
        List<String[]> enrollments = (List<String[]>) request.getAttribute("enrollments");

        if (enrollments != null && !enrollments.isEmpty()) {
            for (String[] enrollment : enrollments) {
    %>
                <tr>
                    <td><%= enrollment[0] %></td> <!-- Codice del corso -->
                    <td><%= enrollment[1] %></td> <!-- Titolo del corso -->
                    <td><%= enrollment[2] %></td> <!-- Crediti del corso -->
                    <td>
                        <form action="ExamDetailsServlet" method="post">
                            <input type="hidden" name="courseCode" value="<%= enrollment[0] %>">
                            <button type="submit">Show related exams</button>
                        </form>
                    </td>
                </tr>
    <%
            }
        } else {
    %>
            <tr>
                <td colspan="4">You are not enrolled in any course</td>
            </tr>
    <%
        }
    %>
</table>

</body>
</html>
