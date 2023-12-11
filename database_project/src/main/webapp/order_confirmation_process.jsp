<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>주문 완료 페이지</title>
</head>
<body>
	<% 

	Class.forName("org.mariadb.jdbc.Driver");

	String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
	String dbUser = "root";
	String dbPass = "0000";
	
	Connection conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	PreparedStatement delivery_stmt = null;
	
	int order_id = Integer.parseInt(request.getParameter("selectedOrder"));
	int delivery_time = 0;
	int delivery_destination_id = 0;
	
	String orderSql = "SELECT * FROM `order` WHERE order_id=?";
	PreparedStatement orderStmt = conn.prepareStatement(orderSql);
	orderStmt.setInt(1, order_id);
	ResultSet orderRs = orderStmt.executeQuery();
	
	if (orderRs.next()){
		delivery_time = orderRs.getInt("delivery_time");
		delivery_destination_id = orderRs.getInt("delivery_destination_id");
	}
	String productName = (String)session.getAttribute("productName");
	int vehicle_id = Integer.parseInt(request.getParameter("selectedVehicle"));
	
	String vehicleSql = "SELECT * FROM transportation_vehicle WHERE vehicle_id=?";
	PreparedStatement vehicleStmt = conn.prepareStatement(vehicleSql);
	vehicleStmt.setInt(1, vehicle_id);
	ResultSet vehicleRs = vehicleStmt.executeQuery();
	
	int capacity = 0;
	
	if (vehicleRs.next()){
		capacity = vehicleRs.getInt("capacity");
		vehicleRs.close();
		vehicleStmt.close();
	}
	
	int factory_id = (int)session.getAttribute("loggedInUser");
	
	String stockSql = "UPDATE factory_stock SET stocks = stocks - ? WHERE factory_id = ?";
	PreparedStatement stockStmt = conn.prepareStatement(stockSql);
	stockStmt.setInt(1, capacity);
	stockStmt.setInt(2, factory_id);
	ResultSet stockRs = stockStmt.executeQuery();
	stockRs.close();
	
	String factoryName = (String)session.getAttribute("locationName");
	String local_id = (String)session.getAttribute("local_id");
	int delivery_id = (int)(Math.random() * 1000000);
	java.util.Date currentDate = new java.util.Date();
	java.sql.Timestamp current = new java.sql.Timestamp(currentDate.getTime());
	
	Calendar calender = Calendar.getInstance();
	calender.setTime(current);
	calender.add(Calendar.MINUTE, delivery_time);
	java.sql.Timestamp delivery_ETA = new java.sql.Timestamp(calender.getTimeInMillis());
	
	delivery_stmt = conn.prepareStatement("INSERT INTO delivery_log (delivery_id, local_id, vehicle_id, vehicle_capacity, product_name, factory_name, delivery_eta, delivery_destination_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
	delivery_stmt.setInt(1, delivery_id);
	delivery_stmt.setString(2, local_id);
	delivery_stmt.setInt(3, vehicle_id);
	delivery_stmt.setInt(4, capacity);
	delivery_stmt.setString(5, productName);
	delivery_stmt.setString(6, factoryName);
	delivery_stmt.setTimestamp(7, delivery_ETA);
	delivery_stmt.setInt(8, delivery_destination_id);

	System.out.println(delivery_stmt + "<--stmt");
	
	delivery_stmt.executeUpdate();
	
	String delete_orderSql = "DELETE FROM `order` WHERE order_id=?";
	PreparedStatement delete_orderStmt = conn.prepareStatement(delete_orderSql);
	delete_orderStmt.setInt(1, order_id);
	int deleteRows = delete_orderStmt.executeUpdate();
	
	int batteryDecreaseAmount = (int)(capacity * 0.05); // 배터리를 5%만큼 감소시킵니다.
	if (batteryDecreaseAmount > 0) {
	    // 배터리 용량을 감소시킵니다.
	    String updateBatterySql = "UPDATE transportation_vehicle SET battery = battery - ? WHERE vehicle_id = ?";
	    PreparedStatement updateBatteryStmt = conn.prepareStatement(updateBatterySql);
	    updateBatteryStmt.setInt(1, batteryDecreaseAmount);
	    updateBatteryStmt.setInt(2, vehicle_id);
	    updateBatteryStmt.executeUpdate();
	    updateBatteryStmt.close();
	}
	
	
	if(deleteRows > 0){
		out.println("<h1> 주문 확인이 처리되었습니다!</h1>");	
	} else{
		out.println("<h1> 주문 삭제 실패하였습니다.</h1>");
	}
	delivery_stmt.close();
	conn.close();
	%>
	<a href="http://localhost:8080/database_project/order_confirmation.jsp">주문 확인으로 돌아가기</a>
	<a href="http://localhost:8080/database_project/main.jsp">메인 창으로 돌아가기</a>
</body>
</html>