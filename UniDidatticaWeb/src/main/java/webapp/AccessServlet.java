package webapp;

import java.io.IOException;
import javax.servlet.ServletException;
// import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AccessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AccessServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("student".equals(action)) {
            response.sendRedirect("UserAccess.jsp");
        } else if ("staff".equals(action)) {
            response.sendRedirect("StaffAccess.jsp");
        } else {
            response.sendRedirect("Error.jsp");
        }
    }
}
