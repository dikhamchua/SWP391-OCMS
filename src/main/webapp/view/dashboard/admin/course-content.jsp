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
        
        .highlight-move {
            transition: all 0.3s ease;
            background-color: #d1f7d6 !important;
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
                                    <a href="${pageContext.request.contextPath}/add-section?courseId=${course.id}" class="btn btn-primary">
                                        <i class="fa fa-plus"></i> Thêm phần mới
                                    </a>
                                </div>
                                
                                <!-- Add this button in the appropriate location in course-content.jsp -->
                                <div class="add-lesson-buttons mt-3 mb-4">
                                    <h5>Thêm bài học mới</h5>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/lesson-edit?action=add&courseId=${course.id}&type=video" class="btn btn-primary me-2">
                                            <i class="fa fa-video"></i> Thêm bài học video
                                        </a>
                                        <a href="${pageContext.request.contextPath}/lesson-edit?action=add&courseId=${course.id}&type=quiz" class="btn btn-info me-2">
                                            <i class="fa fa-question-circle"></i> Thêm bài kiểm tra
                                        </a>
                                        <a href="${pageContext.request.contextPath}/lesson-edit?action=add&courseId=${course.id}&type=document" class="btn btn-success me-2">
                                            <i class="fa fa-file-alt"></i> Thêm tài liệu
                                        </a>
                                    </div>
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
                                                    <div class="lessons-container">
                                                        <c:forEach var="lesson" items="${lessonsBySectionId[section.id]}">
                                                            <div class="course-content-item">
                                                                <div>
                                                                    <p class="course-content-title mb-0">
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
                                                                    <button class="btn btn-sm btn-outline-primary move-up me-1" data-lesson-id="${lesson.id}" data-section-id="${section.id}">
                                                                        <i class="fa fa-arrow-up"></i>
                                                                    </button>
                                                                    <button class="btn btn-sm btn-outline-primary move-down me-2" data-lesson-id="${lesson.id}" data-section-id="${section.id}">
                                                                        <i class="fa fa-arrow-down"></i>
                                                                    </button>
                                                                    <a href="${pageContext.request.contextPath}/lesson-edit?action=edit&id=${lesson.id}" class="btn btn-sm btn-outline-secondary me-2">
                                                                        <i class="fa fa-edit"></i>
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/lesson?action=view&id=${lesson.id}" class="btn btn-sm btn-outline-primary">
                                                                        <i class="fa fa-eye"></i>
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                    
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

        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.move-up').forEach(btn => {
                btn.addEventListener('click', () => {
                    changeLessonOrder(btn.dataset.lessonId, btn.dataset.sectionId, 'up', btn.closest('.course-content-item'));
                });
            });
            document.querySelectorAll('.move-down').forEach(btn => {
                btn.addEventListener('click', () => {
                    changeLessonOrder(btn.dataset.lessonId, btn.dataset.sectionId, 'down', btn.closest('.course-content-item'));
                });
            });

            function changeLessonOrder(lessonId, sectionId, direction, element) {
                const currentItem = element;
                const parent = currentItem.parentElement;

                fetch('${pageContext.request.contextPath}/change-lesson-order', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ lessonId: lessonId, sectionId: sectionId, direction: direction })
                })
                .then(res => res.json())
                .then(data => {
                    iziToast.success({ title: 'OK', message: data.message, position: 'topRight' });

                    // Add animation effect before moving element in DOM
                    const sibling = direction === 'up' ? currentItem.previousElementSibling : currentItem.nextElementSibling;
                    if (!sibling) return;

                    currentItem.classList.add('highlight-move');
                    sibling.classList.add('highlight-move');

                    setTimeout(() => {
                        if (direction === 'up') {
                            parent.insertBefore(currentItem, sibling);
                        } else {
                            parent.insertBefore(sibling, currentItem);
                        }
                        currentItem.classList.remove('highlight-move');
                        sibling.classList.remove('highlight-move');
                    }, 250);
                })
                .catch(err => {
                    iziToast.error({ title: 'Error', message: 'Lỗi thay đổi thứ tự bài học', position: 'topRight' });
                });
            }
        });
    </script>
</body>

</html> 