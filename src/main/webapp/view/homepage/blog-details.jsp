<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://example.com/functions" %>

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

        <!-- blog-details-area -->
        <section class="blog-details-area section-py-120">
            <div class="container">
                <div class="row">
                    <div class="col-xl-9 col-lg-8">
                        <div class="blog__details-wrapper">
                            <!-- <div class="blog__details-thumb">
                                <img src="${blog.thumbnail}" alt="${blog.title}">
                            </div> -->
                            <div class="blog__details-content">
                                <div class="blog__post-meta">
                                    <ul class="list-wrap">
                                        <li><i class="flaticon-calendar"></i> ${fn:formatDate(blog.createdDate, "dd-MM-yyyy HH:mm:ss")}</li>
                                        <li><i class="flaticon-user-1"></i> by <a href="#">${blog.author}</a></li>
                                        <li><i class="flaticon-clock"></i> 20 Min Read</li>
                                    </ul>
                                </div>
                                <h3 class="title">${blog.title}</h3>
                                <div class="brief-info">${blog.briefInfo}</div>
                                <div class="content">${blog.content}</div>
                                <div class="blog__details-bottom">
                                    <div class="row align-items-center">
                                        <div class="col-xl-6 col-md-7">
                                            <div class="tg-post-tag">
                                                <h5 class="tag-title">Category:</h5>
                                                <ul class="list-wrap p-0 mb-0">
                                                    <li><a href="blog?category=${category.id}">${category.name}</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="col-xl-6 col-md-5">
                                            <div class="tg-post-social justify-content-start justify-content-md-end">
                                                <h5 class="social-title">Share :</h5>
                                                <ul class="list-wrap p-0 mb-0">
                                                    <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                                    <li><a href="#"><i class="fab fa-twitter"></i></a></li>
                                                    <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                                    <li><a href="#"><i class="fab fa-pinterest-p"></i></a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="blog__post-author">
                            <div class="blog__post-author-thumb">
                                <a href="#"><img src="assets/img/blog/author.png" alt="img"></a>
                            </div>
                            <div class="blog__post-author-content">
                                <span class="designation">Author</span>
                                <h5 class="name">Brooklyn Simmons</h5>
                                <p>Finanappreciate your trust greatly Our clients choose dentace ducts a curae in tristique liberois ultrices diamraesent varius diam dui. Class aptent taciti sociosqu ad litora torquent per.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-4">
                        <jsp:include page="../common/home/blog_aside.jsp"></jsp:include>  
                    </div>
                </div>
            </div>
        </section>
        <!-- blog-details-area-end -->

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