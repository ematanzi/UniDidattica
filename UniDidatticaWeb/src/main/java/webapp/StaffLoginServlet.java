package webapp;

import java.io.IOException;
//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class StaffLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (isStaffValid(email, password)) {
            HttpSession session = request.getSession();
            session.setAttribute("email", email);
            session.setAttribute("password", password);

            // Reindirizza a StaffHomepage.jsp
            response.sendRedirect("StaffHomepageServlet");
        } else {
            // Se il login fallisce
            request.getRequestDispatcher("Error.jsp").forward(request, response);
        }
    }

    private boolean isStaffValid(String email, String password) {
        return true;  
    }
}


