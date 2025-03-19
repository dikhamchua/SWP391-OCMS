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
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 20px;
            height: 100%;
        }
        
        .course-outline-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .outline-item {
            display: flex;
            align-items: flex-start;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        .outline-item.active {
            background-color: #e9f5ff;
            padding: 10px;
            margin: 0 -10px;
            border-radius: 5px;
        }
        
        .outline-item-checkbox {
            margin-right: 10px;
            margin-top: 3px;
        }
        
        .outline-item-content {
            flex-grow: 1;
        }
        
        .outline-item-title {
            font-weight: 500;
            margin-bottom: 3px;
        }
        
        .outline-item-duration {
            font-size: 12px;
            color: #6c757d;
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
                                    <a href="${pageContext.request.contextPath}/view/dashboard/admin/course-content.jsp" class="btn" style="background-color: #f5f5f5; border: none;">
                                        <i class="fa fa-arrow-left"></i> Quay lại
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
                                            
                                            <div class="quiz-info">
                                                <div class="quiz-info-item">
                                                    <i class="fa fa-check-circle"></i>
                                                    <span>Điểm đạt: ${lessonQuiz.passPercentage}%</span>
                                                </div>
                                                <div class="quiz-info-item">
                                                    <i class="fa fa-redo"></i>
                                                    <span>Số lần làm: ${lessonQuiz.attemptsAllowed != null ? lessonQuiz.attemptsAllowed : 'Không giới hạn'}</span>
                                                </div>
                                                <div class="quiz-info-item">
                                                    <i class="fa fa-users"></i>
                                                    <span>Tổng số học sinh tham gia: 163</span>
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
                                            
                                            <!-- Question 1 -->
                                            <div class="question-container" x-show="currentQuestion === 1">
                                                <div class="question-number">
                                                    <span>Câu hỏi 1</span>
                                                    <span>Tổng số câu hỏi: 4 | Tổng số điểm: 7</span>
                                                </div>
                                                <div class="question-text">
                                                    request.getParameter([x]) ở đây là gì?
                                                </div>
                                                <div class="options-container">
                                                    <label class="option-item">
                                                        <input type="radio" name="question1" value="type">
                                                        type
                                                    </label>
                                                    <label class="option-item">
                                                        <input type="radio" name="question1" value="text">
                                                        text
                                                    </label>
                                                    <label class="option-item">
                                                        <input type="radio" name="question1" value="value">
                                                        value
                                                    </label>
                                                    <label class="option-item">
                                                        <input type="radio" name="question1" value="name">
                                                        name
                                                    </label>
                                                </div>
                                            </div>
                                            
                                            <!-- Question 2 -->
                                            <div class="question-container" x-show="currentQuestion === 2" x-cloak>
                                                <div class="question-number">
                                                    <span>Câu hỏi 2</span>
                                                    <span>Tổng số câu hỏi: 4 | Tổng số điểm: 7</span>
                                                </div>
                                                <div class="question-text">
                                                    Muốn lấy các giá trị đã chọn ở bên thì input có type bằng check box thì nên chọn phương thức nào?
                                                </div>
                                                <div class="options-container">
                                                    <label class="option-item">
                                                        <input type="radio" name="question2" value="getParameter">
                                                        getParameter
                                                    </label>
                                                    <label class="option-item">
                                                        <input type="radio" name="question2" value="getParameterValues">
                                                        getParameterValues
                                                    </label>
                                                </div>
                                            </div>
                                            
                                            <!-- Question 3 -->
                                            <div class="question-container" x-show="currentQuestion === 3" x-cloak>
                                                <div class="question-number">
                                                    <span>Câu hỏi 3</span>
                                                    <span>Tổng số câu hỏi: 4 | Tổng số điểm: 7</span>
                                                </div>
                                                <div class="question-text">
                                                    request.getParameter sẽ trả về kiểu dữ liệu gì?
                                                </div>
                                                <div class="options-container">
                                                    <label class="option-item">
                                                        <input type="radio" name="question3" value="int">
                                                        int
                                                    </label>
                                                    <label class="option-item">
                                                        <input type="radio" name="question3" value="string">
                                                        string
                                                    </label>
                                                    <label class="option-item">
                                                        <input type="radio" name="question3" value="double">
                                                        double
                                                    </label>
                                                    <label class="option-item">
                                                        <input type="radio" name="question3" value="number">
                                                        number
                                                    </label>
                                                </div>
                                            </div>
                                            
                                            <!-- Question 4 -->
                                            <div class="question-container" x-show="currentQuestion === 4" x-cloak>
                                                <div class="question-number">
                                                    <span>Câu hỏi 4</span>
                                                    <span>Tổng số câu hỏi: 4 | Tổng số điểm: 7</span>
                                                </div>
                                                <div class="question-text">
                                                    request.getParameterValues sẽ trả về kiểu dữ liệu gì?
                                                </div>
                                                <div class="options-container">
                                                    <label class="option-item">
                                                        <input type="radio" name="question4" value="mảng">
                                                        mảng
                                                    </label>
                                                    <label class="option-item">
                                                        <input type="radio" name="question4" value="int">
                                                        int
                                                    </label>
                                                    <label class="option-item">
                                                        <input type="radio" name="question4" value="number">
                                                        number
                                                    </label>
                                                    <label class="option-item">
                                                        <input type="radio" name="question4" value="string">
                                                        string
                                                    </label>
                                                </div>
                                            </div>
                                            
                                            <div class="quiz-navigation">
                                                <button class="btn btn-outline-primary" 
                                                    x-show="currentQuestion > 1"
                                                    @click="currentQuestion--">
                                                    <i class="fa fa-arrow-left"></i> Câu trước
                                                </button>
                                                <div x-show="currentQuestion === 1"></div>
                                                
                                                <button class="btn btn-primary" 
                                                    x-show="currentQuestion < totalQuestions"
                                                    @click="currentQuestion++">
                                                    Câu tiếp theo <i class="fa fa-arrow-right"></i>
                                                </button>
                                                
                                                <button class="btn btn-success" 
                                                    x-show="currentQuestion === totalQuestions"
                                                    @click="document.getElementById('quizForm').submit()">
                                                    Nộp bài <i class="fa fa-check"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-lg-4">
                                        <!-- Course Outline -->
                                        <div class="course-outline">
                                            <h4 class="course-outline-title">Nội dung khóa học</h4>
                                            
                                            <!-- Introduction -->
                                            <div x-data="{open: true}">
                                                <div class="d-flex justify-content-between align-items-center mb-2 cursor-pointer" @click="open = !open">
                                                    <h5 class="mb-0">Introduction</h5>
                                                    <span x-text="open ? '-' : '+'"></span>
                                                </div>
                                                <div x-show="open" x-transition>
                                                    <div class="outline-item">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" checked disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">1. Install JDK 17 and Apache Netbeans 17</div>
                                                            <div class="outline-item-duration">10 min</div>
                                                        </div>
                                                    </div>
                                                    <div class="outline-item">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" checked disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">2. Overview</div>
                                                            <div class="outline-item-duration">15 min</div>
                                                        </div>
                                                    </div>
                                                    <div class="outline-item">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" checked disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">3. Set up environment</div>
                                                            <div class="outline-item-duration">12 min</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Servlet -->
                                            <div x-data="{open: true}">
                                                <div class="d-flex justify-content-between align-items-center mb-2 mt-3 cursor-pointer" @click="open = !open">
                                                    <h5 class="mb-0">Servlet</h5>
                                                    <span x-text="open ? '-' : '+'"></span>
                                                </div>
                                                <div x-show="open" x-transition>
                                                    <div class="outline-item">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" checked disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">4. Introduction to Servlets</div>
                                                            <div class="outline-item-duration">20 min</div>
                                                        </div>
                                                    </div>
                                                    <div class="outline-item active">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">5. Servlet Quiz</div>
                                                            <div class="outline-item-duration">30 min</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Exercise 01 -->
                                            <div x-data="{open: false}">
                                                <div class="d-flex justify-content-between align-items-center mb-2 mt-3 cursor-pointer" @click="open = !open">
                                                    <h5 class="mb-0">Exercise 01</h5>
                                                    <span x-text="open ? '-' : '+'"></span>
                                                </div>
                                                <div x-show="open" x-transition>
                                                    <div class="outline-item">
                                                        <div class="outline-item-checkbox">
                                                            <input type="checkbox" disabled>
                                                        </div>
                                                        <div class="outline-item-content">
                                                            <div class="outline-item-title">6. Basic Servlet Implementation</div>
                                                            <div class="outline-item-duration">25 min</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- More sections collapsed -->
                                            <div class="mt-3">
                                                <div class="outline-item">
                                                    <div class="outline-item-content text-center">
                                                        <a href="#" class="text-primary">Show all sections</a>
                                                    </div>
                                                </div>
                                            </div>
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