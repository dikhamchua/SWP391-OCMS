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
                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/course-content.jsp" class="btn" style="background-color: #f5f5f5; border: none;">
                                        <i class="fa fa-arrow-left"></i> Quay lại
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
                                                <a href="#" class="btn btn-outline-primary">
                                                    <i class="fa fa-arrow-left"></i> Previous Lesson
                                                </a>
                                                <a href="#" class="btn btn-primary">
                                                    Next Lesson <i class="fa fa-arrow-right"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-lg-4">
                                        <!-- Course Outline -->
                                        <div class="course-outline">
                                            <h4 class="course-outline-title">Nội dung khóa học</h4>
                                            
                                            <!-- Introduction -->
                                            <div x-data="{open: true}">
                                                <div class="d-flex justify-content-between align-items-center mb-2 cursor-pointer" @click="open = !open">
                                                    <h5 class="mb-0">Introduction</h5>
                                                    <span x-text="open ? '-' : '+'"></span>
                                                </div>
                                                <div x-show="open" x-transition>
                                                    <div class="outline-item">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" checked disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">1. Install JDK 17 and Apache Netbeans 17</div>
                                                            <div class="outline-item-duration">10 min</div>
                                                        </div>
                                                    </div>
                                                    <div class="outline-item">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" checked disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">2. Overview</div>
                                                            <div class="outline-item-duration">15 min</div>
                                                        </div>
                                                    </div>
                                                    <div class="outline-item">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" checked disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">3. Set up environment</div>
                                                            <div class="outline-item-duration">12 min</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Servlet -->
                                            <div x-data="{open: true}">
                                                <div class="d-flex justify-content-between align-items-center mb-2 mt-3 cursor-pointer" @click="open = !open">
                                                    <h5 class="mb-0">Servlet</h5>
                                                    <span x-text="open ? '-' : '+'"></span>
                                                </div>
                                                <div x-show="open" x-transition>
                                                    <div class="outline-item active">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" checked disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">4. Introduction to Servlets</div>
                                                            <div class="outline-item-duration">20 min</div>
                                                        </div>
                                                    </div>
                                                    <div class="outline-item">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">5. Servlet Lifecycle</div>
                                                            <div class="outline-item-duration">18 min</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Exercise 01 -->
                                            <div x-data="{open: false}">
                                                <div class="d-flex justify-content-between align-items-center mb-2 mt-3 cursor-pointer" @click="open = !open">
                                                    <h5 class="mb-0">Exercise 01</h5>
                                                    <span x-text="open ? '-' : '+'"></span>
                                                </div>
                                                <div x-show="open" x-transition>
                                                    <div class="outline-item">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">6. Basic Servlet Implementation</div>
                                                            <div class="outline-item-duration">25 min</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- More sections collapsed -->
                                            <div class="mt-3">
                                                <div class="outline-item">
                                                    <div class="outline-item-content text-center">
                                                        <a href="#" class="text-primary">Show all sections</a>
                                                    </div>
                                                </div>
                                            </div>
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