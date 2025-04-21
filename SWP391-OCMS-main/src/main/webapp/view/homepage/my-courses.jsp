<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
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
        <section class="breadcrumb-area breadcrumb-bg" data-background="${pageContext.request.contextPath}/assets/img/bg/breadcrumb_bg.jpg">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="breadcrumb-content">
                            <h3 class="title">My Courses</h3>
                            <nav class="breadcrumb">
                                <span property="itemListElement" typeof="ListItem">My Learning</span>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="my-courses-area section-py-120">
            <div class="container">
                <!-- Display courses -->
                <div class="row">
                    <c:choose>
                        <c:when test="${empty registrations}">
                            <div class="col-12">
                                <div class="empty-courses">
                                    <i class="fas fa-book-reader"></i>
                                    <h5>You haven't enrolled in any courses yet</h5>
                                    <p>Browse our catalog and find courses that match your interests.</p>
                                    <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary mt-3">Browse Courses</a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${registrations}" var="registration">
                                <c:set var="course" value="${courseDAO.findById(registration.courseId)}" />
                                <div class="col-lg-4 col-md-6">
                                    <div class="course-card">
                                        <img src="${course.thumbnail}" alt="${course.name}" class="course-image">
                                        <div class="course-content">
                                            <h3 class="course-title">${course.name}</h3>
                                            <div class="course-meta">
                                                <span>Enrolled: <fmt:formatDate value="${registration.registrationTime}" pattern="MMM dd, yyyy"/></span>
                                                <span>Valid until: <fmt:formatDate value="${registration.validTo}" pattern="MMM dd, yyyy"/></span>
                                            </div>
                                            <p>${course.shortDescription}</p>
                                        </div>
                                        <div class="course-footer">
                                            <span class="badge ${registration.status == 'Active' ? 'bg-success' : 'bg-warning'}">${registration.status}</span>
                                            <a href="${pageContext.request.contextPath}/course?id=${course.id}" class="btn btn-sm btn-primary">Start Learning</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
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
        function showToast(message, type) {
            let backgroundColor = "#28a745"; // Default success color
            
            if (type === "error") {
                backgroundColor = "#dc3545"; // Danger color
            } else if (type === "info") {
                backgroundColor = "#17a2b8"; // Info color
            } else if (type === "warning") {
                backgroundColor = "#ffc107"; // Warning color
            }
            
            Toastify({
                text: message,
                duration: 5000,
                close: true,
                gravity: "top",
                position: "right",
                backgroundColor: backgroundColor,
                stopOnFocus: true
            }).showToast();
        }
        
        // Check for session messages and display toast
        <c:if test="${not empty sessionScope.message}">
            document.addEventListener("DOMContentLoaded", function() {
                showToast("${sessionScope.message}", "${sessionScope.messageType}");
            });
            <c:remove var="message" scope="session" />
            <c:remove var="messageType" scope="session" />
        </c:if>
    </script>
</body>

</html> 