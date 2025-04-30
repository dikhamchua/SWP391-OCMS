<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - My Course Details</title>
    <meta name="description" content="SkillGro - My Course Details">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../common/home/css-home.jsp" />
    
    <style>
        .lesson-item {
            padding: 10px 15px;
            border-bottom: 1px solid #eee;
            transition: all 0.3s ease;
        }
        
        .lesson-item:hover {
            background-color: #f8f9fa;
        }
        
        .lesson-item a {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #333;
            text-decoration: none;
        }
        
        .lesson-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .lesson-icon {
            font-size: 18px;
            color: #007bff;
        }
        
        .lesson-meta {
            display: flex;
            align-items: center;
            gap: 15px;
            color: #6c757d;
            font-size: 14px;
        }
        
        .lesson-duration {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .progress-container {
            margin-top: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        
        .progress-bar-container {
            height: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            overflow: hidden;
            margin-bottom: 10px;
        }
        
        .progress-bar {
            height: 100%;
            background-color: #28a745;
            border-radius: 5px;
        }
        
        .progress-text {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #6c757d;
        }
        
        .lesson-item {
            position: relative;
            padding: 15px;
            border-bottom: 1px solid #eee;
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

        <!-- courses-details-area -->
        <section class="courses__details-area section-py-120">
            <div class="container">
                <div class="row">
                    <div class="col-xl-9 col-lg-8">
                        <div class="courses__details-thumb">
                            <img src="${pageContext.request.contextPath}/assets/img/courses/${course.thumbnail}" alt="${course.name}">
                        </div>
                        <div class="courses__details-content">
                            <ul class="courses__item-meta list-wrap">
                                <li class="courses__item-tag">
                                    <a href="${pageContext.request.contextPath}/course-list?categories=${course.categoryId}">${categoryMap[course.categoryId]}</a>
                                </li>
                                <li class="avg-rating"><i class="fas fa-star"></i> (${course.rating} Reviews)</li>
                            </ul>
                            <h2 class="title">${course.name}</h2>
                            <div class="courses__details-meta">
                                <ul class="list-wrap">
                                    <li class="author-two">
                                        <img src="${pageContext.request.contextPath}/assets/img/courses/course_author001.png" alt="img">
                                        By
                                        <a href="#">${accountMap[course.createdBy]}</a>
                                    </li>
                                    <li class="date"><i class="flaticon-calendar"></i>${course.createdDate}</li>
                                </ul>
                            </div>

                            <!-- Progress information -->
                            <div class="progress-container">
                                <h5>Your Progress</h5>
                                <div class="progress-bar-container">
                                    <div class="progress-bar" style="width: ${progressPercentage}%"></div>
                                </div>
                                <div class="progress-text">
                                    <span>${completedLessons} of ${totalLessons} lessons completed</span>
                                    <span>${progressPercentage}%</span>
                                </div>
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
                                        <p>This curriculum outlines the content you'll cover in ${course.name}. Click on any lesson to start or continue learning.</p>
                                        
                                        <div class="accordion" id="courseAccordion">
                                            <c:forEach var="section" items="${sections}" varStatus="sectionStatus">
                                                <div class="accordion-item">
                                                    <h2 class="accordion-header" id="heading${section.id}">
                                                        <button class="accordion-button ${sectionStatus.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${section.id}" aria-expanded="${sectionStatus.first ? 'true' : 'false'}" aria-controls="collapse${section.id}">
                                                            ${section.title}
                                                        </button>
                                                    </h2>
                                                    <div id="collapse${section.id}" class="accordion-collapse collapse ${sectionStatus.first ? 'show' : ''}" aria-labelledby="heading${section.id}" data-bs-parent="#courseAccordion">
                                                        <div class="accordion-body">
                                                            <ul class="list-wrap">
                                                                <c:forEach var="lesson" items="${lessonsBySectionId[section.id]}">
                                                                    <li class="lesson-item">
                                                                        <a href="${pageContext.request.contextPath}/lesson?action=view&id=${lesson.id}">
                                                                            <div class="lesson-title">
                                                                                <c:choose>
                                                                                    <c:when test="${lesson.type eq 'video'}">
                                                                                        <i class="fa fa-play-circle lesson-icon"></i>
                                                                                    </c:when>
                                                                                    <c:when test="${lesson.type eq 'quiz'}">
                                                                                        <i class="fa fa-question-circle lesson-icon"></i>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <i class="fa fa-file-alt lesson-icon"></i>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                                <span>${lesson.title}</span>
                                                                            </div>
                                                                            <div class="lesson-meta">
                                                                                <c:if test="${lesson.durationMinutes > 0}">
                                                                                    <div class="lesson-duration">
                                                                                        <i class="fa fa-clock"></i>
                                                                                        <span>${lesson.durationMinutes} min</span>
                                                                                    </div>
                                                                                </c:if>
                                                                                <c:choose>
                                                                                    <c:when test="${completedLessonsMap[lesson.id] == true}">
                                                                                        <i class="fa fa-check-circle" style="color: #28a745;"></i>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <i class="fa fa-circle" style="color: #dee2e6;"></i>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </a>
                                                                    </li>
                                                                </c:forEach>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="instructors-tab-pane" role="tabpanel" aria-labelledby="instructors-tab" tabindex="0">
                                    <div class="courses__instructors-wrap">
                                        <div class="courses__instructors-thumb">
                                            <img src="${pageContext.request.contextPath}/assets/img/courses/course_instructors.png" alt="img">
                                        </div>
                                        <div class="courses__instructors-content">
                                            <h2 class="title">${accountMap[course.createdBy]}</h2>
                                            <span class="designation">Instructor</span>
                                            <p class="avg-rating"><i class="fas fa-star"></i>(${course.rating} Ratings)</p>
                                            <p>Course instructor information will be displayed here. This section provides details about the instructor, their expertise, and teaching background.</p>
                                            <div class="instructor__social">
                                                <ul class="list-wrap justify-content-start">
                                                    <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                                    <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                                                    <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                                    <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="reviews-tab-pane" role="tabpanel" aria-labelledby="reviews-tab" tabindex="0">
                                    <div class="courses__rating-wrap">
                                        <h2 class="title">Student Reviews</h2>
                                        <div class="course-rate">
                                            <div class="course-rate__summary">
                                                <div class="course-rate__summary-value">${course.rating}</div>
                                                <div class="course-rate__summary-stars">
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <i class="fas fa-star"></i>
                                                    </c:forEach>
                                                </div>
                                                <div class="course-rate__summary-text">
                                                    Based on student ratings
                                                </div>
                                            </div>
                                            <div class="course-rate__details">
                                                <!-- Rating details would go here -->
                                                <p>This section will display detailed student reviews and ratings.</p>
                                            </div>
                                        </div>
                                        <!-- Reviews would be displayed here -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-4">
                        <div class="courses__details-sidebar">
                            <div class="courses__details-video">
                                <img src="${pageContext.request.contextPath}/assets/img/courses/course_thumb02.jpg" alt="img">
                                <a href="https://www.youtube.com/watch?v=YwrHGratByU" class="popup-video"><i class="fas fa-play"></i></a>
                            </div>
                            <div class="courses__cost-wrap">
                                <span>Course Status:</span>
                                <h2 class="title status-${registrationStatus.toLowerCase()}">
                                    ${registrationStatus}
                                </h2>
                            </div>
                            <div class="courses__information-wrap">
                                <h5 class="title">Course includes:</h5>
                                <ul class="list-wrap">
                                
                                    <li>
                                        <img src="${pageContext.request.contextPath}/assets/img/icons/course_icon03.svg" alt="img" class="injectable">
                                        Sections
                                        <span>${sections.size()}</span>
                                    </li>
                                    <li>
                                        <img src="${pageContext.request.contextPath}/assets/img/icons/course_icon04.svg" alt="img" class="injectable">
                                        Lessons
                                        <span>${totalLessons}</span>
                                    </li>
                                    <li>
                                        <img src="${pageContext.request.contextPath}/assets/img/icons/course_icon05.svg" alt="img" class="injectable">
                                        Certification
                                        <span>Yes</span>
                                    </li>
                                </ul>
                            </div>
                            <div class="courses__details-social">
                                <h5 class="title">Share this course:</h5>
                                <ul class="list-wrap">
                                    <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                    <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                                    <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                    <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                </ul>
                            </div>
                            <div class="courses__details-enroll">
                                <div class="tg-button-wrap">
                                    <a href="${pageContext.request.contextPath}/lesson?action=view&id=${not empty sections && not empty lessonsBySectionId[sections[0].id] ? lessonsBySectionId[sections[0].id][0].id : ''}" class="btn btn-two arrow-btn">
                                        Continue Learning
                                        <img src="${pageContext.request.contextPath}/assets/img/icons/right_arrow.svg" alt="img" class="injectable">
                                    </a>
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
        
        // Calculate total lessons for all sections
        var totalLessons = 0;
        <c:forEach var="section" items="${sections}">
            <c:if test="${not empty lessonsBySectionId[section.id]}">
                totalLessons += ${lessonsBySectionId[section.id].size()};
            </c:if>
        </c:forEach>
        
        // Update lessons count in the sidebar
        document.addEventListener('DOMContentLoaded', function() {
            const lessonsCountElement = document.querySelector('.courses__information-wrap ul li:nth-child(4) span');
            if (lessonsCountElement) {
                lessonsCountElement.textContent = totalLessons;
            }
        });
        
        // Function to update progress
        function updateLessonProgress(lessonId, progress) {
            fetch('${pageContext.request.contextPath}/lesson-progress', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=progress&lessonId=' + lessonId + '&progress=' + progress
            })
            .then(response => response.json())
            .then(data => {
                console.log('Progress updated:', data);
            })
            .catch(error => {
                console.error('Error updating progress:', error);
            });
        }
        
        // Add click event listeners to lesson links
        document.addEventListener('DOMContentLoaded', function() {
            const lessonLinks = document.querySelectorAll('.lesson-item a');
            lessonLinks.forEach(link => {
                // Extract lesson ID from the URL
                const url = new URL(link.href, window.location.origin);
                const lessonId = url.searchParams.get('id');
                
                // Add event listener to mark lesson as started
                link.addEventListener('click', function(event) {
                    // Don't prevent default navigation, but mark the lesson as started
                    fetch('${pageContext.request.contextPath}/lesson-progress', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=start&lessonId=' + lessonId
                    })
                    .then(response => response.json())
                    .then(data => {
                        console.log('Lesson marked as started:', data);
                    })
                    .catch(error => {
                        console.error('Error marking lesson as started:', error);
                    });
                });
            });
        });
    </script>
</body>

</html> 