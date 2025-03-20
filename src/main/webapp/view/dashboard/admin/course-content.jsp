<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Course Content</title>
    <meta name="description" content="SkillGro - Course Content">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/css-file.jsp"></jsp:include>
    
    <!-- Alpine.js -->
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    
    <style>
        .course-content-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: all 0.3s ease;
        }
        
        .course-content-item:hover {
            background-color: #f8f9fa;
        }
        
        .course-content-title {
            font-weight: 500;
            margin-bottom: 0;
        }
        
        .course-section {
            margin-bottom: 20px;
        }
        
        .course-section-header {
            background-color: #f5f5f5;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 10px;
            cursor: pointer;
        }
        
        .course-qr-code {
            text-align: center;
            margin-top: 30px;
        }
        
        .expand-icon {
            font-size: 18px;
            color: #007aff;
        }
        
        [x-cloak] {
            display: none !important;
        }
        
        .lesson-type-badge {
            font-size: 12px;
            padding: 3px 8px;
            border-radius: 12px;
            margin-left: 10px;
        }
        
        .lesson-type-video {
            background-color: #e6f7ff;
            color: #0070f3;
        }
        
        .lesson-type-document {
            background-color: #fff7e6;
            color: #fa8c16;
        }
        
        .lesson-type-quiz {
            background-color: #f6ffed;
            color: #52c41a;
        }
        
        .lesson-type-file {
            background-color: #f9f0ff;
            color: #722ed1;
        }
        
        .lesson-type-text {
            background-color: #f0f5ff;
            color: #2f54eb;
        }
        
        .course-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .course-title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .course-description {
            color: #666;
            margin-bottom: 0;
        }
        
        .add-section-btn {
            margin-bottom: 20px;
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
                                    <h4 class="title">Nội dung khóa học</h4>
                                    <a href="${pageContext.request.contextPath}/manage-course" class="btn" style="background-color: #f5f5f5; border: none;">
                                        <i class="fa fa-arrow-left"></i> Quay lại
                                    </a>
                                </div>
                                
                                <!-- Course Header -->
                                <div class="course-header">
                                    <h3 class="course-title">${course.name}</h3>
                                    <p class="course-description">${course.description}</p>
                                </div>
                                
                                <!-- Add Section Button -->
                                <div class="add-section-btn">
                                    <a href="${pageContext.request.contextPath}/manage-section?action=add&courseId=${course.id}" class="btn btn-primary">
                                        <i class="fa fa-plus"></i> Thêm phần mới
                                    </a>
                                </div>
                                
                                <!-- Course Content -->
                                <div class="row">
                                    <div class="col-12">
                                        <c:forEach var="section" items="${sections}">
                                            <div class="course-section" x-data="{open: ${section.id == sections[0].id}}">
                                                <div class="course-section-header d-flex justify-content-between align-items-center" @click="open = !open">
                                                    <h5>${section.title}</h5>
                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/manage-section?action=edit&id=${section.id}" class="btn btn-sm btn-outline-secondary me-2">
                                                            <i class="fa fa-edit"></i>
                                                        </a>
                                                        <span class="expand-icon" x-text="open ? '-' : '+'"></span>
                                                    </div>
                                                </div>
                                                <div x-show="open" x-transition>
                                                    <c:forEach var="lesson" items="${lessonsBySectionId[section.id]}">
                                                        <div class="course-content-item">
                                                            <div>
                                                                <p class="course-content-title">
                                                                    ${lesson.title}
                                                                    <c:choose>
                                                                        <c:when test="${lesson.type == 'video'}">
                                                                            <span class="lesson-type-badge lesson-type-video">Video</span>
                                                                        </c:when>
                                                                        <c:when test="${lesson.type == 'document'}">
                                                                            <span class="lesson-type-badge lesson-type-document">Document</span>
                                                                        </c:when>
                                                                        <c:when test="${lesson.type == 'quiz'}">
                                                                            <span class="lesson-type-badge lesson-type-quiz">Quiz</span>
                                                                        </c:when>
                                                                        <c:when test="${lesson.type == 'file'}">
                                                                            <span class="lesson-type-badge lesson-type-file">File</span>
                                                                        </c:when>
                                                                        <c:when test="${lesson.type == 'text'}">
                                                                            <span class="lesson-type-badge lesson-type-text">Text</span>
                                                                        </c:when>
                                                                    </c:choose>
                                                                </p>
                                                            </div>
                                                            <div>
                                                                <a href="${pageContext.request.contextPath}/lesson-edit?action=edit&id=${lesson.id}" class="btn btn-sm btn-outline-secondary me-2">
                                                                    <i class="fa fa-edit"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/lesson?action=view&id=${lesson.id}" class="btn btn-sm btn-outline-primary">
                                                                    <i class="fa fa-eye"></i>
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                    
                                                    <!-- Add Lesson Button -->
                                                    <div class="text-center mt-3">
                                                        <a href="${pageContext.request.contextPath}/manage-lesson?action=add&sectionId=${section.id}" class="btn btn-sm btn-outline-primary">
                                                            <i class="fa fa-plus"></i> Thêm bài học
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        
                                        <!-- If no sections exist -->
                                        <c:if test="${empty sections}">
                                            <div class="alert alert-info text-center">
                                                Chưa có phần nào trong khóa học này. Hãy thêm phần mới để bắt đầu.
                                            </div>
                                        </c:if>
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