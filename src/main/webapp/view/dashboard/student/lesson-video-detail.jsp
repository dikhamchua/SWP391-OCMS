<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Lesson Detail</title>
    <meta name="description" content="SkillGro - Lesson Detail">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/css-file.jsp"></jsp:include>
    
    <!-- Alpine.js -->
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    
    <style>
        .lesson-video-container {
            position: relative;
            padding-bottom: 56.25%; /* 16:9 Aspect Ratio */
            height: 0;
            overflow: hidden;
            margin-bottom: 20px;
            background-color: #000;
        }
        
        .lesson-video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        
        .lesson-content {
            margin-top: 20px;
        }
        
        .lesson-title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .lesson-description {
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .lesson-resources {
            margin-top: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        
        .lesson-resources h5 {
            margin-bottom: 15px;
        }
        
        .resource-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .resource-item i {
            margin-right: 10px;
            color: #007aff;
        }
        
        .course-outline {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 20px;
            height: 100%;
        }
        
        .course-outline-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .outline-item {
            display: flex;
            align-items: flex-start;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        .outline-item.active {
            background-color: #e9f5ff;
            padding: 10px;
            margin: 0 -10px;
            border-radius: 5px;
        }
        
        .outline-item-checkbox {
            margin-right: 10px;
            margin-top: 3px;
        }
        
        .outline-item-content {
            flex-grow: 1;
        }
        
        .outline-item-title {
            font-weight: 500;
            margin-bottom: 3px;
        }
        
        .outline-item-duration {
            font-size: 12px;
            color: #6c757d;
        }
        
        .lesson-navigation {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
        }
        
        [x-cloak] {
            display: none !important;
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
            <div class="container-fluid">
                <jsp:include page="../../common/dashboard/avatar.jsp"></jsp:include>

                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <jsp:include page="../../common/dashboard/sideBar.jsp"></jsp:include>
                        <div class="col-lg-9">
                            <div class="dashboard__content-wrap">
                                <div class="dashboard__content-title d-flex justify-content-between align-items-center">
                                    <h4 class="title">Chi tiết bài học</h4>
                                    <a href="${pageContext.request.contextPath}/course-detail?id=${course.id}" class="btn" style="background-color: #f5f5f5; border: none;">
                                        <i class="fa fa-arrow-left"></i> Quay lại khóa học
                                    </a>
                                </div>
                                
                                <!-- Lesson Content -->
                                <div class="row">
                                    <div class="col-lg-8">
                                        <!-- Video Container -->
                                        <div class="lesson-video-container">
                                            <video controls style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;">
                                                <source src="${lessonVideo.videoUrl}" type="video/mp4">
                                                Your browser does not support the video tag.
                                            </video>                                            
                                        </div>
                                        
                                        <!-- Lesson Content -->
                                        <div class="lesson-content">
                                            <h3 class="lesson-title">${lesson.title}</h3>
                                            <div class="lesson-description">
                                            </div>
                                            
                                            <!-- Lesson Navigation -->
                                            <div class="lesson-navigation">
                                                <c:if test="${prevLesson != null}">
                                                    <a href="${pageContext.request.contextPath}/lesson?action=view&id=${prevLesson.id}" class="btn btn-outline-primary">
                                                        <i class="fa fa-arrow-left"></i> Bài học trước
                                                    </a>
                                                </c:if>
                                                <c:if test="${prevLesson == null}">
                                                    <div></div>
                                                </c:if>
                                                
                                                <c:if test="${nextLesson != null}">
                                                    <a href="${pageContext.request.contextPath}/lesson?action=view&id=${nextLesson.id}" class="btn btn-primary">
                                                        Bài học tiếp theo <i class="fa fa-arrow-right"></i>
                                                    </a>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-lg-4">
                                        <!-- Course Outline -->
                                        <div class="course-outline">
                                            <h4 class="course-outline-title">Nội dung khóa học: ${course.name}</h4>
                                            
                                            <c:forEach var="courseSection" items="${courseSections}">
                                                <div x-data="{open: ${courseSection.id == section.id}}">
                                                    <div class="d-flex justify-content-between align-items-center mb-2 cursor-pointer" @click="open = !open">
                                                        <h5 class="mb-0">${courseSection.title}</h5>
                                                        <span x-text="open ? '-' : '+'"></span>
                                                    </div>
                                                    <div x-show="open" x-transition>
                                                        <c:forEach var="sectionLesson" items="${sectionLessons[courseSection.id]}">
                                                            <div class="outline-item ${sectionLesson.id == lesson.id ? 'active' : ''}">
                                                                <div class="outline-item-content">
                                                                    <div class="outline-item-title">
                                                                        <a href="${pageContext.request.contextPath}/lesson?action=view&id=${sectionLesson.id}">
                                                                            ${sectionLesson.title}
                                                                        </a>
                                                                    </div>
                                                                    <div class="outline-item-duration">${sectionLesson.durationMinutes} min</div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
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
        $(document).ready(function() {
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
        });
    </script>
</body>

</html> 