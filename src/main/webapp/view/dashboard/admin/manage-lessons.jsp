<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Manage Lessons</title>
    <meta name="description" content="SkillGro - Manage Lessons">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/css-file.jsp"></jsp:include>
</head>

<body>

    <!-- Scroll-top -->
    <button class="scroll__top scroll-to-target" data-target="html">
        <i class="tg-flaticon-arrowhead-up"></i>
    </button>
    <!-- Scroll-top-end-->

    <!-- header-area -->
    <jsp:include page="../../common/home/header-home.jsp"></jsp:include>
    <!-- header-area-end -->
    <c:url value="/manage-lessons" var="paginationUrl">
        <c:param name="action" value="list" />
        <c:if test="${not empty param.course}">
            <c:param name="course" value="${param.course}" />
        </c:if>
        <c:if test="${not empty param.section}">
            <c:param name="section" value="${param.section}" />
        </c:if>
        <c:if test="${not empty param.type}">
            <c:param name="type" value="${param.type}" />
        </c:if>
        <c:if test="${not empty param.status}">
            <c:param name="status" value="${param.status}" />
        </c:if>
        <c:if test="${not empty param.search}">
            <c:param name="search" value="${param.search}" />
        </c:if>
    </c:url>

    <!-- main-area -->
    <main class="main-area">
        <section class="dashboard__area section-pb-120">
            <div class="container-fluid">
                <jsp:include page="../../common/dashboard/avatar.jsp"></jsp:include>

                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <jsp:include page="../../common/dashboard/sideBar.jsp"></jsp:include>
                        <div class="col-lg-9">
                            <div class="dashboard__content-wrap">
                                <div class="dashboard__content-title d-flex justify-content-between align-items-center">
                                    <h4 class="title">Lesson List</h4>
                                    <button class="btn" style="background-color: #f5f5f5; border: none;">
                                        <i class="fa fa-cog"></i>
                                    </button>
                                </div>
                                <form action="${pageContext.request.contextPath}/manage-lessons" method="GET"
                                    class="mb-4">
                                    <div class="row mb-3">
                                        <div class="col-md-2">
                                            <select class="form-select" id="courseFilter" name="course">
                                                <option value="">Course</option>
                                                <option value="Java Programming" ${param.course=='Java Programming' ? 'selected' : '' }>Java Programming</option>
                                                <option value="Web Development" ${param.course=='Web Development' ? 'selected' : '' }>Web Development</option>
                                                <option value="Data Science" ${param.course=='Data Science' ? 'selected' : '' }>Data Science</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select class="form-select" id="sectionFilter" name="section">
                                                <option value="">Section</option>
                                                <option value="Section 1" ${param.section=='Section 1' ? 'selected' : '' }>Section 1</option>
                                                <option value="Section 2" ${param.section=='Section 2' ? 'selected' : '' }>Section 2</option>
                                                <option value="Section 3" ${param.section=='Section 3' ? 'selected' : '' }>Section 3</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select class="form-select" id="typeFilter" name="type">
                                                <option value="">Type</option>
                                                <option value="video" ${param.type=='video' ? 'selected' : '' }>Video</option>
                                                <option value="document" ${param.type=='document' ? 'selected' : '' }>Document</option>
                                                <option value="quiz" ${param.type=='quiz' ? 'selected' : '' }>Quiz</option>
                                                <option value="file" ${param.type=='file' ? 'selected' : '' }>File</option>
                                                <option value="text" ${param.type=='text' ? 'selected' : '' }>Text</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select class="form-select" id="statusFilter" name="status">
                                                <option value="">Status</option>
                                                <option value="active" ${param.status=='active' ? 'selected' : '' }>Active</option>
                                                <option value="inactive" ${param.status=='inactive' ? 'selected' : '' }>Inactive</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="text" class="form-control" id="searchFilter"
                                                name="search" placeholder="Search by title..."
                                                value="${param.search}">
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-10">
                                            <button type="submit" style="width: 100%; background-color: #007aff"
                                                class="form-control text-light">
                                                <i class="fa fa-search mr-4"></i>
                                                Filter
                                            </button>
                                        </div>
                                        <div class="col-md-2">
                                            <a href="${pageContext.request.contextPath}/manage-lessons?action=add" 
                                               class="btn btn-success form-control text-light">
                                                <i class="fa fa-plus mr-2"></i> Add Lesson
                                            </a>
                                        </div>
                                    </div>
                                </form>
                                <div class="row">
                                    <div class="col-12">
                                        <div class="dashboard__review-table">
                                            <table class="table table-borderless">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Title</th>
                                                        <th>Section</th>
                                                        <th>Type</th>
                                                        <th>Duration</th>
                                                        <th>Status</th>
                                                        <th style="text-align: center;">Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <!-- Sample data - replace with actual data from your controller -->
                                                    <tr>
                                                        <td>
                                                            <p class="color-black">1</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Introduction to Java</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Section 1</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">video</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">45 min</p>
                                                        </td>
                                                        <td>
                                                            <span class="dashboard__quiz-result">
                                                                active
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="dashboard__review-action">
                                                                <a href="${pageContext.request.contextPath}/manage-lessons?action=edit&id=1"
                                                                    title="Edit"><i class="skillgro-edit"></i></a>
                                                                <a href="#"
                                                                    onclick="confirmDelete('1')"
                                                                    title="Delete"><i class="skillgro-bin"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="color-black">2</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Variables and Data Types</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Section 1</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">document</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">30 min</p>
                                                        </td>
                                                        <td>
                                                            <span class="dashboard__quiz-result">
                                                                active
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="dashboard__review-action">
                                                                <a href="${pageContext.request.contextPath}/manage-lessons?action=edit&id=2"
                                                                    title="Edit"><i class="skillgro-edit"></i></a>
                                                                <a href="#"
                                                                    onclick="confirmDelete('2')"
                                                                    title="Delete"><i class="skillgro-bin"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="color-black">3</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Control Flow Statements</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Section 1</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">quiz</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">20 min</p>
                                                        </td>
                                                        <td>
                                                            <span class="dashboard__quiz-result fail">
                                                                inactive
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="dashboard__review-action">
                                                                <a href="${pageContext.request.contextPath}/manage-lessons?action=edit&id=3"
                                                                    title="Edit"><i class="skillgro-edit"></i></a>
                                                                <a href="#"
                                                                    onclick="confirmDelete('3')"
                                                                    title="Delete"><i class="skillgro-bin"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="color-black">4</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Object-Oriented Programming</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Section 2</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">video</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">60 min</p>
                                                        </td>
                                                        <td>
                                                            <span class="dashboard__quiz-result">
                                                                active
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="dashboard__review-action">
                                                                <a href="${pageContext.request.contextPath}/manage-lessons?action=edit&id=4"
                                                                    title="Edit"><i class="skillgro-edit"></i></a>
                                                                <a href="#"
                                                                    onclick="confirmDelete('4')"
                                                                    title="Delete"><i class="skillgro-bin"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="color-black">5</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Classes and Objects</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Section 2</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">document</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">45 min</p>
                                                        </td>
                                                        <td>
                                                            <span class="dashboard__quiz-result">
                                                                active
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="dashboard__review-action">
                                                                <a href="${pageContext.request.contextPath}/manage-lessons?action=edit&id=5"
                                                                    title="Edit"><i class="skillgro-edit"></i></a>
                                                                <a href="#"
                                                                    onclick="confirmDelete('5')"
                                                                    title="Delete"><i class="skillgro-bin"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="color-black">6</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Inheritance and Polymorphism</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Section 2</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">file</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">35 min</p>
                                                        </td>
                                                        <td>
                                                            <span class="dashboard__quiz-result fail">
                                                                inactive
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="dashboard__review-action">
                                                                <a href="${pageContext.request.contextPath}/manage-lessons?action=edit&id=6"
                                                                    title="Edit"><i class="skillgro-edit"></i></a>
                                                                <a href="#"
                                                                    onclick="confirmDelete('6')"
                                                                    title="Delete"><i class="skillgro-bin"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="color-black">7</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Exception Handling</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Section 3</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">text</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">25 min</p>
                                                        </td>
                                                        <td>
                                                            <span class="dashboard__quiz-result">
                                                                active
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="dashboard__review-action">
                                                                <a href="${pageContext.request.contextPath}/manage-lessons?action=edit&id=7"
                                                                    title="Edit"><i class="skillgro-edit"></i></a>
                                                                <a href="#"
                                                                    onclick="confirmDelete('7')"
                                                                    title="Delete"><i class="skillgro-bin"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <p class="color-black">8</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Collections Framework</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">Section 3</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">quiz</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">40 min</p>
                                                        </td>
                                                        <td>
                                                            <span class="dashboard__quiz-result">
                                                                active
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="dashboard__review-action">
                                                                <a href="${pageContext.request.contextPath}/manage-lessons?action=edit&id=8"
                                                                    title="Edit"><i class="skillgro-edit"></i></a>
                                                                <a href="#"
                                                                    onclick="confirmDelete('8')"
                                                                    title="Delete"><i class="skillgro-bin"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Pagination -->
                                        <nav aria-label="Page navigation" style="margin-top: 30px">
                                            <ul class="pagination justify-content-center">
                                                <c:if test="${currentPage > 1}">
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                            href="${paginationUrl}&page=${currentPage - 1}"
                                                            aria-label="Previous">
                                                            <span aria-hidden="true">&laquo;</span>
                                                        </a>
                                                    </li>
                                                </c:if>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link"
                                                            href="${paginationUrl}&page=${i}">${i}</a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                            href="${paginationUrl}&page=${currentPage + 1}"
                                                            aria-label="Next">
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
            </div>
        </section>
    </main>
    <!-- main-area-end -->

    <!-- footer-area -->
    <jsp:include page="../../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../common/js-file.jsp"></jsp:include>

    <script>
        function confirmDelete(lessonId) {
            if (confirm('Are you sure you want to delete this lesson?')) {
                window.location.href = '${pageContext.request.contextPath}/manage-lessons?action=delete&id=' + lessonId;
            }
        }
    </script>

    <script>
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
                    }).then(response => {
                        if (!response.ok) {
                            console.error('Failed to remove toast attributes');
                        }
                    }).catch(error => {
                        console.error('Error:', error);
                    });
                }
            });
        }
    </script>
</body>

</html> 