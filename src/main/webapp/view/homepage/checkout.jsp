<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Checkout</title>
    <meta name="description" content="SkillGro - Checkout">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../common/home/css-home.jsp" />
    
    <!-- Toast CSS -->
    <link href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" rel="stylesheet">
    
    <style>
        .cart-item {
            border-bottom: 1px solid #eee;
            padding: 15px 0;
            margin-bottom: 15px;
        }
        .cart-item:last-child {
            border-bottom: none;
        }
        .cart-item-image {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
        }
        .cart-item-details {
            display: flex;
            align-items: center;
        }
        .cart-item-info {
            margin-left: 15px;
        }
        .cart-item-title {
            font-weight: 600;
            margin-bottom: 5px;
        }
        .cart-item-price {
            color: #333;
            font-weight: 500;
        }
        .checkout-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
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
    <jsp:include page="../common/home/header-home.jsp"></jsp:include>
    <!-- header-area-end -->

    <!-- main-area -->
    <main class="main-area fix">
        <!-- breadcrumb-area -->
        <section class="breadcrumb-area breadcrumb-bg" data-background="${pageContext.request.contextPath}/assets/img/bg/breadcrumb_bg.jpg">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="breadcrumb-content">
                            <h3 class="title">Checkout</h3>
                            <nav class="breadcrumb">
                                <span property="itemListElement" typeof="ListItem">
                                    <a href="${pageContext.request.contextPath}/">Home</a>
                                </span>
                                <span class="breadcrumb-separator"><i class="fas fa-angle-right"></i></span>
                                <span property="itemListElement" typeof="ListItem">Checkout</span>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- breadcrumb-area-end -->

        <!-- checkout-area -->
        <div class="checkout__area section-py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-7">
                        <div class="checkout-cart-items">
                            <h4 class="mb-4">Your Cart Items (${sessionScope.checkoutItemCount})</h4>
                            
                            <c:forEach items="${sessionScope.checkoutCartItems}" var="item">
                                <c:set var="course" value="${courseDAO.findById(item.courseId)}" />
                                <div class="cart-item">
                                    <div class="cart-item-details">
                                        <img src="${course.thumbnail}" alt="${course.name}" class="cart-item-image">
                                        <div class="cart-item-info">
                                            <h5 class="cart-item-title">${course.name}</h5>
                                            <p class="cart-item-price">$<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <div class="checkout-summary">
                                <div class="d-flex justify-content-between mb-3">
                                    <span>Subtotal:</span>
                                    <span>$<fmt:formatNumber value="${sessionScope.checkoutCartTotal}" pattern="#,##0.00"/></span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <strong>Total:</strong>
                                    <strong>$<fmt:formatNumber value="${sessionScope.checkoutCartTotal}" pattern="#,##0.00"/></strong>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    
                    <div class="col-lg-5">
                        <div class="order__info-wrap">
                            <h2 class="title">ORDER SUMMARY</h2>
                            <ul class="list-wrap">
                                <li class="title">Product <span>Subtotal</span></li>
                                
                                <c:forEach items="${sessionScope.checkoutCartItems}" var="item">
                                    <c:set var="course" value="${courseDAO.findById(item.courseId)}" />
                                    <li>${course.name} <span>$<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></span></li>
                                </c:forEach>
                                
                                <li>Subtotal <span>$<fmt:formatNumber value="${sessionScope.checkoutCartTotal}" pattern="#,##0.00"/></span></li>
                                <li>Total <span>$<fmt:formatNumber value="${sessionScope.checkoutCartTotal}" pattern="#,##0.00"/></span></li>
                            </ul>
                            
                            <div class="mt-4">
                                <h4>What You'll Get:</h4>
                                <ul class="benefits-list">
                                    <li><i class="fas fa-check-circle text-success"></i> Full lifetime access to all course materials</li>
                                    <li><i class="fas fa-check-circle text-success"></i> Access on mobile and desktop</li>
                                    <li><i class="fas fa-check-circle text-success"></i> Certificate of completion</li>
                                    <li><i class="fas fa-check-circle text-success"></i> 30-day money-back guarantee</li>
                                </ul>
                            </div>
                            
                            <p class="mt-4">Your personal data will be used to process your order, support your experience throughout this website, and for other purposes described in our <a href="#">privacy policy</a>.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- checkout-area-end -->
    </main>
    <!-- main-area-end -->

    <!-- footer-area -->
    <jsp:include page="../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../common/home/js-home.jsp" />
    
    <!-- Toast JS -->
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    
    <script>
        // Function to show toast message
        function showToast(message, type) {
            let backgroundColor = "#28a745"; // Default success color
            
            if (type === "error") {
                backgroundColor = "#dc3545"; // Danger color
            } else if (type === "info") {
                backgroundColor = "#17a2b8"; // Info color
            } else if (type === "warning") {
                backgroundColor = "#ffc107"; // Warning color
            }
            
            Toastify({
                text: message,
                duration: 5000,
                close: true,
                gravity: "top",
                position: "right",
                backgroundColor: backgroundColor,
                stopOnFocus: true
            }).showToast();
        }
        
        // Check for session messages and display toast
        <c:if test="${not empty sessionScope.message}">
            document.addEventListener("DOMContentLoaded", function() {
                showToast("${sessionScope.message}", "${sessionScope.messageType}");
            });
            <c:remove var="message" scope="session" />
            <c:remove var="messageType" scope="session" />
        </c:if>
        
        // Form validation
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            if (!this.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
                showToast("Please fill out all required fields", "error");
            } else {
                if (!confirm('Are you sure you want to complete your purchase?')) {
                    e.preventDefault();
                }
            }
            this.classList.add('was-validated');
        });
    </script>
</body>
</html>