<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배송 로그</title>
</head>
<script>
    function updateDeliveryStatus() {
        // 현재 시간을 JavaScript로 얻기
        var currentDate = new Date();
        var currentTime = currentDate.getTime();

        // 모든 행을 가져와서 반복
        var rows = document.querySelectorAll("table tr");
        for (var i = 1; i < rows.length; i++) { // 첫 번째 행은 헤더이므로 무시합니다.
            var row = rows[i];
            var etaCell = row.cells[5]; // 도착 예정 시간 셀의 인덱스 (0부터 시작)

            // 도착 예정 시간을 문자열로 가져오기
            var etaTimeString = etaCell.innerText;
            var etaTime = new Date(etaTimeString).getTime();

            // 배송 상태 업데이트를 위한 셀 선택
            var statusCell = row.cells[6]; // 배송 상태 셀의 인덱스 (0부터 시작)

            // 현재 시간과 비교하여 배송 상태 업데이트
            if (etaTime <= currentTime) {
                statusCell.innerText = "배송 완료";
                // 배송 완료 상태일 경우, 라디오 버튼 활성화
                row.querySelector('input[type="radio"]').disabled = false;
            } else {
                statusCell.innerText = "배송 중";
            }
        }
    }

    // 페이지 로드 후 주기적으로 배송 상태 업데이트 함수 호출
    window.onload = function() {
        updateDeliveryStatus();
        setInterval(updateDeliveryStatus, 2000); // 2초마다 업데이트 (원하는 간격 설정 가능)
    };

    function confirmDelivery(deliveryId) {
        var confirmDelivery = confirm("배송을 확인하시겠습니까?");
        if (confirmDelivery) {
            // 확인 버튼을 누르면 서버로 해당 배송 로그 삭제 요청을 보냅니다.
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    // 삭제 요청이 성공하면 해당 로우를 테이블에서 삭제합니다.
                    var rowToDelete = document.getElementById("row_" + deliveryId);
                    if (rowToDelete) {
                        rowToDelete.remove();
                    }
                }
            };
            xhr.open("GET", "deleteDeliveryLog.jsp?deliveryId=" + deliveryId, true);
            xhr.send();
        }
    }
</script>
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

    table {
        border-collapse: collapse;
        width: 80%;
        margin: 20px auto; /* 가운데 정렬 */
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
</style>
<body>
<%
try {
    Class.forName("org.mariadb.jdbc.Driver");
    String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
    String dbUser = "root";
    String dbPass = "0000";

    Connection conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);

    int user_id = (int) session.getAttribute("loggedInUser");
    int delivery_id = 0;
    String logSql = "SELECT * FROM delivery_log WHERE delivery_destination_id=?";
    PreparedStatement logStmt = conn.prepareStatement(logSql);
    logStmt.setInt(1, user_id);
    ResultSet logRs = logStmt.executeQuery();

    java.util.Date Date = new java.util.Date();
    java.sql.Timestamp eta = new java.sql.Timestamp(Date.getTime());

    Map<String, String> codeMap = new HashMap<>();
    codeMap.put("01", "경기도");
    codeMap.put("02", "강원도");
    codeMap.put("03", "충청북도");
    codeMap.put("04", "충청남도");
    codeMap.put("05", "전라북도");
    codeMap.put("06", "전라남도");
    codeMap.put("07", "경상북도");
    codeMap.put("08", "경상남도");
%>
<h1>배송 로그</h1>
<%
if (!logRs.next()) {
%>
    <script>
        alert("확인된 배송 로그가 없습니다.");
        window.location.href = "http://localhost:8080/database_project/main.jsp";
    </script>
<%
} else {
    // 배송 로그가 있는 경우 테이블을 생성
%>
<table border="1">
    <tr>
        <th>User ID</th>
        <th>지역</th>
        <th>상품명</th>
        <th>차량 ID</th>
        <th>공장명</th>
        <th>도착 예정 시간</th>
        <th>배송 상태</th>
        <th>확인</th>
    </tr>
    <%
    do {
        delivery_id = logRs.getInt("delivery_id");
        String local_id = logRs.getString("local_id");
        String product_name = logRs.getString("product_name");
        String factory_name = logRs.getString("factory_name");
        int vehicle_id = logRs.getInt("vehicle_id");
        eta = logRs.getTimestamp("delivery_eta");

        // 배송 상태 계산 및 표시 (JavaScript로 실시간 업데이트도 가능)
        String deliveryStatus;
        long currentTimeMillis = System.currentTimeMillis();
        if (eta.getTime() <= currentTimeMillis) {
            deliveryStatus = "배송 완료";
        } else {
            deliveryStatus = "배송 중";
        }
    %>
    <tr>
    	<td><%= user_id %></td>
    	<td><%= codeMap.get(local_id) %></td>
    	<td><%= product_name %></td>
    	<td><%= vehicle_id %></td>
    	<td><%= factory_name %></td>
    	<td><%= eta %></td>
    	<td><%= deliveryStatus %></td>
    	<td><input type="radio" onclick="confirmDelivery(<%= delivery_id %>);"> 확인</td>
	</tr>
    
    <%
    } while (logRs.next());
    logStmt.close();
    conn.close();
    %>
</table>
<%
}
} catch (Exception e) {
    // 예외 처리: 데이터베이스 연결 오류 등
%>
    <h2>오류가 발생했습니다.</h2>
<%
}
%>
</body>
</html>
