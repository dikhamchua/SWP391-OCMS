<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Edit Quiz Lesson</title>
    <meta name="description" content="SkillGro - Edit Quiz Lesson">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/css-file.jsp"></jsp:include>
    
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
        
        .status-select {
            width: 100%;
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #ddd;
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
    <jsp:include page="../../common/home/header-home.jsp"></jsp:include>

        <!-- course-details-area -->
        <section class="course-details-area pt-120 pb-100">
            <div class="container">
                <div class="row">
                    <div class="col-xl-12 col-lg-12">
                        <div class="form-container">
                            <form action="${pageContext.request.contextPath}/lesson-edit?action=update" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="id" value="${lesson.id}">
                                <input type="hidden" name="type" value="${lesson.type}">
                                <input type="hidden" name="questionCount" id="questionCount" value="${questions.size()}">
                                
                                <div class="form-section">
                                    <h5 class="form-section-title">Thông tin cơ bản</h5>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Phần</label>
                                        <select name="sectionId" class="form-control" required>
                                            <option value="">-- Chọn phần --</option>
                                            <c:forEach var="sectionItem" items="${sections}">
                                                <option value="${sectionItem.id}" ${sectionItem.id == lesson.sectionId ? 'selected' : ''}>
                                                    ${sectionItem.title}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Tiêu đề bài kiểm tra</label>
                                        <input type="text" class="form-control" name="title" value="${lesson.title}" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Mô tả</label>
                                        <textarea class="form-control" name="description" rows="3">${lesson.description}</textarea>
                                    </div>
                                    
                                    <!-- Quiz Settings -->
                                    <div class="form-section">
                                        <h5 class="form-section-title">Cài đặt bài kiểm tra</h5>
                                        
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                </div>
                                            </div>
                                            
                                            <div class="col-md-4">
                                            </div>
                                            
                                            <div class="col-md-4">
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label">Trạng thái</label>
                                        <select name="status" class="status-select">
                                            <option value="active" ${lesson.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="inactive" ${lesson.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <!-- Quiz Questions -->
                                <div class="form-section">
                                    <h5 class="form-section-title">Câu hỏi</h5>
                                    
                                    <div id="questions-container">
                                        <!-- Existing questions will be loaded here -->
                                        <c:forEach var="question" items="${questions}" varStatus="status">
                                            <div class="question-container" data-question-id="${status.index + 1}">
                                                <div class="question-header">
                                                    <h6 class="question-title">Câu hỏi ${status.index + 1}</h6>
                                                    <span class="remove-question" onclick="removeQuestion(this)"><i class="fa fa-times"></i></span>
                                                </div>
                                                
                                                <div class="form-group">
                                                    <label class="form-label">Nội dung câu hỏi</label>
                                                    <textarea class="question-editor form-control" name="question_text_${status.index + 1}">${question.questionText}</textarea>
                                                    <input type="hidden" name="question_id_${status.index + 1}" value="${question.id}">
                                                </div>
                                                
                                                <div class="form-group">
                                                    <label class="form-label">Các đáp án</label>
                                                    <div class="answers-container" data-question-id="${status.index + 1}">
                                                        <c:forEach var="answer" items="${answersByQuestionId[question.id]}" varStatus="answerStatus">
                                                            <div class="answer-option">
                                                                <input type="radio" name="correct_answer_${status.index + 1}" value="${answerStatus.index + 1}" ${answer.isCorrect ? 'checked' : ''}>
                                                                <input type="text" class="form-control" name="answer_text_${status.index + 1}_${answerStatus.index + 1}" value="${answer.answerText}" placeholder="Đáp án ${answerStatus.index + 1}" required>
                                                                <input type="hidden" name="answer_id_${status.index + 1}_${answerStatus.index + 1}" value="${answer.id}">
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    
                                    <div class="text-center add-question-btn">
                                        <button type="button" class="btn btn-primary" onclick="addQuestion()">
                                            <i class="fa fa-plus"></i> Thêm câu hỏi
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/manage-course?action=manage&id=${course.id}" class="btn btn-outline-secondary">Hủy</a>
                                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- course-details-area-end -->
    </main>

    <!-- footer-area -->
    <jsp:include page="../../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../common/js-file.jsp"></jsp:include>

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
            
            // Initialize TinyMCE for existing question editors
            initTinyMCE();
        });
        
        <%-- Khởi tạo biến đếm câu hỏi --%>
        <c:set var="initialQuestionCount" value="${not empty questions ? questions.size() : 0}" />
        var questionCounter = <%= pageContext.getAttribute("initialQuestionCount") %>;
        var existingQuestions = <%= pageContext.getAttribute("initialQuestionCount") %>;

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
            

        // Function to add a new question
        function addQuestion() {
            questionCounter++;
            var tempId = 'new_' + Date.now() + '_' + questionCounter;
            
            var questionHtml = 
                '<div class="question-container" data-question-id="' + questionCounter + '">' +
                    '<div class="question-header">' +
                        '<h6 class="question-title">Câu hỏi ' + questionCounter + '</h6>' +
                        '<span class="remove-question" onclick="removeQuestion(this)"><i class="fa fa-times"></i></span>' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label class="form-label">Nội dung câu hỏi</label>' +
                        '<textarea class="question-editor-new form-control" id="question_' + questionCounter + '" name="question_text_' + questionCounter + '"></textarea>' +
                        '<input type="hidden" name="question_id_' + questionCounter + '" value="0">' +
                    '</div>' +
                    '<div class="form-group">' +
                        '<label class="form-label">Các đáp án</label>' +
                        '<div class="answers-container" data-question-id="' + questionCounter + '">' +
                            Array(4).fill().map(function(_, idx) {
                                var answerNum = idx + 1;
                                return '<div class="answer-option">' +
                                    '<input type="radio" name="correct_answer_' + questionCounter + '" value="' + answerNum + '" ' + (answerNum === 1 ? 'checked' : '') + '>' +
                                    '<input type="text" class="form-control" name="answer_text_' + questionCounter + '_' + answerNum + '" placeholder="Đáp án ' + answerNum + '" required>' +
                                    '<input type="hidden" name="answer_id_' + questionCounter + '_' + answerNum + '" value="0">' +
                                '</div>';
                            }).join('') +
                        '</div>' +
                    '</div>' +
                '</div>';
            
            $('#questions-container').append(questionHtml);
            $('#questionCount').val(questionCounter);
            
            // Initialize TinyMCE for the new question editor
            initTinyMCE('#question_' + questionCounter);
        }
        
        // Function to remove a question
        function removeQuestion(element) {
            if (questionCounter <= 1) {
                iziToast.error({
                    title: 'Error',
                    message: 'Bài kiểm tra phải có ít nhất một câu hỏi',
                    position: 'topRight'
                });
                return;
            }
            
            // Get the editor instance for this question and destroy it
            var questionContainer = $(element).closest('.question-container');
            var editorId = questionContainer.find('textarea').attr('id');
            if (editorId && tinymce.get(editorId)) {
                tinymce.get(editorId).remove();
            }
            
            questionContainer.remove();
            questionCounter--;
            
            // Renumber remaining questions
            var $questions = $('.question-container');
            $questions.each(function(index) {
                var newIndex = index + 1;
                var $question = $(this);
                
                // Update all elements
                $question.attr('data-question-id', newIndex);
                $question.find('.question-title').text('Câu hỏi ' + newIndex);
                
                // Update input names
                var $textarea = $question.find('textarea');
                $textarea.attr('name', 'question_text_' + newIndex);
                if ($textarea.attr('id')) {
                    $textarea.attr('id', 'question_' + newIndex);
                }
                
                $question.find('[name^="question_id_"]').attr('name', 'question_id_' + newIndex);
                
                // Update radio button names
                $question.find('[name^="correct_answer_"]').attr('name', 'correct_answer_' + newIndex);
                
                $question.find('[name^="answer_text_"]').each(function() {
                    var currentName = $(this).attr('name');
                    var parts = currentName.split('_');
                    parts[2] = newIndex; // answer_text_X_Y -> X is question index
                    $(this).attr('name', parts.join('_'));
                });
                
                $question.find('[name^="answer_id_"]').each(function() {
                    var currentName = $(this).attr('name');
                    var parts = currentName.split('_');
                    parts[2] = newIndex; // answer_id_X_Y -> X is question index
                    $(this).attr('name', parts.join('_'));
                });
            });
            
            $('#questionCount').val(questionCounter);
        }
    </script>
</body>

</html> 