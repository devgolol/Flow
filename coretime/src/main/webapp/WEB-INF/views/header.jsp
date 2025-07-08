<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
        .header{
		width: 100%;
		height: 80px;
		display: flex;
		align-items: center;
		background-color: #f8f9fa;
		margin-bottom: 20px;
	}

	.header__logout{
		margin-left: auto;
		margin-right: 50px;		
	}
</style>
</head>
<body>
        <header class= "header">
		<form class= "header__logout" action="/logout" method="post">
			<%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> --%>
			<button type="submit">로그아웃</button>
		</form>
	</header>
</body>
</html>