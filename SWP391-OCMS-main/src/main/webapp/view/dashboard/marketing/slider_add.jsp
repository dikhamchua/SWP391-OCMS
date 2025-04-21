<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Add Slider</title>
        <meta name="description" content="SkillGro - Add Slider">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon"
              href="${pageContext.request.contextPath}/assets/img/favicon.png">
        <!-- CSS here -->
        <jsp:include page="../../common/css-file.jsp"></jsp:include>
        <!-- Place favicon.ico in the root directory -->
        <style>
            .form-group {
                margin: 10px auto;
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
                                    <div class="dashboard__content-title">
                                        <h4 class="title">Add Slider</h4>
                                    </div>
                                    <div class="row">
                                        <div class="col-12">
                                            <form action="${pageContext.request.contextPath}/manage-slider"
                                                  method="post" enctype="multipart/form-data">
                                                <input type="hidden" name="action" value="add">

                                                <div class="form-group">
                                                    <label for="title">Title*</label>
                                                    <input type="text" class="form-control" id="title" name="title"
                                                           required maxlength="255">
                                                </div>

                                                <div class="form-group">
                                                    <label for="imageUrl">Image*</label>
                                                    <input type="file" class="form-control" id="imageUrl"
                                                           name="image_url" accept="image/*" required>
                                                    <div id="imagePreview" class="mt-2">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label for="backlink">Backlink URL</label>
                                                    <input type="url" class="form-control" id="backlink" name="backlink">
                                                </div>

                                                <div class="form-group">
                                                    <label for="notes">Notes</label>
                                                    <textarea class="form-control" id="notes" name="notes"
                                                              rows="3"></textarea>
                                                </div>

                                                <div class="form-group">
                                                    <label for="status">Status</label>
                                                    <select class="form-control" id="status" name="status">
                                                        <option value="Active">Active</option>
                                                        <option value="Inactive">Inactive</option>
                                                    </select>
                                                </div>

                                                <div class="form-group mt-4">
                                                    <button type="submit" class="btn btn-primary">Add Slider</button>
                                                    <a href="${pageContext.request.contextPath}/manage-slider"
                                                       class="btn btn-secondary ml-2">Cancel</a>
                                                </div>
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
            $(document).ready(function () {
                // Image preview
                $('#imageUrl').change(function () {
                    const file = this.files[0];
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            $('#imagePreview').html(`<img src="\${e.target.result}" class="img-fluid" style="max-height: 200px;">`);
                        }
                        reader.readAsDataURL(file);
                    }
                });
            });

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
