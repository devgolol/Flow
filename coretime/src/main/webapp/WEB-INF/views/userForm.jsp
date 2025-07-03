<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	document.addEventListener('DOMContentLoaded', function() {
		 // 이름 (name) 필드
        const nameInput = document.getElementById('name');
        const nameError = document.getElementById('nameError');
        if (nameInput && nameError) {
            nameInput.addEventListener('input', function() {
                if (nameError.style.display !== 'none') {
                    nameError.style.display = 'none';
                }
            });
        }

        // 아이디 (id) 필드
        const idInput = document.getElementById('id');
        const idError = document.getElementById('idError');
        if (idInput && idError) {
            idInput.addEventListener('input', function() {
                if (idError.style.display !== 'none') {
                    idError.style.display = 'none';
                }
            });
        }

        // 비밀번호 (password) 필드
        const passwordInput = document.getElementById('password');
        const passwordError = document.getElementById('passwordError');
        if (passwordInput && passwordError) {
            passwordInput.addEventListener('input', function() {
                if (passwordError.style.display !== 'none') {
                    passwordError.style.display = 'none';
                }
            });
        }

        // 비밀번호 확인 (confirmPassword) 필드
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const confirmPasswordError = document.getElementById('confirmPasswordError');
        if (confirmPasswordInput && confirmPasswordError) {
            confirmPasswordInput.addEventListener('input', function() {
                if (confirmPasswordError.style.display !== 'none') {
                    confirmPasswordError.style.display = 'none';
                }
            });
        }

        // 이메일 (email) 필드
        const emailInput = document.getElementById('email');
        const emailError = document.getElementById('emailError');
        if (emailInput && emailError) {
            emailInput.addEventListener('input', function() {
                if (emailError.style.display !== 'none') {
                    emailError.style.display = 'none';
                }
            });
        }

        // 전화번호 (tel) 필드
        const telInput = document.getElementById('tel');
        const telError = document.getElementById('telError');
        if (telInput && telError) {
            telInput.addEventListener('input', function() {
                if (telError.style.display !== 'none') {
                    telError.style.display = 'none';
                }
            });
        }

        // 직위 (rank) 필드 - select는 'change' 이벤트를 사용
        const rankSelect = document.getElementById('rankSelect');
        const rankError = document.getElementById('rankError');
        if (rankSelect && rankError) {
            rankSelect.addEventListener('change', function() {
                if (rankError.style.display !== 'none') {
                    rankError.style.display = 'none';
                }
            });
        }

        // 부서 (department) 필드 - select는 'change' 이벤트를 사용
        const departmentSelect = document.getElementById('departmentSelect');
        const departmentError = document.getElementById('departmentError');
        if (departmentSelect && departmentError) {
            departmentSelect.addEventListener('change', function() {
                if (departmentError.style.display !== 'none') {
                    departmentError.style.display = 'none';
                }
            });
        }

        // 생년월일 (birth) 필드
        const birthInput = document.getElementById('birth');
        const birthError = document.getElementById('birthError');
        if (birthInput && birthError) {
            birthInput.addEventListener('input', function() {
                if (birthError.style.display !== 'none') {
                    birthError.style.display = 'none';
                }
            });
        }
	});
	function validateForm(event) {
		const nameInput = document.getElementById("name");
		if (nameInput.value.trim() === "") {
			nameInput.focus();
		}

		const idInput = document.getElementById("id");
		if (idInput.value.trim() === "") {
			idInput.focus();
		}

		const passwordInput = document.getElementById("password");
		if (passwordInput.value.trim() === "") {
			passwordInput.focus();
		}

		// 비밀번호 확인
		const confirmPasswordInput = document.getElementById("confirmPassword");
		if (confirmPasswordInput.value.trim() === "") {
			confirmPasswordInput.focus();

		} else if (passwordInput.value !== confirmPasswordInput.value) {
			confirmPasswordInput.focus();
		}

		// 이메일
		const emailInput = document.getElementById("email");
		if (emailInput.value.trim() === "") {
			emailInput.focus();
		} else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailInput.value)) { // 간단한 이메일 형식 검사
			emailInput.focus();
		}

		// 전화번호
		const telInput = document.getElementById("tel");
		if (telInput.value.trim() === "") {
			telInput.focus();
		} else if (!/^(01[016789])-([0-9]{3,4})-([0-9]{4})$/
				.test(telInput.value)) { // 전화번호 형식 검사
			telInput.focus();
		}

		// 직위
		const rankSelect = document.getElementById("rankSelect");
		if (rankSelect.value === "") {
			rankSelect.focus();
		}

		// 부서
		const departmentSelect = document.getElementById("departmentSelect");
		if (departmentSelect.value === "") {
			departmentSelect.focus();
		}

		// 생년월일 (간단한 필수 여부만)
		const birthInput = document.getElementById("birth");
		if (birthInput.value.trim() === "") {
			birthInput.focus();
		}
	}
