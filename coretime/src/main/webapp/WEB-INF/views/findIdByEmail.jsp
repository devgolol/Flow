<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%-- <meta name="_csrf_token" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" /> --%>
<title>아이디 찾기</title>
</head>
<body>
        <h2>아이디 찾기</h2>

        <form action= "/login/findIdByEmail" method= "post">
                <label for= "email">이메일을 입력하세요</label>
                <input id= "email" name= "email" type= "email"></input>
                <button type= "submit">확인</button>
        </form>

         <%-- 여기부터 수정된 부분입니다. --%>
        <div id="foundIdResult">
            <c:if test="${not empty foundId}">
                <h3>찾은 아이디:</h3>
                <ul>
                    <c:forEach var="id" items="${foundId}">
                        <li>${id}</li>
                    </c:forEach>
                </ul>
            </c:if>
            <c:if test="${empty foundId && param.email != null}">
                <p>해당 이메일로 등록된 아이디가 없습니다.</p>
            </c:if>
        </div>

</body>
</html>