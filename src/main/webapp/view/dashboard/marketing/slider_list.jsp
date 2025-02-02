<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://example.com/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>SkillGro - Manage Sliders</title>
        <meta name="description" content="SkillGro - Manage Sliders">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="shortcut icon" type="image/x-icon"
              href="${pageContext.request.contextPath}/assets/img/favicon.png">
        <!-- Place favicon.ico in the root directory -->

        <!-- CSS here -->
        <jsp:include page="../../common/css-file.jsp"></jsp:include>
        <style>
            .truncate-text {
                max-width: 200px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                display: inline-block;
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
        <c:url value="/manage-slider" var="paginationUrl">
            <c:param name="action" value="list" />
            <c:if test="${not empty param.type}">
                <c:param name="type" value="${param.type}" />
            </c:if>
            <c:if test="${not empty param.status}">
                <c:param name="status" value="${param.status}" />
            </c:if>
            <c:if test="${not empty param.search}">
                <c:param name="search" value="${param.search}" />
            </c:if>
        </c:url>

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
                                        <div
                                            class="dashboard__content-title">
                                            <div class="title d-flex justify-content-between align-items-center">
                                            <h4>Manage Sliders</h4>
                                                <a href="${pageContext.request.contextPath}/manage-slider?action=add"
                                               class="btn btn-primary">
                                                <i class="fas fa-plus"></i> Add New Slider
                                            </a>
                                        </div>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/manage-slider" method="GET"
                                          class="mb-4">
                                        <div class="row mb-3">
                                            <div class="col-md-4">
                                                <select class="form-select" id="statusFilter" name="status">
                                                    <option value="">All Status</option>
                                                    <option value="Active" ${param.status=='Active' ? 'selected'
                                                                             : '' }>Active</option>
                                                    <option value="Inactive" ${param.status=='Inactive' ? 'selected'
                                                                               : '' }>Inactive</option>
                                                </select>
                                            </div>
                                            <div class="col-md-4">
                                                <input type="text" class="form-control" id="searchFilter"
                                                       name="search" placeholder="Search sliders..."
                                                       value="${param.search}">
                                            </div>
                                                <div class="col-md-3">
                                                    <button type="submit" style="width: 100%; background-color: #007aff"
                                                            class="form-control text-light">
                                                        <i class="fa fa-search mr-4"></i>
                                                        Filter
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="dashboard__review-table">
                                                    <table class="table table-borderless">
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Image</th>
                                                                <th>Title</th>
                                                                <th>Backlink</th>
                                                                <th>Status</th>
                                                                <th>Notes</th>
                                                                <th>Created By</th>
                                                                <th>Created At</th>
                                                                <th>Updated At</th>
                                                                <th style="text-align: center;">Action</th>
                                                            </tr>
                                                        </thead>
                                                        <c:forEach var="slider" items="${sliders}">
                                                            <tr>
                                                                <td>
                                                                    <p class="color-black">${slider.id}</p>
                                                                </td>
                                                                <td>
                                                                    <img src="${pageContext.request.contextPath}/assets/img/slider/${slider.imageUrl}"
                                                                         alt="Slider image" class="img-thumbnail"
                                                                         style="width: 100px; height: 60px; object-fit: cover;">
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">${slider.title}</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black truncate-text">${slider.backlink}</p>
                                                                </td>
                                                                <td>
                                                                    <span style="background: #fff;" class="dashboard__quiz-result ${slider.status == 'active' ? 'text-success' : 'text-danger'}">
                                                                        ${slider.status}
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">${slider.notes}</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">${accountMap[slider.createdBy].username}</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">${fn:formatDate(slider.createdAt, "dd-MM-yyyy HH:mm:ss")}</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">${fn:formatDate(slider.updatedAt, "dd-MM-yyyy HH:mm:ss")}</p>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-slider?action=edit&id=${slider.id}"
                                                                           title="Edit"><i
                                                                                class="skillgro-edit"></i></a>
                                                                        <a href="#"
                                                                           onclick="confirmDeactivate(${slider.id})"
                                                                           title="Deactivate"><i
                                                                                class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </table>
                                                </div>

                                                <!-- Pagination -->
                                                <nav aria-label="Page navigation" style="margin-top: 30px">
                                                    <ul class="pagination justify-content-center">
                                                        <c:if test="${currentPage > 1}">
                                                            <li class="page-item">
                                                                <a class="page-link"
                                                                   href="${paginationUrl}&page=${currentPage - 1}"
                                                                   aria-label="Previous">
                                                                    <span aria-hidden="true">&laquo;</span>
                                                                </a>
                                                            </li>
                                                        </c:if>

                                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                                <a class="page-link"
                                                                   href="${paginationUrl}&page=${i}">${i}</a>
                                                            </li>
                                                        </c:forEach>

                                                        <c:if test="${currentPage < totalPages}">
                                                            <li class="page-item">
                                                                <a class="page-link"
                                                                   href="${paginationUrl}&page=${currentPage + 1}"
                                                                   aria-label="Next">
                                                                    <span aria-hidden="true">&raquo;</span>
                                                                </a>
                                                            </li>
                                                        </c:if>
                                                    </ul>
                                                </nav>
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
                    function confirmDeactivate(sliderId) {
                        if (confirm('Are you sure you want to deactivate this slider?')) {
                            window.location.href = '${pageContext.request.contextPath}/manage-slider?action=deactivate&id=' + sliderId;
                        }
                    }
            </script>

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
