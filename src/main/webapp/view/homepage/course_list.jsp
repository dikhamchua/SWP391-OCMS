<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Online Courses & Education Template</title>
        <meta name="description" content="SkillGro - Online Courses & Education Template">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <jsp:include page="../common/css-file.jsp"></jsp:include>

        <style>
            .pagination__wrap .disabled a {
                pointer-events: none;
                opacity: 0.5;
                cursor: not-allowed;
            }
        </style>
    </head>

        <body>

            <!--Preloader-->
            <div id="preloader">
                <div id="loader" class="loader">
                    <div class="loader-container">
                        <div class="loader-icon"><img src="assets/img/logo/preloader.svg" alt="Preloader"></div>
                    </div>
                </div>
            </div>
            <!--Preloader-end -->

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

                <!-- all-courses -->
                <section class="all-courses-area section-py-120">
                    <div class="container">
                        <div class="row">
                            <div class="col-xl-3 col-lg-4 order-2 order-lg-0">
                            <jsp:include page="course_list_aside.jsp"></jsp:include>
                            </div>
                            <div class="col-xl-9 col-lg-8">
                                <div class="courses-top-wrap courses-top-wrap">
                                    <div class="row align-items-center">
                                        <div class="col-md-5">
                                            <div class="courses-top-left">
                                                <p>Showing ${totalRecords} total results</p>
                                            </div>
                                        </div>
                                        <div class="col-md-7">
                                            <div class="d-flex justify-content-center justify-content-md-end align-items-center flex-wrap">
                                                <div class="courses-top-right m-0 ms-md-auto">
                                                    <span class="sort-by">Sort By:</span>
                                                    <div class="courses-top-right-select">
                                                        <select name="orderby" class="orderby">
                                                            <!-- <option value="popularity" <%= "popularity".equals(request.getParameter("sort")) ? "selected" : "" %>>Most Popular</option>
                                                            <option value="average rating" <%= "average rating".equals(request.getParameter("sort")) ? "selected" : "" %>>average rating</option>
                                                            <option value="latest" <%= "latest".equals(request.getParameter("sort")) ? "selected" : "" %>>latest</option> -->

                                                            <!-- <option value="popularity" <c:if test="${param.sort eq 'popularity'}">selected</c:if>>
                                                                Most Popular
                                                            </option> -->
                                                            <option value="average rating desc" <c:if test="${param.sort eq 'average rating desc'}">selected</c:if>>
                                                                Average Rating (High to Low)
                                                            </option>
                                                            <option value="average rating asc" <c:if test="${param.sort eq 'average rating asc'}">selected</c:if>>
                                                                Average Rating (Low to High)
                                                            </option>
                                                            <option value="latest" <c:if test="${param.sort eq 'latest'}">selected</c:if>>
                                                                Latest
                                                            </option>
                                                            <option value="earliest" <c:if test="${param.sort eq 'earliest'}">selected</c:if>>
                                                                Earliest
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-content" id="myTabContent">
                                    <div class="tab-pane fade show active" id="grid" role="tabpanel" aria-labelledby="grid-tab">
                                        <div class="row courses__grid-wrap row-cols-1 row-cols-xl-3 row-cols-lg-2 row-cols-md-2 row-cols-sm-1">
                                        <c:forEach items="${courses}" var="course">
                                            <div class="col">
                                                <div class="courses__item shine__animate-item">
                                                    <div class="courses__item-thumb">
                                                        <a href="course-details.html" class="shine__animate-link">
                                                            <img src="${course.thumbnail}" alt="img">
                                                        </a>
                                                    </div>
                                                    <div class="courses__item-content">
                                                        <ul class="courses__item-meta list-wrap">
                                                            <li class="courses__item-tag">
                                                                <a href="course.html">${categoryNames[course.categoryId]}</a>
                                                            </li>
                                                            <li class="avg-rating"><i class="fas fa-star"></i> (${course.rating} Reviews)</li>
                                                        </ul>
                                                        <h5 class="title"><a href="course-details.html">${course.name}</a></h5>
                                                        <p class="author">By <a href="#">${authorNames[course.createdBy]}</a></p>
                                                        <div class="courses__item-bottom">
                                                            <div class="button">
                                                                <a href="course-details.html">
                                                                    <span class="text">Enroll Now</span>
                                                                    <i class="flaticon-arrow-right"></i>
                                                                </a>
                                                            </div>
                                                            <h5 class="price">$${course.price}</h5>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <nav class="pagination__wrap mt-30">
                                        <ul class="list-wrap">
                                            <%-- First and Previous buttons --%>
                                            <li class="${currentPage == 1 ? 'disabled' : ''}">
                                                <c:url var="firstUrl" value="/course-list">
                                                    <c:param name="page" value="1"/>
                                                    <c:param name="search" value="${param.search}"/>
                                                    <c:param name="sort" value="${param.sort}"/>
                                                    <c:param name="categories" value="${param.categories}"/>
                                                    <c:param name="ratings" value="${param.ratings}"/>
                                                </c:url>
                                                <a href="${firstUrl}"><i class="fas fa-angle-double-left"></i></a>
                                            </li>
                                            <li class="${currentPage == 1 ? 'disabled' : ''}">
                                                <c:url var="prevUrl" value="/course-list">
                                                    <c:param name="page" value="${currentPage - 1}"/>
                                                    <c:param name="search" value="${param.search}"/>
                                                    <c:param name="sort" value="${param.sort}"/>
                                                    <c:param name="categories" value="${param.categories}"/>
                                                    <c:param name="ratings" value="${param.ratings}"/>
                                                </c:url>
                                                <a href="${prevUrl}"><i class="fas fa-angle-left"></i></a>
                                            </li>
                                    
                                            <%-- Dynamic page numbers --%>
                                            <c:set var="maxVisiblePages" value="5" />
                                            <c:set var="halfVisible" value="${(maxVisiblePages - 1) div 2}" />
                                            
                                            <c:choose>
                                                <c:when test="${totalPages <= maxVisiblePages}">
                                                    <c:set var="startPage" value="1" />
                                                    <c:set var="endPage" value="${totalPages}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <%-- Tính toán startPage và endPage ban đầu --%>
                                                    <c:set var="startPage" value="${currentPage - halfVisible > 1 ? currentPage - halfVisible : 1}" />
                                                    <c:set var="endPage" value="${currentPage + halfVisible < totalPages ? currentPage + halfVisible : totalPages}" />
                                                    
                                                    <%-- Điều chỉnh nếu khoảng trang hiển thị không đủ --%>
                                                    <c:if test="${endPage - startPage < maxVisiblePages - 1}">
                                                        <c:set var="startPage" value="${endPage - maxVisiblePages + 1}" />
                                                        <%-- Đảm bảo startPage không nhỏ hơn 1 --%>
                                                        <c:if test="${startPage < 1}">
                                                            <c:set var="startPage" value="1" />
                                                        </c:if>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                    
                                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                                <c:url var="pageUrl" value="/course-list">
                                                    <c:param name="page" value="${i}"/>
                                                    <c:param name="search" value="${param.search}"/>
                                                    <c:param name="sort" value="${param.sort}"/>
                                                    <c:param name="categories" value="${param.categories}"/>
                                                    <c:param name="ratings" value="${param.ratings}"/>
                                                </c:url>
                                                <li class="${currentPage == i ? 'active' : ''}">
                                                    <a href="${pageUrl}">${i}</a>
                                                </li>
                                            </c:forEach>
                                    
                                            <%-- Next and Last buttons --%>
                                            <li class="${currentPage == totalPages ? 'disabled' : ''}">
                                                <c:url var="nextUrl" value="/course-list">
                                                    <c:param name="page" value="${currentPage + 1}"/>
                                                    <c:param name="search" value="${param.search}"/>
                                                    <c:param name="sort" value="${param.sort}"/>
                                                    <c:param name="categories" value="${param.categories}"/>
                                                    <c:param name="ratings" value="${param.ratings}"/>
                                                </c:url>
                                                <a href="${nextUrl}"><i class="fas fa-angle-right"></i></a>
                                            </li>
                                            <li class="${currentPage == totalPages ? 'disabled' : ''}">
                                                <c:url var="lastUrl" value="/course-list">
                                                    <c:param name="page" value="${totalPages}"/>
                                                    <c:param name="search" value="${param.search}"/>
                                                    <c:param name="sort" value="${param.sort}"/>
                                                    <c:param name="categories" value="${param.categories}"/>
                                                    <c:param name="ratings" value="${param.ratings}"/>
                                                </c:url>
                                                <a href="${lastUrl}"><i class="fas fa-angle-double-right"></i></a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- all-courses-end -->

        </main>
        <!-- main-area-end -->



        <!-- footer-area -->
        <jsp:include page="../common/home/footer-home.jsp"></jsp:include>
            <!-- footer-area-end -->


            <!-- JS here -->
        <jsp:include page="../common/js-file.jsp"></jsp:include>
        <script>
            SVGInject(document.querySelectorAll("img.injectable"));
        </script>
        // Thêm đoạn này vào file course_list.jsp
        <script>
            document.querySelector('.orderby').addEventListener('change', function() {
                const sortValue = this.value;
                
                // Tạo URL mới với tham số sort
                const urlParams = new URLSearchParams(window.location.search);
                urlParams.set('sort', sortValue);
                urlParams.delete('page'); // Reset về page 1 khi thay đổi sort
                
                // Gửi request GET về controller
                window.location.href = window.location.pathname + '?' + urlParams.toString();
            });
        </script>
    </body>

</html>