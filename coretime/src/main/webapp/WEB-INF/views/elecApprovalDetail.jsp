<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전자결재 상세 보기</title>
<link rel="stylesheet" href='/resources/css/vacationRequestForm.css' type="text/css">
<%-- 이전에 작성된 스타일을 여기에 포함하거나, 외부 CSS 파일에 링크할 수 있습니다 --%>
<style>
    body {
        font-family: 'Malgun Gothic', Dotum, Arial, Tahoma;
        font-size: 9pt;
        line-height: 1.5;
        color: #333;
    }
    .container {
        width: 800px;
        margin: 20px auto;
        border: 1px solid #ccc;
        padding: 30px;
        box-shadow: 0 0 10px rgba(0,0,0,0.05);
        background-color: #fff;
    }
    h1 {
        text-align: center;
        font-size: 2.5em;
        color: #333;
        margin-bottom: 30px;
        border-bottom: 2px solid #eee;
        padding-bottom: 10px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 25px;
    }
    table th, table td {
        padding: 10px;
        border: 1px solid #ddd;
        text-align: left;
    }
    table th {
        background-color: #e0e0e0;
        font-weight: bold;
        text-align: center;
        width: 120px;
    }
    table td {
        background-color: #f9f9f9;
    }
    table tbody tr:nth-child(even) td {
        background-color: #f5f5f5;
    }
    .read-only-field {
        background-color: #f5f5f5;
        padding: 8px;
        border: 1px solid #ddd;
    }
    .approval-line {
        margin-top: 25px;
        margin-bottom: 25px;
        border: 1px solid #ddd;
    }
    .approval-line th, .approval-line td {
        padding: 0;
        text-align: center;
        border: 1px solid #ddd;
    }
    .approval-line th {
        width: 100px;
        background-color: #e0e0e0;
        vertical-align: middle;
        font-weight: bold;
        height: 80px;
    }
    .approval-sub-table {
        width: 100%;
        border-collapse: collapse;
    }
    .approval-sub-table td {
        padding: 5px;
        border: none;
    }
    .approval-date {
        font-size: 0.8em;
        color: #666;
    }
    .info-section {
        font-size: 0.9em;
        line-height: 1.6;
        color: #555;
        background-color: #f8f9fa;
        padding: 15px;
        border: 1px dashed #e0e0e0;
        border-radius: 5px;
        margin-top: 20px;
    }
    .info-section strong {
        color: #333;
    }
    .form-section-title {
        font-size: 1.2em;
        font-weight: bold;
        margin-top: 30px;
        margin-bottom: 15px;
        padding-bottom: 5px;
        border-bottom: 1px solid #ddd;
        color: #007bff;
    }
