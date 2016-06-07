package transactS;

import java.io.IOException;
import java.sql.DriverManager;          // Handles communicatoin with DB
import java.sql.Connection;             // A Connection to DB
import java.sql.Statement;              // Static SQL statement
import java.sql.ResultSet;              // Table of rows returned from SQL query
import java.sql.SQLException;
import java.util.Properties;            // For key/value pairs
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class EmpFinder extends HttpServlet {

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse res) {
        executeQueryAndRedirect(req, res);
    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse res) {
        sendResponse(req, res, "POST requests only please.", true);
    }

    private void executeQueryAndRedirect(HttpServletRequest req, HttpServletResponse res) {
        Connection conn = getConnection();
        int eid = -1;

        try {
            eid = Integer.parseInt(req.getParameter("eid"));
            String sql = "SELECT employee.id, employee.name, employee.department, salary.salary FROM employee, salary WHERE employee.id = " + eid + " AND employee.id = salary.emp_id;";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            if(rs.isBeforeFirst()) {    // Records exists because cursor is before first row
                rs.next();
                HttpSession session = req.getSession();
                session.setAttribute("employeeID", rs.getInt(1));
                session.setAttribute("employeeName", rs.getString(2));
                session.setAttribute("department", rs.getString(3));
                session.setAttribute("salary", rs.getBigDecimal(4));
                res.sendRedirect("editEmployee.jsp");
                return;
            }
        } 
        catch (NumberFormatException e) {}
        catch (SQLException e) { System.out.println(e); }
        catch (IOException e) {}

        String msg = "There is no employee with ID " + eid + ".";
        sendResponse(req, res, msg, true);
    }

    /**
     * Sends server response back to client with a string message
     * @param req   Request Object
     * @param res   Response Object
     * @param msg   String to display
     * @param error Boolean to determine which page to direct to (ok, error)
     */
    private void sendResponse(HttpServletRequest req, HttpServletResponse res, String msg, boolean error) {
        try {
            HttpSession session = req.getSession();
            session.setAttribute("result", msg);
            if(error) {
                res.sendRedirect("badResult.jsp");
            } else {
                res.sendRedirect("goodResult.jsp");
            }
        } catch (IOException e) {}
    }

    /**
     * Convenience method to connect to the database
     * @return connection to database
     */
    private Connection getConnection() {
        String uri = "jdbc:postgresql://localhost/skistuff";
        Properties props = setLoginForDB("rupert", "secret");
        Connection conn = null;
        try {
            Class.forName("org.postgresql.Driver");     // Load Postgresql driver
            conn = DriverManager.getConnection(uri, props);
        }
        catch(ClassNotFoundException e){}
        catch (SQLException e){}

        return conn;
    }

    /**
     * Sets login for database
     * @param  uname  
     * @param  passwd 
     * @return A property (key, value) for login info
     */
    private Properties setLoginForDB(final String uname, final String passwd) {
        Properties props = new Properties();
        props.setProperty("user", uname);
        props.setProperty("password", passwd);
        return props;
    }

}