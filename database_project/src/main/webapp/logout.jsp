<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // 현재 세션을 가져옵니다.
    HttpSession current_session = request.getSession(false);

    // 세션을 종료하고 모든 세션 데이터를 삭제합니다.
    if (current_session != null) {
    	current_session.invalidate();
    }

    // 로그아웃 후 로그인 페이지로 리다이렉트합니다.
    response.sendRedirect("login.jsp");
%>
