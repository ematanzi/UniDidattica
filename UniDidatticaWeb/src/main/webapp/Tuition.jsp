<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Universitary taxes details</title>
</head>
<body>
    <h2>Taxes</h2>

    <%
    String email = (String) session.getAttribute("email");
    %>

    <h3>Taxes for the account: <%= email %></h3>

    <table border="1">
        <tr>
            <th>Degree Program</th>
            <th>Expiration Date</th>
            <th>Amount</th>
            <th>Paid</th>
        </tr>
        <%
            List<String[]> tuitions = (List<String[]>) request.getAttribute("tuitions");

            if (tuitions != null && !tuitions.isEmpty()) {
                for (String[] tuition : tuitions) {
        %>
                    <tr>
                        <td><%= tuition[0] %></td> <!-- Corso di laurea -->
                        <td><%= tuition[1] %></td> <!-- Data di scadenza -->
                        <td><%= tuition[2] %></td> <!-- Importo -->
                        <td><%= "t".equalsIgnoreCase(tuition[3]) ? "Sì" : "No" %></td> <!-- Pagata ('t' -> Sì, 'f' -> No) -->
                    </tr>
        <%
                }
            } else {
        %>
                <tr>
                    <td colspan="4">Non ci sono tasse registrate per questo studente.</td>
                </tr>
        <%
            }
        %>
    </table>

    <a href="UserHomepage.jsp">Back</a>
</body>
</html>
