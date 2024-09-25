package webapp;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserHomepageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UserHomepageServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("courses".equals(action)) {
            // Reindirizza al servlet EnrollmentServlet
            response.sendRedirect("EnrollmentServlet");
        } else if ("payments".equals(action)) {
            response.sendRedirect("TuitionServlet");
        } else {
            response.sendRedirect("Error.jsp");
        }
    }
}
