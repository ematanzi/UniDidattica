<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Elenco Account Studenti</title>
</head>
<body>
    <h2>Elenco Account Studenti</h2>

    <!-- Visualizza la tabella degli account passata dal servlet -->
    <div>
        <%= request.getAttribute("studentAccounts") %>
    </div>

    <br>
    <a href="Access.jsp">Torna alla pagina principale</a>
</body>
</html>
