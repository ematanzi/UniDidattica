package webapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UserLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupera email e password dall'input utente
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Verifica se l'utente è valido
        if (isUserValid(email, password)) {
        	HttpSession session = request.getSession();
            session.setAttribute("email", email);
        	
            // Reindirizza a UserHomepage.jsp se il login ha successo
            request.getRequestDispatcher("UserHomepage.jsp").forward(request, response);
        } else {
            // Reindirizza a Error.jsp in caso di fallimento del login
            request.getRequestDispatcher("Error.jsp").forward(request, response);
        }
    }

    // Metodo per verificare la validità dell'utente
    private boolean isUserValid(String email, String password) {
        boolean isValid = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Connessione al database
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521:ORCL";
            con = DriverManager.getConnection(url, "C##UNIDIDATTICA", "unididattica");

            // Query SQL sulla vista StudentCredentialsView
            String query = "SELECT email, password FROM StudentCredentialsView WHERE email = ? AND password = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, email);  // Imposta l'email
            ps.setString(2, password);  // Imposta la password
            rs = ps.executeQuery();

            // Se la query restituisce un risultato, l'utente è valido
            if (rs.next()) {
                isValid = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Chiudi tutte le risorse
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return isValid;
    }
}

