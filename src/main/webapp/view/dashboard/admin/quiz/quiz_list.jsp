<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    </c:url>

    <!-- main-area -->
    <main class="main-area">
        <section class="dashboard__area section-pb-120">
            <div class="container-fluid">
                <jsp:include page="../../../common/dashboard/avatar.jsp"></jsp:include>

                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <jsp:include page="../../../common/dashboard/sideBar.jsp"></jsp:include>
                        <div class="col-lg-9">
                            <div class="dashboard__content-wrap">
                                <!-- Title and Buttons Row -->
                                <div class="row mb-4">
                                    <div class="col">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Quiz Management</h4>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <a href="${pageContext.request.contextPath}/lesson-edit?action=add&type=quiz" class="btn btn-primary">
                                            <i class="fa fa-plus"></i> Add New Quiz
                                        </a>
                                    </div>
                                </div>

                                <!-- Filter Form -->
                                <form action="${pageContext.request.contextPath}/manage-quiz" method="get" class="filter-form">
                                    <input type="hidden" name="action" value="list">
                                    <div class="row align-items-end">
                                        <div class="col-md-4 mb-3 mb-md-0">
                                            <label for="courseId" class="form-label">Course</label>
                                            <select class="form-select" id="courseId" name="courseId" onchange="this.form.submit()">
                                                <option value="">All Courses</option>
                                                <c:forEach items="${courseList}" var="course">
                                                    <option value="${course.id}" ${param.courseId == course.id ? 'selected' : ''}>
                                                        ${course.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4 mb-3 mb-md-0">
                                            <label for="sectionId" class="form-label">Section</label>
                                            <select class="form-select" id="sectionId" name="sectionId" ${empty param.courseId ? 'disabled' : ''}>
                                                <option value="">All Sections</option>
                                                <c:if test="${not empty sectionList}">
                                                    <c:forEach items="${sectionList}" var="section">
                                                        <option value="${section.id}" ${param.sectionId == section.id ? 'selected' : ''}>
                                                            ${section.title}
                                                        </option>
                                                    </c:forEach>
                                                </c:if>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="search" class="form-label">Search</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="search" placeholder="Search quizzes..." name="search" value="${param.search}">
                                                <button class="btn btn-primary" type="submit">
                                                    <i class="fa fa-search"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>

                                <!-- Results Count and Page Size -->
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div>
                                        Showing <span class="fw-bold">${startRecord}</span> to 
                                        <span class="fw-bold">${endRecord}</span> of 
                                        <span class="fw-bold">${totalQuizzes}</span> quizzes
                                    </div>
                                    <div>
                                        <select class="form-select form-select-sm" onchange="changePageSize(this.value)">
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
                                                <th>ID</th>
                                                <th>Quiz Title</th>
                                                <th>Course</th>
                                                <th>Section</th>
                                                <th>Questions</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${quizList}" var="quizInfo">
                                                <tr>
                                                    <td>${quizInfo.lesson.id}</td>
                                                    <td>${quizInfo.lesson.title}</td>
                                                    <td>${quizInfo.course.name}</td>
                                                    <td>${quizInfo.section.title}</td>
                                                    <td>${quizInfo.questionCount}</td>
                                                    <td>
                                                        <span class="quiz-status status-${quizInfo.lesson.status.toLowerCase()}">
                                                            ${quizInfo.lesson.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="table-actions">
                                                            <a href="${pageContext.request.contextPath}/manage-quiz?action=view&id=${quizInfo.lesson.id}" class="action-view">
                                                                <i class="fa fa-eye"></i> View
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/manage-quiz?action=edit&id=${quizInfo.lesson.id}" class="action-edit">
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