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

public class ExamDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String courseCode = request.getParameter("courseCode"); 

        if (email != null && courseCode != null && !courseCode.isEmpty()) {
            List<String[]> examDetails = getExamDetailsByEmailAndCourseCode(email, courseCode);

            request.setAttribute("examDetails", examDetails);

            RequestDispatcher dispatcher = request.getRequestDispatcher("ExamDetails.jsp");
            dispatcher.forward(request, response);
        } else {
            
            response.sendRedirect("UserLogin.jsp");
        }
    }

    private List<String[]> getExamDetailsByEmailAndCourseCode(String email, String courseCode) {
        List<String[]> examDetails = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521:ORCL";
            con = DriverManager.getConnection(url, "C##UNIDIDATTICA", "unididattica");

            String query = "SELECT email, code, title, exam_date, mark, accepted FROM ExamsByStudentView WHERE email = ? AND code = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, courseCode);
            rs = ps.executeQuery();

            while (rs.next()) {
                String[] exam = new String[6];
                exam[0] = rs.getString("email");
                exam[1] = rs.getString("code");
                exam[2] = rs.getString("title");
                exam[3] = rs.getString("exam_date");
                exam[4] = rs.getString("mark");
                exam[5] = rs.getString("accepted");
                examDetails.add(exam);
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

        return examDetails;
    }
}
