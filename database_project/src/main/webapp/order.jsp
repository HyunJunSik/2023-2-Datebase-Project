<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 페이지</title>
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

    form {
        margin: 20px;
    }

    table {
        border-collapse: collapse;
        width: 100%;
    }

    th, td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }

    tr:nth-child(even) {
        background-color: #f2f2f2;
    }

    th {
        background-color: #007bff;
        color: white;
    }

    input[type="radio"] {
        margin-right: 5px;
    }

    input[type="text"], input[type="submit"] {
        padding: 5px;
        margin: 5px;
    }
</style>
</head>
<body>
<h1>주문 페이지</h1>
<%
    Class.forName("org.mariadb.jdbc.Driver");
    
    String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
    String dbUser = "root";
    String dbPass = "0000";

    Connection conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
    
    String local_id = (String) session.getAttribute("local_id"); 
    
    String sql = "SELECT * FROM factory WHERE local_id=?";
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, local_id);
    ResultSet rs = stmt.executeQuery();
    
%>
    <form action="order_process.jsp" method="post">
        <table border="1" id="factoryTable">
            <tr>
                <th>Select</th>
                <th>Factory ID</th>
                <th>Factory Name</th>
                <th>Product Name</th>
            </tr>
        <%
            while (rs.next()){
                int factory_id = rs.getInt("factory_id");
                String address = rs.getString("address");

                // 팩토리별로 주문 품목 정보 조회
                int product_id = rs.getInt("maufact_product_id");
                String productSql = "SELECT * FROM product WHERE product_id=?";
                PreparedStatement productStmt = conn.prepareStatement(productSql);
                productStmt.setInt(1, product_id);
                ResultSet productRs = productStmt.executeQuery();
                String productName = "";
                if (productRs.next()) {
                    productName = productRs.getString("product_name");
                }
        %>
                <tr>
                    <td><input type="radio" name="selectedFactory" value="<%= factory_id %>"></td>
                    <td><%= factory_id %></td>
                    <td><%= address %></td>
                    <td><%= productName %></td>
                </tr>
        <%
                productRs.close();
                productStmt.close();
            }
            rs.close();
            stmt.close();
        %>
        </table>
        <input type="text" id="quantity" name="quantity" placeholder="주문 수량">
        <input type="submit" value="주문">
    </form>
    <a href="http://localhost:8080/database_project/main.jsp">메인 페이지로 돌아가기</a>
</body>
</html>
