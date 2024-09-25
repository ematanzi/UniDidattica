package webapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class InsertProgramServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	String degreeName = request.getParameter("degreeName");
        String credits = request.getParameter("credits");
        String internshipHours = request.getParameter("internshipHours");

        HttpSession session = request.getSession(false);
        String email = (String) session.getAttribute("email");
        String password = (String) session.getAttribute("password");
        
        System.out.println(email);
        System.out.println(password);

        String department = getDepartmentByEmailAndPassword(email, password);
        
        System.out.println(department);

        if (department != null && insertDegreeProgram(degreeName, department, credits, internshipHours)) {
            response.sendRedirect("InsertionOk.jsp");
        } else {
            response.sendRedirect("Error.jsp");
        }
    }

    private String getDepartmentByEmailAndPassword(String email, String password) {
        String department = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521:ORCL";
            con = DriverManager.getConnection(url, "C##UNIDIDATTICA", "unididattica");

            String query = "SELECT Department FROM DepartmentOfStafferView WHERE s_email = ? AND s_password = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                department = rs.getString("Department");
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

        return department;
    }

    private boolean insertDegreeProgram(String degreeName, String department, String credits, String internshipHours) {
        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement refPs = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521:ORCL";
            con = DriverManager.getConnection(url, "C##UNIDIDATTICA", "unididattica");

            String refQuery = "SELECT department FROM DepartmentREFView WHERE deptname = ?";
            refPs = con.prepareStatement(refQuery);
            refPs.setString(1, department);
            rs = refPs.executeQuery();

            if (rs.next()) {
                Object departmentRef = rs.getObject(1); 

                String query = "INSERT INTO DegreeProgram (DegreeName, Department, RequiredCredits, InternshipHours) VALUES (?, ?, ?, ?)";
                ps = con.prepareStatement(query);
                ps.setString(1, degreeName);
                ps.setObject(2, departmentRef); 
                ps.setString(3, credits);
                ps.setString(4, internshipHours);

                int result = ps.executeUpdate();
                return result > 0;  
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (refPs != null) refPs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

