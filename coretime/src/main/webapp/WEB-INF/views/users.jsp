<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="_csrf_token" content="${_csrf.token}" />
            <meta name="_csrf_header" content="${_csrf.headerName}" />
            <title>Insert title here</title>

            <style>
                body {
                    display: flex;
                }

                .pagination {
                    text-align: center;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }

                th,
                td {
                    border: 1px solid #ddd;
                    padding: 8px;
                    text-align: left;
                }

                th {
                    background-color: #f2f2f2;
                }

                /* .container {
	display: flex;
	background-color: "white";
}
 */
                #nav {
                    width: 200px;
                    /* 내비게이션 너비 설정 (원하는 대로 조절) */
                    /* background-color: #f0f0f0; /* 내비게이션 구분용 배경색 (선택 사항) */
                    padding: 10px;
                    box-sizing: border-box;
                    /* 패딩이 너비에 포함되도록 */
                }

                .main-content {
                    /* 메인 콘텐츠 div의 클래스 */
                    flex-grow: 1;
                    /* 남은 공간을 모두 차지하도록 확장 */
                    padding: 20px;
                    /* 메인 콘텐츠 여백 추가 */
                    box-sizing: border-box;
                }

                .active {
                    border: 1px solid #000;
                    padding: 2px 5px;
                    border-radius: 3px;
                    font-size: 1.2em;
                    font-weight: bold;
                }

                .deactive {
                    padding: 2px;
                }
            </style>

        </head>

        <body>
            <div id="nav">
                <%@ include file="leftNav.jsp" %>
            </div>

            <div class="main-content">
                <h1>등록된 사용자 목록</h1>
                <h2>사용자 목록 (${pageInfo.total}명)</h2>


                <c:if test="${empty userList}">
                    <p>등록된 사용자가 없습니다.</p>
                </c:if>

                <c:if test="${not empty userList}">
                    <div>
                        <button onclick="location.href='/users/new'">신규 유저 생성</button>
                        <button id="deleteSelectedUsersBtn">유저 삭제</button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="selectAllUsers"></th>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>이메일</th>
                                <th>전화번호</th>
                                <th>직위</th>
                                <th>부서</th>
                                <th>생년월일</th>
                                <th>생성일</th>
                                <th>수정일</th>
                                <th>역할</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${userList}">
                                <tr>
                                    <td><input type="checkbox" name="selectedUsers" value="${user.id}"></td>
                                    <td>${user.name}</td>
                                    <td>
                                        <a href="users/edit?existingId=${user.id}">${user.name}</a>
                                    </td>
                                    <td>${user.id}</td>
                                    <td>${user.email}</td>
                                    <td>${user.tel}</td>
                                    <td>${user.rank}</td>
                                    <td>${user.department}</td>
                                    <td>${user.birth}</td>
                                    <td>${user.createdAt}</td>
                                    <td>${user.updatedAt}</td>
                                    <td>${user.role}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="pagination">
                        <c:if test="${pageInfo.hasPreviousPage}">
                            PageInfo의 hasPreviousPage 사용
                            <a href="/users?page=${pageInfo.prePage}&size=${pageInfo.pageSize}">이전</a>
                        </c:if>
                        <c:if test="${pageInfo.hasPreviousPage}">
                            이전 페이지 그룹의 시작 페이지 계산
                            <c:set var="prevPageGroupStart" value="${pageInfo.navigateFirstPage - 1}" />
                            1페이지보다 작아지지 않도록 확인
                            <c:set var="finalPrevPage" value="${prevPageGroupStart gt 0 ? prevPageGroupStart : 1}" />

                            <a href="/users?page=${finalPrevPage}&size=${pageInfo.pageSize}">이전</a>
                        </c:if>
                        <c:if test="${!pageInfo.hasPreviousPage}">
                            <span class="disabled">이전</span>
                        </c:if>

                        <c:forEach var="pageNum" items="${pageInfo.navigatepageNums}">
                            <c:choose>
                                <c:when test="${pageNum eq pageInfo.pageNum}">
                                    <a href="/users?page=${pageNum}&size=${pageInfo.pageSize}"
                                        class="active">${pageNum}</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="/users?page=${pageNum}&size=${pageInfo.pageSize}"
                                        class="deactive">${pageNum}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:if test="${pageInfo.hasNextPage}">
                            <a href="/users?page=${pageInfo.nextPage}&size=${pageInfo.pageSize}">다음</a>
                        </c:if>
                        <c:if test="${pageInfo.hasNextPage}">
                            다음 페이지 그룹의 첫 페이지 계산
                            <c:set var="nextPageGroupStart" value="${pageInfo.navigateLastPage + 1}" />
                            총 페이지 수를 넘지 않도록 확인
                            <c:set var="finalNextPage"
                                value="${nextPageGroupStart le pageInfo.pages ? nextPageGroupStart : pageInfo.pages}" />

                            '다음'은 다음 페이지 그룹의 시작 페이지로 이동
                            <a href="/users?page=${finalNextPage}&size=${pageInfo.pageSize}">다음</a>
                        </c:if>
                        <c:if test="${!pageInfo.hasNextPage}">
                            <span class="disabled">다음</span>
                        </c:if>
                    </div>
                </c:if>
            </div>
            <script>
                /* const csrfToken = document.querySelector('meta[name="_csrf_token"]').content;
                const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content; */
                document.getElementById('selectAllUsers').addEventListener('change', function () {
                    const checkboxes = document.querySelectorAll('input[name="selectedUsers"]');
                    checkboxes.forEach(checkbox => {
                        checkbox.checked = this.checked;
                    });
                });

                document.getElementById('deleteSelectedUsersBtn').addEventListener('click', function () {
                    //console.log("csrfHeader:", csrfHeader);
                    const selectedIds = [];
                    const checkboxes = document.querySelectorAll('input[name="selectedUsers"]');
                    checkboxes.forEach(checkbox => {
                        if (checkbox.checked) {
                            selectedIds.push(checkbox.value);
                        }
                    })
                    //console.log(selectedIds);
                    fetch('/users/delete', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            //[csrfHeader]: csrfToken
                        },
                        body: JSON.stringify({ ids: selectedIds })
                    })
                        .then(response => {
                            if (response.ok) {
                                alert('선택된 유저가 성공적으로 삭제되었습니다.');
                                location.reload();
                            } else {
                                return response.json().then(errorData => {
                                    alert('유저 삭제 중 오류가 발생했습니다: ' + (errorData.message || '알 수 없는 오류'));
                                }).catch(() => {
                                    alert('유저 삭제 중 오류가 발생했습니다. 서버 응답을 확인하세요.');
                                });
                            }
                        })
                        .catch(error => {
                            console.error('삭제 요청 중 오류:', error);
                            alert('서버와 통신 중 오류가 발생했습니다.');
                        });
                });
            </script>
        </body>

        </html> --%>

        <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

            <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <%-- <meta name="_csrf_token" content="${_csrf.token}" />
                    <meta name="_csrf_header" content="${_csrf.headerName}" /> --%>
                    <title>사용자 목록</title>

                    <link href="https://cdn.datatables.net/2.0.8/css/dataTables.dataTables.min.css" rel="stylesheet">

                    <style>
                        /* 기존 스타일은 그대로 유지 */
                        body {
                            display: flex;
                        }

                        #nav {
                            width: 200px;
                            padding: 10px;
                            box-sizing: border-box;
                        }

                        .main-content {
                            flex-grow: 1;
                            padding: 20px;
                            box-sizing: border-box;
                        }

                        h1 {
                            color: #333;
                        }

                        table {
                            width: 100%;
                            border-collapse: collapse;
                            margin-top: 20px;
                        }

                        /* DataTables 기본 CSS가 테이블 테두리를 처리할 것이므로, 필요시 조정 */
                        /* th, td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
} */
                        th {
                            background-color: #f2f2f2;
                        }

                        /* DataTables가 생성하는 요소들에 대한 기본 스타일은 DataTables CSS에 포함됩니다. */
                        /* 따라서 기존 pagination, active, deactive 관련 스타일은 더 이상 필요 없을 수 있습니다. */
                        /* 직접 커스텀 스타일을 원한다면 DataTables가 생성하는 클래스명 (예: .dataTables_paginate)에 맞춰 작성해야 합니다. */
                    </style>
                </head>

                <body>
                    <div id="nav">
                        <%@ include file="leftNav.jsp" %>
                    </div>

                    <div class="main-content">
                        <h1>등록된 사용자 목록</h1>
                        <h2>사용자 목록 (${userList.size()}명)</h2>

                        <c:if test="${empty userList}">
                            <p>등록된 사용자가 없습니다.</p>
                        </c:if>

                        <c:if test="${not empty userList}">
                            <div>
                                <button onclick="location.href='/users/new'">신규 유저 생성</button>
                                <button id="deleteSelectedUsersBtn">유저 삭제</button>
                            </div>

                            <table id="userTable" style="width:100%">
                                <thead>
                                    <tr>
                                        <th><input type="checkbox" id="selectAllUsers"></th>
                                        <th>이름</th>
                                        <th>아이디</th>
                                        <th>이메일</th>
                                        <th>전화번호</th>
                                        <th>직위</th>
                                        <th>부서</th>
                                        <!-- <th>생년월일</th> -->
                                        <!-- <th>생성일</th> -->
                                        <th>수정일</th>
                                        <!-- <th>역할</th> -->
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${userList}">
                                        <tr>
                                            <td><input type="checkbox" name="selectedUsers" value="${user.id}"></td>
                                            <td><a href="/users/edit?existingId=${user.id}">${user.name}</a></td>
                                            <td>${user.id}</td>
                                            <td>${user.email}</td>
                                            <td>${user.tel}</td>
                                            <td>${user.rank}</td>
                                            <td>${user.department}</td>
                                            <%-- <td>${user.birth}</td> --%>
                                                <%-- <td>${user.createdAt}</td> --%>
                                                    <td>${user.updatedAt}</td>
                                                    <%-- <td>${user.role}</td> --%>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                    </div>

                    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
                    <script src="https://cdn.datatables.net/2.0.8/js/dataTables.min.js"></script>

                    <script>
                        $(document).ready(function () {
                            // DataTables 초기화
                            $('#userTable').DataTable(/*{
                                // DataTables 옵션:
                                // 'ordering': true, // 정렬 기능 활성화 (기본값 true)
                                // 'searching': true, // 검색 기능 활성화 (기본값 true)
                                // 'paging': true, // 페이지네이션 기능 활성화 (기본값 true)
                                // 'lengthMenu': [[10, 25, 50, -1], [10, 25, 50, "All"]], // 보여줄 행 수 옵션
                                // 'pageLength': 10, // 기본 페이지당 행 수
                                'language': { // 한글화
                                    'decimal': '',
                                    'emptyTable': '데이터가 없습니다.',
                                    'info': '총 _TOTAL_명 중 _START_에서 _END_까지 표시',
                                    'infoEmpty': '0명 중 0에서 0까지 표시',
                                    'infoFiltered': '(총 _MAX_명에서 필터링됨)',
                                    'infoPostFix': '',
                                    'thousands': ',',
                                    'lengthMenu': '_MENU_개씩 보기',
                                    'loadingRecords': '로딩 중...',
                                    'processing': '처리 중...',
                                    'search': '검색:',
                                    'zeroRecords': '일치하는 데이터가 없습니다.',
                                    'paginate': {
                                        'first': '처음',
                                        'last': '마지막',
                                        'next': '다음',
                                        'previous': '이전'
                                    },
                                    'aria': {
                                        'sortAscending': ': 오름차순으로 정렬',
                                        'sortDescending': ': 내림차순으로 정렬'
                                    }
                                },
                                // 정렬을 하지 않을 컬럼 지정 (체크박스 컬럼)
                                "columnDefs": [
                                    { "orderable": false, "targets": 0 } // 첫 번째 컬럼 (인덱스 0)은 정렬 비활성화
                                ]
                            }*/);
                        });

                        // 기존의 체크박스 전체 선택/해제 로직은 그대로 유지
                        document.getElementById('selectAllUsers').addEventListener('change', function () {
                            const checkboxes = document.querySelectorAll('input[name="selectedUsers"]');
                            checkboxes.forEach(checkbox => {
                                checkbox.checked = this.checked;
                            });
                        });

                        // 삭제 버튼 로직은 그대로 유지
                        document.getElementById('deleteSelectedUsersBtn').addEventListener('click', function () {
                            const selectedIds = [];
                            const checkboxes = document.querySelectorAll('input[name="selectedUsers"]');
                            checkboxes.forEach(checkbox => {
                                if (checkbox.checked) {
                                    selectedIds.push(checkbox.value);
                                }
                            })

                            fetch('/users/delete', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json',
                                    // CSRF 토큰 사용 시 주석 해제:
                                    // 'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf_token"]').content
                                },
                                body: JSON.stringify({ ids: selectedIds })
                            })
                                .then(response => {
                                    if (response.ok) {
                                        alert('선택된 유저가 성공적으로 삭제되었습니다.');
                                        location.reload();
                                    } else {
                                        return response.json().then(errorData => {
                                            alert('유저 삭제 중 오류가 발생했습니다: ' + (errorData.message || '알 수 없는 오류'));
                                        }).catch(() => {
                                            alert('유저 삭제 중 오류가 발생했습니다. 서버 응답을 확인하세요.');
                                        });
                                    }
                                })
                                .catch(error => {
                                    console.error('삭제 요청 중 오류:', error);
                                    alert('서버와 통신 중 오류가 발생했습니다.');
                                });
                        });
                    </script>
                </body>

                </html>`