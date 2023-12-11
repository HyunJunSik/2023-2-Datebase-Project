<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>주문 확인 페이지</title>
</head>
<body>
<script type="text/javascript">
    function checkOrder() {
        // 선택된 주문과 운송수단을 가져옵니다.
        var selectedOrder = document.querySelector('input[name="selectedOrder"]:checked');
        var selectedVehicle = document.querySelector('input[name="selectedVehicle"]:checked');

        if (!selectedOrder) {
            alert("주문을 선택해주세요.");
            return false;
        }
        
        if (!selectedVehicle) {
            alert("운송수단을 선택해주세요.");
            return false;
        }

        // 배터리 용량과 최대 적재량을 가져옵니다.
        var batteryCapacity = parseInt(selectedVehicle.parentElement.nextElementSibling.nextElementSibling.nextElementSibling.innerText);
        var capacity = parseInt(selectedVehicle.parentElement.nextElementSibling.nextElementSibling.innerText);

        // 만약 배터리 용량이 30% 미만이거나 capacity보다 많은 량을 주문했을 경우 알림을 띄웁니다.
        if (batteryCapacity < capacity * 0.3) {
            alert("배터리 용량이 부족합니다. 주문을 받을 수 없습니다.");
            return false; // 주문을 처리하지 않음
        }

        // 다른 예외 체크 로직을 추가할 수 있습니다.

        // 주문이 정상적으로 처리될 경우 true를 반환합니다.
        return true;
    }
</script>
<%
	int factory_id = (int)session.getAttribute("loggedInUser");
	String local_id = (String)session.getAttribute("local_id");
	Connection conn = null;
	PreparedStatement stmt = null;

	Class.forName("org.mariadb.jdbc.Driver");

	String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
	String dbUser = "root";
	String dbPass = "0000";

	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	
	PreparedStatement orderStmt = conn.prepareStatement("SELECT * FROM `order` WHERE factory_id = ?");
	orderStmt.setInt(1, factory_id);
	ResultSet orderRs = orderStmt.executeQuery();
	
	PreparedStatement vehicleStmt = conn.prepareStatement("SELECT * FROM transportation_vehicle WHERE local_id=?");
	vehicleStmt.setString(1, local_id);
	ResultSet vehicleRs = vehicleStmt.executeQuery();
	

%>
	<form action="order_confirmation_process.jsp" method="post" onsubmit="return checkOrder();">
  <table border="1" id="orderTable">
    <tr>
      <th>Select</th>
      <th>주문 ID</th>
      <th>총 금액(원)</th>
      <th>주문일자</th>
      <th>상품명</th>
    </tr>
    <%
      while (orderRs.next()) {
        int order_id = orderRs.getInt("order_id");
        int total_price = orderRs.getInt("total_price");
        java.sql.Timestamp order_date = orderRs.getTimestamp("order_date");
        int product_id = orderRs.getInt("product_id");
        String productName = "";

        // 상품 정보 조회
        String productSql = "SELECT * FROM product WHERE product_id=?";
        PreparedStatement productStmt = conn.prepareStatement(productSql);
        productStmt.setInt(1, product_id);
        ResultSet productRs = productStmt.executeQuery();
        
        if (productRs.next()) {
          productName = productRs.getString("product_name");
          session.setAttribute("productName", productName);
        }
    %>
    <tr>
      <td><input type="radio" name="selectedOrder" value="<%=order_id %>"></td>
      <td><%= order_id %></td>
      <td><%= total_price %></td>
      <td><%= order_date %></td>
      <td><%= productName %></td>
    </tr>
    <%
        productRs.close();
        productStmt.close();
      }
      orderRs.close();
      orderStmt.close();
    %>
    <tr>
    <td colspan="5">&nbsp;</td> <!-- 5개의 열에 걸쳐서 공백을 추가 -->
	</tr>
    <tr>
      <th>Select</th>
      <th>초전도체 운송수단</th>
      <th>상태</th>
      <th>최대 적재량</th>
      <th>배터리 용량</th>
    </tr>
    <%
    	while(vehicleRs.next()){
 	   	int vehicle_id = vehicleRs.getInt("vehicle_id");
 	   	String status = vehicleRs.getString("status");
 	   	int capacity = vehicleRs.getInt("capacity");
 	   	int battery = vehicleRs.getInt("battery");
 	%>
 	<tr>
 		<td><input type="radio" name="selectedVehicle" value="<%=vehicle_id %>"></td>
 		<td><%=vehicle_id %></td>
 		<td><%=status %></td>
 		<td><%=capacity %></td>
 		<td><%=battery %></td>
 	</tr>
 	<% 
 		} 
		vehicleRs.close();
		vehicleStmt.close();
 	%>
 	</table>

  <input type="submit" value="주문">
</form>


</body>
</html>