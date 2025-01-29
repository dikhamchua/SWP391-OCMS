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

    <style>
        .blog__post-content .title a {
            display: -webkit-box;
            -webkit-line-clamp: 2; /* Giới hạn hiển thị 2 dòng */
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.5em; /* Đảm bảo chiều cao dòng phù hợp */
            max-height: 3em; /* 2 dòng x 1.5em */
        }

        .blog__post-item {
            display: flex;
            flex-direction: column;
            height: 80%;
        }
        
        .blog__post-content {
            flex-grow: 1; /* Phần nội dung sẽ lấp đầy khoảng trống */
            display: flex;
            flex-direction: column;
            justify-content: space-between; /* Đảm bảo title luôn nằm dưới cùng */
        }
        
        

    </style>
</head>

<body>

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

        <!-- blog-area -->
        <section class="blog-area section-py-120">
            <div class="container">
                <div class="row">
                    <div class="col-xl-9 col-lg-8">
                        <div class="row gutter-20">
                            <c:forEach items="${blogs}" var="blog">
                                <div class="col-xl-4 col-md-6">
                                    <div class="blog__post-item shine__animate-item">
                                        <div class="blog__post-thumb">
                                            <a href="blog-details?id=${blog.id}" class="shine__animate-link">
                                                <img src="${blog.thumbnail}" alt="blog thumbnail">
                                            </a>
                                            <!-- <a href="blog?category=${blog.categoryId}" class="post-tag">Category</a> -->
                                        </div>
                                        <div class="blog__post-content">
                                            <div class="blog__post-meta">
                                                <ul class="list-wrap">
                                                    <li>
                                                        <i class="flaticon-calendar"></i>
                                                        ${fn:formatDate(blog.createdDate, "dd-MM-yyyy HH:mm:ss")}
                                                    </li>
                                                    <li><i class="flaticon-user-1"></i>by <a href="#">Admin</a></li>
                                                </ul>
                                            </div>
                                            <h4 class="title">
                                                <a href="blog-details?id=${blog.id}">${blog.title}</a>
                                            </h4>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <nav class="pagination__wrap mt-25">
                            <ul class="list-wrap">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="${currentPage == i ? 'active' : ''}">
                                        <a href="blog?page=${i}&search=${searchTerm}&category=${categoryId}">${i}</a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </nav>
                    </div>
                    <div class="col-xl-3 col-lg-4">
                        <jsp:include page="../common/home/blog_aside.jsp"></jsp:include>
                    </div>
                </div>
            </div>
        </section>
        <!-- blog-area-end -->

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