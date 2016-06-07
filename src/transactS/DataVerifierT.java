package transactS;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DataVerifierT extends HttpServlet {
    public static final int MinLength = 6;

    public DataVerifierT() {}

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse res) {
        Connection conn = getConnection();
        verifyUserInputsAndUpdateDB(conn, req, res);
        try {
            conn.close();
        } catch(SQLException e){}
    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse res) {
        sendResponse(req, res, "POST requests only please.", true);
    }

    private void verifyUserInputsAndUpdateDB(Connection conn, HttpServletRequest req, HttpServletResponse res) {
        String name = req.getParameter("name");
        String department = req.getParameter("department");
        String salary = req.getParameter("salary");
        String idString = req.getParameter("id");

        // Verifications
        if(name == null) { sendResponse(req, res, "Employee name is missing.", true); return;}
        if(department == null) { sendResponse(req, res, "Employee department is missing.", true); return;}
        if(salary == null) { sendResponse(req, res, "Employee salary is missing.", true); return;}
        if(idString == null) { sendResponse(req, res, "Employee id is missing.", true); return;}
        if(name.length() < 6) { sendResponse(req, res, "Employee name must be 6 or more characters.", true); return;}
        if(department.length() < 6) { sendResponse(req, res, "Employee name must be 6 or more characters.", true); return;}

        BigDecimal salaryBD = convertSalary(salary);
        if(salaryBD == null) { sendResponse(req, res, "The salary can only contain digits, +, - and .", true); return;}

        name = capitalizeParts(name);
        department = capitalizeParts(department);

        if(handleEdit(conn, res, idString, name, department, salaryBD)) {
            sendResponse(req, res, "Employee " + name + " updated successfully.", false);
        } else {
            sendResponse(req, res, "Problem updating Employee " + name + ".", true);
        }
    }

    private boolean handleEdit(Connection conn, HttpServletResponse res, String idString, String name, String department, BigDecimal salary) {
        String sql1 = "UPDATE employee SET name=?, department=? WHERE id=?";
        String sql2 = "UPDATE salary SET salary=? WHERE emp_id=?";
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;

        try {
            conn.setAutoCommit(false);  // Remove implicit commit. We want to commit both statements explicitly (thus at the same time)

            int idEmp = Integer.parseInt(idString.trim());

            pstmt1 = conn.prepareStatement(sql1);
            pstmt1.setString(1, name);
            pstmt1.setString(2, department);
            pstmt1.setInt(3, idEmp);

            pstmt2 = conn.prepareStatement(sql2);
            pstmt2.setBigDecimal(1, salary);
            pstmt2.setInt(2, idEmp);
            
            pstmt1.executeUpdate();
            pstmt2.executeUpdate();

            conn.commit();      // Explicit commit

            return true;
        }
        catch(NumberFormatException e) {}
        catch(SQLException e2) {
            try {
                conn.rollback();
            } catch (Exception e) {}
        }
        finally {
            try{
                if (pstmt1 != null) { pstmt1.close(); }
                if (pstmt2 != null) { pstmt2.close(); }
                if (conn != null) { conn.close(); }
            } catch (Exception e) {}
        }

        return false;
    }

    private BigDecimal convertSalary(String salary){
        BigDecimal result = null;
        try{
            result = new BigDecimal(salary);
        } catch(NumberFormatException e) {}
        return result;
    }

    private String capitalizeParts(String str){
        if(str.length() < 1) return str;
        String[] parts = str.split(" ");
        String result = "";

        for(String part: parts){
            if(part.length()>0) {
                result += new String(Character.toUpperCase(part.charAt(0)) + part.substring(1) + " ");
            }
        }
        result = result.trim();
        return result;
    }

    private void sendResponse(HttpServletRequest req, HttpServletResponse res, String msg, boolean error) {
        try{
            HttpSession session = req.getSession();
            session.setAttribute("result", msg);
            if(error){
                res.sendRedirect("badResult.jsp");
            } else {
                res.sendRedirect("goodResult.jsp");
            }
        } catch(IOException e) {}
    }

    private Connection getConnection(){
        String uri = "jdbc:postgresql://localhost/skistuff";
        Properties props = setLoginForDB("rupert", "secret");
        Connection conn = null;
        try{
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(uri, props);
        } 
        catch(ClassNotFoundException e){}
        catch(SQLException e){}

        return conn;
    }

    private Properties setLoginForDB(final String uname, final String passwd) {
        Properties props = new Properties();
        props.setProperty("user", uname);
        props.setProperty("password", passwd);
        return props;
    }
}