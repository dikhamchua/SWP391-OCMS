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
    <jsp:include page="../common/home/css-home.jsp" />
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

        <!-- courses-details-area -->
        <section class="courses__details-area section-py-120">
            <div class="container">
                <div class="row">
                    <div class="col-xl-9 col-lg-8">
                        <div class="courses__details-thumb">
                            <img src="${course.thumbnail}" alt="${course.name}">
                        </div>
                        <div class="courses__details-content">
                            <ul class="courses__item-meta list-wrap">
                                <li class="courses__item-tag">
                                    <a href="#">${course.categoryId}</a>
                                </li>
                                <li class="avg-rating"><i class="fas fa-star"></i> (${course.rating} Reviews)</li>
                            </ul>
                            <h2 class="title">${course.name}</h2>
                            <div class="courses__details-meta">
                                <ul class="list-wrap">
                                    <li class="author-two">
                                        <img src="assets/img/courses/course_author001.png" alt="img">
                                        By
                                        <a href="#">${course.createdBy}</a>
                                    </li>
                                    <li class="date"><i class="flaticon-calendar"></i>${course.createdDate}</li>
                                    <li><i class="flaticon-mortarboard"></i>2,250 Students</li>
                                </ul>
                            </div>
                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#overview-tab-pane" type="button" role="tab" aria-controls="overview-tab-pane" aria-selected="true">Overview</button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="curriculum-tab" data-bs-toggle="tab" data-bs-target="#curriculum-tab-pane" type="button" role="tab" aria-controls="curriculum-tab-pane" aria-selected="false">Curriculum</button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="instructors-tab" data-bs-toggle="tab" data-bs-target="#instructors-tab-pane" type="button" role="tab" aria-controls="instructors-tab-pane" aria-selected="false">Instructors</button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews-tab-pane" type="button" role="tab" aria-controls="reviews-tab-pane" aria-selected="false">reviews</button>
                                </li>
                            </ul>
                            <div class="tab-content" id="myTabContent">
                                <div class="tab-pane fade show active" id="overview-tab-pane" role="tabpanel" aria-labelledby="overview-tab" tabindex="0">
                                    <div class="courses__overview-wrap">
                                        <h3 class="title">Course Description</h3>
                                        ${course.description}                                        
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="curriculum-tab-pane" role="tabpanel" aria-labelledby="curriculum-tab" tabindex="0">
                                    <div class="courses__curriculum-wrap">
                                        <h3 class="title">Course Curriculum</h3>
                                        <p>Dorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua Quis ipsum suspendisse ultrices gravida. Risus commodo viverra maecenas accumsan.</p>
                                        <div class="accordion" id="accordionExample">
                                            <div class="accordion-item">
                                                <h2 class="accordion-header" id="headingOne">
                                                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne"  aria-expanded="true" aria-controls="collapseOne">
                                                        Introduction
                                                    </button>
                                                </h2>
                                                <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
                                                    <div class="accordion-body">
                                                        <ul class="list-wrap">
                                                            <li class="course-item open-item">
                                                                <a href="https://www.youtube.com/watch?v=b2Az7_lLh3g" class="course-item-link popup-video">
                                                                    <span class="item-name">Course Installation</span>
                                                                    <div class="course-item-meta">
                                                                        <span class="item-meta duration">03:03</span>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                            <li class="course-item">
                                                                <a href="#" class="course-item-link">
                                                                    <span class="item-name">Create a Simple React App</span>
                                                                    <div class="course-item-meta">
                                                                        <span class="item-meta duration">07:48</span>
                                                                        <span class="item-meta course-item-status">
                                                                            <img src="assets/img/icons/lock.svg" alt="icon">
                                                                        </span>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                            <li class="course-item">
                                                                <a href="#" class="course-item-link">
                                                                    <span class="item-name">React for the Rest of us</span>
                                                                    <div class="course-item-meta">
                                                                        <span class="item-meta duration">10:48</span>
                                                                        <span class="item-meta course-item-status">
                                                                            <img src="assets/img/icons/lock.svg" alt="icon">
                                                                        </span>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="accordion-item">
                                                <h2 class="accordion-header" id="headingTwo">
                                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                                        Capacitance and Inductance
                                                    </button>
                                                </h2>
                                                <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
                                                    <div class="accordion-body">
                                                        <ul class="list-wrap">
                                                            <li class="course-item">
                                                                <a href="#" class="course-item-link">
                                                                    <span class="item-name">Course Installation</span>
                                                                    <div class="course-item-meta">
                                                                        <span class="item-meta duration">07:48</span>
                                                                        <span class="item-meta course-item-status">
                                                                            <img src="assets/img/icons/lock.svg" alt="icon">
                                                                        </span>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                            <li class="course-item">
                                                                <a href="#" class="course-item-link">
                                                                    <span class="item-name">Create a Simple React App</span>
                                                                    <div class="course-item-meta">
                                                                        <span class="item-meta duration">07:48</span>
                                                                        <span class="item-meta course-item-status">
                                                                            <img src="assets/img/icons/lock.svg" alt="icon">
                                                                        </span>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                            <li class="course-item">
                                                                <a href="#" class="course-item-link">
                                                                    <span class="item-name">React for the Rest of us</span>
                                                                    <div class="course-item-meta">
                                                                        <span class="item-meta duration">10:48</span>
                                                                        <span class="item-meta course-item-status">
                                                                            <img src="assets/img/icons/lock.svg" alt="icon">
                                                                        </span>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="accordion-item">
                                                <h2 class="accordion-header" id="headingThree">
                                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                                        Final Audit
                                                    </button>
                                                </h2>
                                                <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree"
                                                    data-bs-parent="#accordionExample">
                                                    <div class="accordion-body">
                                                        <ul class="list-wrap">
                                                            <li class="course-item">
                                                                <a href="#" class="course-item-link">
                                                                    <span class="item-name">Course Installation</span>
                                                                    <div class="course-item-meta">
                                                                        <span class="item-meta duration">07:48</span>
                                                                        <span class="item-meta course-item-status">
                                                                            <img src="assets/img/icons/lock.svg" alt="icon">
                                                                        </span>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                            <li class="course-item">
                                                                <a href="#" class="course-item-link">
                                                                    <span class="item-name">Create a Simple React App</span>
                                                                    <div class="course-item-meta">
                                                                        <span class="item-meta duration">07:48</span>
                                                                        <span class="item-meta course-item-status">
                                                                            <img src="assets/img/icons/lock.svg" alt="icon">
                                                                        </span>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                            <li class="course-item">
                                                                <a href="#" class="course-item-link">
                                                                    <span class="item-name">React for the Rest of us</span>
                                                                    <div class="course-item-meta">
                                                                        <span class="item-meta duration">10:48</span>
                                                                        <span class="item-meta course-item-status">
                                                                            <img src="assets/img/icons/lock.svg" alt="icon">
                                                                        </span>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="instructors-tab-pane" role="tabpanel" aria-labelledby="instructors-tab" tabindex="0">
                                    <div class="courses__instructors-wrap">
                                        <div class="courses__instructors-thumb">
                                            <img src="assets/img/courses/course_instructors.png" alt="img">
                                        </div>
                                        <div class="courses__instructors-content">
                                            <h2 class="title">Mark Jukarberg</h2>
                                            <span class="designation">UX Design Lead</span>
                                            <p class="avg-rating"><i class="fas fa-star"></i>(4.8 Ratings)</p>
                                            <p>Dorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua Quis ipsum suspendisse ultrices gravida. Risus commodo viverra maecenas accumsan.</p>
                                            <div class="instructor__social">
                                                <ul class="list-wrap justify-content-start">
                                                    <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                                    <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                                                    <li><a href="#"><i class="fab fa-whatsapp"></i></a></li>
                                                    <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="reviews-tab-pane" role="tabpanel" aria-labelledby="reviews-tab" tabindex="0">
                                    <div class="courses__rating-wrap">
                                        <h2 class="title">Reviews</h2>
                                        <div class="course-rate">
                                            <div class="course-rate__summary">
                                                <div class="course-rate__summary-value">4.8</div>
                                                <div class="course-rate__summary-stars">
                                                    <i class="fas fa-star"></i>
                                                    <i class="fas fa-star"></i>
                                                    <i class="fas fa-star"></i>
                                                    <i class="fas fa-star"></i>
                                                    <i class="fas fa-star"></i>
                                                </div>
                                                <div class="course-rate__summary-text">
                                                    12 Ratings
                                                </div>
                                            </div>
                                            <div class="course-rate__details">
                                                <div class="course-rate__details-row">
                                                    <div class="course-rate__details-row-star">
                                                        5
                                                        <i class="fas fa-star"></i>
                                                    </div>
                                                    <div class="course-rate__details-row-value">
                                                        <div class="rating-gray"></div>
                                                        <div class="rating" style="width:80%;" title="80%"></div>
                                                        <span class="rating-count">2</span>
                                                    </div>
                                                </div>
                                                <div class="course-rate__details-row">
                                                    <div class="course-rate__details-row-star">
                                                        4
                                                        <i class="fas fa-star"></i>
                                                    </div>
                                                    <div class="course-rate__details-row-value">
                                                        <div class="rating-gray"></div>
                                                        <div class="rating" style="width:50%;" title="50%"></div>
                                                        <span class="rating-count">1</span>
                                                    </div>
                                                </div>
                                                <div class="course-rate__details-row">
                                                    <div class="course-rate__details-row-star">
                                                        3
                                                        <i class="fas fa-star"></i>
                                                    </div>
                                                    <div class="course-rate__details-row-value">
                                                        <div class="rating-gray"></div>
                                                        <div class="rating" style="width:0%;" title="0%"></div>
                                                        <span class="rating-count">0</span>
                                                    </div>
                                                </div>
                                                <div class="course-rate__details-row">
                                                    <div class="course-rate__details-row-star">
                                                        2
                                                        <i class="fas fa-star"></i>
                                                    </div>
                                                    <div class="course-rate__details-row-value">
                                                        <div class="rating-gray"></div>
                                                        <div class="rating" style="width:0%;" title="0%"></div>
                                                        <span class="rating-count">0</span>
                                                    </div>
                                                </div>
                                                <div class="course-rate__details-row">
                                                    <div class="course-rate__details-row-star">
                                                        1
                                                        <i class="fas fa-star"></i>
                                                    </div>
                                                    <div class="course-rate__details-row-value">
                                                        <div class="rating-gray"></div>
                                                        <div class="rating" style="width:0%;" title="0%"></div>
                                                        <span class="rating-count">0</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="course-review-head">
                                            <div class="review-author-thumb">
                                                <img src="assets/img/courses/review-author.png" alt="img">
                                            </div>
                                            <div class="review-author-content">
                                                <div class="author-name">
                                                    <h5 class="name">Jura Hujaor <span>2 Days ago</span></h5>
                                                    <div class="author-rating">
                                                        <i class="fas fa-star"></i>
                                                        <i class="fas fa-star"></i>
                                                        <i class="fas fa-star"></i>
                                                        <i class="fas fa-star"></i>
                                                        <i class="fas fa-star"></i>
                                                    </div>
                                                </div>
                                                <h4 class="title">The best LMS Design System</h4>
                                                <p>Maximus ligula eleifend id nisl quis interdum. Sed malesuada tortor non turpis semper bibendum nisi porta, malesuada risus nonerviverra dolor. Vestibulum ante ipsum primis in faucibus.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-4">
                        <div class="courses__details-sidebar">
                            <div class="courses__details-video">
                                <img src="assets/img/courses/course_thumb02.jpg" alt="img">
                                <a href="https://www.youtube.com/watch?v=YwrHGratByU" class="popup-video"><i class="fas fa-play"></i></a>
                            </div>
                            <div class="courses__cost-wrap">
                                <span>This Course Fee:</span>
                                <h2 class="title">
                                    $${course.price}
                                    <!-- <del>$32.00</del> -->
                                </h2>
                            </div>
                            <div class="courses__information-wrap">
                                <h5 class="title">Course includes:</h5>
                                <ul class="list-wrap">
                                    <li>
                                        <img src="assets/img/icons/course_icon01.svg" alt="img" class="injectable">
                                        Level
                                        <span>Expert</span>
                                    </li>
                                    <!-- <li>
                                        <img src="assets/img/icons/course_icon02.svg" alt="img" class="injectable">
                                        Duration
                                        <span>11h 20m</span>
                                    </li> -->
                                    <!-- <li>
                                        <img src="assets/img/icons/course_icon03.svg" alt="img" class="injectable">
                                        Lessons
                                        <span>12</span>
                                    </li> -->
                                    <li>
                                        <img src="assets/img/icons/course_icon04.svg" alt="img" class="injectable">
                                        Quizzes
                                        <span>145</span>
                                    </li>
                                    <li>
                                        <img src="assets/img/icons/course_icon05.svg" alt="img" class="injectable">
                                        Certifications
                                        <span>Yes</span>
                                    </li>
                                    <li>
                                        <img src="assets/img/icons/course_icon06.svg" alt="img" class="injectable">
                                        Graduation
                                        <span>25K</span>
                                    </li>
                                </ul>
                            </div>
                            <div class="courses__payment">
                                <h5 class="title">Secure Payment:</h5>
                                <img src="assets/img/others/payment.png" alt="img">
                            </div>
                            <div class="courses__details-social">
                                <h5 class="title">Share this course:</h5>
                                <ul class="list-wrap">
                                    <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                    <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                                    <li><a href="#"><i class="fab fa-whatsapp"></i></a></li>
                                    <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                    <li><a href="#"><i class="fab fa-youtube"></i></a></li>
                                </ul>
                            </div>
                            <div class="courses__details-enroll">
                                <div class="tg-button-wrap">
                                    <form action="${pageContext.request.contextPath}/cart" method="post" id="addToCartForm">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="courseId" value="${course.id}">
                                        <input type="hidden" name="price" value="${course.price}">
                                        <button type="submit" class="btn btn-two arrow-btn">
                                            Add To Cart
                                            <img src="assets/img/icons/right_arrow.svg" alt="img" class="injectable">
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- courses-details-area-end -->

    </main>
    <!-- main-area-end -->



    <!-- footer-area -->
    <jsp:include page="../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->




    <!-- JS here -->
    <jsp:include page="../common/home/js-home.jsp" />
    <script>
        SVGInject(document.querySelectorAll("img.injectable"));
    </script>
</body>

</html>