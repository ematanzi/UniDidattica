package webapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ShowStudentAccountsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            // Inizializza il driver JDBC e stabilisce la connessione
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521:ORCL";
            Connection con = DriverManager.getConnection(url, "C##UNIDIDATTICA", "unididattica");

            // Esegue la query
            String query = "SELECT deref(student).email, studentpassword FROM StudentAccount";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            // Salva i risultati in attributi di richiesta
            StringBuilder sb = new StringBuilder();
            sb.append("<table border='1'><tr><th>Email</th><th>Password</th></tr>");
            while (rs.next()) {
                sb.append("<tr><td>").append(rs.getString(1)).append("</td>");
                sb.append("<td>").append(rs.getString(2)).append("</td></tr>");
            }
            sb.append("</table>");

            // Imposta i risultati come attributo di richiesta
            request.setAttribute("studentAccounts", sb.toString());

            // Chiudi le risorse
            rs.close();
            ps.close();
            con.close();

            // Forward ai risultati nella JSP
            request.getRequestDispatcher("showStudentAccounts.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }
}