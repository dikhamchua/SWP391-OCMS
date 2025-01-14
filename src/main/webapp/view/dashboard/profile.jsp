<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Online Courses & Education Template</title>
        <meta name="description" content="SkillGro - Online Courses & Education Template">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.png">
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
            <main class="main-area">

                <!-- dashboard-area -->
                <section class="dashboard__area section-pb-120">
                <div class="container">
                <jsp:include page="../common/dashboard/avatar.jsp"></jsp:include>
                    <div class="dashboard__inner-wrap">
                        <div class="row">
                            <!--Side bar-->
                            <jsp:include page="../common/dashboard/sideBar.jsp"></jsp:include>

                                <!--Main Content-->
                                <div class="col-lg-9">
                                    <div class="dashboard__content-wrap">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">My Profile</h4>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <div class="profile__content-wrap">
                                                    <form action="${pageContext.request.contextPath}/dashboard-profile" method="post">
                                                    <div class="mb-3">
                                                        <label for="email" class="form-label">Email</label>
                                                        <input type="email" class="form-control" id="email" name="email" value="${accountDetails.email}" readonly>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="role" class="form-label">Role</label>
                                                        <input type="text" class="form-control" id="role" name="role" value="${accountDetails.role}" readonly>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="gender" class="form-label">Gender</label>
                                                        <select class="form-select" id="gender" name="gender">
                                                            <option value="true" ${accountDetails.gender ? 'selected' : ''}>Male</option>
                                                            <option value="false" ${!accountDetails.gender ? 'selected' : ''}>Female</option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="lastLogin" class="form-label">Last Login</label>
                                                        <input type="text" class="form-control" id="lastLogin" name="lastLogin" 
                                                               value="<fmt:formatDate value="${accountDetails.lastLogin}" pattern="MMMM dd, yyyy h:mm a" />" readonly>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary">Update Profile</button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- dashboard-area-end -->

        </main>
        <!-- main-area-end -->



        <!-- footer-area -->
        <jsp:include page="../common/home/footer-home.jsp"></jsp:include>
            <!-- footer-area-end -->



            <!-- JS here -->
        <jsp:include page="../common/js-file.jsp"></jsp:include>
            <!--        <script>
                        SVGInject(document.querySelectorAll("img.injectable"));
                    </script>-->
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    var toastMessage = "${toastMessage}";
                    var toastType = "${toastType}";

                    if (toastMessage) {
                        iziToast.show({
                            title: toastType === 'success' ? 'Success' : 'Error',
                            message: toastMessage,
                            position: 'topRight',
                            color: toastType === 'success' ? 'green' : 'red',
                            timeout: 5000
                        });
                    }
                });
        </script>
    </body>

</html>