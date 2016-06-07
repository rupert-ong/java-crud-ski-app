/*
    0. In a normal install of PostgreSQL, PostgreSQL becomes a 'service' that
       starts up when the machine boots. The installer also starts PostgreSQL
       after the installation is completed.

    1. Open the 'psql' interface to PostgreSQL (from GUI or command-line).
       The 'psql' utility is included in the normal installation.

    2. Enter this command at the 'psql' prompt:

           create role rupert superuser login;        ## 'role' is effectively 'user'

    3. Enter this command at the prompt:

           alter role rupert with password 'secret';  ## set the password for rupert

    4. Enter this command at the prompt:

           create database skistuff;                ## create an empty database

    4. \q
*/

import java.sql.DriverManager;     // handles communication with the DB
import java.sql.Connection;        // a connection to the DB
import java.sql.Statement;         // an SQL statement for the DB to execute
import java.sql.ResultSet;         // a table of rows generated from an SQL query
import java.sql.SQLException;      // what's thrown when the JDBC operations fail
import java.util.Properties;       // key/value pairs

/* Compilation and execution from the command-line, with '%' as the command-line prompt:

   % javac BasicJDBC.java   ## core Java only is enough

   % java -cp .:postgresql-jdbc.jar BasicJDBC  ## the JAR contains the PostgreSQL 'driver'

   ## On Windows: % java -cp .;postgresql-jdbc.jar BasicJDBC
 */

public class BasicJDBC {
    /* Each string represents an inventory item, formatted as follows into three fields:
       
       product_name ! product_category ! price

       For example, in the first string the product name  is 'Scott Synergy',
       the product category is 'Telemark boot', and the price is '499.95'.
    */  
    private static String[ ] data = {
	"Scott Synergy!Telemark boot!499.95",
	"Black Diamond Factor 110!Telemark boot!244.65",
	"Scarpa Gia!Telemark boot!479.89",
	"Scarpa TRace!Telemark boot!579.59",
	"Salamon XPro 120!Alpine boot!360.99",
	"Lange RX 100!Alpine boot!455.99",
	"Rossignol X6 Combi!Cross country boot!149.95",
	"Scarpa T4 Backcountry!Cross country boot!224.59",
	"Fischer RC3 Skate!Cross country boot!145.55",
	"Dynafit 7 Summits!Telemark skis!546.77",
	"DPS SKIS Nina!Telemark skis!677.88",
	"LaSportiva 99E!Alpine touring skis!689.49",
	"Black Diamond Verdict!Alpine touring skis!499.99",
	"K2 Iconic!Alpine skis!699.49",
	"Volkl RTM 81!Alpine skis!726.99",
	"Atomic Theory!Alpine skis!598.95",
	"Fischer CRS Classic Vasa!Cross country skis!189.95",
	"Salomon Snowscape Classic!Cross country skis!228.95",
	"Fischer CRS Skate!Cross country skis!194.59",
	"Atomic Redstar Skate!Cross country skis!321.99"
    };

    public static void main(String[ ] args)  {
	new BasicJDBC().setUp();
    }

    private Properties setLoginForDB() {
	Properties props = new Properties();
	props.setProperty("user", "rupert");
	props.setProperty("password", "secret");
	return props;
    }

    private boolean tableExistsAlready(Connection conn, String name) {
	boolean flag = false;
	try {
	    Statement stmt = conn.createStatement();
	    String sql = "select count(*) as total from " + name + ";";
	    ResultSet rs = stmt.executeQuery(sql);
	    rs.next();
	    if (rs.getInt("total") > 0)
		flag = true;
	}
	catch(SQLException e) { e.printStackTrace(); }
	return flag;
    }

    /*
      Under JDBC, a URI (Uniform Resource Identifier) names a database. For a PostgreSQL DB, the URI
      has one of these forms:

      jdbc:postgresql:database
      jdbc:postgresql://host/database
      jdbc:postgresql://host:port/database
      
      where 'host', 'port', and 'database' name the machine that hosts the DB system, the port number
      at which the DB handles requests, and the database in question.
    */
    private void setUp() {
	String uri = "jdbc:postgresql://localhost/skistuff";  //*** skistuff is the database's name
	Properties props = setLoginForDB();

	try {
	    Class.forName("org.postgresql.Driver"); //*** load the PostreSQL driver
	    Connection conn = DriverManager.getConnection(uri, props);

	    // Check whether SkiStuff table exists already.
	    if (tableExistsAlready(conn, "skisEtc")) {
		// do nothing
	    }
	    else { 
		// otherwise, create the table and insert data
		Statement stmt = conn.createStatement();
		createDB(stmt);
	    
		conn.setAutoCommit(false); // We'll explicitly commit all of the rows after the insertions.
		insertRows(stmt);
		conn.commit();
		stmt.close();
	    }
	    conn.close(); // in either case, close the connection
	}
	catch(SQLException e) { e.printStackTrace(); }
	catch(ClassNotFoundException e) { e.printStackTrace(); } //*** Class.forName(...)

	testCreationInsertion(uri, props);
    }
    
    private void createDB(Statement stmt) {
	try {
	    String sql = "CREATE TABLE skisEtc " +
		"(id        SERIAL PRIMARY KEY NOT NULL," + // auto-generated integer key
		" product   VARCHAR(50)        NOT NULL," + // variable-length text, 50 chars at most
        " category  VARCHAR(50)        NOT NULL," + // ditto
		" price     REAL)";                         // floating-point
	    stmt.executeUpdate(sql);
	}
	catch(SQLException e) { e.printStackTrace(); }
    }
    
    private void insertRows(Statement stmt) {
	try {
	    for (String str : data) {
		String[ ] columns = str.split("!"); // get the 3 pieces
		String sql = "INSERT INTO skisEtc (product, category, price) " +
		    "VALUES ('" + columns[0] +"', '" + columns[1] + "', " + columns[2] + ");";
		stmt.executeUpdate(sql);
	    }
	}
	catch(SQLException e) { e.printStackTrace(); }
    }

    private void testCreationInsertion(String uri, Properties props) {
	try {
	    Connection conn = DriverManager.getConnection(uri, props);
	    Statement stmt = conn.createStatement();

	    ResultSet rs = stmt.executeQuery("SELECT * FROM skisEtc;");
	    while (rs.next()) {
		int id = rs.getInt("id");
		String product = rs.getString("product");
		String category = rs.getString("category");
		float price = rs.getFloat("price");
		System.out.format("%d %s %s %.2f\n", id, product, category, price);
	    }
	    rs.close();
	    stmt.close();
	    conn.close();
	}
	catch(SQLException e) { e.printStackTrace(); }
    }
}
