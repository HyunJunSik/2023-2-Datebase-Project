<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>재고 현황</title>
</head>
<body>
    <%    
    Class.forName("org.mariadb.jdbc.Driver");

    String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
    String dbUser = "root";
    String dbPass = "0000";

    Connection conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);

    int factory_id = (int) session.getAttribute("loggedInUser");
	String product_name = "";
    // factory_stock 테이블에서 factory_id로 SELECT
    String stockSql = "SELECT * FROM factory_stock WHERE factory_id=?";
    PreparedStatement stockStmt = conn.prepareStatement(stockSql);
    stockStmt.setInt(1, factory_id);
    ResultSet stockRs = stockStmt.executeQuery();
    %>

    <h1>재고 현황</h1>
    <table border="1">
        <tr>
            <th>Product ID</th>
            <th>Stocks</th>
        </tr>
        <%
        while (stockRs.next()) {
            int product_id = stockRs.getInt("product_id");
            String productSql = "SELECT * FROM product WHERE product_id=?";
            PreparedStatement productStmt = conn.prepareStatement(productSql);
            productStmt.setInt(1, product_id);
            ResultSet productRs = productStmt.executeQuery();
            if(productRs.next()){
            	product_name = productRs.getString("product_name");
            }
            int stocks = stockRs.getInt("stocks");
        %>
        <tr>
            <td><%= product_name %></td>
            <td><%= stocks %></td>
        </tr>
        <%
        }
        stockRs.close();
        stockStmt.close();
        conn.close();
        %>
    </table>
    <a href="http://localhost:8080/database_project/main.jsp">메인 페이지로 돌아가기</a>
</body>
</html>