</style>
</head>
<body>
    <div class="container">
        <h1>전자결재 상세 보기</h1>

        <%-- <div class="form-section-title">문서 기본 정보</div> --%>
        <%-- <table>
            <colgroup>
                <col style="width: 120px;">
                <col style="width: auto;">
            </colgroup>
            <tbody>
                <tr>
                    <th>문서 ID</th>
                    <td class="read-only-field">${documentDetail.docId}</td>
                </tr>
                <tr>
                    <th>결재 양식</th>
                    <td class="read-only-field">${documentDetail.docType}</td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td class="read-only-field">${documentDetail.title}</td>
                </tr>
                <tr>
                    <th>결재 상태</th>
                    <td class="read-only-field">${documentDetail.status}</td>
                </tr>
                <tr>
                    <th>기안자 ID</th>
                    <td class="read-only-field">${documentDetail.initiatorId}</td>
                </tr>
                <tr>
                    <th>기안자 부서</th>
                    <td class="read-only-field">${documentDetail.initiatorDepartment}</td>
                </tr>
                <tr>
                    <th>기안일</th>
                    <td class="read-only-field">${formattedDetailDraftDate}</td>
                </tr>
                <tr>
                    <th>최종 수정일</th>
                    <td class="read-only-field">${formattedDetailUpdatedAt}</td>
                </tr>
            </tbody>
        </table> --%>

        <div class="form-section-title">결재선</div>
        <table class="approval-line">
            <tbody>
                <tr>
                    <th>신청</th>
                    <td>
                        <table class="approval-sub-table">
                            <tbody>
                                <tr><td>${currentUser.getRank()}</td></tr>
                                <tr><td>${currentUser.getName()}</td></tr> <%-- 기안자 ID --%>
                                <tr><td class="approval-date">${formattedDetailDraftDate}</td></tr>
                            </tbody>
                        </table>
                    </td>
                    <%-- 실제 결재선은 반복문으로 동적으로 생성되어야 합니다 --%>
                    <th>승인</th>
                    <td>
                        <table class="approval-sub-table">
                            <tbody>
                                <tr><td>대리</td></tr>
                                <tr><td>장바로</td></tr>
                                <tr><td class="approval-date"></td></tr> <%-- 승인일 --%>
                            </tbody>
                        </table>
                    </td>
                    <td>
                        <table class="approval-sub-table">
                            <tbody>
                                <tr><td>대표이사</td></tr>
                                <tr><td>한판승</td></tr>
                                <tr><td class="approval-date"></td></tr>
                            </tbody>
                        </table>
                    </td>
                    <td>
                        <table class="approval-sub-table">
                            <tbody>
                                <tr><td>부사장</td></tr>
                                <tr><td>강회계</td></tr>
                                <tr><td class="approval-date"></td></tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="form-section-title">상세 신청 내용 (휴가 신청서)</div>
        <table>
            <colgroup>
                <col style="width: 120px;">
                <col style="width: auto;">
            </colgroup>
            <tbody>
                <tr>
                    <th>신청자</th>
                    <td id="jsonApplicantName" class="read-only-field"></td>
                </tr>
                <tr>
                    <th>부서</th>
                    <td id="jsonDepartment" class="read-only-field"></td>
                </tr>
                <tr>
                    <th>휴가 종류</th>
                    <td id="jsonVacationType" class="read-only-field"></td>
                </tr>
                <tr>
                    <th>시작일</th>
                    <td id="jsonStartDate" class="read-only-field"></td>
                </tr>
                <tr>
                    <th>종료일</th>
                    <td id="jsonEndDate" class="read-only-field"></td>
                </tr>
                <tr>
                    <th>사유</th>
                    <td id="jsonReason" class="read-only-field"></td>
                </tr>
                <tr>
                    <th>비상 연락처</th>
                    <td id="jsonContactInfo" class="read-only-field"></td>
                </tr>
            </tbody>
        </table>

        <div class="form-actions">
            <button type="button" class="cancel-button" onclick="history.back()">목록으로 돌아가기</button>
            <%-- 문서 수정/결재/반려 등 액션 버튼은 여기에 추가 --%>
            <%-- 예: <button type="button" class="submit-button">결재</button> --%>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 서버에서 전달받은 documentDetail 객체의 jsonContent 값을 가져옴
            const jsonContentString = '<c:out value="${documentDetail.jsonContent}" escapeXml="false"/>';

            if (jsonContentString) {
                try {
                    const jsonData = JSON.parse(jsonContentString);
                    console.log("Parsed JSON Content:", jsonData); // 파싱된 데이터 확인

                    // doc_type에 따라 다른 필드를 표시할 수 있도록 확장 가능
                    // 현재는 휴가 신청서 (vacationRequestForm)를 가정
                    const docType = '${documentDetail.docType}'; 

                    if (docType === '휴가신청서' || docType === 'vacationRequestForm') { // 실제 DB 저장된 값과 비교
                        document.getElementById('jsonApplicantName').innerText = jsonData.applicantName || '';
                        document.getElementById('jsonDepartment').innerText = jsonData.department || '';
                        document.getElementById('jsonVacationType').innerText = jsonData.vacationType || '';
                        document.getElementById('jsonStartDate').innerText = jsonData.startDate || '';
                        document.getElementById('jsonEndDate').innerText = jsonData.endDate || '';
                        document.getElementById('jsonReason').innerText = jsonData.reason || '';
                        document.getElementById('jsonContactInfo').innerText = jsonData.contactInfo || '';
                    } 
                    // else if (docType === '다른양식타입') {
                    //     // 다른 양식에 맞는 필드를 여기에 표시
                    // }
                    // ...
                } catch (e) {
                    console.error("JSON 파싱 오류:", e);
                    document.getElementById('jsonContentError').innerText = "JSON 내용을 파싱하는 데 오류가 발생했습니다.";
                }
            } else {
                console.log("json_content가 비어있습니다.");
            }
        });
    </script>
</body>
</html>