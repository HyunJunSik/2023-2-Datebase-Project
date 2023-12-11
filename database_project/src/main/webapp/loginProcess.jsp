<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>로그인 결과</title>
</head>
<body>
<%
	int user_id = Integer.parseInt(request.getParameter("username"));
	String password = request.getParameter("password");
	String who = request.getParameter("who");
	PreparedStatement stmt = null;
	Connection conn = null;
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("DB 사용 가능");
	
	String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
	String dbUser = "root";
	String dbPass = "0000";
	
	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	
	String sql="";
	if("delivery_destination".equals(who)){
		sql = "SELECT * FROM delivery_destination WHERE delivery_destination_id=? AND password=?";
	} else if ("factory".equals(who)){
		sql = "SELECT * FROM factory WHERE factory_id=? AND password=?";
	}
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, user_id);
	stmt.setString(2, password);
	ResultSet rs = stmt.executeQuery();
	String locationName = null;
	String local_id = null;
	
	if (rs.next()){
		session.setAttribute("loggedInUser", user_id);
		session.setAttribute("userRole", who);
		
		if("delivery_destination".equals(who)){
			String deliveryDestinationSql = "SELECT * FROM delivery_destination WHERE delivery_destination_id=?";
			PreparedStatement deliveryStmt = conn.prepareStatement(deliveryDestinationSql);
			deliveryStmt.setInt(1, user_id);
            ResultSet deliveryDestinationRs = deliveryStmt.executeQuery();	
            if(deliveryDestinationRs.next()){
            	locationName = deliveryDestinationRs.getString("location_name");
            	local_id = deliveryDestinationRs.getString("local_id");
            	int distance = deliveryDestinationRs.getInt("distance");
            	session.setAttribute("distance", distance);
            }
		} else if("factory".equals(who)){
			String factorySql = "SELECT * FROM factory WHERE factory_id=?";
			PreparedStatement factoryStmt = conn.prepareStatement(factorySql);
			factoryStmt.setInt(1, user_id);
			ResultSet factoryRs = factoryStmt.executeQuery();
			if(factoryRs.next()){
				locationName = factoryRs.getString("address");
				local_id = factoryRs.getString("local_id");
			}
		}
		session.setAttribute("locationName", locationName);
		session.setAttribute("local_id", local_id);
		response.sendRedirect("main.jsp");
	} else{
        request.setAttribute("loginError", "로그인에 실패하였습니다. 아이디와 비밀번호를 확인하세요.");
        
        // 로그인 실패 페이지로 포워딩
        request.getRequestDispatcher("loginFailed.jsp").forward(request, response);
	}
	stmt.close();
	conn.close();
%>
</body>
</html>