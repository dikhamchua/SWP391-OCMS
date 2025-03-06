<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Manage Registration</title>
    <meta name="description" content="SkillGro - Manage Accounts">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

<!-- CSS here -->
<jsp:include page="../../common/css-file.jsp"></jsp:include>

<!-- Bootstrap CSS -->
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

    <c:url value="/manage-registration" var="paginationUrl">
        <c:param name="action" value="list" />
        <c:if test="${not empty param.category}">
            <c:param name="category" value="${param.category}" />
        </c:if>
        <c:if test="${not empty param.fromDate}">
            <c:param name="fromDate" value="${param.fromDate}" />
        </c:if>
        <c:if test="${not empty param.toDate}">
            <c:param name="toDate" value="${param.toDate}" />
        </c:if>
        <c:if test="${not empty param.status}">
            <c:param name="status" value="${param.status}" />
        </c:if>
        <c:if test="${not empty param.search}">
            <c:param name="search" value="${param.search}" />
        </c:if>
        <c:if test="${not empty param.pageSize}">
            <c:param name="pageSize" value="${param.pageSize}" />
        </c:if>
        <c:if test="${not empty paramValues.optionChoice}">
            <c:forEach items="${paramValues.optionChoice}" var="column">
                <c:param name="optionChoice" value="${column}" />
            </c:forEach>
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
                                <!-- Title and Buttons Row -->
                                <div class="row mb-4">
                                    <div class="col">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Registration List</h4>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <button class="btn btn-primary rounded-pill" data-bs-toggle="modal" data-bs-target="#settingModal">
                                            <i class="fa fa-cog me-2"></i> Setting View
                                        </button>
                                    </div>
                                </div>

                                <!-- Filter Form -->
                                <form action="${pageContext.request.contextPath}/manage-registration" method="GET">
                                    <input type="hidden" name="action" value="list">
                                    
                                    <!-- First Row of Filters -->
                                    <div class="row mb-3">
                                        <div class="col-md-3">
                                            <select class="form-select" name="category">
                                                <option value="">Course</option>
                                                <c:forEach items="${courses}" var="course">
                                                    <option value="${course.id}" ${param.category == course.id ? 'selected' : ''}>
                                                        ${course.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="date" class="form-control" name="fromDate" 
                                                   value="${param.fromDate}">
                                        </div>
                                        <div class="col-md-1 d-flex align-items-center justify-content-center">
                                            <span>To</span>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="date" class="form-control" name="toDate" 
                                                   value="${param.toDate}">
                                        </div>
                                    </div>
                                    <!-- Second Row of Filters -->
                                    <div class="row mb-3">
                                        <div class="col-md-3">
                                            <select class="form-select" name="status">
                                                <option value="">Status</option>
                                                <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Active</option>
                                                <option value="Inactive" ${param.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <input type="number" class="form-control" name="pageSize" 
                                                   value="${pageSize}"
                                                   placeholder="Size">
                                        </div>
                                        <div class="col-md-5">
                                            <input type="text" class="form-control" name="search" 
                                                   value="${param.search}" placeholder="search by name, email">
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-primary w-100 rounded-pill">
                                                <i class="fa fa-search me-2"></i>Filter
                                            </button>
                                        </div>
                                    </div>
                                </form>

                                <div class="row">
                                    <div class="col-12">
                                        <div class="dashboard__review-table">
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <c:if test="${not empty listColum && listColum.contains('idChoice')}">
                                                            <th>ID</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('nameChoice')}">
                                                            <th>Name</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('emailChoice')}">
                                                            <th>Email</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('registrationTimeChoice')}">
                                                            <th>Registration Time</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('categoryChoice')}">
                                                            <th>Course</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('packageChoice')}">
                                                            <th>Package</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('totalCostChoice')}">
                                                            <th>Total Cost</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('statusChoice')}">
                                                            <th>Status</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('validFromChoice')}">
                                                            <th>Valid From</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('validToChoice')}">
                                                            <th>Valid To</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('lastUpdatedByChoice')}">
                                                            <th>Last Updated By</th>
                                                        </c:if>
                                                        <c:if test="${not empty listColum && listColum.contains('actionChoice')}">
                                                            <th>Action</th>
                                                        </c:if>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${registrations}" var="reg">
                                                        <tr>
                                                            <c:if test="${not empty listColum && listColum.contains('idChoice')}">
                                                                <td>${reg.id}</td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('nameChoice')}">
                                                                <td>${accountNames[reg.accountId]}</td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('emailChoice')}">
                                                                <td>${reg.email}</td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('registrationTimeChoice')}">
                                                                <td><fmt:formatDate value="${reg.registrationTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('categoryChoice')}">
                                                                <td>${courseNames[reg.courseId]}</td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('packageChoice')}">
                                                                <td>${reg.packages}</td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('totalCostChoice')}">
                                                                <td><fmt:formatNumber value="${reg.totalCost}" type="currency"/></td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('statusChoice')}">
                                                                <td>
                                                                   <span
                                                                           class="dashboard__quiz-result ${reg.status == 'Active' ? '' : 'fail'}">
                                                                           ${reg.status}
                                                                   </span>
                                                                </td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('validFromChoice')}">
                                                                <td><fmt:formatDate value="${reg.validFrom}" pattern="dd/MM/yyyy"/></td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('validToChoice')}">
                                                                <td><fmt:formatDate value="${reg.validTo}" pattern="dd/MM/yyyy"/></td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('lastUpdatedByChoice')}">
                                                                <td>${lastUpdatedByNames[reg.lastUpdateByPerson]}</td>
                                                            </c:if>
                                                            <c:if test="${not empty listColum && listColum.contains('actionChoice')}">
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-registration?action=edit&id=${reg.id}" 
                                                                           title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#" onclick="confirmDelete(${reg.id})" 
                                                                           title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </c:if>
                                                        </tr>
                                                    </c:forEach>
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

    <!-- 1. First jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- 2. Then include modal setting -->
    <jsp:include page="registration_list_setting.jsp"></jsp:include>

    <!-- 3. Then other JS files -->
    <jsp:include page="../../common/js-file.jsp"></jsp:include>

    <script>
        function confirmDeactivate(registrationId) {
            if (confirm('Are you sure you want to deactivate this registration?')) {
                window.location.href = '${pageContext.request.contextPath}/manage-registration?action=deactivate&id=' + registrationId;
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

    <!-- 4. Finally your custom scripts -->
    <script>
        $(document).ready(function() {
            // Xử lý đóng modal
            $('.close, .btn-secondary[data-dismiss="modal"]').click(function() {
                $('#settingModal').modal('hide');
            });

            // Xử lý mở modal
            $('[data-toggle="modal"]').click(function() {
                $('#settingModal').modal('show');
            });
        });
    </script>

    <script>
    function changePageSize(size) {
        let url = new URL(window.location.href);
        url.searchParams.set('pageSize', size);
        url.searchParams.set('page', '1'); // Reset to first page when changing page size
        window.location.href = url.toString();
    }
    </script>
</body>

</html>