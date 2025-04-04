<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!doctype html>
        <html class="no-js" lang="en">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <title>SkillGro - Edit Account</title>
            <meta name="description" content="SkillGro - Edit Account">
            <meta name="viewport" content="width=device-width, initial-scale=1">

            <link rel="shortcut icon" type="image/x-icon"
                href="${pageContext.request.contextPath}/assets/img/favicon.png">
            <!-- Place favicon.ico in the root directory -->
            <style>
                .form-group {
                    margin: 10px auto;
                }
            </style>
            <!-- CSS here -->
            <jsp:include page="../../common/css-file.jsp"></jsp:include>
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
                    <div class="container">
                        <jsp:include page="../../common/dashboard/avatar.jsp"></jsp:include>

                        <div class="dashboard__inner-wrap">
                            <div class="row">
                                <jsp:include page="../../common/dashboard/sideBar.jsp"></jsp:include>
                                <div class="col-lg-9">
                                    <div class="dashboard__content-wrap">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Edit Account</h4>
                                        </div>
                                        <div class="row">
                                            <div class="col-12">
                                                <form action="${pageContext.request.contextPath}/manage-account" method="post">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="id" value="${account.id}">
                                        
                                                    <div class="form-group">
                                                        <label for="email">Email</label>
                                                        <input type="email" class="form-control" id="email" name="email" value="${account.email}" readonly>
                                                    </div>
                                        
                                                    <div class="form-group">
                                                        <label for="username">Username</label>
                                                        <input type="text" class="form-control" id="username" name="username" value="${account.username}" readonly>
                                                    </div>
                                        
                                                    <div class="form-group">
                                                        <label for="phone">Phone Number</label>
                                                        <input type="tel" class="form-control" id="phone" name="phone" value="${account.phone}" 
                                                            pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number" required>
                                                    </div>
                                        
                                                    <div class="form-group">
                                                        <label for="role">Role</label>
                                                        <input type="text" class="form-control" id="role" 
                                                            value="${account.roleId == 1 ? 'Admin' : account.roleId == 2 ? 'Teacher' : 'Student'}" readonly>
                                                        <input type="hidden" name="role" value="${account.roleId}">
                                                    </div>
                                        
                                                    <div class="form-group">
                                                        <label for="status">Status</label>
                                                        <select class="form-control" id="status" name="status">
                                                            <option value="true" ${account.isActive ? 'selected' : ''}>Active</option>
                                                            <option value="false" ${!account.isActive ? 'selected' : ''}>Inactive</option>
                                                        </select>
                                                    </div>
                                        
                                                    <div class="form-group">
                                                        <label for="gender">Gender</label>
                                                        <select class="form-control" id="gender" name="gender">
                                                            <option value="true" ${account.gender ? 'selected' : ''}>Male</option>
                                                            <option value="false" ${!account.gender ? 'selected' : ''}>Female</option>
                                                        </select>
                                                    </div>
                                        
                                                    <button type="submit" class="btn btn-primary">Update Account</button>
                                                </form>
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
            </script>
        </body>

        </html>