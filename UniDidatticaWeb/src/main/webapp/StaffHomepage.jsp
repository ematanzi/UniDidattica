<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Homepage</title>
</head>
<body>
    <h2>Welcome to the department page</h2>

    <!-- Stampa il dipartimento -->
    <p><strong>Department:</strong> <%= request.getAttribute("department") != null ? request.getAttribute("department") : "Nessun dipartimento trovato" %></p>

    <!-- Aggiungi un pulsante per l'inserimento di un nuovo programma -->
    <form action="InsertProgram.jsp">
        <button type="submit">Insert New program</button>
    </form>

    <!-- Stampa i programmi di studio -->
    <h3>Available degree programs</h3>
    <table border="1">
        <tr>
            <th>Degree program name</th>
            <th>Credits</th>
            <th>Internship Hours</th>
        </tr>
        <%
            // Recupera la lista dei programmi di studio passata dal servlet
            List<String[]> degreePrograms = (List<String[]>) request.getAttribute("degreePrograms");

            if (degreePrograms != null && !degreePrograms.isEmpty()) {
                // Itera sui programmi di studio e li stampa nella tabella
                for (String[] program : degreePrograms) {
        %>
                    <tr>
                        <td><%= program[0] %></td> <!-- Nome del Corso di Laurea -->
                        <td><%= program[1] %></td> <!-- Crediti -->
                        <td><%= program[2] %></td> <!-- Ore di Tirocinio -->
                    </tr>
        <%
                }
            } else {
        %>
                <tr>
                    <td colspan="3">No degree program found</td>
                </tr>
        <%
            }
        %>
    </table>
</body>
</html>

