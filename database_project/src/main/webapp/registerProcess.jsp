<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"  %>
<%@ page import="java.sql.Connection"  %>
<%@ page import="java.sql.PreparedStatement"  %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 결과</title>
</head>
<body>
<h1>회원가입 완료</h1>
	<%
		int user_id = Integer.parseInt(request.getParameter("user_id"));
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String area = request.getParameter("area");
		int distance = Integer.parseInt(request.getParameter("distance"));
		String address = request.getParameter("address");
		PreparedStatement stmt = null;
		Connection conn = null;
		Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("DB 사용 가능");
		
		String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
		String dbUser = "root";
		String dbPass = "0000";
		
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		stmt = conn.prepareStatement("INSERT INTO delivery_destination(delivery_destination_id, local_id, location_name, address, distance, password) VALUES(?, ?, ?, ?, ?, ?)");
		stmt.setInt(1, user_id);
		stmt.setString(2, area);
		stmt.setString(3, username);
		stmt.setString(4, address);
		stmt.setInt(5, distance);
		stmt.setString(6, password);
		stmt.executeUpdate();
		try{
			
			
		} catch (Exception e){
			e.printStackTrace();
			out.println("오류발생");
		}finally{
			if(stmt != null){
				stmt.close();
			}
			if(conn != null){
				conn.close();
			}
		}
				
	%>
	<a href="http://localhost:8080/database_project/login.jsp">로그인 창으로 돌아가기</a>
</body>
</html>