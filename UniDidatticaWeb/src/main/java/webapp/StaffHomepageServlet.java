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

public class StaffHomepageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(); 
        if (session != null) {
            String email = (String) session.getAttribute("email");
            String password = (String) session.getAttribute("password");

            String department = getDepartmentByEmailAndPassword(email, password);

            if (department != null) {
                List<String[]> degreePrograms = getDegreeProgramsByDepartment(department);

                request.setAttribute("department", department);
                request.setAttribute("degreePrograms", degreePrograms);

                RequestDispatcher dispatcher = request.getRequestDispatcher("StaffHomepage.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect("Error.jsp");
            }
        } else {
            response.sendRedirect("StaffAccess.jsp");
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

    private List<String[]> getDegreeProgramsByDepartment(String department) {
        List<String[]> degreePrograms = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521:ORCL";
            con = DriverManager.getConnection(url, "C##UNIDIDATTICA", "unididattica");

            String query = "SELECT DegreeName, Credits, InternshipHours FROM DegreeProgramView WHERE department = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, department);
            rs = ps.executeQuery();

            while (rs.next()) {
                String[] program = new String[3];
                program[0] = rs.getString("DegreeName");
                program[1] = rs.getString("Credits");
                program[2] = rs.getString("InternshipHours");
                degreePrograms.add(program);
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

        return degreePrograms;
    }
}

