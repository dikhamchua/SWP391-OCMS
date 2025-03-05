<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Change Password</title>
        <meta name="description" content="SkillGro - Change Password">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.png">

        <!-- CSS here -->
        <jsp:include page="../common/css-file.jsp"></jsp:include>
            <style>
                .error-message {
                    color: red;
                    font-size: 0.8em;
                    margin-top: 5px;
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
            <main class="main-area">
                <!-- dashboard-area -->
                <section class="dashboard__area section-pb-120">
                    <div class="container">
                       <jsp:include page="../common/dashboard/avatar.jsp"></jsp:include>
                    <div class="dashboard__inner-wrap">
                        <div class="row">
                            <!--Side bar-->
                            <jsp:include page="../common/dashboard/sideBar.jsp"></jsp:include>

                                <!--Main Content-->
                                <div class="col-lg-9">
                                    <div class="dashboard__content-wrap">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Change Password</h4>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <div class="profile__content-wrap">
                                                    <form id="changePasswordForm" action="${pageContext.request.contextPath}/dashboard-profile?action=changePassword" method="post">
                                                    <div class="mb-3">
                                                        <label for="currentPassword" class="form-label">Current Password</label>
                                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                                        <span id="currentPasswordError" class="error-message"></span>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="newPassword" class="form-label">New Password</label>
                                                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                                        <span id="newPasswordError" class="error-message"></span>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                                        <span id="confirmPasswordError" class="error-message"></span>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary">Change Password</button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- dashboard-area-end -->
        </main>
        <!-- main-area-end -->

        <!-- footer-area -->
        <jsp:include page="../common/home/footer-home.jsp"></jsp:include>
            <!-- footer-area-end -->

            <!-- JS here -->
        <jsp:include page="../common/js-file.jsp"></jsp:include>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    var form = document.getElementById('changePasswordForm');
                    var currentPassword = document.getElementById('currentPassword');
                    var newPassword = document.getElementById('newPassword');
                    var confirmPassword = document.getElementById('confirmPassword');
                    var currentPasswordError = document.getElementById('currentPasswordError');
                    var newPasswordError = document.getElementById('newPasswordError');
                    var confirmPasswordError = document.getElementById('confirmPasswordError');

                    form.addEventListener('submit', function (event) {
                        var isValid = true;

                        // Reset error messages
                        currentPasswordError.textContent = '';
                        newPasswordError.textContent = '';
                        confirmPasswordError.textContent = '';

                        // Check if fields are empty
                        if (currentPassword.value.trim() === '') {
                            currentPasswordError.textContent = 'Current password is required';
                            isValid = false;
                        }

                        if (newPassword.value.trim() === '') {
                            newPasswordError.textContent = 'New password is required';
                            isValid = false;
                        }

                        if (confirmPassword.value.trim() === '') {
                            confirmPasswordError.textContent = 'Confirm password is required';
                            isValid = false;
                        }

                        // Check if new password matches confirm password
                        if (newPassword.value !== confirmPassword.value) {
                            confirmPasswordError.textContent = 'Passwords do not match';
                            isValid = false;
                        }

                        if (!isValid) {
                            event.preventDefault(); // Prevent form submission if there are errors
                        }
                    });

                    // Real-time validation for confirm password
                    confirmPassword.addEventListener('input', function () {
                        if (this.value !== newPassword.value) {
                            confirmPasswordError.textContent = 'Passwords do not match';
                        } else {
                            confirmPasswordError.textContent = '';
                        }
                    });

                    // Toast message display
                    var toastMessage = "${toastMessage}";
                    var toastType = "${toastType}";

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