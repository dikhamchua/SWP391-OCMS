<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <jsp:include page="../common/home/css-home.jsp"></jsp:include>
        <style>
            .error {
                color: red;
                font-size: 0.85em;
                margin-top: 5px;
                display: block;
            }
            .form-grp {
                margin-bottom: 20px;
            }
            .password-requirements {
                font-size: 0.85em;
                margin-top: 5px;
                color: #666;
            }
            .valid-feedback {
                color: green;
                font-size: 0.85em;
                margin-top: 5px;
                display: none;
            }
            input.is-valid {
                border-color: green !important;
            }
            input.is-invalid {
                border-color: red !important;
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

            <!-- breadcrumb-area -->
            <section class="breadcrumb__area breadcrumb__bg" data-background="assets/img/bg/breadcrumb_bg.jpg">
                <div class="container">
                    <div class="row">
                        <div class="col-12">
                            <div class="breadcrumb__content">
                                <h3 class="title">Student SignUp</h3>
                                <nav class="breadcrumb">
                                    <span property="itemListElement" typeof="ListItem">
                                        <a href="index.html">Home</a>
                                    </span>
                                    <span class="breadcrumb-separator"><i class="fas fa-angle-right"></i></span>
                                    <span property="itemListElement" typeof="ListItem">SignUp</span>
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
                                        <label for="username">Username <span style="color: red">*</span></label>
                                        <input type="text" name="username" id="username" placeholder="Enter your username">
                                        <span class="error" id="usernameError"></span>
                                        <span class="valid-feedback" id="usernameValid">Username looks good!</span>
                                    </div>
                                    <div class="form-grp">
                                        <label for="email">Email <span style="color: red">*</span></label>
                                        <input type="email" name="email" id="email" placeholder="Enter your email">
                                        <span class="error" id="emailError"></span>
                                        <span class="valid-feedback" id="emailValid">Email looks good!</span>
                                    </div>
                                    <div class="form-grp">
                                        <label for="password">Password <span style="color: red">*</span></label>
                                        <input type="password" name="password" id="password" placeholder="Enter your password">
                                        <div class="password-requirements">
                                            Password should be at least 8 characters and include uppercase, lowercase, numbers and special characters.
                                        </div>
                                        <span class="error" id="passwordError"></span>
                                        <span class="valid-feedback" id="passwordValid">Password meets requirements!</span>
                                    </div>
                                    <div class="form-grp">
                                        <label for="confirm-password">Confirm Password <span style="color: red">*</span></label>
                                        <input type="password" name="confirmPassword" id="confirm-password" placeholder="Confirm your password">
                                        <span class="error" id="confirmPasswordError"></span>
                                        <span class="valid-feedback" id="confirmPasswordValid">Passwords match!</span>
                                    </div>
                                    <p style="color: red">${error}<br></p>
                                    <button type="submit" class="btn btn-two arrow-btn" id="submitBtn">Sign Up<img src="assets/img/icons/right_arrow.svg" alt="img" class="injectable"></button>
                                </form>
                                <div class="account__switch">
                                    <p>Already have an account? <a href="authen?action=login">Login</a></p>
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
                const username = document.getElementById('username');
                const email = document.getElementById('email');
                const password = document.getElementById('password');
                const confirmPassword = document.getElementById('confirm-password');
                
                const usernameError = document.getElementById('usernameError');
                const emailError = document.getElementById('emailError');
                const passwordError = document.getElementById('passwordError');
                const confirmPasswordError = document.getElementById('confirmPasswordError');
                
                const usernameValid = document.getElementById('usernameValid');
                const emailValid = document.getElementById('emailValid');
                const passwordValid = document.getElementById('passwordValid');
                const confirmPasswordValid = document.getElementById('confirmPasswordValid');

                // Live validation for username
                username.addEventListener('input', function() {
                    validateUsername();
                });
                
                // Live validation for email
                email.addEventListener('input', function() {
                    validateEmail();
                });
                
                // Live validation for password
                password.addEventListener('input', function() {
                    validatePassword();
                    // Also validate confirm password if it has a value
                    if (confirmPassword.value.trim() !== '') {
                        validateConfirmPassword();
                    }
                });
                
                // Live validation for confirm password
                confirmPassword.addEventListener('input', function() {
                    validateConfirmPassword();
                });

                // Form submission validation
                form.addEventListener('submit', function (event) {
                    // Reset all visual indicators
                    resetValidation();
                    
                    // Validate all fields and get the result
                    const isUsernameValid = validateUsername();
                    const isEmailValid = validateEmail();
                    const isPasswordValid = validatePassword();
                    const isConfirmPasswordValid = validateConfirmPassword();
                    
                    // Only proceed with submission if all validations pass
                    if (!(isUsernameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid)) {
                        event.preventDefault(); // Prevent form submission
                    }
                });
                
                // Function to validate username
                function validateUsername() {
                    const usernameValue = username.value.trim();
                    
                    // Reset validation indicators
                    usernameError.textContent = '';
                    usernameValid.style.display = 'none';
                    username.classList.remove('is-valid', 'is-invalid');
                    
                    // Check if username is empty
                    if (usernameValue === '') {
                        usernameError.textContent = 'Username is required';
                        username.classList.add('is-invalid');
                        return false;
                    }
                    
                    // Check username length
                    if (usernameValue.length < 3) {
                        usernameError.textContent = 'Username must be at least 3 characters';
                        username.classList.add('is-invalid');
                        return false;
                    }
                    
                    // Check username format (alphanumeric and underscores only)
                    const usernameRegex = /^[a-zA-Z0-9_]+$/;
                    if (!usernameRegex.test(usernameValue)) {
                        usernameError.textContent = 'Username can only contain letters, numbers, and underscores';
                        username.classList.add('is-invalid');
                        return false;
                    }
                    
                    // If all checks pass
                    username.classList.add('is-valid');
                    usernameValid.style.display = 'block';
                    return true;
                }
                
                // Function to validate email
                function validateEmail() {
                    const emailValue = email.value.trim();
                    
                    // Reset validation indicators
                    emailError.textContent = '';
                    emailValid.style.display = 'none';
                    email.classList.remove('is-valid', 'is-invalid');
                    
                    // Check if email is empty
                    if (emailValue === '') {
                        emailError.textContent = 'Email is required';
                        email.classList.add('is-invalid');
                        return false;
                    }
                    
                    // Check email format
                    if (!isValidEmail(emailValue)) {
                        emailError.textContent = 'Please enter a valid email address';
                        email.classList.add('is-invalid');
                        return false;
                    }
                    
                    // If all checks pass
                    email.classList.add('is-valid');
                    emailValid.style.display = 'block';
                    return true;
                }
                
                // Function to validate password
                function validatePassword() {
                    const passwordValue = password.value.trim();
                    
                    // Reset validation indicators
                    passwordError.textContent = '';
                    passwordValid.style.display = 'none';
                    password.classList.remove('is-valid', 'is-invalid');
                    
                    // Check if password is empty
                    if (passwordValue === '') {
                        passwordError.textContent = 'Password is required';
                        password.classList.add('is-invalid');
                        return false;
                    }
                    
                    // Check password length
                    if (passwordValue.length < 8) {
                        passwordError.textContent = 'Password must be at least 8 characters long';
                        password.classList.add('is-invalid');
                        return false;
                    }
                    
                    // Check password strength (optional)
                    const strongPasswordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                    if (!strongPasswordRegex.test(passwordValue)) {
                        passwordError.textContent = 'Password must include uppercase, lowercase, number and special character';
                        password.classList.add('is-invalid');
                        return false;
                    }
                    
                    // If all checks pass
                    password.classList.add('is-valid');
                    passwordValid.style.display = 'block';
                    return true;
                }
                
                // Function to validate confirm password
                function validateConfirmPassword() {
                    const confirmPasswordValue = confirmPassword.value.trim();
                    const passwordValue = password.value.trim();
                    
                    // Reset validation indicators
                    confirmPasswordError.textContent = '';
                    confirmPasswordValid.style.display = 'none';
                    confirmPassword.classList.remove('is-valid', 'is-invalid');
                    
                    // Check if confirm password is empty
                    if (confirmPasswordValue === '') {
                        confirmPasswordError.textContent = 'Please confirm your password';
                        confirmPassword.classList.add('is-invalid');
                        return false;
                    }
                    
                    // Check if passwords match
                    if (confirmPasswordValue !== passwordValue) {
                        confirmPasswordError.textContent = 'Passwords do not match';
                        confirmPassword.classList.add('is-invalid');
                        return false;
                    }
                    
                    // If all checks pass
                    confirmPassword.classList.add('is-valid');
                    confirmPasswordValid.style.display = 'block';
                    return true;
                }
                
                // Reset all validation indicators
                function resetValidation() {
                    const elements = [username, email, password, confirmPassword];
                    const errorElements = [usernameError, emailError, passwordError, confirmPasswordError];
                    const validElements = [usernameValid, emailValid, passwordValid, confirmPasswordValid];
                    
                    elements.forEach(element => {
                        element.classList.remove('is-valid', 'is-invalid');
                    });
                    
                    errorElements.forEach(element => {
                        element.textContent = '';
                    });
                    
                    validElements.forEach(element => {
                        element.style.display = 'none';
                    });
                }

                // Email validation function
                function isValidEmail(email) {
                    // More comprehensive email validation regex
                    const emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                    return emailRegex.test(email.toLowerCase());
                }
                
                // Optionally add debounce to prevent too frequent validation
                function debounce(func, timeout = 300) {
                    let timer;
                    return (...args) => {
                        clearTimeout(timer);
                        timer = setTimeout(() => { func.apply(this, args); }, timeout);
                    };
                }
            });
        </script>

        <script>
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
        </script>
    </body>

</html>