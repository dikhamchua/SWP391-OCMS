<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Edit Video Lesson</title>
    <meta name="description" content="SkillGro - Edit Video Lesson">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/css-file.jsp"></jsp:include>
    
    <style>
        .form-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .form-section {
            margin-bottom: 25px;
        }
        
        .form-section-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px 15px;
            width: 100%;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .form-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .icon-input {
            position: relative;
        }
        
        .icon-input i {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        
        .icon-input input {
            padding-left: 35px;
        }
        
        .file-upload {
            position: relative;
            overflow: hidden;
            margin-top: 10px;
        }
        
        .file-upload input[type=file] {
            position: absolute;
            top: 0;
            right: 0;
            min-width: 100%;
            min-height: 100%;
            font-size: 100px;
            text-align: right;
            filter: alpha(opacity=0);
            opacity: 0;
            outline: none;
            cursor: pointer;
            display: block;
        }
        
        .preview-container {
            margin-top: 15px;
            border: 1px dashed #ddd;
            padding: 15px;
            border-radius: 4px;
            text-align: center;
        }
        
        .status-select {
            width: 100%;
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #ddd;
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
    <jsp:include page="../../common/home/header-home.jsp"></jsp:include>
    <!-- header-area-end -->

    <!-- main-area -->
    <main class="main-area">
        <section class="dashboard__area section-pb-120">
            <div class="container-fluid">
                <jsp:include page="../../common/dashboard/avatar.jsp"></jsp:include>

                <div class="dashboard__inner-wrap">
                    <div class="row">
                        <jsp:include page="../../common/dashboard/sideBar.jsp"></jsp:include>
                        <div class="col-lg-9">
                            <div class="dashboard__content-wrap">
                                <div class="dashboard__content-title d-flex justify-content-between align-items-center">
                                    <h4 class="title">Chỉnh sửa bài học video</h4>
                                    <a href="${pageContext.request.contextPath}/manage-course?action=manage&id=${course.id}" class="btn" style="background-color: #f5f5f5; border: none;">
                                        <i class="fa fa-arrow-left"></i> Quay lại
                                    </a>
                                </div>
                                
                                <!-- Edit Form -->
                                <div class="form-container">
                                    <form action="${pageContext.request.contextPath}/lesson-edit" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="id" value="${lesson.id}">
                                        
                                        <!-- Basic Information -->
                                        <div class="form-section">
                                            <h5 class="form-section-title">Thông tin cơ bản</h5>
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">ID</label>
                                                        <input type="text" class="form-control" value="${lesson.id}" disabled>
                                                    </div>
                                                </div>
                                                
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Phần</label>
                                                        <select name="sectionId" class="form-control">
                                                            <c:forEach var="sectionItem" items="${sections}">
                                                                <option value="${sectionItem.id}" ${sectionItem.id == lesson.sectionId ? 'selected' : ''}>
                                                                    ${sectionItem.title}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label class="form-label">Tiêu đề bài học</label>
                                                <input type="text" class="form-control" name="title" value="${lesson.title}" required>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label class="form-label">Mô tả</label>
                                                <textarea class="form-control" name="description" rows="3">${lesson.description}</textarea>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Thời lượng (phút)</label>
                                                        <div class="icon-input">
                                                            <i class="fa fa-clock"></i>
                                                            <input type="number" class="form-control" name="durationMinutes" value="${lesson.durationMinutes}" min="0">
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Thứ tự</label>
                                                        <input type="number" class="form-control" name="orderNumber" value="${lesson.orderNumber}" min="1">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Video Information -->
                                        <div class="form-section">
                                            <h5 class="form-section-title">Thông tin video</h5>
                                            
                                            <div class="form-group">
                                                <label class="form-label">Tải lên video</label>
                                                <div class="file-upload">
                                                    <input type="file" name="videoFile" id="videoFile" accept="video/*">
                                                    <button type="button" class="btn btn-outline-secondary">Chọn tệp video</button>
                                                </div>
                                                <small class="form-text">Tải lên video trực tiếp (MP4, WebM, Ogg). Kích thước tối đa: 50MB</small>
                                                
                                                <c:if test="${lessonVideo != null && lessonVideo.videoUrl != null}">
                                                    <div class="mt-2">
                                                        <span class="text-success">
                                                            <i class="fa fa-check-circle"></i> 
                                                            Video hiện tại: ${lessonVideo.videoUrl.substring(lessonVideo.videoUrl.lastIndexOf('/') + 1)}
                                                        </span>
                                                        <input type="hidden" name="videoUrl" value="${lessonVideo.videoUrl}">
                                                    </div>
                                                </c:if>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label class="form-label">Thời lượng video (phút)</label>
                                                <input type="number" class="form-control" name="videoDuration" value="${lessonVideo.videoDuration}" min="0">
                                                <small class="form-text">Nhập thời lượng video tính bằng phút</small>
                                            </div>
                                            
                                            <!-- Video Preview -->
                                            <div class="preview-container">
                                                <c:choose>
                                                    <c:when test="${lessonVideo != null && lessonVideo.videoUrl != null && !empty lessonVideo.videoUrl}">
                                                        <h6>Xem trước video</h6>
                                                        <div style="max-width: 400px; margin: 0 auto;">
                                                            <div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
                                                                <video controls style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;">
                                                                    <source src="${lessonVideo.videoUrl}" type="video/mp4">
                                                                    Your browser does not support the video tag.
                                                                </video>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fa fa-video fa-3x mb-3 text-muted"></i>
                                                        <p>Không có video nào được cung cấp</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <!-- Status Information -->
                                        <div class="form-section">
                                            <h5 class="form-section-title">Trạng thái</h5>
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Trạng thái</label>
                                                        <select name="status" class="status-select">
                                                            <option value="active" ${lesson.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                                            <option value="inactive" ${lesson.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                                            <option value="draft" ${lesson.status == 'draft' ? 'selected' : ''}>Bản nháp</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Ngày tạo</label>
                                                        <input type="text" class="form-control" value="${lesson.createdDate}" disabled>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label class="form-label">Cập nhật lần cuối</label>
                                                <input type="text" class="form-control" value="${lesson.modifiedDate}" disabled>
                                            </div>
                                        </div>
                                        
                                        <!-- Form Actions -->
                                        <div class="form-actions">
                                            <a href="${pageContext.request.contextPath}/manage-course?action=manage&id=${course.id}" class="btn btn-outline-secondary">Hủy</a>
                                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
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
    <jsp:include page="../../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../common/js-file.jsp"></jsp:include>

    <script>
        $(document).ready(function() {
            // File upload button functionality
            $('.file-upload button').click(function() {
                $(this).siblings('input[type=file]').click();
            });
            
            // Display filename when selected
            $('input[type=file]').change(function() {
                var filename = $(this).val().split('\\').pop();
                if (filename) {
                    $(this).siblings('button').text(filename);
                } else {
                    $(this).siblings('button').text('Chọn tệp video');
                }
            });
            
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
        });
    </script>
</body>

</html>
