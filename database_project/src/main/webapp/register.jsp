<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
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
            width: 300px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
        }

        input[type="text"],
        input[type="password"],
        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        input[type="submit"] {
            background-color: #333;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #555;
        }

        /* 추가 스타일: 입력란을 감싸는 div */
        .input-container {
            margin-bottom: 10px;
        }
        .bottom-image {
            position: fixed;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            z-index: -1; /* 다른 콘텐츠 위에 표시되도록 설정 */
        }
    </style>
</head>
<body>
    <h1>회원가입</h1>
    <form action="./registerProcess.jsp" method="post">
        <div class="input-container">
            <label for="user_id">납품처 아이디(11개 번호 이내):</label>
            <input type="text" id="user_id" name="user_id">
        </div>
        <!-- 납품처 이름 입력란 -->
        <div class="input-container">
            <label for="username">납품처 이름:</label>
            <input type="text" id="username" name="username">
        </div>

        <!-- 비밀번호 입력란 -->
        <div class="input-container">
            <label for="password">비밀번호:</label>
            <input type="password" id="password" name="password">
        </div>
        
        <div class="input-container">
        	<label for="address">주소</label>
        	<input type="text" id="address" name="address">
        </div>

        <!-- 납품처 위치 선택 -->
        <label for="area">납품처 위치:</label>
        <select id="area" name="area">
            <option value="01">경기도</option>
            <option value="02">강원도</option>
            <option value="03">충청북도</option>
            <option value="04">충청남도</option>
            <option value="05">전라북도</option>
            <option value="06">전라남도</option>
            <option value="07">경상북도</option>
            <option value="08">경상남도</option>
        </select><br>

        <!-- 공장과의 거리 선택 -->
        <label for="distance">공장과의 거리:</label>
        <select id="distance" name="distance">
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
        </select><br>

        <!-- 제출 버튼 -->
        <input type="submit" value="가입">
    </form>
       <img src="./register.png" class="bottom-image">
</body>
</html>
