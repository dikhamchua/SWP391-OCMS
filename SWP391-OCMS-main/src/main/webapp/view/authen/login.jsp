<%-- 
    Document   : login
    Created on : Sep 17, 2024, 10:44:57 PM
    Author     : manhpthe172481
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!doctype html>
<html class="no-js" lang="en">


    <!-- Mirrored from html.themegenix.com/skillgro/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 16 Sep 2024 01:45:08 GMT -->
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
                <section class="breadcrumb__area breadcrumb__bg" data-background="${pageContext.request.contextPath}/assets/img/bg/breadcrumb_bg.jpg">
                <div class="container">
                    <div class="row">
                        <div class="col-12">
                            <div class="breadcrumb__content">
                                <h3 class="title">Student Login</h3>
                                <nav class="breadcrumb">
                                    <span property="itemListElement" typeof="ListItem">
                                        <a href="index.html">Home</a>
                                    </span>
                                    <span class="breadcrumb-separator"><i class="fas fa-angle-right"></i></span>
                                    <span property="itemListElement" typeof="ListItem">Login</span>
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

            <!-- singUp-area -->
            <section class="singUp-area section-py-120">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-xl-6 col-lg-8">
                            <div class="singUp-wrap">
                                <h2 class="title">Welcome back!</h2>
                                <p>Hey there! Ready to log in? Just enter your username and password below and you'll be back in action in no time. Let's go!</p>
                                <div class="account__social">
                                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:9999/SWP_OCMS/LoginGoogleHandler&response_type=code&client_id=963287415197-l9joe5bma0vurl662udjm2nktq1tpmbt.apps.googleusercontent.com&approval_prompt=force" class="account__social-btn">
                                        <img src="${pageContext.request.contextPath}/assets/img/icons/google.svg" alt="img">
                                        Continue with google
                                    </a>
                                </div>
                                <div class="account__divider">
                                    <span>or</span>
                                </div>
                                <form action="authen?action=login" class="account__form" method="POST" id="loginForm">
                                    <div class="form-grp">
                                        <label for="username">Username or email</label>
                                        <input id="username" name="username" type="text" placeholder="username">
                                        <span class="error" id="emailError"></span>
                                    </div>
                                    <div class="form-grp">
                                        <label for="password">Password</label>
                                        <input id="password" name="password" type="password" placeholder="password">
                                        <span class="error" id="passwordError"></span>
                                    </div>
                                    <button type="submit" class="btn btn-two arrow-btn">Sign In<img src="${pageContext.request.contextPath}/assets/img/icons/right_arrow.svg" alt="img" class="injectable"></button>
                                    <div class="account__check">
                                        <div class="account__check-remember">
                                            <input type="checkbox" class="form-check-input" value="" id="terms-check">
                                            <label for="terms-check" class="form-check-label">Remember me</label>
                                        </div>
                                        <div class="account__check-forgot">
                                            <a href="authen?action=enter-email">Forgot Password?</a>
                                        </div>
                                    </div>
                                </form>
                                <div class="account__switch">
                                    <p>Don't have an account?<a href="authen?action=sign-up">Sign Up</a></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- singUp-area-end -->

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

        <!-- Add this right before the closing </body> tag -->
        <!-- Toast container -->
        <div id="toast-container" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>
    
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const form = document.getElementById('loginForm');
                const username = document.getElementById('username');
                const password = document.getElementById('password');
                const emailError = document.getElementById('emailError');
                const passwordError = document.getElementById('passwordError');
    
                // Check if there's a login error from the server
                const loginError = "${requestScope.error}";
                console.log("Login error:", loginError); // Thêm log để kiểm tra
                if (loginError && loginError !== "" && loginError !== "null") {
                    showToast(loginError, "error");
                    // Thêm hiển thị lỗi trực tiếp trên trang
                    document.getElementById('emailError').textContent = loginError;
                }
    
                form.addEventListener('submit', function (event) {
                    let isValid = true;
    
                    // Reset error messages
                    emailError.textContent = '';
                    passwordError.textContent = '';
    
                    // Username/Email validation
                    if (username.value.trim() === '') {
                        emailError.textContent = 'Username or email is required';
                        isValid = false;
                    }
    
                    // Password validation
                    if (password.value.trim() === '') {
                        passwordError.textContent = 'Password is required';
                        isValid = false;
                    }
    
                    if (!isValid) {
                        event.preventDefault(); // Prevent form submission if there are errors
                    }
                });
    
                // Toast function
                function showToast(message, type = "info") {
                    const toast = document.createElement('div');
                    toast.className = 'toast ' + type;
                    toast.innerHTML = 
                        '<div class="toast-content">' +
                            '<i class="fas ' + (type === 'error' ? 'fa-exclamation-circle' : 'fa-check-circle') + '"></i>' +
                            '<div class="message">' +
                                '<span class="text">' + message + '</span>' +
                            '</div>' +
                        '</div>' +
                        '<i class="fa-solid fa-xmark close"></i>';
                    
                    document.getElementById('toast-container').appendChild(toast);
                    
                    // Auto remove after 5 seconds
                    setTimeout(() => {
                        toast.classList.add('hide');
                        setTimeout(() => {
                            toast.remove();
                        }, 500);
                    }, 5000);
                    
                    // Close button functionality
                    const closeBtn = toast.querySelector('.close');
                    if (closeBtn) {
                        closeBtn.addEventListener('click', () => {
                            toast.classList.add('hide');
                            setTimeout(() => {
                                toast.remove();
                            }, 500);
                        });
                    }
                }
            });
        </script>
    </body>


    <!-- Mirrored from html.themegenix.com/skillgro/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 16 Sep 2024 01:45:08 GMT -->
</html>

<!-- Add toast styling -->
<style>
    .toast {
        position: relative;
        padding: 15px 20px;
        margin-bottom: 10px;
        border-radius: 8px;
        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        transform: translateX(100%);
        animation: slide-in 0.3s forwards;
        max-width: 300px;
    }
    
    .toast.error {
        background: #fff;
        border-left: 5px solid #ff5252;
    }
    
    .toast.info {
        background: #fff;
        border-left: 5px solid #4caf50;
    }
    
    .toast .toast-content {
        display: flex;
        align-items: center;
    }
    
    .toast-content i {
        font-size: 20px;
        margin-right: 10px;
    }
    
    .toast.error i {
        color: #ff5252;
    }
    
    .toast.info i {
        color: #4caf50;
    }
    
    .toast .close {
        position: absolute;
        top: 10px;
        right: 10px;
        cursor: pointer;
        opacity: 0.7;
    }
    
    .toast .close:hover {
        opacity: 1;
    }
    
    .toast.hide {
        animation: slide-out 0.3s forwards;
    }
    
    @keyframes slide-in {
        from { transform: translateX(100%); }
        to { transform: translateX(0); }
    }
    
    @keyframes slide-out {
        from { transform: translateX(0); }
        to { transform: translateX(100%); }
    }
</style>