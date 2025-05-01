<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Online Courses & Education Template</title>
        <meta name="description" content="SkillGro - Online Courses & Education Template">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.png">
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
                                            <h4 class="title">My Profile</h4>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <div class="profile__content-wrap">
                                                    <form action="${pageContext.request.contextPath}/dashboard-profile" method="post">
                                                    <input type="hidden" name="action" value="updateProfile">
                                                    <div class="mb-3">
                                                        <label for="email" class="form-label">Email</label>
                                                        <input type="email" class="form-control" id="email" name="email" value="${accountDetails.email}" readonly>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="role" class="form-label">Role</label>
                                                        <input type="text" class="form-control" id="role" name="role" 
                                                        value="${accountDetails.roleId == 1 ? 'Admin' : accountDetails.roleId == 2 ? 'Teacher' : accountDetails.roleId == 3 ? 'Student' : 'Marketing'}"
                                                               readonly>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="phone" class="form-label">Phone</label>
                                                        <input type="text" class="form-control" id="phone" name="phone" 
                                                               value="${accountDetails.phone}"
                                                               maxlength="13">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="fullName" class="form-label">Full Name</label>
                                                        <input type="text" class="form-control" id="fullName" name="fullName" 
                                                               value="${accountDetails.fullName}">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="gender" class="form-label">Gender</label>
                                                        <select class="form-select" id="gender" name="gender">
                                                            <option value="true" ${accountDetails.gender ? 'selected' : ''}>Male</option>
                                                            <option value="false" ${!accountDetails.gender ? 'selected' : ''}>Female</option>
                                                        </select>
                                                    </div>
                                                    
                                                    <button type="submit" class="btn btn-primary">Update Profile</button>
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
            <!--        <script>
                        SVGInject(document.querySelectorAll("img.injectable"));
                    </script>-->
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    var toastMessage = "${toastMessage}";
                    var toastType = "${toastType}";

                    if (toastMessage) {
                        iziToast.show({
                            title: toastType === 'success' ? 'Success' : 'Error',
                            message: toastMessage,
                            position: 'topRight',
                            color: toastType === 'success' ? 'green' : 'red',
                            timeout: 5000
                        });
                    }
                    
                    // Thêm validation cho form
                    const profileForm = document.querySelector('form[action="${pageContext.request.contextPath}/dashboard-profile"]');
                    const phoneInput = document.getElementById('phone');
                    const fullNameInput = document.getElementById('fullName');
                    
                    // Thêm thông báo lỗi
                    function showError(input, message) {
                        const formGroup = input.parentElement;
                        let errorDiv = formGroup.querySelector('.invalid-feedback');
                        
                        if (!errorDiv) {
                            errorDiv = document.createElement('div');
                            errorDiv.className = 'invalid-feedback';
                            formGroup.appendChild(errorDiv);
                        }
                        
                        input.classList.add('is-invalid');
                        errorDiv.textContent = message;
                    }
                    
                    // Xóa thông báo lỗi
                    function clearError(input) {
                        input.classList.remove('is-invalid');
                        const formGroup = input.parentElement;
                        const errorDiv = formGroup.querySelector('.invalid-feedback');
                        if (errorDiv) {
                            errorDiv.textContent = '';
                        }
                    }
                    
                    // Kiểm tra số điện thoại
                    function validatePhone(phone) {
                        const phoneRegex = /^[0-9]{10,13}$/;
                        return phoneRegex.test(phone);
                    }
                    
                    // Kiểm tra họ tên
                    function validateFullName(name) {
                        // Kiểm tra độ dài tối thiểu
                        if (name.trim().length < 2) {
                            return false;
                        }
                        
                        // Kiểm tra không chứa số và ký tự đặc biệt
                        const nameRegex = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]+$/;
                        return nameRegex.test(name);
                    }
                    
                    // Xử lý sự kiện khi nhập số điện thoại
                    phoneInput.addEventListener('input', function() {
                        clearError(phoneInput);
                    });
                    
                    // Xử lý sự kiện khi nhập họ tên
                    fullNameInput.addEventListener('input', function() {
                        clearError(fullNameInput);
                    });
                    
                    // Xử lý sự kiện submit form
                    profileForm.addEventListener('submit', function(e) {
                        let isValid = true;
                        
                        // Kiểm tra số điện thoại
                        if (!validatePhone(phoneInput.value)) {
                            showError(phoneInput, 'Số điện thoại phải có 10-13 chữ số');
                            isValid = false;
                        }
                        
                        // Kiểm tra họ tên
                        if (!validateFullName(fullNameInput.value)) {
                            if (fullNameInput.value.trim().length < 2) {
                                showError(fullNameInput, 'Họ tên phải có ít nhất 2 ký tự');
                            } else {
                                showError(fullNameInput, 'Họ tên không được chứa số và ký tự đặc biệt');
                            }
                            isValid = false;
                        }
                        
                        if (!isValid) {
                            e.preventDefault();
                        }
                    });
                });
            </script>
        </script>
    </body>

</html>