<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Quiz Questions</title>
    <meta name="description" content="SkillGro - Quiz Questions">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../../common/css-file.jsp"></jsp:include>

    <style>
        .question-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
            position: relative;
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        
        .question-number {
            font-weight: 600;
            color: #333;
        }
        
        .question-actions {
            display: flex;
            gap: 10px;
        }
        
        .question-content {
            margin-bottom: 15px;
        }
        
        .answer-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .answer-item {
            padding: 8px 12px;
            margin-bottom: 8px;
            border-radius: 4px;
            background-color: #f8f9fa;
            border: 1px solid #eee;
        }
        
        .answer-item.correct {
            background-color: #e6f7e6;
            border-color: #28a745;
        }
        
        .badge-success {
            background-color: #28a745;
            color: white;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
        }
        
        .add-question-btn {
            margin-bottom: 20px;
        }
        
        .quiz-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .quiz-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .quiz-meta {
            display: flex;
            gap: 20px;
            color: #6c757d;
            font-size: 14px;
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
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="dashboard__content-area">
                            <div class="dashboard__content-title d-flex justify-content-between align-items-center">
                                <h4 class="title">Danh sách câu hỏi</h4>
                                <a href="${pageContext.request.contextPath}/manage-quiz" class="btn btn-outline-secondary">
                                    <i class="fa fa-arrow-left"></i> Quay lại danh sách bài kiểm tra
                                </a>
                            </div>
                            
                            <!-- Quiz Info -->
                            <div class="quiz-info">
                                <div class="quiz-title">${lesson.title}</div>
                                <div class="quiz-meta">
                                    <div><strong>Thời gian:</strong> ${quiz.duration} phút</div>
                                    <div><strong>Số câu hỏi:</strong> ${questions.size()}</div>
                                    <div><strong>Trạng thái:</strong> 
                                        <span class="quiz-status status-${lesson.status}">
                                            ${lesson.status}
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Add Question Button -->
                            <div class="add-question-btn">
                                <a href="${pageContext.request.contextPath}/manage-quiz?action=newQuestion&quizId=${quiz.id}" class="btn btn-primary">
                                    <i class="fa fa-plus"></i> Thêm câu hỏi mới
                                </a>
                            </div>
                            
                            <!-- Questions List -->
                            <div class="questions-container">
                                <c:choose>
                                    <c:when test="${empty questions}">
                                        <div class="alert alert-info">
                                            Chưa có câu hỏi nào. Hãy thêm câu hỏi mới để bắt đầu.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="question" items="${questions}" varStatus="status">
                                            <div class="question-card">
                                                <div class="question-header">
                                                    <div class="question-number">Câu hỏi ${status.index + 1}</div>
                                                    <div class="question-actions">
                                                        <a href="${pageContext.request.contextPath}/manage-quiz?action=editQuestion&questionId=${question.id}&quizId=${quiz.id}" class="btn btn-sm btn-primary">
                                                            <i class="fa fa-edit"></i> Sửa
                                                        </a>
                                                        <a href="#" onclick="confirmDelete(${question.id}, ${quiz.id})" class="btn btn-sm btn-danger">
                                                            <i class="fa fa-trash"></i> Xóa
                                                        </a>
                                                    </div>
                                                </div>
                                                
                                                <div class="question-content">
                                                    ${question.questionText}
                                                </div>
                                                
                                                <div class="answers">
                                                    <strong>Đáp án:</strong>
                                                    <ul class="answer-list">
                                                        <c:forEach var="answer" items="${questionAnswersMap[question]}">
                                                            <li class="answer-item ${answer.isCorrect ? 'correct' : ''}">
                                                                ${answer.answerText}
                                                                <c:if test="${answer.isCorrect}">
                                                                    <span class="badge badge-success float-right">Đáp án đúng</span>
                                                                </c:if>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </div>
                                                
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
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

    <script>
        function confirmDelete(questionId, quizId) {
            if (confirm('Bạn có chắc chắn muốn xóa câu hỏi này không? Hành động này không thể hoàn tác.')) {
                window.location.href = '${pageContext.request.contextPath}/manage-quiz?action=deleteQuestion&questionId=' + questionId + '&quizId=' + quizId;
            }
        }
        
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
    </script>
</body>

</html> 