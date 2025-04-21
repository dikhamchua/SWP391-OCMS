<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Quiz Lesson</title>
    <meta name="description" content="SkillGro - Quiz Lesson">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/css-file.jsp"></jsp:include>
    
    <!-- Alpine.js -->
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    
    <style>
        .quiz-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .quiz-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .quiz-title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 0;
        }
        
        .quiz-info {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .quiz-info-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .quiz-info-item i {
            color: #007aff;
        }
        
        .question-container {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #007aff;
        }
        
        .question-number {
            font-weight: 600;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
        }
        
        .question-text {
            font-size: 18px;
            margin-bottom: 20px;
        }
        
        .options-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .option-item {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .option-item:hover {
            background-color: #f0f7ff;
            border-color: #007aff;
        }
        
        .option-item input[type="checkbox"],
        .option-item input[type="radio"] {
            margin-right: 10px;
        }
        
        .quiz-navigation {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }
        
        .quiz-submit {
            text-align: center;
            margin-top: 30px;
        }
        
        .course-outline {
            background-color: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.07);
            margin-bottom: 20px;
        }
        
        .course-outline-title {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #007aff;
            color: #1a1a1a;
            position: relative;
        }
        
        .course-outline-title:after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 60px;
            height: 2px;
            background-color: #007aff;
        }
        
        .outline-section-title {
            font-size: 17px;
            font-weight: 600;
            padding: 12px 15px;
            background-color: #f5f8ff;
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.2s ease;
            border-left: 3px solid #c8d8f7;
        }
        
        .outline-section-title:hover {
            background-color: #e9f3ff;
            border-left-color: #007aff;
            transform: translateX(2px);
        }
        
        .outline-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 8px;
            transition: all 0.2s ease;
            border-left: 3px solid transparent;
        }
        
        .outline-item.active {
            background-color: #e6f4ff;
            border-left: 3px solid #007aff;
            box-shadow: 0 2px 5px rgba(0, 122, 255, 0.1);
        }
        
        .outline-item:hover {
            background-color: #f7faff;
            transform: translateX(2px);
        }
        
        .outline-item-content {
            flex-grow: 1;
            padding-left: 10px;
        }
        
        .outline-item-title {
            font-size: 15px;
            font-weight: 500;
            color: #333;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
        }
        
        .outline-item-title a {
            text-decoration: none;
            color: #007aff;
            transition: color 0.2s ease;
        }
        
        .outline-item-title a:hover {
            text-decoration: underline;
            color: #0056b3;
        }
        
        .outline-item-duration {
            font-size: 12px;
            color: #777;
            display: flex;
            align-items: center;
        }
        
        .outline-item-duration i {
            margin-right: 5px;
            font-size: 11px;
            color: #999;
        }
        
        .quiz-progress {
            height: 8px;
            margin-bottom: 20px;
            border-radius: 4px;
            overflow: hidden;
        }
        
        .timer-container {
            text-align: center;
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: 600;
        }
        
        .timer-container i {
            color: #dc3545;
            margin-right: 5px;
        }
        
        [x-cloak] {
            display: none !important;
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
                                    <h4 class="title">Bài kiểm tra</h4>
                                    <a href="${pageContext.request.contextPath}/course-detail?id=${course.id}" class="btn" style="background-color: #f5f5f5; border: none;">
                                        <i class="fa fa-arrow-left"></i> Quay lại khóa học
                                    </a>
                                </div>
                                
                                <!-- Quiz Content -->
                                <div class="row">
                                    <div class="col-lg-8">
                                        <div class="quiz-container" x-data="{ 
                                            currentQuestion: 1,
                                            totalQuestions: 4,
                                            timeLeft: 1800,
                                            formatTime(seconds) {
                                                const mins = Math.floor(seconds / 60);
                                                const secs = seconds % 60;
                                                return `${mins}:${secs < 10 ? '0' : ''}${secs}`;
                                            }
                                        }" x-init="setInterval(() => { if(timeLeft > 0) timeLeft--; }, 1000)">
                                            <div class="quiz-header">
                                                <h3 class="quiz-title">${lesson.title}</h3>
                                                <div class="timer-container">
                                                    <i class="fa fa-clock"></i> <span x-text="formatTime(timeLeft)"></span>
                                                </div>
                                            </div>
                                            
                                            <div class="quiz-progress">
                                                <div class="progress">
                                                    <div class="progress-bar bg-primary" role="progressbar" 
                                                        x-bind:style="'width: ' + (currentQuestion / totalQuestions * 100) + '%'" 
                                                        aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <form id="quizForm" action="${pageContext.request.contextPath}/submit-quiz" method="post">
                                                <input type="hidden" name="lessonQuizId" value="${lessonQuiz.id}">
                                                
                                                <!-- Hiển thị các câu hỏi động từ dữ liệu -->
                                                <c:forEach var="question" items="${listQuestions}" varStatus="status">
                                                    <div class="question-container" x-show="currentQuestion === ${status.index + 1}" x-cloak>
                                                        <div class="question-number">
                                                            <span>Câu hỏi ${status.index + 1}</span>
                                                            <span>Tổng số câu hỏi: ${listQuestions.size()} | Điểm: ${question.points}</span>
                                                        </div>
                                                        <div class="question-text">
                                                            ${question.questionText}
                                                        </div>
                                                        <div class="options-container">
                                                            <c:forEach var="answer" items="${questionAnswersMap[question]}">
                                                                <label class="option-item">
                                                                    <input type="radio" name="question_${question.id}" value="${answer.id}">
                                                                    ${answer.answerText}
                                                                </label>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                                
                                                <!-- Navigation -->
                                                <div class="quiz-navigation">
                                                    <button type="button" class="btn btn-outline-primary" 
                                                        x-show="currentQuestion > 1"
                                                        @click="currentQuestion--">
                                                        <i class="fa fa-arrow-left"></i> Câu trước
                                                    </button>
                                                    <div x-show="currentQuestion === 1"></div>
                                                    
                                                    <button type="button" class="btn btn-primary" 
                                                        x-show="currentQuestion < totalQuestions"
                                                        @click="currentQuestion++">
                                                        Câu tiếp theo <i class="fa fa-arrow-right"></i>
                                                    </button>
                                                    
                                                    <button type="submit" class="btn btn-success" 
                                                        x-show="currentQuestion === totalQuestions">
                                                        Nộp bài <i class="fa fa-check"></i>
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                    
                                    <div class="col-lg-4">
                                        <!-- Course Outline -->
                                        <div class="course-outline">
                                            <h4 class="course-outline-title">Nội dung khóa học: ${course.name}</h4>
                                            
                                            <c:forEach var="courseSection" items="${courseSections}">
                                                <div x-data="{open: ${courseSection.id == section.id}}">
                                                    <div class="d-flex justify-content-between align-items-center mb-2 cursor-pointer" @click="open = !open">
                                                        <h5 class="mb-0">${courseSection.title}</h5>
                                                        <span x-text="open ? '-' : '+'"></span>
                                                    </div>
                                                    <div x-show="open" x-transition>
                                                        <c:forEach var="sectionLesson" items="${sectionLessons[courseSection.id]}">
                                                            <div class="outline-item ${sectionLesson.id == lesson.id ? 'active' : ''}">
                                                                <div class="outline-item-content">
                                                                    <div class="outline-item-title">
                                                                        <a href="${pageContext.request.contextPath}/lesson?action=view&id=${sectionLesson.id}">
                                                                            ${sectionLesson.title}
                                                                        </a>
                                                                    </div>
                                                                    <div class="outline-item-duration">${sectionLesson.durationMinutes} min</div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
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
    </script>
</body>

</html> 