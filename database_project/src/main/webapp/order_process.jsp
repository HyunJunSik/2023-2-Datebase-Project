<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>주문처리</title>
</head>
<body>

<%


	int distance = (int) session.getAttribute("distance");
	int selected_factory = Integer.parseInt(request.getParameter("selectedFactory"));
	int quantity = Integer.parseInt(request.getParameter("quantity"));
	String local_id = (String) session.getAttribute("local_id");
	int delivery_destination_id = (int) session.getAttribute("loggedInUser");
	Connection conn = null;
	PreparedStatement stmt = null;
	
    Class.forName("org.mariadb.jdbc.Driver");
    
    String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
    String dbUser = "root";
    String dbPass = "0000";
    
    conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
    
    String factorySql = "SELECT * FROM factory WHERE factory_id=?";
    PreparedStatement factoryStmt = conn.prepareStatement(factorySql);
    factoryStmt.setInt(1, selected_factory);
    ResultSet factoryRs = factoryStmt.executeQuery();
    
    if (factoryRs.next()){
    	
    	int product_id = factoryRs.getInt("maufact_product_id");
    	String address = factoryRs.getString("address");
    	
    	String productSql = "SELECT * FROM product WHERE product_id=?";
    	PreparedStatement productStmt = conn.prepareStatement(productSql);
    	productStmt.setInt(1, product_id);
    	ResultSet productRs = productStmt.executeQuery();
    	int productPrice = 0;
    	
    	if(productRs.next()){
    		productPrice = productRs.getInt("price");
    	}
    	
    	int totalPrice = productPrice * quantity;
    	
    	int order_id = (int)(Math.random() * 1000000);
    	java.util.Date currentDate = new java.util.Date();
    	java.sql.Timestamp order_date = new java.sql.Timestamp(currentDate.getTime());
    	
    	String feedback = "";
    	
        stmt = conn.prepareStatement("INSERT INTO `order` (order_id, delivery_destination_id, total_price, order_date, delivery_time, product_id, feedback, factory_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    	stmt.setInt(1, order_id);
    	stmt.setInt(2, delivery_destination_id);
    	stmt.setInt(3, totalPrice);
    	stmt.setTimestamp(4, order_date);
    	stmt.setInt(5, distance);
    	stmt.setInt(6, product_id);
    	stmt.setString(7, feedback);
    	stmt.setInt(8, selected_factory);
    	
    	System.out.println(stmt + "<--stmt");
    	
    	stmt.executeUpdate();
    	
    	out.println("<h1> 주문이 성공적으로 처리되었습니다!</h1>");
    	stmt.close();
    	conn.close();
    	
    }

	
%>
	<a href="http://localhost:8080/database_project/order.jsp">주문 창으로 돌아가기</a>
	<a href="http://localhost:8080/database_project/main.jsp">메인 창으로 돌아가기</a>
</body>
</html>