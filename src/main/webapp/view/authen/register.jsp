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
                                    <h3 class="title">Student SingUp</h3>
                                    <nav class="breadcrumb">
                                        <span property="itemListElement" typeof="ListItem">
                                            <a href="index.html">Home</a>
                                        </span>
                                        <span class="breadcrumb-separator"><i class="fas fa-angle-right"></i></span>
                                        <span property="itemListElement" typeof="ListItem">SingUp</span>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="breadcrumb__shape-wrap">
                        <img src="assets/img/others/breadcrumb_shape01.svg" alt="img" class="alltuchtopdown">
                        <img src="assets/img/others/breadcrumb_shape02.svg" alt="img" data-aos="fade-right" data-aos-delay="300">
                        <img src="assets/img/others/breadcrumb_shape03.svg" alt="img" data-aos="fade-up" data-aos-delay="400">
                        <img src="assets/img/others/breadcrumb_shape04.svg" alt="img" data-aos="fade-down-left" data-aos-delay="400">
                        <img src="assets/img/others/breadcrumb_shape05.svg" alt="img" data-aos="fade-left" data-aos-delay="400">
                    </div>
                </section>
                <!-- breadcrumb-area-end -->

                <!-- singUp-area -->
                <section class="singUp-area section-py-120">
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-xl-6 col-lg-8">
                                <div class="singUp-wrap">
                                    <h2 class="title">Create Your Account</h2>
                                    <div class="account__social">
                                        <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:9998/SWP_OCMS/LoginGoogleHandler&response_type=code&client_id=257748132214-9811944a5anccchj9egqhg9qci33l5ij.apps.googleusercontent.com&approval_prompt=force" class="account__social-btn">
                                            <img src="assets/img/icons/google.svg" alt="img">
                                            Continue with google
                                        </a>
                                    </div>
                                    <div class="account__divider">
                                        <span>or</span>
                                    </div>
                                    <form action="authen?action=sign-up" method="POST" class="account__form" id="signupForm">
                                        <div class="form-grp">
                                            <label for="email">Email</label>
                                            <input type="email" name="email" id="email" placeholder="email">
                                            <span class="error" id="emailError"></span>
                                        </div>
                                        <div class="form-grp">
                                            <label for="password">Password</label>
                                            <input type="password" name="password" id="password" placeholder="password">
                                            <span class="error" id="passwordError"></span>
                                        </div>
                                        <div class="form-grp">
                                            <label for="confirm-password">Confirm Password</label>
                                            <input type="password" name="confirmPassword" id="confirm-password" placeholder="Confirm Password">
                                            <span class="error" id="confirmPasswordError"></span>
                                        </div>
                                        <p style="color: red">${error}<br></p>
                                    <button type="submit" class="btn btn-two arrow-btn">Sign Up<img src="assets/img/icons/right_arrow.svg" alt="img" class="injectable"></button>
                                </form>
                                <div class="account__switch">
                                    <p>Already have an account?<a href="authen?action=login">Login</a></p>
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

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const form = document.getElementById('signupForm');
                const email = document.getElementById('email');
                const password = document.getElementById('password');
                const confirmPassword = document.getElementById('confirm-password');
                const emailError = document.getElementById('emailError');
                const passwordError = document.getElementById('passwordError');
                const confirmPasswordError = document.getElementById('confirmPasswordError');

                form.addEventListener('submit', function (event) {
                    let isValid = true;

                    // Reset error messages
                    emailError.textContent = '';
                    passwordError.textContent = '';
                    confirmPasswordError.textContent = '';

                    // Email validation
                    if (email.value.trim() === '') {
                        emailError.textContent = 'Email is required';
                        isValid = false;
                    } else if (!isValidEmail(email.value)) {
                        emailError.textContent = 'Please enter a valid email address';
                        isValid = false;
                    }

                    // Password validation
                    if (password.value.trim() === '') {
                        passwordError.textContent = 'Password is required';
                        isValid = false;
                    } else if (password.value.length < 8) {
                        passwordError.textContent = 'Password must be at least 8 characters long';
                        isValid = false;
                    }

                    // Confirm Password validation
                    if (confirmPassword.value.trim() === '') {
                        confirmPasswordError.textContent = 'Please confirm your password';
                        isValid = false;
                    } else if (password.value !== confirmPassword.value) {
                        confirmPasswordError.textContent = 'Passwords do not match';
                        isValid = false;
                    }

                    if (!isValid) {
                        event.preventDefault(); // Prevent form submission if there are errors
                    }
                });

                function isValidEmail(email) {
                    // Basic email validation regex
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    return emailRegex.test(email);
                }
            });
        </script>
    </body>

</html>