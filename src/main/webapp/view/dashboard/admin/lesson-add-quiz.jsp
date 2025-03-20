<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Add Quiz Lesson</title>
    <meta name="description" content="SkillGro - Add Quiz Lesson">
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
            font-weight: 500;
            margin: 0;
        }
        
        .remove-question {
            color: #dc3545;
            cursor: pointer;
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
        
        .answer-option input[type="text"] {
            flex-grow: 1;
        }
        
        .add-answer-btn {
            margin-top: 10px;
        }
        
        .add-question-btn {
            margin-top: 20px;
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
                                    <h4 class="title">Thêm bài kiểm tra mới</h4>
                                    <a href="${pageContext.request.contextPath}/manage-course?action=manage&id=${course.id}" class="btn" style="background-color: #f5f5f5; border: none;">
                                        <i class="fa fa-arrow-left"></i> Quay lại
                                    </a>
                                </div>
                                
                                <div class="form-container">
                                    <form action="${pageContext.request.contextPath}/lesson-edit?action=add" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="type" value="quiz">
                                        
                                        <!-- Basic Information -->
                                        <div class="form-section">
                                            <h5 class="form-section-title">Thông tin cơ bản</h5>
                                            
                                            <div class="form-group">
                                                <label class="form-label">Phần</label>
                                                <select name="sectionId" class="form-control" required>
                                                    <option value="">-- Chọn phần --</option>
                                                    <c:forEach var="sectionItem" items="${sections}">
                                                        <option value="${sectionItem.id}">
                                                            ${sectionItem.title}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label class="form-label">Tiêu đề bài kiểm tra</label>
                                                <input type="text" class="form-control" name="title" required>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label class="form-label">Mô tả</label>
                                                <textarea class="form-control" name="description" rows="3"></textarea>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Thời gian làm bài (phút)</label>
                                                        <div class="icon-input">
                                                            <i class="fa fa-clock"></i>
                                                            <input type="number" class="form-control" name="durationMinutes" value="15" min="1">
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="form-label">Điểm đạt</label>
                                                        <input type="number" class="form-control" name="passingScore" value="70" min="0" max="100">
                                                        <small class="form-text">Điểm tối thiểu để đạt (0-100)</small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Quiz Questions -->
                                        <div class="form-section">
                                            <h5 class="form-section-title">Câu hỏi</h5>
                                            
                                            <div id="questions-container">
                                                <!-- Question template will be added here -->
                                                <div class="question-container" data-question-id="1">
                                                    <div class="question-header">
                                                        <h6 class="question-title">Câu hỏi 1</h6>
                                                        <span class="remove-question" onclick="removeQuestion(this)"><i class="fa fa-times"></i></span>
                                                    </div>
                                                    
                                                    <div class="form-group">
                                                        <label class="form-label">Nội dung câu hỏi</label>
                                                        <input type="text" class="form-control" name="question_text_1" required>
                                                    </div>
                                                    
                                                    <div class="form-group">
                                                        <label class="form-label">Các đáp án</label>
                                                        <div class="answers-container" data-question-id="1">
                                                            <div class="answer-option">
                                                                <input type="radio" name="correct_answer_1" value="1" checked>
                                                                <input type="text" class="form-control" name="answer_text_1_1" placeholder="Đáp án 1" required>
                                                            </div>
                                                            <div class="answer-option">
                                                                <input type="radio" name="correct_answer_1" value="2">
                                                                <input type="text" class="form-control" name="answer_text_1_2" placeholder="Đáp án 2" required>
                                                            </div>
                                                            <div class="answer-option">
                                                                <input type="radio" name="correct_answer_1" value="3">
                                                                <input type="text" class="form-control" name="answer_text_1_3" placeholder="Đáp án 3" required>
                                                            </div>
                                                            <div class="answer-option">
                                                                <input type="radio" name="correct_answer_1" value="4">
                                                                <input type="text" class="form-control" name="answer_text_1_4" placeholder="Đáp án 4" required>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <button type="button" class="btn btn-outline-primary add-question-btn" onclick="addQuestion()">
                                                <i class="fa fa-plus"></i> Thêm câu hỏi
                                            </button>
                                            
                                            <!-- Hidden field to track the number of questions -->
                                            <input type="hidden" name="questionCount" id="questionCount" value="1">
                                        </div>
                                        
                                        <!-- Status Information -->
                                        <div class="form-section">
                                            <h5 class="form-section-title">Trạng thái</h5>
                                            
                                            <div class="form-group">
                                                <label class="form-label">Trạng thái</label>
                                                <select name="status" class="status-select">
                                                    <option value="active">Hoạt động</option>
                                                    <option value="inactive">Không hoạt động</option>
                                                    <option value="draft" selected>Bản nháp</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <!-- Form Actions -->
                                        <div class="form-actions">
                                            <a href="${pageContext.request.contextPath}/manage-course?action=manage&id=${course.id}" class="btn btn-outline-secondary">Hủy</a>
                                            <button type="submit" class="btn btn-primary">Thêm bài kiểm tra</button>
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
        
        // Question counter
        var questionCounter = 1;
        
        // Function to add a new question
        function addQuestion() {
            questionCounter++;
            
            var questionHtml = `
                <div class="question-container" data-question-id="${questionCounter}">
                    <div class="question-header">
                        <h6 class="question-title">Câu hỏi ${questionCounter}</h6>
                        <span class="remove-question" onclick="removeQuestion(this)"><i class="fa fa-times"></i></span>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Nội dung câu hỏi</label>
                        <input type="text" class="form-control" name="question_text_${questionCounter}" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Các đáp án</label>
                        <div class="answers-container" data-question-id="${questionCounter}">
                            <div class="answer-option">
                                <input type="radio" name="correct_answer_${questionCounter}" value="1" checked>
                                <input type="text" class="form-control" name="answer_text_${questionCounter}_1" placeholder="Đáp án 1" required>
                            </div>
                            <div class="answer-option">
                                <input type="radio" name="correct_answer_${questionCounter}" value="2">
                                <input type="text" class="form-control" name="answer_text_${questionCounter}_2" placeholder="Đáp án 2" required>
                            </div>
                            <div class="answer-option">
                                <input type="radio" name="correct_answer_${questionCounter}" value="3">
                                <input type="text" class="form-control" name="answer_text_${questionCounter}_3" placeholder="Đáp án 3" required>
                            </div>
                            <div class="answer-option">
                                <input type="radio" name="correct_answer_${questionCounter}" value="4">
                                <input type="text" class="form-control" name="answer_text_${questionCounter}_4" placeholder="Đáp án 4" required>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            
            $('#questions-container').append(questionHtml);
            $('#questionCount').val(questionCounter);
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
            
            $(element).closest('.question-container').remove();
            questionCounter--;
            
            // Renumber the remaining questions
            $('.question-container').each(function(index) {
                var newIndex = index + 1;
                $(this).attr('data-question-id', newIndex);
                $(this).find('.question-title').text('Câu hỏi ' + newIndex);
                
                // Update the name attributes for the question
                $(this).find('input[name^="question_text_"]').attr('name', 'question_text_' + newIndex);
                
                // Update the name attributes for the correct answer radio buttons
                $(this).find('input[name^="correct_answer_"]').attr('name', 'correct_answer_' + newIndex);
                
                // Update the answers container
                var answersContainer = $(this).find('.answers-container');
                answersContainer.attr('data-question-id', newIndex);
                
                // Update the name attributes for each answer
                answersContainer.find('input[name^="answer_text_"]').each(function(answerIndex) {
                    $(this).attr('name', 'answer_text_' + newIndex + '_' + (answerIndex + 1));
                });
            });
            
            $('#questionCount').val(questionCounter);
        }
    </script>
</body>

</html> 