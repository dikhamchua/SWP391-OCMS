<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Online Courses & Education Template</title>
    <meta name="description" content="SkillGro - Online Courses & Education Template">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../common/css-file.jsp"></jsp:include>
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
        <section class="breadcrumb__area breadcrumb__bg" data-background="assets/img/bg/breadcrumb_bg.jpg">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="breadcrumb__content">
                            <h3 class="title">Cart</h3>
                            <nav class="breadcrumb">
                                <span property="itemListElement" typeof="ListItem">
                                    <a href="index.html">Home</a>
                                </span>
                                <span class="breadcrumb-separator"><i class="fas fa-angle-right"></i></span>
                                <span property="itemListElement" typeof="ListItem">Cart</span>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
            <div class="breadcrumb__shape-wrap">
                <img src="assets/img/others/breadcrumb_shape01.svg" alt="img" class="alltuchtopdown">
                <img src="assets/img/others/breadcrumb_shape02.svg" alt="img" data-aos="fade-right" data-aos-delay="300">
                <img src="assets/img/others/breadcrumb_shape03.svg" alt="img" data-aos="fade-up" data-aos-delay="400">
                <img src="assets/img/others/breadcrumb_shape04.svg" alt="img" data-aos="fade-down-left" data-aos-delay="400">
                <img src="assets/img/others/breadcrumb_shape05.svg" alt="img" data-aos="fade-left" data-aos-delay="400">
            </div>
        </section>
        <!-- breadcrumb-area-end -->

        <!-- cart-area -->
        <div class="cart__area section-py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-8">
                        <table class="table cart__table">
                            <thead>
                                <tr>
                                    <th class="product__thumb">&nbsp;</th>
                                    <th class="product__name">Product</th>
                                    <th class="product__price">Price</th>
                                    <th class="product__quantity">Quantity</th>
                                    <th class="product__subtotal">Subtotal</th>
                                    <th class="product__remove">&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="product__thumb">
                                        <a href="shop-details.html"><img src="assets/img/shop/shop_img01.jpg" alt=""></a>
                                    </td>
                                    <td class="product__name">
                                        <a href="shop-details.html">Antiaging and Longevity</a>
                                    </td>
                                    <td class="product__price">$13.00</td>
                                    <td class="product__quantity">
                                        <div class="cart-plus-minus">
                                            <input type="text" value="1">
                                        </div>
                                    </td>
                                    <td class="product__subtotal">$13.00</td>
                                    <td class="product__remove">
                                        <a href="#">×</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="product__thumb">
                                        <a href="shop-details.html"><img src="assets/img/shop/shop_img02.jpg" alt=""></a>
                                    </td>
                                    <td class="product__name">
                                        <a href="shop-details.html">Time to Explore</a>
                                    </td>
                                    <td class="product__price">$19.00</td>
                                    <td class="product__quantity">
                                        <div class="cart-plus-minus">
                                            <input type="text" value="1">
                                        </div>
                                    </td>
                                    <td class="product__subtotal">$19.00</td>
                                    <td class="product__remove">
                                        <a href="#">×</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6" class="cart__actions">
                                        <form action="#" class="cart__actions-form">
                                            <input type="text" placeholder="Coupon code">
                                            <button type="submit" class="btn">Apply coupon</button>
                                        </form>
                                        <div class="update__cart-btn text-end f-right">
                                            <button type="submit" class="btn">Update cart</button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-lg-4">
                        <div class="cart__collaterals-wrap">
                            <h2 class="title">Cart totals</h2>
                            <ul class="list-wrap">
                                <li>Subtotal <span>$32.00</span></li>
                                <li>Total <span class="amount">$32.00</span></li>
                            </ul>
                            <a href="check-out.html" class="btn">Proceed to checkout</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- cart-area-end -->

    </main>
    <!-- main-area-end -->



    <!-- footer-area -->
    <jsp:include page="../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->



    <!-- JS here -->
    <jsp:include page="../common/js-file.jsp"></jsp:include>

    <script>
        SVGInject(document.querySelectorAll("img.injectable"));
    </script>
</body>

</html>