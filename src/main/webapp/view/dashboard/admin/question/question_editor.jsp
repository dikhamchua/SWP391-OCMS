<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Quiz Question Editor</title>
    <meta name="description" content="SkillGro - Quiz Question Editor">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../../common/css-file.jsp"></jsp:include>
    
    <!-- TinyMCE CDN -->
    <script src="https://cdn.tiny.cloud/1/1u2sqtwzv5mnznfeh0gp0y5wnpqarxf9yx4bn0pjzvot8xy2/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
    
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
        
        .question-container {
            border: 1px solid #eee;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
            position: relative;
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .question-title {
            margin: 0;
            color: #333;
        }
        
        .remove-question {
            cursor: pointer;
            color: #dc3545;
            font-size: 18px;
        }
        
        .answer-option {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .answer-option input[type="radio"] {
            margin-right: 10px;
        }
        
        .add-question-btn {
            margin-top: 15px;
        }
        
        /* TinyMCE specific styles */
        .tox-tinymce {
            border-radius: 4px;
            border: 1px solid #ddd !important;
        }
        
        .tox-statusbar {
            border-top: 1px solid #eee !important;
        }
        
        .tox-tinymce-aux {
            z-index: 9999 !important;
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

    <!-- main-area -->
    <main class="main-area">
        <section class="course-details-area pt-120 pb-100">
            <div class="container">
                <div class="row">
                    <div class="col-xl-12 col-lg-12">
                        <div class="form-container">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="mb-0">
                                    <c:choose>
                                        <c:when test="${question.id == 0}">Thêm câu hỏi mới</c:when>
                                        <c:otherwise>Chỉnh sửa câu hỏi</c:otherwise>
                                    </c:choose>
                                </h4>
                                <a href="${pageContext.request.contextPath}/manage-question" class="btn btn-outline-secondary">
                                    <i class="fa fa-arrow-left"></i> Quay lại danh sách câu hỏi
                                </a>
                            </div>
                            
                            <form action="${pageContext.request.contextPath}/manage-question" method="post" id="questionForm">
                                <input type="hidden" name="action" value="saveQuestion">
                                <input type="hidden" name="questionId" value="${question.id}">
                                <input type="hidden" name="quizId" value="${question.quizId}">
                                <input type="hidden" id="answerCount" name="answerCount" value="${empty answers ? 4 : answers.size()}">
                                
                                <div class="form-section">
                                    <div class="form-section-title">Thông tin câu hỏi</div>
                                    <div class="form-group">
                                        <label class="form-label">Nội dung câu hỏi</label>
                                        <textarea class="form-control question-editor" name="questionText" rows="5">${question.questionText}</textarea>
                                        <small class="form-text">Bạn có thể thêm hình ảnh, âm thanh hoặc định dạng văn bản.</small>
                                    </div>
                                </div>
                                
                                <div class="form-section">
                                    <div class="form-section-title">Đáp án</div>
                                    <div class="form-group">
                                        <label class="form-label">Các đáp án</label>
                                        <div class="answers-container" id="answers-container">
                                            <c:choose>
                                                <c:when test="${not empty answers}">
                                                    <c:forEach var="answer" items="${answers}" varStatus="status">
                                                        <div class="answer-option" id="answer-${status.index + 1}">
                                                            <input type="radio" name="correctAnswer" value="${status.index + 1}" ${answer.isCorrect ? 'checked' : ''}>
                                                            <input type="text" class="form-control" name="answerText_${status.index + 1}" value="${answer.answerText}" placeholder="Đáp án ${status.index + 1}" required>
                                                            <input type="hidden" name="answerId_${status.index + 1}" value="${answer.id}">
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach begin="1" end="4" varStatus="status">
                                                        <div class="answer-option" id="answer-${status.index}">
                                                            <input type="radio" name="correctAnswer" value="${status.index}" ${status.index == 1 ? 'checked' : ''}>
                                                            <input type="text" class="form-control" name="answerText_${status.index}" placeholder="Đáp án ${status.index}" required>
                                                            <input type="hidden" name="answerId_${status.index}" value="0">
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/manage-question" class="btn btn-outline-secondary">Hủy</a>
                                    <button type="submit" class="btn btn-primary">Lưu câu hỏi</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- footer-area -->
    <jsp:include page="../../../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../../common/js-file.jsp"></jsp:include>

    <script>
        $(document).ready(function() {
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
            
            // Initialize TinyMCE
            initTinyMCE();
            
            // Form submission
            $('#questionForm').submit(function(e) {
                // Save TinyMCE content before submitting
                tinymce.triggerSave();
                
                // Validate form
                if (!validateForm()) {
                    e.preventDefault();
                    return false;
                }
                
                return true;
            });
            
            // Validate form
            function validateForm() {
                // Check if question text is not empty
                var questionText = tinymce.get('questionText').getContent();
                if (!questionText || questionText.trim() === '') {
                    iziToast.error({
                        title: 'Error',
                        message: 'Question text cannot be empty',
                        position: 'topRight',
                        timeout: 3000
                    });
                    return false;
                }
                
                // Check if at least one answer is selected as correct
                if (!$('input[name="correctAnswer"]:checked').length) {
                    iziToast.error({
                        title: 'Error',
                        message: 'Please select a correct answer',
                        position: 'topRight',
                        timeout: 3000
                    });
                    return false;
                }
                
                // Check if all answer fields are filled
                var allFilled = true;
                $('input[name^="answerText_"]').each(function() {
                    if ($(this).val().trim() === '') {
                        allFilled = false;
                        return false; // break the loop
                    }
                });
                
                if (!allFilled) {
                    iziToast.error({
                        title: 'Error',
                        message: 'All answer fields must be filled',
                        position: 'topRight',
                        timeout: 3000
                    });
                    return false;
                }
                
                return true;
            }
            
            // Add answer option
            $('#addAnswerBtn').click(function() {
                var answerCount = parseInt($('#answerCount').val());
                answerCount++;
                
                var newAnswer = `
                    <div class="answer-option" id="answer-${answerCount}">
                        <input type="radio" name="correctAnswer" value="${answerCount}">
                        <input type="text" class="form-control" name="answerText_${answerCount}" placeholder="Đáp án ${answerCount}" required>
                        <input type="hidden" name="answerId_${answerCount}" value="0">
                    </div>
                `;
                
                $('#answers-container').append(newAnswer);
                $('#answerCount').val(answerCount);
            });
            
            // Remove last answer option
            $('#removeAnswerBtn').click(function() {
                var answerCount = parseInt($('#answerCount').val());
                if (answerCount > 2) {
                    $(`#answer-${answerCount}`).remove();
                    answerCount--;
                    $('#answerCount').val(answerCount);
                } else {
                    iziToast.warning({
                        title: 'Warning',
                        message: 'A quiz must have at least 2 answer options',
                        position: 'topRight',
                        timeout: 3000
                    });
                }
            });
        });
        
        // Function to initialize TinyMCE
        function initTinyMCE(selector = '.question-editor') {
            tinymce.init({
                selector: selector,
                plugins: 'image media code table lists link',
                toolbar: 'undo redo | formatselect | bold italic | alignleft aligncenter alignright | bullist numlist | link image media insertAudio | table | code',
                height: 250,
                image_caption: true,
                automatic_uploads: true,
                media_live_embeds: true,
                file_picker_types: 'image',
                file_picker_callback: function(cb, value, meta) {
                    if (meta.filetype === 'image') {
                        const input = document.createElement('input');
                        input.setAttribute('type', 'file');
                        input.setAttribute('accept', 'image/*');
                        input.click();
                        input.onchange = function () {
                            const file = this.files[0];
                            const reader = new FileReader();
                            reader.onload = function () {
                                const id = 'blobid' + (new Date()).getTime();
                                const blobCache = tinymce.activeEditor.editorUpload.blobCache;
                                const base64 = reader.result.split(',')[1];
                                const blobInfo = blobCache.create(id, file, base64);
                                blobCache.add(blobInfo);
                                cb(blobInfo.blobUri(), { title: file.name });
                            };
                            reader.readAsDataURL(file);
                        };
                    }
                },
                setup: function (editor) {
                    // Add custom audio upload button
                    editor.ui.registry.addButton('insertAudio', {
                        text: 'Upload Audio',
                        icon: 'audio',
                        onAction: function () {
                            const input = document.createElement('input');
                            input.type = 'file';
                            input.accept = 'audio/*';
                            input.click();
        
                            input.onchange = function () {
                                const file = input.files[0];
                                const formData = new FormData();
                                formData.append('audio', file);
        
                                fetch('${pageContext.request.contextPath}/uploadAudioServlet', {
                                    method: 'POST',
                                    body: formData
                                })
                                .then(res => res.text())
                                .then(url => {
                                    editor.insertContent(
                                        '<p>🎧 File âm thanh:</p>' +
                                        '<audio controls>' +
                                        '<source src=\"' + url + '\" type=\"' + file.type + '\">' +
                                        'Trình duyệt của bạn không hỗ trợ audio.' +
                                        '</audio><br>'
                                    );
                                });
                            };
                        }
                    });
        
                    editor.on('change', function () {
                        editor.save();
                    });
                }
            });
        }
    </script>
</body>

</html> 