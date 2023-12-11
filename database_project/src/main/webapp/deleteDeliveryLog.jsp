<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
// 필요한 JDBC 연결 정보 설정
String jdbcDriver = "jdbc:mariadb://localhost:3306/project";
String dbUser = "root";
String dbPass = "0000";

Connection conn = null;
PreparedStatement stmt = null;

try {
    // JDBC 드라이버 로딩
    Class.forName("org.mariadb.jdbc.Driver");

    // 데이터베이스 연결
    conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);

    // 파라미터로 전달된 delivery_id 가져오기
    int deliveryId = Integer.parseInt(request.getParameter("deliveryId"));

    // 배송 로그 삭제 쿼리 실행
    String deleteSql = "DELETE FROM delivery_log WHERE delivery_id=?";
    stmt = conn.prepareStatement(deleteSql);
    stmt.setInt(1, deliveryId);
    int rowsAffected = stmt.executeUpdate();

    // 삭제가 성공적으로 수행되었는지 확인
    if (rowsAffected > 0) {
        // 삭제 성공 시 응답 메시지 출력
        out.println("배송 로그 삭제가 완료되었습니다.");
    } else {
        // 삭제 실패 시 응답 메시지 출력
        out.println("배송 로그 삭제에 실패했습니다.");
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    // 리소스 해제
    if (stmt != null) {
        try {
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (conn != null) {
        try {
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
%>
