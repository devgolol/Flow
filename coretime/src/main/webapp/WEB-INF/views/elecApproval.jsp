<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%-- <meta name="_csrf_token" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" /> --%>
<title>전자결재</title>

<style>
	.content{
		display: flex;
		gap: 20px;
	}

    .main{
        width: 100%;
    }

    .section{
        width: 100%;
    }

    .data-table{
        width: 100%;
    }

    /* 모달 기본 스타일 (이 부분이 중요합니다) */
    .modal {
        display: none; /* 초기에는 숨김 */
        position: fixed; /* 뷰포트에 고정 */
        z-index: 1000; /* 다른 요소들 위에 표시 */
        left: 0;
        top: 0;
        width: 100%; /* 전체 너비 */
        height: 100%; /* 전체 높이 */
        overflow: auto; /* 내용이 넘칠 경우 스크롤 허용 */
        background-color: rgba(0,0,0,0.4); /* 반투명 검정색 배경 */
        justify-content: center; /* 자식 요소 (modal-content) 수평 중앙 정렬 */
        align-items: center; /* 자식 요소 (modal-content) 수직 중앙 정렬 */
    }

    .modal-content {
        background-color: #fefefe;
        margin: auto; /* display: flex와 함께 사용하면 중앙 정렬에 도움 */
        padding: 20px;
        border: 1px solid #888;
        width: 80%; /* 모달 내용의 너비 */
        max-width: 700px; /* 최대 너비 */
        box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);
        border-radius: 8px;
    }

    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #eee;
        padding-bottom: 10px;
        margin-bottom: 15px;
    }

    .modal-close-button {
        color: #aaa;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
    }

    .modal-close-button:hover{
        color: black;
        text-decoration: none;
        cursor: pointer;
    }

    .form-select-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }

    .form-section {
        border: 1px solid #eee;
        padding: 15px;
        border-radius: 5px;
    }

    .form-section__title {
        margin-top: 0;
        color: #333;
    }

    .form-section__checkbox-group {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .form-checkbox-item {
        display: flex;
        align-items: center;
        gap: 5px;
        cursor: pointer;
    }

    .form-checkbox-item input[type="radio"] {
        margin-right: 5px;
    }

    .form-detail-info p {
        margin: 5px 0;
        font-size: 0.9em;
    }

    .form-detail-info strong {
        color: #555;
    }

    .modal-footer {
        border-top: 1px solid #eee;
        padding-top: 15px;
        margin-top: 20px;
        display: flex;
        justify-content: flex-end;
        gap: 10px;
    }

    .modal-footer__button--confirm,
    .modal-footer__button--cancel {
        padding: 8px 15px;
        border-radius: 5px;
        cursor: pointer;
    }

    .modal-footer__button--confirm {
        background-color: #007bff;
        color: white;
        border: none;
    }

    .modal-footer__button--cancel {
        background-color: #6c757d;
        color: white;
        border: none;
    }
</style>


</head>
<body>
    <div class="header">
        <%@ include file="header.jsp"%>
    </div>
    <div class="content">
        <div id="nav">
            <%@ include file="leftNav.jsp"%>
        </div>
        <div class="main">
            <h1>전자결재 시스템</h1>

            <div class="action-buttons">
                <button onclick="openFormSelectionModal()">새 결재 진행</button>
            </div>

            <h2>나의 결재 대기 문서</h2>
            <div class="pending-approvals">
                <c:if test="${empty pendingApprovals}">
                    <p class="no-data">현재 결재 대기 중인 문서가 없습니다.</p>
                </c:if>
                <c:if test="${not empty pendingApprovals}">
                    <table id= "pendingApprovalsTable">
                        <thead>
                            <tr>
                                <th>문서 ID</th>
                                <th>제목</th>
                                <th>결재양식</th>
                                <th>기안자</th>
                                <th>소속</th>
                                <th>기안일</th>
                                <th>상태</th>
                                <th>액션</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="doc" items="${pendingApprovals}">
                                <tr>
                                    <td>${doc.docId}</td>
                                    <td><a href= "elecApproval/detail/${doc.getDocId()}">${doc.title}</a></td>
                                    <td>${doc.docType}</td>
                                    <td>${doc.initiatorName}</td>
                                    <td>${doc.initiatorDepartment}</td>
                                    <td><fmt:formatDate value="${doc.draftDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td><span class="status-badge status-${doc.status}">${doc.status}</span></td>
                                    <td><button onclick="quickApprove(${doc.getDocId()})">바로결재</button></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>


            <div class= "section">
                <h2>내가 기안한 진행 중 문서</h2>
                <div class="my-in-progress-documents">
                    <c:if test="${empty myInProgressDocs}">
                        <p class="no-data">현재 진행 중인 기안 문서가 없습니다.</p>
                    </c:if>
                    <c:if test="${not empty myInProgressDocs}">
                        <table id= "inProgressDocsTable" class= "data-table">
                            <thead>
                                <tr class="data-table__row">
                                        <th class="data-table__header-cell">문서 아이디</th>
                                        <th class="data-table__header-cell">기안일</th>	
                                        <th class="data-table__header-cell">결재양식</th>
                                        <th class="data-table__header-cell">제목</th>
                                        <th class="data-table__header-cell">상태</th>   
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="doc" items="${myInProgressDocs}">
                                    <tr>
                                        <td>${doc.docId}</td>
                                        <td><fmt:formatDate value="${doc.draftDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td>${doc.docType}</td>
                                        <td><a href= "elecApproval/detail/${doc.getDocId()}">${doc.title}</a></td>
                                        <td><span class="status-badge status-${doc.status}">${doc.status}</span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                </div>
            </div>

            <c:if test="${isAdmin}">
                <div class="admin-section">
                    <h2>관리자 메뉴</h2>
                    <div class="admin-buttons action-buttons">
                        <button onclick="location.href='/admin/users'">사용자 관리</button>
                        <button onclick="location.href='/admin/forms'">결재 양식 관리</button>
                        <%-- 필요에 따라 다른 관리자 기능 추가 --%>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
    <%@ include file="/WEB-INF/modals/formSelectionModal.jsp"%>
    <script type="text/javascript" src="/js/elecApprovalModal.js"></script>
    <script>
        function quickApprove(docId){
            if(!confirm("바로 승인하시겠습니까?")){
                return;
            }
            console.log("docId: ", docId);
            fetch("elecApproval/approval/"+docId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    // 'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf_token"]').content
                },
                body: JSON.stringify({
                    action: 'APPROVED',
                    comment: '바로 승인'
                })
            })
            .then(response => {
                if (!response.ok) {
                    // 서버에서 4xx, 5xx 에러 응답 시
                    return response.json().then(error => { throw new Error(error.message || '요청 처리 중 오류가 발생했습니다.'); });
                }
                return response.json(); // 성공 응답을 JSON으로 파싱
            })
            .then(data => {
                alert(data.message); // 서버로부터 받은 메시지 (예: "결재가 승인되었습니다.")
                window.location.reload(); // 페이지 새로고침하여 목록 업데이트
                // 또는 window.location.href = '/elecApproval'; // 메인 대시보드로 이동
            })
            .catch(error => {
                console.error('Error:', error);
                alert('승인 처리 중 오류가 발생했습니다: ' + error.message);
            });
        }
    </script>
        
    
</body>
</html>