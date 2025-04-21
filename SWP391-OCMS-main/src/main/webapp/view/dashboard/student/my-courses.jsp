<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - My Courses</title>
    <meta name="description" content="SkillGro - My Courses">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/css-file.jsp"></jsp:include>
    
    <style>
        .course-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            overflow: hidden;
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        
        .course-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateY(-5px);
        }
        
        .course-image {
            position: relative;
            overflow: hidden;
            height: 180px;
        }
        
        .course-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .course-content {
            padding: 15px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        
        .course-description {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
            flex-grow: 1;
        }
        
        .course-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .learn-btn {
            display: inline-block;
            padding: 8px 20px;
            background-color: #2b4eff;
            color: #fff;
            border-radius: 5px;
            text-align: center;
            transition: all 0.3s ease;
            align-self: flex-start;
        }
        
        .learn-btn:hover {
            background-color: #1a3bcc;
            color: #fff;
        }
        
        .view-options {
            margin-bottom: 20px;
        }
        
        .view-option {
            margin-right: 15px;
        }
        
        .search-box {
            position: relative;
            margin-bottom: 20px;
        }
        
        .search-box input {
            padding-left: 35px;
            border-radius: 20px;
        }
        
        .search-box i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }
        
        .pagination .page-item .page-link {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 5px;
            border-radius: 5px;
            font-weight: 500;
            color: #333;
            border: 1px solid #dee2e6;
        }
        
        .pagination .page-item.active .page-link {
            background-color: #4169e1;
            border-color: #4169e1;
            color: white;
        }
        
        .pagination .page-item.disabled .page-link {
            background-color: #f0f0f0;
            color: #999;
            cursor: not-allowed;
        }
        
        .pagination .page-item:not(.active):not(.disabled) .page-link:hover {
            background-color: #f8f9fa;
            color: #4169e1;
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
    <jsp:include page="../../common/home/header-home.jsp"></jsp:include>
    <!-- header-area-end -->

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
                                <div class="dashboard__content-title mb-4">
                                    <h4 class="title">My Courses</h4>
                                </div>
                                
                                <!-- Search and View Options -->
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <div class="search-box">
                                            <i class="fas fa-search"></i>
                                            <input type="text" class="form-control" id="searchInput" placeholder="Search course...">
                                        </div>
                                    </div>
                                    <div class="col-md-6 text-md-end">
                                        <div class="view-options d-flex justify-content-md-end">
                                            <div class="view-option">
                                                <input type="checkbox" id="imageView" checked>
                                                <label for="imageView">Image</label>
                                            </div>
                                            <div class="view-option">
                                                <input type="checkbox" id="titleView" checked>
                                                <label for="titleView">Title</label>
                                            </div>
                                            <div class="view-option">
                                                <input type="checkbox" id="nameView" checked>
                                                <label for="nameView">Course Name</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Page Size Selection -->
                                <div class="row mb-4">
                                    <div class="col-12 text-end">
                                        <div class="d-flex align-items-center justify-content-end">
                                            <span class="me-2">Items per page:</span>
                                            <select class="form-select" id="pageSizeSelect" style="width: auto;">
                                                <option value="10" ${param.pageSize == '10' || empty param.pageSize ? 'selected' : ''}>10</option>
                                                <option value="20" ${param.pageSize == '20' ? 'selected' : ''}>20</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Course Items -->
                                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="courseContainer">
                                    <c:forEach items="${paginatedCourses}" var="course">
                                        <div class="col course-item">
                                            <div class="course-card">
                                                <div class="course-image">
                                                    <img src="${pageContext.request.contextPath}/assets/img/course/${course.thumbnail}" alt="${course.name}">
                                                </div>
                                                <div class="course-content">
                                                    <p class="course-description">${course.description}</p>
                                                    <h5 class="course-name">${course.name}</h5>
                                                    <a href="${pageContext.request.contextPath}/course-details?id=${course.id}" class="learn-btn">Learn</a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    
                                    <c:if test="${empty paginatedCourses}">
                                        <div class="col-12 text-center py-5">
                                            <h5>You haven't enrolled in any courses yet.</h5>
                                            <a href="${pageContext.request.contextPath}/course-list" class="btn btn-primary mt-3">Browse Courses</a>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <!-- Pagination -->
                                <c:if test="${not empty paginatedCourses && totalPages > 1}">
                                    <div class="pagination-wrap mt-4">
                                        <nav aria-label="Page navigation">
                                            <ul class="pagination justify-content-center">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/my-courses?page=1&pageSize=${param.pageSize}" aria-label="First">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                                
                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/my-courses?page=${i}&pageSize=${param.pageSize}">${i}</a>
                                                    </li>
                                                </c:forEach>
                                                
                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/my-courses?page=${totalPages}&pageSize=${param.pageSize}" aria-label="Last">
                                                        <span aria-hidden="true">&raquo;</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </div>
                                </c:if>
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
        $(document).ready(function() {
            // Handle view options
            $('#imageView').change(function() {
                $('.course-image').toggle($(this).is(':checked'));
            });
            
            $('#titleView').change(function() {
                $('.course-description').toggle($(this).is(':checked'));
            });
            
            $('#nameView').change(function() {
                $('.course-name').toggle($(this).is(':checked'));
            });
            
            // Handle page size selection
            $('#pageSizeSelect').change(function() {
                const pageSize = $(this).val();
                window.location.href = '${pageContext.request.contextPath}/my-courses?page=1&pageSize=' + pageSize;
            });
            
            // Handle search functionality
            $('#searchInput').on('keyup', function() {
                const searchText = $(this).val().toLowerCase();
                
                $('.course-item').each(function() {
                    const courseName = $(this).find('.course-name').text().toLowerCase();
                    const courseDesc = $(this).find('.course-description').text().toLowerCase();
                    
                    if(courseName.includes(searchText) || courseDesc.includes(searchText)) {
                        $(this).show();
                    } else {
                        $(this).hide();
                    }
                });
            });
        });
    </script>

    <!-- Toast message display -->
    <script>
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