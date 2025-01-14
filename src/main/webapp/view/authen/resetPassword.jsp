<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <jsp:include page="../common/home/css-home.jsp"></jsp:include>
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

        <!-- breadcrumb-area -->
        <section class="breadcrumb__area breadcrumb__bg" data-background="assets/img/bg/breadcrumb_bg.jpg">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="breadcrumb__content">
                            <h3 class="title">Reset Password</h3>
                            <nav class="breadcrumb">
                                <span property="itemListElement" typeof="ListItem">
                                    <a href="index.html">Home</a>
                                </span>
                                <span class="breadcrumb-separator"><i class="fas fa-angle-right"></i></span>
                                <span property="itemListElement" typeof="ListItem">Reset Password</span>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
            <div class="breadcrumb__shape-wrap">
                <img src="${pageContext.request.contextPath}/assets/img/others/breadcrumb_shape01.svg" alt="img" class="alltuchtopdown">
                <img src="${pageContext.request.contextPath}/assets/img/others/breadcrumb_shape02.svg" alt="img" data-aos="fade-right" data-aos-delay="300">
                <img src="${pageContext.request.contextPath}/assets/img/others/breadcrumb_shape03.svg" alt="img" data-aos="fade-up" data-aos-delay="400">
                <img src="${pageContext.request.contextPath}/assets/img/others/breadcrumb_shape04.svg" alt="img" data-aos="fade-down-left" data-aos-delay="400">
                <img src="${pageContext.request.contextPath}/assets/img/others/breadcrumb_shape05.svg" alt="img" data-aos="fade-left" data-aos-delay="400">
            </div>
        </section>
        <!-- breadcrumb-area-end -->

        <!-- reset-password-area -->
        <section class="singUp-area section-py-120">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-xl-6 col-lg-8">
                        <div class="singUp-wrap">
                            <h2 class="title">Reset Your Password</h2>
                            <form action="authen?action=reset-password" method="POST" class="account__form">
                                <div class="form-grp">
                                    <label for="new-password">New Password</label>
                                    <input type="password" name="newPassword" id="new-password" placeholder="Enter new password" required>
                                </div>
                                <div class="form-grp">
                                    <label for="confirm-password">Confirm New Password</label>
                                    <input type="password" name="confirmPassword" id="confirm-password" placeholder="Confirm new password" required>
                                </div>
                                <p style="color: red">${error}<br></p>
                                <button type="submit" class="btn btn-two arrow-btn">Reset Password</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- reset-password-area-end -->

    </main>
    <!-- main-area-end -->

    <!-- footer-area -->
    <jsp:include page="../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../common/home/js-home.jsp"></jsp:include>

    <script>
        SVGInject(document.querySelectorAll("img.injectable"));
    </script>
</body>

</html>