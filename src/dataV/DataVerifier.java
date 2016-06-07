package dataV;

import java.math.BigDecimal;					// For prices
import java.sql.DriverManager;					// Handles communicaton with DB
import java.sql.Connection;						// A connection to DB
import java.sql.Statement;
import java.sql.PreparedStatement;				// SQL statement for DB to execute
import java.sql.ResultSet;						// Table of rows generated from SQL query
import java.sql.SQLException;					// What's thrown when JDBC fails
import java.util.Properties;					// For key/value pairs
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.ws.http.HTTPException;
import java.io.IOException;

public class DataVerifier extends HttpServlet {
	private static final int MinLength = 8;

	public DataVerifier(){}

	public void doPost(HttpServletRequest req, HttpServletResponse res) {
		Connection conn = getConnection();
		verifyUserInputsAndUpdateDB(conn, req, res);
		try {
			conn.close();
		} catch (SQLException e) {}
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res){
		/** Throw new HTTPException(HttpServletResponse.SC_METHOD_NOT_ALLOWED); HTTP 405 */
		sendResponse(req, res, "Only POST requests are allowed.", true);
	}

	private void verifyUserInputsAndUpdateDB(Connection conn, HttpServletRequest req, HttpServletResponse res) {
		String productN = req.getParameter("product");
		String categoryN = req.getParameter("category");
		String price = req.getParameter("price");

		// Data verification
		if(productN == null || categoryN == null || price == null) {
			sendResponse(req, res, "One or more bad input items found.", true);
			return;
		}

		if(productN.length() < MinLength) {
			sendResponse(req, res, "A product's name must be at least " + MinLength + " characters.", true);
			return;
		}

		if(categoryN.length() < MinLength) {
			sendResponse(req, res, "A category's name must be at least " + MinLength + " characters.", true);
			return;
		}

		BigDecimal priceBD = convertPrice(price);
		if(priceBD == null){
			sendResponse(req, res, "Price can only contain +/-, ., and decimal digits only.", true);
			return;
		}

		// Capitalize
		productN = capitalizeParts(productN);
		categoryN = capitalizeParts(categoryN);

		// Create scenario: (no id in parameter)
		if(req.getParameter("id") == null) {
			if(productNameInUse(conn, productN)) {
				sendResponse(req, res, "The name " + productN + " is already in use.", true);
			} else if(handleCreate(conn, res, productN, categoryN, priceBD)) {
				sendResponse(req, res, productN + " add to the database.", false);
			} else {
				sendResponse(req, res, "Problem saving " + productN + " to the database.", true);
			}
		// Edit scenario:
		} else {
			if(handleEdit(conn, res, req.getParameter("id"), productN, categoryN, priceBD)) {
				sendResponse(req, res, productN + " updated successfully.", false);
			} else {
				sendResponse(req, res, "Problem updating " + productN, true);
			}
		}
	}

	/**
	 * Create row in database table skisEtc
	 * @param  conn                Database connection
	 * @param  res                 HTTP Response
	 * @param  product             String name
	 * @param  category            String category
	 * @param  price               Numeric price
	 * @return                     Boolean to indicate if sql statement was successful
	 */
	private boolean handleCreate(Connection conn, HttpServletResponse res, String product, String category, BigDecimal price) {
		boolean flag = false;
		String sql = "INSERT INTO skisEtc(product, category, price) VALUES (?, ?, ?)";

		try {
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, product);
			pstmt.setString(2, category);
			pstmt.setBigDecimal(3, price);
			pstmt.executeUpdate();
			flag = true;
			pstmt.close();
		} catch(SQLException e) {}

		return flag;
	}

	/**
	 * Edit row in database table skisEtc
	 * @param  conn                Database connection
	 * @param  res                 HTTP Response
	 * @param  idString			   String of id to edit
	 * @param  product             String name
	 * @param  category            String category
	 * @param  price               Numeric price
	 * @return                     Boolean to indicate if sql statement was successful
	 */
	private boolean handleEdit(Connection conn, HttpServletResponse res, String idString, String product, String category, BigDecimal price) {
		boolean flag = false;
		String sql = "UPDATE skisEtc SET product=?, category=?, price=? WHERE id=?";

		try {
			int id = Integer.parseInt(idString.trim());
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, product);
			pstmt.setString(2, category);
			pstmt.setBigDecimal(3, price);
			pstmt.setInt(4, id);
			pstmt.executeUpdate();
			flag = true;
			pstmt.close();
		} catch(SQLException e) {}

		return flag;
	}

	/**
	 * Sends server response back to client with a string message
	 * @param req   Request Object
	 * @param res   Response Object
	 * @param msg   String to display
	 * @param error Boolean to determine which page to direct to (ok, error)
	 */
	private void sendResponse(HttpServletRequest req, HttpServletResponse res, String msg, boolean error){
		try {
			HttpSession session = req.getSession();
			session.setAttribute("result", msg);
			if(error){
				res.sendRedirect("badResult.jsp");
			} else {
				res.sendRedirect("goodResult.jsp");
			}
		} catch(IOException e) {}
	}

	/**
	 * Convert string to BigDecimal format (price)
	 * @param  price String of price
	 * @return       BigDecimal of price
	 */
	private BigDecimal convertPrice(String price) {
		BigDecimal result = null;
		try {
			result = new BigDecimal(price);
		} catch (NumberFormatException e) {}

		return result;
	}

	/**
	 * Title case a string
	 * @param  str String to title case
	 * @return     Converted, title-cased string
	 */
	private String capitalizeParts(String str) {
		if(str.length() < 1) return str;
		String[] parts = str.split(" ");
		String result = "";

		for(String part : parts) {
			if(part.length() > 0) {
				result += new String(Character.toUpperCase(part.charAt(0)) + part.substring(1) + " ");
			}
		}
		result = result.trim();
		return result;
	}

	/**
	 * Check if product name is already in table
	 * @param  conn DB Connection
	 * @param  name Product name to check
	 * @return      True or False depending if name already exists
	 */
	private boolean productNameInUse(Connection conn, String name) {
		boolean flag = false;
		try {
			// Better way of checking if entry exists in table...
			Statement stmt = conn.createStatement();
			String sql = "SELECT product FROM skisEtc WHERE UPPER(product) = UPPER('"+name+"');";
			ResultSet rs = stmt.executeQuery(sql);
			if(rs.isBeforeFirst()) {    // Records exists because cursor is before first row
				flag = true;
			}
			/*while(rs.next()){
				String product = rs.getString("product");
				if(product.equalsIgnoreCase(name)) {
					flag = true;
					break;
				}
			}*/
			rs.close();
			stmt.close();
		} catch (SQLException e) {} 

		return flag;
	}

	/**
	 * Convenience method to connect to the database
	 * @return connection to database
	 */
	private Connection getConnection(){
		String uri = "jdbc:postgresql://localhost/skistuff";
		Properties props = setLoginForDB("rupert", "secret");
		Connection conn = null;
		try {
			Class.forName("org.postgresql.Driver");		// load PostgreSQL driver
			conn = DriverManager.getConnection(uri, props);
		}
		catch(ClassNotFoundException e){}
		catch(SQLException e) {}

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