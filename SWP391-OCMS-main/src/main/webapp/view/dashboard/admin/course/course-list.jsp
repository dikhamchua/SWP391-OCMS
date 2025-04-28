<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://example.com/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Quản lý khóa học</title>
    <meta name="description" content="SkillGro - Quản lý khóa học">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../../common/css-file.jsp"></jsp:include>
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
    <c:url value="/manage-course" var="paginationUrl">
        <c:param name="action" value="list" />
        <c:if test="${not empty param.categoryId}">
            <c:param name="categoryId" value="${param.categoryId}" />
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
                <jsp:include page="../../../common/dashboard/avatar.jsp"></jsp:include>

                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <jsp:include page="../../../common/dashboard/sideBar.jsp"></jsp:include>
                        <div class="col-lg-9">
                            <div class="dashboard__content-wrap">
                                <div class="dashboard__content-title">
                                    <div class="title d-flex justify-content-between align-items-center">
                                        <h4>Quản lý khóa học</h4>
                                        <a href="${pageContext.request.contextPath}/manage-course?action=add"
                                            class="btn btn-primary">
                                            <i class="fas fa-plus"></i> Thêm khóa học mới
                                        </a>
                                    </div>
                                </div>
                                <form action="${pageContext.request.contextPath}/manage-course" method="GET"
                                    class="mb-4">
                                    <div class="row mb-3">
                                        <div class="col-md-3">
                                            <select class="form-select" id="categoryFilter" name="categoryId">
                                                <option value="">Tất cả danh mục</option>
                                                <c:forEach var="entry" items="${categoryMap}">
                                                    <option value="${entry.key}" ${param.categoryId==entry.key
                                                        ? 'selected' : '' }>
                                                        ${entry.value.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <select class="form-select" id="statusFilter" name="status">
                                                <option value="">Tất cả trạng thái</option>
                                                <option value="active" ${param.status=='active' ? 'selected'
                                                    : '' }>Hoạt động</option>
                                                <option value="inactive" ${param.status=='inactive' ? 'selected'
                                                    : '' }>Không hoạt động</option>
                                                <option value="draft" ${param.status=='draft' ? 'selected'
                                                    : '' }>Bản nháp</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="text" class="form-control" id="searchFilter"
                                                name="search" placeholder="Tìm kiếm khóa học..."
                                                value="${param.search}">
                                        </div>
                                        <div class="col-md-3">
                                            <button type="submit" style="width: 100%; background-color: #007aff"
                                                class="form-control text-light">
                                                <i class="fa fa-search mr-4"></i>
                                                Lọc
                                            </button>
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
                                                        <th>Hình ảnh</th>
                                                        <th>Tên khóa học</th>
                                                        <th>Danh mục</th>
                                                        <th>Tác giả</th>
                                                        <th>Đánh giá</th>
                                                        <th>Giá</th>
                                                        <th>Trạng thái</th>
                                                        <th>Ngày tạo</th>
                                                        <th>Ngày cập nhật</th>
                                                        <th style="text-align: center;">Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <c:forEach var="course" items="${courses}">
                                                    <tr>
                                                        <td>
                                                            <p class="color-black">${course.id}</p>
                                                        </td>
                                                        <td>
                                                            <img src="${pageContext.request.contextPath}/assets/img/courses/${course.thumbnail}"
                                                                alt="Course thumbnail" class="img-thumbnail"
                                                                style="width: 100px; height: 60px; object-fit: cover;">
                                                        </td>
                                                        <td>
                                                            <p class="color-black">${course.name}</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">
                                                                ${categoryMap[course.categoryId].name}</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">${accountMap[course.createdBy].username}</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">${course.rating}/5 <i class="fas fa-star" style="color: #FFD700;"></i></p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">$${course.price}</p>
                                                        </td>
                                                        <td>
                                                            <span
                                                                class="dashboard__quiz-result ${course.status == 'active' ? '' : 'fail'}">
                                                                ${course.status}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">${fn:formatDate(course.createdDate, "dd-MM-yyyy HH:mm:ss")}</p>
                                                        </td>
                                                        <td>
                                                            <p class="color-black">${fn:formatDate(course.modifiedDate, "dd-MM-yyyy HH:mm:ss")}</p>
                                                        </td>
                                                        <td>
                                                            <div class="dashboard__review-action">
                                                                <a href="${pageContext.request.contextPath}/manage-course?action=manage&id=${course.id}"
                                                                    title="Chỉnh sửa"><i
                                                                        class="skillgro-edit"></i></a>
                                                                <c:choose>
                                                                    <c:when test="${course.status == 'active'}">
                                                                        <a href="#"
                                                                            onclick="confirmDeactivate(${course.id})"
                                                                            title="Vô hiệu hóa"><i
                                                                                class="skillgro-bin"></i></a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="#"
                                                                            onclick="confirmActivate(${course.id})"
                                                                            title="Kích hoạt"><i
                                                                                class="fas fa-check-circle" style="color: #28a745;"></i></a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </table>
                                        </div>

                                        <!-- Phân trang -->
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
    <jsp:include page="../../../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../../common/js-file.jsp"></jsp:include>

    <script>
        function confirmDeactivate(courseId) {
            if (confirm('Bạn có chắc chắn muốn vô hiệu hóa khóa học này?')) {
                window.location.href = '${pageContext.request.contextPath}/manage-course?action=deactivate&id=' + courseId;
            }
        }
        
        function confirmActivate(courseId) {
            if (confirm('Bạn có chắc chắn muốn kích hoạt khóa học này?')) {
                window.location.href = '${pageContext.request.contextPath}/manage-course?action=activate&id=' + courseId;
            }
        }
    </script>

    <script>
        // Hiển thị thông báo
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage) {
            iziToast.show({
                title: toastType === 'success' ? 'Thành công' : 'Lỗi',
                message: toastMessage,
                position: 'topRight',
                color: toastType === 'success' ? 'green' : 'red',
                timeout: 5000,
                onClosing: function () {
                    // Xóa thông báo khỏi session sau khi hiển thị
                    fetch('${pageContext.request.contextPath}/remove-toast', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                    }).then(response => {
                        if (!response.ok) {
                            console.error('Không thể xóa thông báo');
                        }
                    }).catch(error => {
                        console.error('Lỗi:', error);
                    });
                }
            });
        }
    </script>
</body>

</html>
