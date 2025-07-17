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
    /* ----- 기본 및 레이아웃 ----- */
    body {
        font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
        background-color: #f4f7f6;
        color: #333;
        margin: 0;
        font-size: 14px;
    }

    .content {
        display: flex;
        gap: 20px;
    }

    .main {
        width: 100%;
        padding: 20px;
    }

    .main h1 {
        font-size: 24px;
        font-weight: 600;
        color: #1a2a44;
        margin-bottom: 25px;
        border-bottom: 2px solid #e0e0e0;
        padding-bottom: 10px;
    }

    /* ----- 카드(위젯) 디자인 ----- */
    .widget {
        background-color: #ffffff;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 25px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    .widget h2 {
        font-size: 18px;
        color: #1a2a44;
        margin-top: 0;
        margin-bottom: 20px;
    }

    /* ----- 버튼 스타일 ----- */
    .action-buttons {
        margin-bottom: 20px;
    }
    
    .btn {
        padding: 8px 15px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-weight: 500;
        transition: background-color 0.2s, box-shadow 0.2s;
    }

    .btn-primary {
        background-color: #007bff;
        color: white;
    }
    .btn-primary:hover {
        background-color: #0056b3;
        box-shadow: 0 2px 5px rgba(0, 123, 255, 0.3);
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
        font-size: 12px;
        padding: 6px 12px;
    }
    .btn-secondary:hover {
        background-color: #5a6268;
    }

    /* ----- 테이블 스타일 ----- */
    .data-table {
        width: 100%;
        border-collapse: collapse;
        text-align: center;
    }

    .data-table th, .data-table td {
        padding: 12px 10px;
        border-bottom: 1px solid #e9ecef;
    }

    .data-table thead th {
        background-color: #f8f9fa;
        color: #495057;
        font-weight: 600;
        border-top: 1px solid #dee2e6;
        border-bottom-width: 2px;
    }
    
    .data-table tbody tr:hover {
        background-color: #f1f3f5;
    }
    
    .data-table td:nth-child(2) { /* 제목 컬럼 */
        text-align: left;
    }

    .data-table a {
        color: #0056b3;
        text-decoration: none;
        font-weight: 500;
    }
    .data-table a:hover {
        text-decoration: underline;
    }
    
    /* ----- 상태 배지 스타일 ----- */
    .status-badge {
        padding: 4px 10px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
        color: #fff;
        text-transform: uppercase;
    }
    .status-PENDING { background-color: #ffc107; color: #333; }
    .status-IN_PROGRESS { background-color: #17a2b8; }
    .status-APPROVED { background-color: #28a745; }
    .status-REJECTED { background-color: #dc3545; }

    /* 데이터 없을 때 메시지 */
    .no-data {
        text-align: center;
        padding: 40px;
        color: #868e96;
    }

    /* ----- 모달 스타일 (기존 스타일 유지) ----- */
    .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); justify-content: center; align-items: center; }
    .modal-content { background-color: #fefefe; margin: auto; padding: 20px; border: 1px solid #888; width: 80%; max-width: 700px; box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19); border-radius: 8px; }
    .modal-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
    .modal-close-button { color: #aaa; font-size: 28px; font-weight: bold; cursor: pointer; }
    .modal-close-button:hover{ color: black; text-decoration: none; cursor: pointer; }
    .form-select-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    .form-section { border: 1px solid #eee; padding: 15px; border-radius: 5px; }
    .form-section__title { margin-top: 0; color: #333; }
    .form-section__checkbox-group { display: flex; flex-direction: column; gap: 10px; }
    .form-checkbox-item { display: flex; align-items: center; gap: 5px; cursor: pointer; }
    .form-checkbox-item input[type="radio"] { margin-right: 5px; }
    .form-detail-info p { margin: 5px 0; font-size: 0.9em; }
    .form-detail-info strong { color: #555; }
    .modal-footer { border-top: 1px solid #eee; padding-top: 15px; margin-top: 20px; display: flex; justify-content: flex-end; gap: 10px; }
    .modal-footer__button--confirm, .modal-footer__button--cancel { padding: 8px 15px; border-radius: 5px; cursor: pointer; }
    .modal-footer__button--confirm { background-color: #007bff; color: white; border: none; }
    .modal-footer__button--cancel { background-color: #6c757d; color: white; border: none; }
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
                <button class="btn btn-primary" onclick="openFormSelectionModal()">새 결재 진행</button>
            </div>

            <c:if test="${currentUserAuthority eq 'ROLE_ADMIN'}">
                <div class="widget">
                    <h2>나의 결재 대기 문서</h2>
                    <c:choose>
                        <c:when test="${not empty pendingApprovals}">
                            <table class="data-table">
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
                                            <td><a href="elecApproval/detail/${doc.docId}">${doc.title}</a></td>
                                            <td>${doc.docType}</td>
                                            <td>${doc.initiatorName}</td>
                                            <td>${doc.initiatorDepartment}</td>
                                            <td><fmt:formatDate value="${doc.draftDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <td><span class="status-badge status-${doc.status}">${doc.status}</span></td>
                                            <td><button class="btn btn-secondary" onclick="quickApprove(${doc.docId})">바로결재</button></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p class="no-data">결재할 문서가 없습니다.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <div class="widget">
                <h2>내가 기안한 진행 중 문서</h2>
                <c:choose>
                    <c:when test="${not empty myInProgressDocs}">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>문서 ID</th>
                                    <th>제목</th>
                                    <th>기안일</th>
                                    <th>결재양식</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="doc" items="${myInProgressDocs}">
                                    <tr>
                                        <td>${doc.docId}</td>
                                        <td><a href="elecApproval/detail/${doc.docId}">${doc.title}</a></td>
                                        <td><fmt:formatDate value="${doc.draftDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td>${doc.docType}</td>
                                        <td><span class="status-badge status-${doc.status}">${doc.status}</span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p class="no-data">현재 진행 중인 기안 문서가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="widget">
                <h2>결재 승인된 문서</h2>
                <c:choose>
                    <c:when test="${not empty myApprovedDocs}">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>문서 ID</th>
                                    <th>제목</th>
                                    <th>기안일</th>
                                    <th>결재양식</th>
                                    <th>결재상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="doc" items="${myApprovedDocs}">
                                    <tr>
                                        <td>${doc.docId}</td>
                                        <td><a href="elecApproval/detail/${doc.docId}">${doc.title}</a></td>
                                        <td><fmt:formatDate value="${doc.draftDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                        <td>${doc.docType}</td>
                                        <td><span class="status-badge status-${doc.status}">${doc.status}</span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p class="no-data">완료된 문서가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${isAdmin}">
                <div class="widget">
                    <h2>관리자 메뉴</h2>
                    <div class="action-buttons">
                        <button class="btn btn-primary" onclick="location.href='/admin/users'">사용자 관리</button>
                        <button class="btn btn-primary" onclick="location.href='/admin/forms'">결재 양식 관리</button>
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
                    return response.json().then(error => { throw new Error(error.message || '요청 처리 중 오류가 발생했습니다.'); });
                }
                return response.json();
            })
            .then(data => {
                alert(data.message);
                window.location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('승인 처리 중 오류가 발생했습니다: ' + error.message);
            });
        }
    </script>
</body>
</html>