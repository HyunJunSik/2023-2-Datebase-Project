<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 실패</title>
</head>
<body>
    <h1>로그인 실패</h1>
    <%-- 실패 메시지를 표시합니다 --%>
    <p><%= request.getAttribute("loginError") %></p>
    
    <%-- 다시 로그인 페이지로 이동하는 링크를 표시합니다 --%>
    <p><a href="login.jsp">다시 로그인</a></p>
</body>
</html>
