package webapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.RequestDispatcher;

public class TuitionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        System.out.println(email);

        if (email != null) {
            List<String[]> tuitions = getTuitionsByEmail(email);

            request.setAttribute("tuitions", tuitions);

            RequestDispatcher dispatcher = request.getRequestDispatcher("Tuition.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect("UserLogin.jsp");
        }
    }

    private List<String[]> getTuitionsByEmail(String email) {
        List<String[]> tuitions = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521:ORCL";
            con = DriverManager.getConnection(url, "C##UNIDIDATTICA", "unididattica");

            String query = "SELECT degree, expiration, amount, paid FROM StudentTuitionsView WHERE email = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();

            while (rs.next()) {
                String[] tuition = new String[4];
                tuition[0] = rs.getString("degree");      
                tuition[1] = rs.getString("expiration");  
                tuition[2] = rs.getString("amount");      
                tuition[3] = rs.getString("paid");        
                tuitions.add(tuition);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return tuitions;
    }
}
