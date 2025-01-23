<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!doctype html>
        <html class="no-js" lang="en">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <title>SkillGro - Manage Accounts</title>
            <meta name="description" content="SkillGro - Manage Accounts">
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
            <c:url value="/manage-account" var="paginationUrl">
                <c:if test="${not empty param.role}">
                    <c:param name="role" value="${param.role}" />
                </c:if>
                <c:if test="${not empty param.gender}">
                    <c:param name="gender" value="${param.gender}" />
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
                    <div class="container">
                        <jsp:include page="../../common/dashboard/avatar.jsp"></jsp:include>

                        <div class="dashboard__inner-wrap">
                            <div class="row">
                                <jsp:include page="../../common/dashboard/sideBar.jsp"></jsp:include>
                                <div class="col-lg-9">
                                    <div class="dashboard__content-wrap">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Manage Accounts</h4>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/manage-account" method="GET"
                                            class="mb-4">
                                            <div class="row mb-3">
                                                <div class="col-md-2">
                                                    <select class="form-select" id="roleFilter" name="role">
                                                        <option value="">All Roles</option>
                                                        <option value="2" ${param.role=='2' ? 'selected' : '' }>Teacher
                                                        </option>
                                                        <option value="3" ${param.role=='3' ? 'selected' : '' }>Student
                                                        </option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select" id="genderFilter" name="gender">
                                                        <option value="">Gender</option>
                                                        <option value="2" ${param.gender=='2' ? 'selected' : '' }>Male
                                                        </option>
                                                        <option value="3" ${param.gender=='3' ? 'selected' : '' }>Female
                                                        </option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select" id="statusFilter" name="status">
                                                        <option value="">All Status</option>
                                                        <option value="true" ${param.status=='true' ? 'selected' : '' }>
                                                            Active</option>
                                                        <option value="false" ${param.status=='false' ? 'selected' : ''
                                                            }>Non-active</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-3">
                                                    <input type="text" class="form-control" id="searchFilter"
                                                        name="search" placeholder="Search by email..."
                                                        value="${param.search}">
                                                </div>
                                                <div class="col-md-3">
                                                    <button type="submit" style="width: 100%; background-color: #007aff"
                                                        class="form-control text-light">
                                                        <i class="fa fa-search mr-4"></i>
                                                        Filter
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="dashboard__review-table">
                                                    <table class="table table-borderless">
                                                        <!-- ... table header ... -->
                                                        <thead>
                                                            <tr>
                                                                <th>Account ID</th>
                                                                <th>Email</th>
                                                                <th>Role</th>
                                                                <th>Status</th>
                                                                <th style="text-align: center;">Action</th>
                                                            </tr>
                                                        </thead>
                                                        <c:forEach var="account" items="${nonAdminAccounts}">
                                                            <tr>
                                                                <td>
                                                                    <p class="color-black">${account.id}</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">${account.email}</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">${accountDetails.roleId == 1
                                                                        ? 'Admin' : accountDetails.roleId == 2 ?
                                                                        'Teacher' : 'Student'}</p>
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class="dashboard__quiz-result ${account.isActive ? '' : 'fail'}">
                                                                        ${account.isActive ? 'Active' : 'Non-active'}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-account?action=edit&id=${account.id}"
                                                                            title="Edit"><i
                                                                                class="skillgro-edit"></i></a>
                                                                        <a href="#"
                                                                            onclick="confirmDeactivate(${account.id})"
                                                                            title="Deactivate"><i
                                                                                class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
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
                function confirmDeactivate(accountId) {
                    if (confirm('Are you sure you want to deactivate this account?')) {
                        window.location.href = '${pageContext.request.contextPath}/manage-account?action=deactivate&id=' + accountId;
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