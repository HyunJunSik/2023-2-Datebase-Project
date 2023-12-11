<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f0f0f0;
        margin: 0;
        padding: 0;
    }

    h1 {
        text-align: center;
        background-color: #007bff;
        color: #fff;
        padding: 10px;
    }

    div {
        float: right;
        background-color: #fff;
        margin: 20px;
        padding: 10px;
        border-radius: 5px;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    }

    div p {
        margin: 0;
    }

    a {
        text-decoration: none;
        color: #007bff;
    }

    ul {
        list-style: none;
        padding: 0;
    }

    ul li {
        margin-bottom: 10px;
    }

    ul li a {
        text-decoration: none;
        color: #007bff;
    }

    ul li a:hover {
        text-decoration: underline;
    }
</style>

<title>메인 페이지</title>
</head>
<body>
    <div style="float: right;">
    	<% String locationName = (String) session.getAttribute("locationName"); %>
    	<p><strong>사용자 이름:</strong> <%=locationName %></p>
        <p><a href="logout.jsp">로그아웃</a></p>
    </div>
    <h1>메인 페이지</h1>
    <ul>
    	<% String userRole = (String) session.getAttribute("userRole"); %>
        <% if("delivery_destination".equals(userRole)) {%>
            <li><a href="http://localhost:8080/database_project/order.jsp">주문 페이지</a></li>
            <li><a href="http://localhost:8080/database_project/delivery_log.jsp">배송 로그</a></li>
        <%}%>
        
        <% if("factory".equals(userRole)) {%>
            <li><a href="http://localhost:8080/database_project/order_confirmation.jsp">주문 확인</a></li>
            <li><a href="http://localhost:8080/database_project/inventory.jsp">재고 확인</a></li>
        <%}%>
    </ul>
</body>
</html>
