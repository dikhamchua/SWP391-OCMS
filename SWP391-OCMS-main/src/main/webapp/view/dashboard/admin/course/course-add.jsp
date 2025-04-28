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
                                                <div class="invalid-feedback">Vui lòng nhập tên khóa học</div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="coursePrice" class="form-label required-field">Giá (USD)</label>
                                                <input type="number" class="form-control" id="coursePrice" name="price" step="0.01" min="0" required>
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
        
        // Form validation
        document.getElementById('courseForm').addEventListener('submit', function(e) {
            // Get form elements
            const form = e.target;
            const nameInput = document.getElementById('courseName');
            const priceInput = document.getElementById('coursePrice');
            const categorySelect = document.getElementById('courseCategory');
            const thumbnailInput = document.getElementById('courseThumbnail');
            
            // Check name
            if (!nameInput.value.trim()) {
                nameInput.classList.add('is-invalid');
                e.preventDefault();
            } else {
                nameInput.classList.remove('is-invalid');
            }
            
            // Check price
            if (priceInput.value === '' || parseFloat(priceInput.value) < 0) {
                priceInput.classList.add('is-invalid');
                e.preventDefault();
            } else {
                priceInput.classList.remove('is-invalid');
            }
            
            // Check category
            if (!categorySelect.value) {
                categorySelect.classList.add('is-invalid');
                e.preventDefault();
            } else {
                categorySelect.classList.remove('is-invalid');
            }
            
            // Check thumbnail
            if (!thumbnailInput.files || thumbnailInput.files.length === 0) {
                thumbnailInput.classList.add('is-invalid');
                e.preventDefault();
            } else {
                thumbnailInput.classList.remove('is-invalid');
            }
            
            // Check description
            const description = CKEDITOR.instances.courseDescription.getData();
            if (!description.trim()) {
                document.getElementById('courseDescription').classList.add('is-invalid');
                e.preventDefault();
            } else {
                document.getElementById('courseDescription').classList.remove('is-invalid');
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