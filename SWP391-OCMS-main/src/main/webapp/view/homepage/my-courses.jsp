<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!doctype html>
                <html class="no-js" lang="en">

                <head>
                    <meta charset="utf-8">
                    <meta http-equiv="x-ua-compatible" content="ie=edge">
                    <title>SkillGro - My Courses</title>
                    <meta name="description" content="SkillGro - My Courses">
                    <meta name="viewport" content="width=device-width, initial-scale=1">

                    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">
                    <!-- Place favicon.ico in the root directory -->

                    <!-- CSS here -->
                    <jsp:include page="../common/home/css-home.jsp" />

                    <!-- Toast CSS -->
                    <link href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" rel="stylesheet">

                    <style>
                        .course-card {
                            border: 1px solid #eee;
                            border-radius: 8px;
                            overflow: hidden;
                            transition: all 0.3s ease;
                            margin-bottom: 30px;
                        }

                        .course-card:hover {
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                            transform: translateY(-5px);
                        }

                        .course-image {
                            height: 200px;
                            object-fit: cover;
                            width: 100%;
                        }

                        .course-content {
                            padding: 20px;
                        }

                        .course-title {
                            font-size: 18px;
                            margin-bottom: 10px;
                            font-weight: 600;
                        }

                        .course-meta {
                            display: flex;
                            justify-content: space-between;
                            margin-bottom: 15px;
                            color: #777;
                            font-size: 14px;
                        }

                        .course-footer {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: 15px 20px;
                            background-color: #f8f9fa;
                            border-top: 1px solid #eee;
                        }

                        .empty-courses {
                            text-align: center;
                            padding: 50px 0;
                        }

                        .empty-courses i {
                            font-size: 60px;
                            color: #ddd;
                            margin-bottom: 20px;
                        }

                        .filter-section {
                            background-color: #f8f9fa;
                            padding: 20px;
                            border-radius: 8px;
                            margin-bottom: 30px;
                        }

                        .pagination-container {
                            display: flex;
                            justify-content: center;
                            margin-top: 30px;
                        }

                        .course-card {
                            display: flex;
                            flex-direction: column;
                            justify-content: space-between;
                            height: 100%;
                            /* Quan trọng */
                            border: 1px solid #eee;
                            border-radius: 8px;
                            overflow: hidden;
                            transition: all 0.3s ease;
                            margin-bottom: 30px;
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
                    <jsp:include page="../common/home/header-home.jsp"></jsp:include>
                    <!-- header-area-end -->

                    <!-- main-area -->
                    <main class="main-area fix">
                        <section class="breadcrumb-area breadcrumb-bg"
                            data-background="${pageContext.request.contextPath}/assets/img/bg/breadcrumb_bg.jpg">
                            <div class="container">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="breadcrumb-content">
                                            <h3 class="title">Khóa học của tôi</h3>
                                            <nav class="breadcrumb">
                                                <span property="itemListElement" typeof="ListItem">Học tập của
                                                    tôi</span>
                                            </nav>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="my-courses-area section-py-120">
                            <div class="container">
                                <!-- Filter Section -->
                                <div class="filter-section">
                                    <form action="${pageContext.request.contextPath}/my-courses" method="GET"
                                        id="filterForm">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label for="category">Danh mục:</label>
                                                    <select class="form-control" id="category" name="category"
                                                        onchange="document.getElementById('filterForm').submit()">
                                                        <option value="">Tất cả danh mục</option>
                                                        <c:forEach items="${categories}" var="category">
                                                            <option value="${category.id}" ${categoryId==category.id
                                                                ? 'selected' : '' }>${category.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="search">Tìm kiếm:</label>
                                                    <div class="input-group">
                                                        <input type="text" class="form-control" id="search"
                                                            name="search" placeholder="Tìm kiếm theo tên khóa học..."
                                                            value="${search}">
                                                        <div class="input-group-append">
                                                            <button class="btn btn-primary" type="submit">
                                                                <i class="fas fa-search"></i> Tìm kiếm
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label>&nbsp;</label>
                                                    <button type="button" class="btn btn-secondary btn-block"
                                                        onclick="resetFilters()">
                                                        <i class="fas fa-redo"></i> Đặt lại
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <!-- Display courses -->
                                <c:choose>
                                    <c:when test="${empty myCourses}">
                                        <div class="col-12">
                                            <div class="empty-courses">
                                                <i class="fas fa-book-reader"></i>
                                                <h5>Bạn chưa đăng ký khóa học nào</h5>
                                                <p>Hãy khám phá danh mục khóa học của chúng tôi và tìm những khóa học
                                                    phù hợp với sở thích của bạn.</p>
                                                <a href="${pageContext.request.contextPath}/course-list"
                                                    class="btn btn-primary mt-3">Khám phá khóa học</a>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Thông báo hiển thị số lượng -->
                                        <div class="row mb-4">
                                            <div class="col-12">
                                                <h5>Hiển thị ${(currentPage-1)*pageSize + 1} -
                                                    ${Math.min(currentPage*pageSize, totalCourses*1)} trong tổng số
                                                    ${totalCourses} khóa học</h5>
                                            </div>
                                        </div>

                                        <!-- Danh sách khóa học -->
                                        <!-- Danh sách khóa học -->
                                        <div class="row course-list align-items-stretch">
                                            <c:forEach items="${myCourses}" var="course">
                                                <div class="col-lg-4 col-md-6 mb-4 d-flex">
                                                    <div class="course-card w-100 d-flex flex-column h-100">
                                                        <!-- Thumbnail -->
                                                        <a
                                                            href="${pageContext.request.contextPath}/my-courses?action=details&id=${course.id}">
                                                            <img src="${pageContext.request.contextPath}/assets/img/courses/${course.thumbnail}"
                                                                alt="${course.name}" class="course-image"
                                                                onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/courses/default.jpg';" />
                                                        </a>

                                                        <!-- Nội dung khóa học -->
                                                        <div class="course-content">
                                                            <h3 class="course-title">
                                                                <a
                                                                    href="${pageContext.request.contextPath}/my-courses?action=details&id=${course.id}">
                                                                    ${course.name}
                                                                </a>
                                                            </h3>
                                                            <div class="course-meta">
                                                                <span>Đánh giá: ${course.rating}/5</span>
                                                                <span>Trạng thái: ${registrationMap[course.id]}</span>
                                                            </div>
                                                            <div class="course-description">
                                                                <p>
                                                                    ${fn:substring(course.description, 0, 100)}
                                                                    <c:if test="${fn:length(course.description) > 100}">
                                                                        ...</c:if>
                                                                </p>
                                                            </div>
                                                        </div>

                                                        <!-- Footer -->
                                                        <div class="course-footer mt-auto">
                                                            <span
                                                                class="badge ${registrationMap[course.id] == 'Active' ? 'bg-success' : 'bg-warning'}">
                                                                ${registrationMap[course.id]}
                                                            </span>
                                                            <c:choose>
                                                                <c:when
                                                                    test="${registrationMap[course.id] != 'Pending'}">
                                                                    <a href="${pageContext.request.contextPath}/my-courses?action=details&id=${course.id}"
                                                                        class="btn btn-sm btn-primary">Chi tiết</a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Chờ phê duyệt</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <!-- Pagination -->
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="pagination-container">
                                                    <nav aria-label="Page navigation">
                                                        <ul class="pagination">
                                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                                <a class="page-link"
                                                                    href="${pageContext.request.contextPath}/my-courses?page=1&category=${categoryId}&search=${search}"
                                                                    aria-label="First">
                                                                    <span aria-hidden="true">&laquo;&laquo;</span>
                                                                </a>
                                                            </li>
                                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                                <a class="page-link"
                                                                    href="${pageContext.request.contextPath}/my-courses?page=${currentPage - 1}&category=${categoryId}&search=${search}"
                                                                    aria-label="Previous">
                                                                    <span aria-hidden="true">&laquo;</span>
                                                                </a>
                                                            </li>

                                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                                <c:choose>
                                                                    <c:when test="${i == currentPage}">
                                                                        <li class="page-item active"><span
                                                                                class="page-link">${i}</span></li>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <li class="page-item">
                                                                            <a class="page-link"
                                                                                href="${pageContext.request.contextPath}/my-courses?page=${i}&category=${categoryId}&search=${search}">${i}</a>
                                                                        </li>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>

                                                            <li
                                                                class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                                <a class="page-link"
                                                                    href="${pageContext.request.contextPath}/my-courses?page=${currentPage + 1}&category=${categoryId}&search=${search}"
                                                                    aria-label="Next">
                                                                    <span aria-hidden="true">&raquo;</span>
                                                                </a>
                                                            </li>
                                                            <li
                                                                class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                                <a class="page-link"
                                                                    href="${pageContext.request.contextPath}/my-courses?page=${totalPages}&category=${categoryId}&search=${search}"
                                                                    aria-label="Last">
                                                                    <span aria-hidden="true">&raquo;&raquo;</span>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </nav>
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </section>
                    </main>
                    <!-- main-area-end -->

                    <!-- footer-area -->
                    <jsp:include page="../common/home/footer-home.jsp"></jsp:include>
                    <!-- footer-area-end -->

                    <!-- JS here -->
                    <jsp:include page="../common/home/js-home.jsp" />

                    <!-- Toast JS -->
                    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>

                    <script>
                        // Function to show toast message
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

                        // Function to reset filters
                        function resetFilters() {
                            document.getElementById('category').value = '';
                            document.getElementById('search').value = '';
                            document.getElementById('filterForm').submit();
                        }

                        // Check for session messages and display toast

                    </script>
                </body>

                </html>