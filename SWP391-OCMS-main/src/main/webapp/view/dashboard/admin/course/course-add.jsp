<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://example.com/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Thêm khóa học mới</title>
    <meta name="description" content="SkillGro - Thêm khóa học mới">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../../common/css-file.jsp"></jsp:include>
    
    <style>
        .preview-image {
            max-width: 300px;
            margin-top: 10px;
            display: none;
        }
        
        .required-field::after {
            content: " *";
            color: red;
        }
        
        .custom-file-input {
            cursor: pointer;
        }
        
        .form-label {
            font-weight: 600;
        }
        
        .rich-text-editor {
            min-height: 200px;
        }
        
        /* Thêm CSS cho thông báo lỗi */
        .text-danger {
            color: #dc3545;
            font-size: 0.85em;
            margin-top: 5px;
            display: block;
        }
        
        .input-error {
            border-color: #dc3545;
        }
        
        input:focus.input-error,
        select:focus.input-error {
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
            border-color: #dc3545;
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
    <jsp:include page="../../../common/home/header-home.jsp"></jsp:include>
    <!-- header-area-end -->

    <!-- main-area -->
    <main class="main-area">
        <section class="dashboard__area section-pb-120">
            <div class="container-fluid">
                <jsp:include page="../../../common/dashboard/avatar.jsp"></jsp:include>

                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <jsp:include page="../../../common/dashboard/sideBar.jsp"></jsp:include>
                        <div class="col-lg-9">
                            <div class="dashboard__content-wrap">
                                <div class="dashboard__content-title">
                                    <div class="title d-flex justify-content-between align-items-center">
                                        <h4>Thêm khóa học mới</h4>
                                        <a href="${pageContext.request.contextPath}/manage-course?action=list"
                                            class="btn btn-secondary">
                                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                                        </a>
                                    </div>
                                </div>
                                
                                <div class="dashboard__content-form">
                                    <form id="courseForm" action="${pageContext.request.contextPath}/manage-course?action=add" method="post" enctype="multipart/form-data">
                                        <div class="row mb-3">
                                            <div class="col-md-12">
                                                <label for="courseName" class="form-label required-field">Tên khóa học</label>
                                                <input type="text" class="form-control" id="courseName" name="name" required>
                                                <small id="courseNameError" class="text-danger"></small>
                                                <div class="invalid-feedback">Vui lòng nhập tên khóa học</div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="coursePrice" class="form-label required-field">Giá (USD)</label>
                                                <input type="number" class="form-control" id="coursePrice" name="price" step="0.01" min="0" required>
                                                <small id="coursePriceError" class="text-danger"></small>
                                                <div class="invalid-feedback">Giá không hợp lệ</div>
                                            </div>
                                            
                                            <div class="col-md-6">
                                                <label for="courseCategory" class="form-label required-field">Danh mục</label>
                                                <select class="form-select" id="courseCategory" name="categoryId" required>
                                                    <option value="">-- Chọn danh mục --</option>
                                                    <c:forEach var="category" items="${categories}">
                                                        <option value="${category.id}">${category.name}</option>
                                                    </c:forEach>
                                                </select>
                                                <div class="invalid-feedback">Vui lòng chọn danh mục</div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-12">
                                                <label for="courseThumbnail" class="form-label required-field">Ảnh thumbnail</label>
                                                <input type="file" class="form-control custom-file-input" id="courseThumbnail" name="thumbnail" accept="image/*" required>
                                                <div class="invalid-feedback">Vui lòng chọn ảnh thumbnail</div>
                                                <img id="thumbnailPreview" class="preview-image" src="#" alt="Thumbnail preview">
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-12">
                                                <label for="courseDescription" class="form-label required-field">Mô tả khóa học</label>
                                                <textarea class="form-control rich-text-editor" id="courseDescription" name="description" rows="10" required></textarea>
                                                <small id="courseDescriptionError" class="text-danger"></small>
                                                <div class="invalid-feedback">Vui lòng nhập mô tả khóa học</div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-4">
                                            <div class="col-md-12">
                                                <label for="courseStatus" class="form-label required-field">Trạng thái</label>
                                                <select class="form-select" id="courseStatus" name="status" required>
                                                    <option value="draft">Bản nháp</option>
                                                    <option value="inactive">Chưa hoạt động</option>
                                                    <option value="active">Hoạt động</option>
                                                </select>
                                                <div class="invalid-feedback">Vui lòng chọn trạng thái</div>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-12 text-center">
                                                <button type="submit" class="btn btn-primary btn-lg px-5">
                                                    <i class="fas fa-save"></i> Lưu khóa học
                                                </button>
                                            </div>
                                        </div>
                                    </form>
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
    <jsp:include page="../../../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../../common/js-file.jsp"></jsp:include>
    
    <!-- Include CKEditor from CDN -->
    <script src="https://cdn.ckeditor.com/4.14.1/standard/ckeditor.js"></script>
    
    <script>
        // Initialize CKEditor for rich text description
        CKEDITOR.replace('courseDescription', {
            height: 300,
            removePlugins: 'resize',
            toolbarGroups: [
                { name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
                { name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
                { name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
                { name: 'forms', groups: [ 'forms' ] },
                '/',
                { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
                { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
                { name: 'links', groups: [ 'links' ] },
                { name: 'insert', groups: [ 'insert' ] },
                '/',
                { name: 'styles', groups: [ 'styles' ] },
                { name: 'colors', groups: [ 'colors' ] },
                { name: 'tools', groups: [ 'tools' ] },
                { name: 'others', groups: [ 'others' ] },
                { name: 'about', groups: [ 'about' ] }
            ]
        });
        
        // Preview image before upload
        document.getElementById('courseThumbnail').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                const preview = document.getElementById('thumbnailPreview');
                
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                
                reader.readAsDataURL(file);
            }
        });
        
        // Hàm validate tên khóa học
        function validateCourseName() {
            const nameInput = document.getElementById('courseName');
            const nameError = document.getElementById('courseNameError');
            
            if (!nameInput.value.trim()) {
                nameError.textContent = "Tên khóa học không được để trống.";
                nameInput.classList.add('input-error');
                return false;
            } else if (nameInput.value.length > 100) {
                nameError.textContent = "Tên khóa học không được vượt quá 100 ký tự.";
                nameInput.classList.add('input-error');
                return false;
            } else {
                nameError.textContent = "";
                nameInput.classList.remove('input-error');
                return true;
            }
        }
        
        // Hàm validate giá khóa học
        function validateCoursePrice() {
            const priceInput = document.getElementById('coursePrice');
            const priceError = document.getElementById('coursePriceError');
            
            if (!priceInput.value.trim()) {
                priceError.textContent = "Giá khóa học không được để trống.";
                priceInput.classList.add('input-error');
                return false;
            } else if (!/^\d+(\.\d+)?$/.test(priceInput.value)) {
                priceError.textContent = "Giá khóa học phải là định dạng số hợp lệ.";
                priceInput.classList.add('input-error');
                return false;
            } else if (parseFloat(priceInput.value) <= 0) {
                priceError.textContent = "Giá khóa học phải là số dương.";
                priceInput.classList.add('input-error');
                return false;
            } else {
                priceError.textContent = "";
                priceInput.classList.remove('input-error');
                return true;
            }
        }
        
        // Hàm validate mô tả khóa học
        function validateCourseDescription() {
            const description = CKEDITOR.instances.courseDescription.getData();
            const descriptionError = document.getElementById('courseDescriptionError');
            
            if (!description.trim()) {
                descriptionError.textContent = "Mô tả khóa học không được để trống.";
                return false;
            } else if (description.replace(/<[^>]*>/g, '').length > 500) {
                descriptionError.textContent = "Mô tả không được vượt quá 500 ký tự.";
                return false;
            } else {
                descriptionError.textContent = "";
                return true;
            }
        }
        
        // Thêm sự kiện blur cho các trường nhập liệu
        document.getElementById('courseName').addEventListener('blur', validateCourseName);
        document.getElementById('coursePrice').addEventListener('blur', validateCoursePrice);
        
        // Event listener cho CKEditor khi mất focus
        CKEDITOR.instances.courseDescription.on('blur', validateCourseDescription);
        
        // Form validation khi submit
        document.getElementById('courseForm').addEventListener('submit', function(e) {
            let isValid = true;
            
            // Validate tất cả các trường
            if (!validateCourseName()) isValid = false;
            if (!validateCoursePrice()) isValid = false;
            if (!validateCourseDescription()) isValid = false;
            
            // Nếu có lỗi, ngăn form submit
            if (!isValid) {
                e.preventDefault();
            }
        });
        
        // Hiển thị thông báo
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage) {
            iziToast.show({
                title: toastType === 'success' ? 'Thành công' : 'Lỗi',
                message: toastMessage,
                position: 'topRight',
                color: toastType === 'success' ? 'green' : 'red',
                timeout: 5000,
                onClosing: function () {
                    // Xóa thông báo khỏi session sau khi hiển thị
                    fetch('${pageContext.request.contextPath}/remove-toast', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                    }).then(response => {
                        if (!response.ok) {
                            console.error('Không thể xóa thông báo');
                        }
                    }).catch(error => {
                        console.error('Lỗi:', error);
                    });
                }
            });
        }
    </script>
</body>

</html>