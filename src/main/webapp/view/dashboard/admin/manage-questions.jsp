<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!doctype html>
        <html class="no-js" lang="en">

        <head>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <title>SkillGro - Manage Questions</title>
            <meta name="description" content="SkillGro - Manage Questions">
            <meta name="viewport" content="width=device-width, initial-scale=1">

            <link rel="shortcut icon" type="image/x-icon"
                href="${pageContext.request.contextPath}/assets/img/favicon.png">
            <!-- Place favicon.ico in the root directory -->

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
            <c:url value="/manage-questions" var="paginationUrl">
                <c:param name="action" value="list" />
                <c:if test="${not empty param.subject}">
                    <c:param name="subject" value="${param.subject}" />
                </c:if>
                <c:if test="${not empty param.lesson}">
                    <c:param name="lesson" value="${param.lesson}" />
                </c:if>
                <c:if test="${not empty param.level}">
                    <c:param name="level" value="${param.level}" />
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
                                        <div class="dashboard__content-title d-flex justify-content-between align-items-center">
                                            <h4 class="title">Question List</h4>
                                            <button class="btn" style="background-color: #f5f5f5; border: none;">
                                                <i class="fa fa-cog"></i>
                                            </button>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/manage-questions" method="GET"
                                            class="mb-4">
                                            <div class="row mb-3">
                                                <div class="col-md-2">
                                                    <select class="form-select" id="subjectFilter" name="subject">
                                                        <option value="">Subject</option>
                                                        <option value="Programming" ${param.subject=='Programming' ? 'selected' : '' }>Programming</option>
                                                        <option value="Artificial Intelligence" ${param.subject=='Artificial Intelligence' ? 'selected' : '' }>Artificial Intelligence</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select" id="lessonFilter" name="lesson">
                                                        <option value="">Lesson</option>
                                                        <option value="Lesson 1" ${param.lesson=='Lesson 1' ? 'selected' : '' }>Lesson 1</option>
                                                        <option value="Lesson 2" ${param.lesson=='Lesson 2' ? 'selected' : '' }>Lesson 2</option>
                                                        <option value="Lesson 3" ${param.lesson=='Lesson 3' ? 'selected' : '' }>Lesson 3</option>
                                                        <option value="Lesson 4" ${param.lesson=='Lesson 4' ? 'selected' : '' }>Lesson 4</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select" id="dimensionFilter" name="dimension">
                                                        <option value="">Dimension</option>
                                                        <!-- Add dimension options here -->
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select" id="levelFilter" name="level">
                                                        <option value="">Level</option>
                                                        <option value="Beginner" ${param.level=='Beginner' ? 'selected' : '' }>Beginner</option>
                                                        <option value="Intermediate" ${param.level=='Intermediate' ? 'selected' : '' }>Intermediate</option>
                                                        <option value="Advanced" ${param.level=='Advanced' ? 'selected' : '' }>Advanced</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <select class="form-select" id="statusFilter" name="status">
                                                        <option value="">Status</option>
                                                        <option value="Active" ${param.status=='Active' ? 'selected' : '' }>Active</option>
                                                        <option value="Paused" ${param.status=='Paused' ? 'selected' : '' }>Paused</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <input type="text" class="form-control" id="searchFilter"
                                                        name="search" placeholder="Search by content..."
                                                        value="${param.search}">
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-10">
                                                    <button type="submit" style="width: 100%; background-color: #007aff"
                                                        class="form-control text-light">
                                                        <i class="fa fa-search mr-4"></i>
                                                        Filter
                                                    </button>
                                                </div>
                                                <div class="col-md-2">
                                                    <a href="${pageContext.request.contextPath}/manage-questions?action=add" 
                                                       class="btn btn-success form-control text-light">
                                                        <i class="fa fa-plus mr-2"></i> Add Question
                                                    </a>
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
                                                                <th>Content</th>
                                                                <th>Subject</th>
                                                                <th>Lesson</th>
                                                                <th>Level</th>
                                                                <th>Status</th>
                                                                <th style="text-align: center;">Action</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <!-- Sample data - replace with actual data from your controller -->
                                                            <tr>
                                                                <td>
                                                                    <p class="color-black">Q001</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Introduction to Programming</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Programming</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Lesson 1</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Beginner</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result">
                                                                        Active
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-questions?action=edit&id=Q001"
                                                                            title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#"
                                                                            onclick="confirmDelete('Q001')"
                                                                            title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p class="color-black">Q002</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Conditional Structures</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Programming</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Lesson 2</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Beginner</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result">
                                                                        Active
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-questions?action=edit&id=Q002"
                                                                            title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#"
                                                                            onclick="confirmDelete('Q002')"
                                                                            title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p class="color-black">Q003</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Loops in Python</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Programming</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Lesson 3</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Intermediate</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result fail">
                                                                        Paused
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-questions?action=edit&id=Q003"
                                                                            title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#"
                                                                            onclick="confirmDelete('Q003')"
                                                                            title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p class="color-black">Q004</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Functions and Modules</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Programming</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Lesson 4</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Intermediate</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result">
                                                                        Active
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-questions?action=edit&id=Q004"
                                                                            title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#"
                                                                            onclick="confirmDelete('Q004')"
                                                                            title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p class="color-black">Q005</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Introduction to AI</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Artificial Intelligence</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Lesson 1</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Beginner</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result">
                                                                        Active
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-questions?action=edit&id=Q005"
                                                                            title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#"
                                                                            onclick="confirmDelete('Q005')"
                                                                            title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p class="color-black">Q006</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">What is Machine Learning?</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Artificial Intelligence</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Lesson 2</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Intermediate</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result fail">
                                                                        Paused
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-questions?action=edit&id=Q006"
                                                                            title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#"
                                                                            onclick="confirmDelete('Q006')"
                                                                            title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p class="color-black">Q007</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Natural Language Processing</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Artificial Intelligence</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Lesson 3</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Advanced</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result">
                                                                        Active
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-questions?action=edit&id=Q007"
                                                                            title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#"
                                                                            onclick="confirmDelete('Q007')"
                                                                            title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p class="color-black">Q008</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Computer Vision</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Artificial Intelligence</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Lesson 4</p>
                                                                </td>
                                                                <td>
                                                                    <p class="color-black">Advanced</p>
                                                                </td>
                                                                <td>
                                                                    <span class="dashboard__quiz-result">
                                                                        Active
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <div class="dashboard__review-action">
                                                                        <a href="${pageContext.request.contextPath}/manage-questions?action=edit&id=Q008"
                                                                            title="Edit"><i class="skillgro-edit"></i></a>
                                                                        <a href="#"
                                                                            onclick="confirmDelete('Q008')"
                                                                            title="Delete"><i class="skillgro-bin"></i></a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
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
                function confirmDelete(questionId) {
                    if (confirm('Are you sure you want to delete this question?')) {
                        window.location.href = '${pageContext.request.contextPath}/manage-questions?action=delete&id=' + questionId;
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