</script>
</head>
<body>
<body>
	<h2>신규 유저 생성</h2>
	<%-- <form:form modelAttribute="user" method="post" action="/users/insert" onsubmit="return validateForm()">
	<p>이름 (한글): <form:input path="name" id="name" value= "박지훈"/></p>
    <p>아이디: <form:input path="id" id="id" value= "flow1"/>
        <span id="idError" style="color: red;">
            ${idErrorMessage}
        </span>
        <form:errors path="id" cssStyle="color: red;"/>
    </p>
    <p>비밀번호: <form:password path="password" value= "1234"/></p>
    <p>비밀번호 확인: <form:password path="confirmPassword" value= "1234"/></p>
    <p>이메일: <form:input path="email" value= "jack981109@naver.com"/></p>
    <p>전화번호: <form:input path="tel" value= "010-6230-1825"/></p>
    <p>직위: 
        <form:select path="rank" id="rankSelect" onchange="clearRankError()">
            <form:option value="">선택</form:option>
            <form:option value="사원">사원</form:option>
            <form:option value="대리">대리</form:option>
            <form:option value="과장">과장</form:option>
            <form:option value="차장">차장</form:option>
            <form:option value="부장">부장</form:option>
        </form:select>
        <span id="rankError" style="color: red; display: none;">직위를 선택해주세요.</span>
        <form:errors path="rank" cssStyle="color: red;"/>
    </p>
    <p>부서: <form:input path="department" value= "개발"/></p>
    <p>생년월일: <form:input path="birth" value= "2025-06-30"/></p>

    <p>
        <button type="submit">저장</button>
        <button type="submit" formaction="/users/saveAndContinue">저장 후 계속 생성</button>
    </p>
</form:form> --%>
	<form:form modelAttribute="user" method="post" action="/users/insert"
		onsubmit="return validateForm(event)">
		<p>
			이름 (한글):
			<form:input path="name" id="name" />
			<form:errors path="name" cssStyle="color: red;" id="nameError" />
		</p>

		<p>
			아이디:
			<form:input path="id" id="id" />
			<form:errors path="id" cssStyle="color: red;" id="idError" />
		</p>
		<p>
			비밀번호:
			<form:password path="password" id="password" />
			<form:errors path="password" cssStyle="color: red;" id="passwordError" />
		</p>
		<p>
			비밀번호 확인:
			<form:password path="confirmPassword" id="confirmPassword" />
			<form:errors path="confirmPassword" cssStyle="color: red;" id="confirmPasswordError" />
		</p>
		<p>
			이메일:
			<form:input path="email" id="email" />
			<form:errors path="email" cssStyle="color: red;" id="emailError" />
		</p>
		<p>
			전화번호:
			<form:input path="tel" id="tel" />
			<form:errors path="tel" cssStyle="color: red;" id="telError" />
		</p>
		<p>
			직위:
			<form:select path="rank" id="rankSelect">
				<form:option value="">선택</form:option>
				<form:option value="사원">사원</form:option>
				<form:option value="대리">대리</form:option>
				<form:option value="과장">과장</form:option>
				<form:option value="차장">차장</form:option>
				<form:option value="부장">부장</form:option>
			</form:select>
			<form:errors path="rank" cssStyle="color: red;" id="rankError" />
		</p>
		<p>
			부서:
			<form:select path="department" id="departmentSelect">
				<form:option value="">선택</form:option>
				<form:option value="개발팀">개발팀</form:option>
				<form:option value="영업팀">영업팀</form:option>
				<form:option value="마케팅팀">마케팅팀</form:option>
				<form:option value="인사팀">인사팀</form:option>
				<form:option value="회계팀">회계팀</form:option>
			</form:select>
			<form:errors path="department" cssStyle="color: red;" id="departmentError" />
		</p>
		<p>
			생년월일:
			<form:input path="birth" id="birth" type="date" />
			<form:errors path="birth" cssStyle="color: red;" id="birthError" />
		</p>

		<p>
			<button type="submit">저장</button>
		</p>
	</form:form>
</body>
</html>