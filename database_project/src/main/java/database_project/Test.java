package database_project;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class Test {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Connection conn = null;
		Statement stmt = null;
		ResultSet result = null;
		
		try {
			String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
			String dbUser = "root";
			String dbPass = "0000";
			String query = "SHOW tables;";
			
			// DB Connection 생성
			conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
			stmt = conn.createStatement();
			result = stmt.executeQuery(query);
			
			while(result.next()) {
				System.out.println(result.getString(1));
			}
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				try {
					conn.close();
				}
				catch(SQLException e) {
					e.printStackTrace();
				}
			}
	}

}
