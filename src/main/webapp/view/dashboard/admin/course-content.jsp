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
                                    <button class="btn" style="background-color: #f5f5f5; border: none;">
                                        <i class="fa fa-cog"></i>
                                    </button>
                                </div>
                                
                                <!-- Course Content -->
                                <div class="row">
                                    <div class="col-12">
                                        <!-- Introduction Section -->
                                        <div class="course-section" x-data="{open: false}">
                                            <div class="course-section-header d-flex justify-content-between align-items-center" @click="open = !open">
                                                <h5>Introduction</h5>
                                                <span class="expand-icon" x-text="open ? '-' : '+'"></span>
                                            </div>
                                            <div class="course-content-item" x-show="open" x-transition>
                                                <p class="course-content-title">Overview of Java Web Development</p>
                                                <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                            </div>
                                        </div>
                                        
                                        <!-- Servlet Section -->
                                        <div class="course-section" x-data="{open: false}">
                                            <div class="course-section-header d-flex justify-content-between align-items-center" @click="open = !open">
                                                <h5>Servlet</h5>
                                                <span class="expand-icon" x-text="open ? '-' : '+'"></span>
                                            </div>
                                            <div x-show="open" x-transition>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Introduction to Servlets</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Servlet Lifecycle</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Exercise 01 Section -->
                                        <div class="course-section" x-data="{open: false}">
                                            <div class="course-section-header d-flex justify-content-between align-items-center" @click="open = !open">
                                                <h5>Exercise 01</h5>
                                                <span class="expand-icon" x-text="open ? '-' : '+'"></span>
                                            </div>
                                            <div x-show="open" x-transition>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Basic Servlet Implementation</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Exercise 02 Section -->
                                        <div class="course-section" x-data="{open: false}">
                                            <div class="course-section-header d-flex justify-content-between align-items-center" @click="open = !open">
                                                <h5>Exercise 02</h5>
                                                <span class="expand-icon" x-text="open ? '-' : '+'"></span>
                                            </div>
                                            <div x-show="open" x-transition>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Form Handling with Servlets</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Servlet 03 + JSP Section -->
                                        <div class="course-section" x-data="{open: false}">
                                            <div class="course-section-header d-flex justify-content-between align-items-center" @click="open = !open">
                                                <h5>Servlet 03 + JSP</h5>
                                                <span class="expand-icon" x-text="open ? '-' : '+'"></span>
                                            </div>
                                            <div x-show="open" x-transition>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Introduction to JSP</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Servlet and JSP Integration</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- CRUD with Collections Section -->
                                        <div class="course-section" x-data="{open: false}">
                                            <div class="course-section-header d-flex justify-content-between align-items-center" @click="open = !open">
                                                <h5>CRUD with Collections</h5>
                                                <span class="expand-icon" x-text="open ? '-' : '+'"></span>
                                            </div>
                                            <div x-show="open" x-transition>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">In-Memory Data Management</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">CRUD Operations with Collections</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Session Section -->
                                        <div class="course-section" x-data="{open: false}">
                                            <div class="course-section-header d-flex justify-content-between align-items-center" @click="open = !open">
                                                <h5>Session</h5>
                                                <span class="expand-icon" x-text="open ? '-' : '+'"></span>
                                            </div>
                                            <div x-show="open" x-transition>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Session Management in Servlets</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Cookies and URL Rewriting</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- CRUD with Database Section -->
                                        <div class="course-section" x-data="{open: false}">
                                            <div class="course-section-header d-flex justify-content-between align-items-center" @click="open = !open">
                                                <h5>CRUD with Database</h5>
                                                <span class="expand-icon" x-text="open ? '-' : '+'"></span>
                                            </div>
                                            <div x-show="open" x-transition>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">JDBC Introduction</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Database Operations</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Projects Section -->
                                        <div class="course-section" x-data="{open: false}">
                                            <div class="course-section-header d-flex justify-content-between align-items-center" @click="open = !open">
                                                <h5>Projects</h5>
                                                <span class="expand-icon" x-text="open ? '-' : '+'"></span>
                                            </div>
                                            <div x-show="open" x-transition>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Project 01</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Project 02</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Project 03</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Project 04</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
                                                </div>
                                                <div class="course-content-item">
                                                    <p class="course-content-title">Project 05</p>
                                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/lesson-detail.jsp" class="btn btn-sm btn-outline-primary">View</a>
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