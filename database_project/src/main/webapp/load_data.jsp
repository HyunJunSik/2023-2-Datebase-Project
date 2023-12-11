<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>

<%
	Class.forName("org.mariadb.jdbc.Driver");
	
	String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
	String dbUser = "root";
	String dbPass = "0000";

	Connection conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	
	PreparedStatement stmt = conn.prepareStatement("select * from product");
	
	ResultSet rs = stmt.executeQuery();
			
%>
	<table border="1">
		<tr>
			<td>product_id</td>
			<td>price</td>
			<td>product_type</td>
		</tr>
<%
	while(rs.next()){
%>
		<tr>
			<td><%=rs.getString("product_id") %></td>
			<td><%=rs.getString("price") %></td>
			<td><%=rs.getString("product_type") %></td>
		</tr>
<%
	}
%>
	</table>
</body>
</html>