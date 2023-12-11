<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
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
        max-width: 400px;
        margin: 0 auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 5px;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    }

    label, input {
        display: block;
        margin-bottom: 10px;
    }

    input[type="text"], input[type="password"] {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    input[type="radio"] {
        margin-right: 5px;
    }

    input[type="submit"] {
        width: 100%;
        padding: 10px;
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    input[type="submit"]:hover {
        background-color: #0056b3;
    }

    a {
        display: block;
        text-align: center;
        margin-top: 10px;
        color: #007bff;
        text-decoration: none;
    }
</style>

<script>
    function toggleLoginType() {
        var radioValue = document.querySelector('input[name="who"]:checked').value;
        var usernameField = document.querySelector('input[name="username"]');
        if (radioValue === "factory") {
            // 공장장 로그인 선택 시, 비밀번호 필드를 숨기고 아이디만 표시
            usernameField.placeholder = "공장장 아이디";
        } else {
            // 납품처 로그인 선택 시, 비밀번호 필드를 보이게 하고 아이디 표시
            usernameField.placeholder = "납품처 아이디";
        }
    }
</script>
</head>
<body>
    <h1>로그인</h1>
    <form action="loginProcess.jsp" method="post">
        사용자 아이디 : <input type="text" name="username" placeholder="납품처 아이디"><br>
        비밀번호 : <input type="password" name="password"><br>
        <input type="radio" name="who" value="delivery_destination" onclick="toggleLoginType()" checked>납품처
        <input type="radio" name="who" value="factory" onclick="toggleLoginType()">공장장
        <input type="submit" value="로그인">
    </form>
    <a href="http://localhost:8080/database_project/register.jsp">회원가입</a>
</body>
</html>
