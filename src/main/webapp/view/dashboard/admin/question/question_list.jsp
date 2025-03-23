<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Manage Quizzes</title>
    <meta name="description" content="SkillGro - Manage Quizzes">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../../common/css-file.jsp"></jsp:include>

    <!-- Bootstrap CSS -->
    <style>
        .quiz-status {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-active {
            background-color: #e6f7e6;
            color: #28a745;
        }
        
        .status-inactive {
            background-color: #f8d7da;
            color: #dc3545;
        }
        
        .status-draft {
            background-color: #fff3cd;
            color: #ffc107;
        }
        
        .table-actions {
            display: flex;
            gap: 8px;
        }
        
        .table-actions a {
            padding: 4px 8px;
            border-radius: 4px;
            color: white;
            text-decoration: none;
            font-size: 12px;
        }
        
        .action-view {
            background-color: #17a2b8;
        }
        
        .action-edit {
            background-color: #007bff;
        }
        
        .action-delete {
            background-color: #dc3545;
        }
        
        .filter-form {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .settings-btn {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .modal-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        
        .column-option {
            margin-bottom: 10px;
        }
    </style>
</head>

<body>

    <!-- Scroll-top -->
    <button class="scroll__top scroll-to-target" data-target="html">
        <i class="tg-flaticon-arrowhead-up"></i>
    </button>
    <!-- Scroll-top-end-->

    <!-- header-area -->
    <jsp:include page="../../../common/home/header-home.jsp"></jsp:include>
    <!-- header-area-end -->

    <c:url value="/manage-quiz" var="paginationUrl">
        <c:param name="action" value="list" />
        <c:if test="${not empty param.courseId}">
            <c:param name="courseId" value="${param.courseId}" />
        </c:if>
        <c:if test="${not empty param.sectionId}">
            <c:param name="sectionId" value="${param.sectionId}" />
        </c:if>
        <c:if test="${not empty param.search}">
            <c:param name="search" value="${param.search}" />
        </c:if>
        <c:if test="${not empty param.pageSize}">
            <c:param name="pageSize" value="${param.pageSize}" />
        </c:if>
        <c:forEach items="${paramValues.optionChoice}" var="option">
            <c:param name="optionChoice" value="${option}" />
        </c:forEach>
    </c:url>

    <!-- main-area -->
    <main class="main-area">
        <section class="dashboard__area section-pb-120">
            <div class="container-fluid">
                <jsp:include page="../../../common/dashboard/avatar.jsp"></jsp:include>

                <div class="dashboard__inner-wrap">

                    <div class="row">
                        <jsp:include page="../../../common/dashboard/sideBar.jsp"></jsp:include>

                        <div class="col-xl-9">
                            <div class="dashboard__content-area">
                                <div class="dashboard__content-title d-flex justify-content-between align-items-center">
                                    <h4 class="title">Quản lý bài kiểm tra</h4>
                                    <button type="button" class="settings-btn" data-toggle="modal" data-target="#settingModal">
                                        <i class="fa fa-cog"></i> Cài đặt hiển thị
                                    </button>
                                </div>

                                <!-- Filter Form -->
                                <div class="filter-form">
                                    <form action="${pageContext.request.contextPath}/manage-quiz" method="get">
                                        <input type="hidden" name="action" value="list">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label for="courseId">Khóa học</label>
                                                    <select class="form-control" id="courseId" name="courseId">
                                                        <option value="">Tất cả khóa học</option>
                                                        <c:forEach items="${courseList}" var="course">
                                                            <option value="${course.id}" ${param.courseId == course.id ? 'selected' : ''}>
                                                                ${course.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label for="sectionId">Phần học</label>
                                                    <select class="form-control" id="sectionId" name="sectionId" ${empty param.courseId ? 'disabled' : ''}>
                                                        <option value="">Tất cả phần học</option>
                                                        <c:if test="${not empty sectionList}">
                                                            <c:forEach items="${sectionList}" var="section">
                                                                <option value="${section.id}" ${param.sectionId == section.id ? 'selected' : ''}>
                                                                    ${section.title}
                                                                </option>
                                                            </c:forEach>
                                                        </c:if>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label for="search">Tìm kiếm</label>
                                                    <input type="text" class="form-control" id="search" name="search" 
                                                           placeholder="Tìm theo tiêu đề bài kiểm tra" value="${param.search}">
                                                </div>
                                            </div>
                                            <div class="col-md-2 d-flex align-items-end">
                                                <button type="submit" class="btn btn-primary w-100">Lọc</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <!-- Quiz List -->
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div>
                                        Showing <span class="fw-bold">${startRecord}</span> to 
                                        <span class="fw-bold">${endRecord}</span> of 
                                        <span class="fw-bold">${totalQuizzes}</span> quizzes
                                    </div>
                                    <div>
                                        <select class="form-control" onchange="changePageSize(this.value)">
                                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 per page</option>
                                            <option value="25" ${pageSize == 25 ? 'selected' : ''}>25 per page</option>
                                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 per page</option>
                                            <option value="100" ${pageSize == 100 ? 'selected' : ''}>100 per page</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Quiz Table -->
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <c:set var="showId" value="${empty selectedColumns}" />
                                                <c:set var="showTitle" value="${empty selectedColumns}" />
                                                <c:set var="showCourse" value="${empty selectedColumns}" />
                                                <c:set var="showSection" value="${empty selectedColumns}" />
                                                <!-- <c:set var="showQuestionCount" value="${empty selectedColumns}" /> -->
                                                <!-- <c:set var="showStatus" value="${empty selectedColumns}" /> -->
                                                <!-- <c:set var="showDuration" value="false" /> -->
                                                
                                                <c:forEach items="${selectedColumns}" var="col">
                                                    <c:if test="${col eq 'id'}"><c:set var="showId" value="true" /></c:if>
                                                    <c:if test="${col eq 'title'}"><c:set var="showTitle" value="true" /></c:if>
                                                    <c:if test="${col eq 'course'}"><c:set var="showCourse" value="true" /></c:if>
                                                    <c:if test="${col eq 'section'}"><c:set var="showSection" value="true" /></c:if>
                                                    <!-- <c:if test="${col eq 'questionCount'}"><c:set var="showQuestionCount" value="true" /></c:if> -->
                                                    <!-- <c:if test="${col eq 'status'}"><c:set var="showStatus" value="true" /></c:if> -->
                                                    <!-- <c:if test="${col eq 'duration'}"><c:set var="showDuration" value="true" /></c:if> -->
                                                </c:forEach>
                                                
                                                <c:if test="${showId}"><th>ID</th></c:if>
                                                <c:if test="${showTitle}"><th>Question Title</th></c:if>
                                                <c:if test="${showCourse}"><th>Course</th></c:if>
                                                <c:if test="${showSection}"><th>Section</th></c:if>
                                                <!-- <c:if test="${showQuestionCount}"><th>Questions</th></c:if> -->
                                                <!-- <c:if test="${showStatus}"><th>Status</th></c:if> -->
                                                <!-- <c:if test="${showDuration}"><th>Duration (minutes)</th></c:if> -->
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${questionsList}" var="question" varStatus="loop">
                                                <tr>
                                                    <c:if test="${showId}"><td>${question.id}</td></c:if>
                                                    <c:if test="${showTitle}"><td>${question.questionText}</td></c:if>
                                                    <c:if test="${showCourse}"><td>${courseDAO.getByQuestionId(question.id).name}</td></c:if>
                                                    <c:if test="${showSection}"><td>${sectionDAO.findByQuestionId(question.id).title}</td></c:if>
                                                    <!-- <c:if test="${showQuestionCount}"><td>${quizInfo.questionCount}</td></c:if> -->
                                                    <!-- <c:if test="${showDuration}"><td>${quizInfo.lesson.duration}</td></c:if> -->
                                                    <td>
                                                        <div class="table-actions">
                                                            <a href="${pageContext.request.contextPath}/manage-quiz?action=editQuestion&questionId=${quizInfo.lesson.id}" class="action-edit">
                                                                <i class="fa fa-edit"></i> Edit
                                                            </a>
                                                            <a href="#" onclick="confirmDelete(${quizInfo.lesson.id})" class="action-delete">
                                                                <i class="fa fa-trash"></i> Delete
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty quizList}">
                                                <tr>
                                                    <td colspan="7" class="text-center">No quizzes found</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <div class="d-flex justify-content-center mt-4">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination">
                                            <c:if test="${currentPage > 1}">
                                                <li class="page-item">
                                                    <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                            </c:if>
                                            
                                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <li class="page-item">
                                                    <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" aria-label="Next">
                                                        <span aria-hidden="true">&raquo;</span>
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    <!-- main-area-end -->

    <!-- Settings Modal -->
    <div class="modal fade" id="settingModal" tabindex="-1" role="dialog" aria-labelledby="settingModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="settingModalLabel">Cài đặt hiển thị</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/manage-quiz" method="get" id="settingsForm">
                        <input type="hidden" name="action" value="list">
                        <c:if test="${not empty param.courseId}">
                            <input type="hidden" name="courseId" value="${param.courseId}">
                        </c:if>
                        <c:if test="${not empty param.sectionId}">
                            <input type="hidden" name="sectionId" value="${param.sectionId}">
                        </c:if>
                        <c:if test="${not empty param.search}">
                            <input type="hidden" name="search" value="${param.search}">
                        </c:if>
                        <c:if test="${not empty param.pageSize}">
                            <input type="hidden" name="pageSize" value="${param.pageSize}">
                        </c:if>
                        <c:if test="${not empty param.page}">
                            <input type="hidden" name="page" value="${param.page}">
                        </c:if>
                        
                        <div class="form-group">
                            <label>Chọn cột hiển thị:</label>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="id" id="idColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'id'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="idColumn">
                                        ID
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="title" id="titleColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'title'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="titleColumn">
                                        Quiz Title
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="course" id="courseColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'course'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="courseColumn">
                                        Course
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="section" id="sectionColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'section'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="sectionColumn">
                                        Section
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="questionCount" id="questionsColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'questionCount'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="questionsColumn">
                                        Questions
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="status" id="statusColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'status'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="statusColumn">
                                        Status
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="duration" id="durationColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'duration'}">checked</c:if>
                                           </c:forEach>>
                                    <label class="form-check-label" for="durationColumn">
                                        Duration
                                    </label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="document.getElementById('settingsForm').submit();">Apply</button>
                </div>
            </div>
        </div>
    </div>

    <!-- footer-area -->
    <jsp:include page="../../../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../../common/js-file.jsp"></jsp:include>

    <script>
        function confirmDelete(quizId) {
            if (confirm('Are you sure you want to delete this quiz? This action cannot be undone.')) {
                window.location.href = '${pageContext.request.contextPath}/manage-quiz?action=delete&id=' + quizId;
            }
        }
        
        function changePageSize(size) {
            var url = new URL(window.location.href);
            url.searchParams.set('pageSize', size);
            url.searchParams.set('page', '1'); // Reset to first page when changing page size
            window.location.href = url.toString();
        }
        
        $(document).ready(function() {
            // Course and section dropdown dependency
            $('#courseId').change(function() {
                var courseId = $(this).val();
                var sectionDropdown = $('#sectionId');
                
                if (courseId) {
                    // Enable section dropdown
                    sectionDropdown.prop('disabled', false);
                    
                    // AJAX call to get sections for selected course
                    $.ajax({
                        url: '${pageContext.request.contextPath}/get-sections',
                        type: 'GET',
                        data: { courseId: courseId },
                        success: function(data) {
                            // Clear current options
                            sectionDropdown.empty();
                            sectionDropdown.append('<option value="">All Sections</option>');
                            
                            // Add new options
                            $.each(data, function(index, section) {
                                sectionDropdown.append('<option value="' + section.id + '">' + section.title + '</option>');
                            });
                        },
                        error: function() {
                            console.error('Failed to load sections');
                        }
                    });
                } else {
                    // Disable and reset section dropdown
                    sectionDropdown.prop('disabled', true);
                    sectionDropdown.empty();
                    sectionDropdown.append('<option value="">All Sections</option>');
                }
            });
            
            // Xử lý đóng modal
            $('.close, .btn-secondary[data-dismiss="modal"]').click(function() {
                $('#settingModal').modal('hide');
            });

            // Xử lý mở modal
            $('[data-toggle="modal"]').click(function() {
                $('#settingModal').modal('show');
            });
            
            // Toast message display
            var toastMessage = "${sessionScope.toastMessage}";
            var toastType = "${sessionScope.toastType}";
            if (toastMessage) {
                iziToast.show({
                    title: toastType === 'success' ? 'Success' : 'Error',
                    message: toastMessage,
                    position: 'topRight',
                    color: toastType === 'success' ? 'green' : 'red',
                    timeout: 5000,
                    onClosing: function () {
                        // Remove toast attributes from the session after displaying
                        fetch('${pageContext.request.contextPath}/remove-toast', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                        }).then(function(response) {
                            if (!response.ok) {
                                console.error('Failed to remove toast attributes');
                            }
                        }).catch(function(error) {
                            console.error('Error:', error);
                        });
                    }
                });
            }
        });
    </script>
</body>

</html> 