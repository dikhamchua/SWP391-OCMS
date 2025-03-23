<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Shopping Cart</title>
    <meta name="description" content="SkillGro - Shopping Cart">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../common/home/css-home.jsp" />
    
    <style>
        .cart-item {
            border-bottom: 1px solid #eee;
            padding: 20px 0;
        }
        .cart-item:last-child {
            border-bottom: none;
        }
        .cart-item-image {
            width: 120px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
        }
        .cart-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
        }
        .empty-cart {
            text-align: center;
            padding: 50px 0;
        }
        .empty-cart i {
            font-size: 60px;
            color: #ddd;
            margin-bottom: 20px;
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
        <section class="breadcrumb-area breadcrumb-bg" data-background="${pageContext.request.contextPath}/assets/img/bg/breadcrumb_bg.jpg">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="breadcrumb-content">
                            <h3 class="title">Shopping Cart</h3>
                            <nav class="breadcrumb">
                                <span property="itemListElement" typeof="ListItem">
                                    <a href="${pageContext.request.contextPath}/">Home</a>
                                </span>
                                <span class="breadcrumb-separator"><i class="fas fa-angle-right"></i></span>
                                <span property="itemListElement" typeof="ListItem">Shopping Cart</span>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="cart-area section-py-120">
            <div class="container">
                <!-- Display messages if any -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-${sessionScope.messageType == 'error' ? 'danger' : sessionScope.messageType}">
                        ${sessionScope.message}
                    </div>
                    <c:remove var="message" scope="session" />
                    <c:remove var="messageType" scope="session" />
                </c:if>
                
                <div class="row">
                    <div class="col-lg-8">
                        <div class="cart-items-wrapper">
                            <h4 class="mb-4">Your Cart (${itemCount} items)</h4>
                            
                            <c:choose>
                                <c:when test="${empty cartItems}">
                                    <div class="empty-cart">
                                        <i class="fas fa-shopping-cart"></i>
                                        <h5>Your cart is empty</h5>
                                        <p>Looks like you haven't added any courses to your cart yet.</p>
                                        <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary mt-3">Browse Courses</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${cartItems}" var="item" varStatus="status">
                                        <div class="cart-item">
                                            <div class="row align-items-center">
                                                <div class="col-md-2">
                                                    <!-- <img src="#" alt="Course thumbnail" class="cart-item-image"> -->
                                                </div>
                                                <div class="col-md-6">
                                                    <h5>abc</h5>
                                                    <small>Added on: <fmt:formatDate value="${item.addedDate}" pattern="MMM dd, yyyy"/></small>
                                                </div>
                                                <div class="col-md-2 text-right">
                                                    <span class="price">$<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></span>
                                                </div>
                                                <div class="col-md-2 text-right">
                                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="itemId" value="${item.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                                            <i class="fas fa-trash"></i> Remove
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="col-lg-4">
                        <div class="cart-summary">
                            <h4 class="mb-4">Order Summary</h4>
                            
                            <div class="d-flex justify-content-between mb-3">
                                <span>Subtotal:</span>
                                <span>$<fmt:formatNumber value="${cartTotal}" pattern="#,##0.00"/></span>
                            </div>
                            
                            <hr>
                            
                            <div class="d-flex justify-content-between mb-4">
                                <strong>Total:</strong>
                                <strong>$<fmt:formatNumber value="${cartTotal}" pattern="#,##0.00"/></strong>
                            </div>
                            
                            <c:if test="${not empty cartItems}">
                                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-block">
                                    Proceed to Checkout
                                </a>
                            </c:if>
                            
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-secondary btn-block mt-3">
                                Continue Shopping
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    <!-- main-area-end -->

    <!-- footer-area -->
    <jsp:include page="../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../common/home/js-home.jsp" />
    <script>
        // Clear session messages after 5 seconds
        setTimeout(function() {
            $('.alert').fadeOut('slow');
        }, 5000);
    </script>
</body>

</html>