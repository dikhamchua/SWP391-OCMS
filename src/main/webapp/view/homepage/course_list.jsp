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
                                                <p>Showing 250 total results</p>
                                            </div>
                                        </div>
                                        <div class="col-md-7">
                                            <div class="d-flex justify-content-center justify-content-md-end align-items-center flex-wrap">
                                                <div class="courses-top-right m-0 ms-md-auto">
                                                    <span class="sort-by">Sort By:</span>
                                                    <div class="courses-top-right-select">
                                                        <select name="orderby" class="orderby">
                                                            <option value="Most Popular">Most Popular</option>
                                                            <option value="popularity">popularity</option>
                                                            <option value="average rating">average rating</option>
                                                            <option value="latest">latest</option>
                                                            <option value="latest">latest</option>
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
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="${currentPage == i ? 'active' : ''}">
                                                    <a href="course-list?page=${i}${keyword != null ? '&search='.concat(keyword) : ''}">${i}</a>
                                                </li>
                                            </c:forEach>
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
    </body>

</html>