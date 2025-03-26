<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - My Registrations</title>
    <meta name="description" content="SkillGro - My Registrations">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/css-file.jsp"></jsp:include>

    <!-- Bootstrap CSS -->
    <style>
        .registration-status {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-active {
            background-color: #e6f7e6;
            color: #28a745;
        }
        
        .status-pending {
            background-color: #fff3cd;
            color: #ffc107;
        }
        
        .status-expired {
            background-color: #f8d7da;
            color: #dc3545;
        }
        
        .status-cancelled {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        
        .table-actions {
            display: flex;
            gap: 8px;
        }
        
        .table-actions a {
            padding: 4px 8px;
            border-radius: 4px;
            color: white;
            text-decoration: none;
            font-size: 12px;
        }
        
        .action-view {
            background-color: #17a2b8;
        }
        
        .action-resume {
            background-color: #28a745;
        }
        
        .filter-form {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .settings-btn {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .modal-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        
        .column-option {
            margin-bottom: 10px;
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

    <c:url value="/my-registration" var="paginationUrl">
        <c:if test="${not empty param.courseId}">
            <c:param name="courseId" value="${param.courseId}" />
        </c:if>
        <c:if test="${not empty param.status}">
            <c:param name="status" value="${param.status}" />
        </c:if>
        <c:if test="${not empty param.search}">
            <c:param name="search" value="${param.search}" />
        </c:if>
        <c:if test="${not empty param.fromDate}">
            <c:param name="fromDate" value="${param.fromDate}" />
        </c:if>
        <c:if test="${not empty param.toDate}">
            <c:param name="toDate" value="${param.toDate}" />
        </c:if>
        <c:if test="${not empty param.pageSize}">
            <c:param name="pageSize" value="${param.pageSize}" />
        </c:if>
        <c:forEach items="${selectedColumns}" var="column">
            <c:param name="columns" value="${column}" />
        </c:forEach>
    </c:url>

    <!-- main-area -->
    <main class="main-area">
        <section class="dashboard__area section-pb-120">
            <div class="container-fluid">
                <jsp:include page="../../common/dashboard/avatar.jsp"></jsp:include>

                <div class="dashboard__inner-wrap">

                    <div class="row">
                        <jsp:include page="../../common/dashboard/sideBar.jsp"></jsp:include>

                        <div class="col-xl-9">
                            <div class="dashboard__content-area">
                                <div class="dashboard__content-title d-flex justify-content-between align-items-center">
                                    <h4 class="title">My Course Registrations</h4>
                                    <button type="button" class="settings-btn" data-toggle="modal" data-target="#settingModal">
                                        <i class="fa fa-cog"></i> Display Settings
                                    </button>
                                </div>

                                <!-- Filter Form -->
                                <div class="filter-form">
                                    <form action="${pageContext.request.contextPath}/my-registration" method="get">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label for="courseId">Course</label>
                                                    <select class="form-control" id="courseId" name="courseId">
                                                        <option value="">All Courses</option>
                                                        <c:forEach items="${courseList}" var="course">
                                                            <option value="${course.id}" ${param.courseId == course.id ? 'selected' : ''}>
                                                                ${course.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label for="status">Status</label>
                                                    <select class="form-control" id="status" name="status">
                                                        <option value="">All Status</option>
                                                        <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Active</option>
                                                        <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                        <option value="Expired" ${param.status == 'Expired' ? 'selected' : ''}>Expired</option>
                                                        <option value="Cancelled" ${param.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label for="search">Search</label>
                                                    <input type="text" class="form-control" id="search" name="search" 
                                                           placeholder="Search by course name" value="${param.search}">
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label for="fromDate">From Date</label>
                                                    <input type="date" class="form-control" id="fromDate" name="fromDate" value="${param.fromDate}">
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <label for="toDate">To Date</label>
                                                    <input type="date" class="form-control" id="toDate" name="toDate" value="${param.toDate}">
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Hidden inputs for column selections -->
                                        <c:forEach items="${selectedColumns}" var="col">
                                            <input type="hidden" name="columns" value="${col}">
                                        </c:forEach>
                                        
                                        <div class="row mt-2">
                                            <div class="col-md-12 d-flex justify-content-end">
                                                <button type="submit" class="btn btn-primary">Filter</button>
                                                <a href="${pageContext.request.contextPath}/my-registration" class="btn btn-secondary ml-2">Reset</a>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <!-- Registration List -->
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div>
                                        Showing <span class="fw-bold">${startRecord}</span> to 
                                        <span class="fw-bold">${endRecord}</span> of 
                                        <span class="fw-bold">${totalRegistrations}</span> registrations
                                    </div>
                                    <div>
                                        <form id="pageSizeForm" method="get" action="${pageContext.request.contextPath}/my-registration">
                                            <c:if test="${not empty param.courseId}">
                                                <input type="hidden" name="courseId" value="${param.courseId}">
                                            </c:if>
                                            <c:if test="${not empty param.status}">
                                                <input type="hidden" name="status" value="${param.status}">
                                            </c:if>
                                            <c:if test="${not empty param.search}">
                                                <input type="hidden" name="search" value="${param.search}">
                                            </c:if>
                                            <c:if test="${not empty param.fromDate}">
                                                <input type="hidden" name="fromDate" value="${param.fromDate}">
                                            </c:if>
                                            <c:if test="${not empty param.toDate}">
                                                <input type="hidden" name="toDate" value="${param.toDate}">
                                            </c:if>
                                            <!-- Hidden inputs for column selections -->
                                            <c:forEach items="${selectedColumns}" var="col">
                                                <input type="hidden" name="columns" value="${col}">
                                            </c:forEach>
                                            <input type="hidden" name="page" value="1">
                                            <select class="form-control" name="pageSize" onchange="document.getElementById('pageSizeForm').submit()">
                                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 per page</option>
                                                <option value="25" ${pageSize == 25 ? 'selected' : ''}>25 per page</option>
                                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 per page</option>
                                                <option value="100" ${pageSize == 100 ? 'selected' : ''}>100 per page</option>
                                            </select>
                                        </form>
                                    </div>
                                </div>

                                <!-- Registration Table -->
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <c:set var="showId" value="${empty selectedColumns}" />
                                                <c:set var="showCourse" value="${empty selectedColumns}" />
                                                <c:set var="showDate" value="${empty selectedColumns}" />
                                                <c:set var="showCost" value="${empty selectedColumns}" />
                                                <c:set var="showStatus" value="${empty selectedColumns}" />
                                                <c:set var="showValidity" value="${empty selectedColumns}" />
                                                
                                                <c:forEach items="${selectedColumns}" var="col">
                                                    <c:if test="${col eq 'id'}"><c:set var="showId" value="true" /></c:if>
                                                    <c:if test="${col eq 'course'}"><c:set var="showCourse" value="true" /></c:if>
                                                    <c:if test="${col eq 'date'}"><c:set var="showDate" value="true" /></c:if>
                                                    <c:if test="${col eq 'cost'}"><c:set var="showCost" value="true" /></c:if>
                                                    <c:if test="${col eq 'status'}"><c:set var="showStatus" value="true" /></c:if>
                                                    <c:if test="${col eq 'validity'}"><c:set var="showValidity" value="true" /></c:if>
                                                </c:forEach>
                                                
                                                <c:if test="${showId}"><th>ID</th></c:if>
                                                <c:if test="${showCourse}"><th>Course</th></c:if>
                                                <c:if test="${showDate}"><th>Registration Date</th></c:if>
                                                <c:if test="${showCost}"><th>Cost</th></c:if>
                                                <c:if test="${showStatus}"><th>Status</th></c:if>
                                                <c:if test="${showValidity}"><th>Valid Until</th></c:if>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${registrations}" var="registration" varStatus="loop">
                                                <c:set var="course" value="${courseDAO.findById(registration.courseId)}" />
                                                <tr>
                                                    <c:if test="${showId}"><td>${registration.id}</td></c:if>
                                                    <c:if test="${showCourse}"><td>${course.name}</td></c:if>
                                                    <c:if test="${showDate}">
                                                        <td><fmt:formatDate value="${registration.registrationTime}" pattern="yyyy-MM-dd" /></td>
                                                    </c:if>
                                                    <c:if test="${showCost}">
                                                        <td><fmt:formatNumber value="${registration.totalCost}" type="currency" currencySymbol="$" /></td>
                                                    </c:if>
                                                    <c:if test="${showStatus}">
                                                        <td>
                                                            <span class="registration-status 
                                                                <c:choose>
                                                                    <c:when test="${registration.status eq 'Active'}">status-active</c:when>
                                                                    <c:when test="${registration.status eq 'Pending'}">status-pending</c:when>
                                                                    <c:when test="${registration.status eq 'Expired'}">status-expired</c:when>
                                                                    <c:otherwise>status-cancelled</c:otherwise>
                                                                </c:choose>
                                                            ">
                                                                ${registration.status}
                                                            </span>
                                                        </td>
                                                    </c:if>
                                                    <c:if test="${showValidity}">
                                                        <td><fmt:formatDate value="${registration.validTo}" pattern="yyyy-MM-dd" /></td>
                                                    </c:if>
                                                    <td>
                                                        <div class="table-actions">
                                                            <a href="${pageContext.request.contextPath}/my-registration?action=view&id=${registration.id}" class="action-view">
                                                                <i class="fa fa-info-circle"></i> Details
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/course-detail?id=${registration.courseId}" class="action-view">
                                                                <i class="fa fa-eye"></i> View Course
                                                            </a>
                                                            <c:if test="${registration.status eq 'Active'}">
                                                                <a href="${pageContext.request.contextPath}/course-content?courseId=${registration.courseId}" class="action-resume">
                                                                    <i class="fa fa-play"></i> Resume
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty registrations}">
                                                <tr>
                                                    <c:set var="visibleColCount" value="1" /> <!-- Start with 1 for Actions column -->
                                                    <c:if test="${showId}"><c:set var="visibleColCount" value="${visibleColCount + 1}" /></c:if>
                                                    <c:if test="${showCourse}"><c:set var="visibleColCount" value="${visibleColCount + 1}" /></c:if>
                                                    <c:if test="${showDate}"><c:set var="visibleColCount" value="${visibleColCount + 1}" /></c:if>
                                                    <c:if test="${showCost}"><c:set var="visibleColCount" value="${visibleColCount + 1}" /></c:if>
                                                    <c:if test="${showStatus}"><c:set var="visibleColCount" value="${visibleColCount + 1}" /></c:if>
                                                    <c:if test="${showValidity}"><c:set var="visibleColCount" value="${visibleColCount + 1}" /></c:if>
                                                    
                                                    <td colspan="${visibleColCount}" class="text-center">No registrations found</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <div class="d-flex justify-content-center mt-4">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination">
                                            <c:if test="${currentPage > 1}">
                                                <li class="page-item">
                                                    <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                            </c:if>
                                            
                                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <li class="page-item">
                                                    <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" aria-label="Next">
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
        </section>
    </main>
    <!-- main-area-end -->

    <!-- Settings Modal -->
    <div class="modal fade" id="settingModal" tabindex="-1" role="dialog" aria-labelledby="settingModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="settingModalLabel">Display Settings</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/my-registration" method="get" id="settingsForm">
                        <c:if test="${not empty param.courseId}">
                            <input type="hidden" name="courseId" value="${param.courseId}">
                        </c:if>
                        <c:if test="${not empty param.status}">
                            <input type="hidden" name="status" value="${param.status}">
                        </c:if>
                        <c:if test="${not empty param.search}">
                            <input type="hidden" name="search" value="${param.search}">
                        </c:if>
                        <c:if test="${not empty param.fromDate}">
                            <input type="hidden" name="fromDate" value="${param.fromDate}">
                        </c:if>
                        <c:if test="${not empty param.toDate}">
                            <input type="hidden" name="toDate" value="${param.toDate}">
                        </c:if>
                        <c:if test="${not empty param.pageSize}">
                            <input type="hidden" name="pageSize" value="${param.pageSize}">
                        </c:if>
                        <c:if test="${not empty param.page}">
                            <input type="hidden" name="page" value="${param.page}">
                        </c:if>
                        
                        <div class="form-group">
                            <label class="font-weight-bold mb-3">Select columns to display:</label>
                            <div class="d-flex justify-content-end mb-3">
                                <button type="button" class="btn btn-sm btn-outline-primary mr-2" id="selectAllColumns">Select All</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" id="deselectAllColumns">Deselect All</button>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="id" id="idColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'id'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="idColumn">
                                        ID
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="course" id="courseColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'course'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="courseColumn">
                                        Course
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="date" id="dateColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'date'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="dateColumn">
                                        Registration Date
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="cost" id="costColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'cost'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="costColumn">
                                        Cost
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="status" id="statusColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'status'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="statusColumn">
                                        Status
                                    </label>
                                </div>
                            </div>
                            <div class="column-option">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="columns" value="validity" id="validityColumn"
                                           <c:forEach items="${selectedColumns}" var="col">
                                               <c:if test="${col eq 'validity'}">checked</c:if>
                                           </c:forEach>
                                           <c:if test="${empty selectedColumns}">checked</c:if>>
                                    <label class="form-check-label" for="validityColumn">
                                        Valid Until
                                    </label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="document.getElementById('settingsForm').submit();">Apply</button>
                </div>
            </div>
        </div>
    </div>

    <!-- footer-area -->
    <jsp:include page="../../common/home/footer-home.jsp"></jsp:include>
    <!-- footer-area-end -->

    <!-- JS here -->
    <jsp:include page="../../common/js-file.jsp"></jsp:include>

    <script>
        $(document).ready(function() {
            // Initialize Bootstrap modal
            if (typeof $.fn.modal === 'function') {
                $('#settingModal').modal({
                    show: false
                });
                
                // Handle modal open/close
                $('.close, .btn-secondary[data-dismiss="modal"]').click(function() {
                    $('#settingModal').modal('hide');
                });
    
                $('[data-toggle="modal"]').click(function() {
                    $('#settingModal').modal('show');
                });
            } else {
                console.warn('Bootstrap modal plugin not loaded');
                
                // Fallback for modal show/hide
                $('.close, .btn-secondary[data-dismiss="modal"]').click(function() {
                    $('#settingModal').hide();
                });
    
                $('[data-toggle="modal"]').click(function() {
                    $('#settingModal').show();
                });
            }
            
            // Select all columns button
            $('#selectAllColumns').click(function() {
                $('input[name="columns"]').prop('checked', true);
            });
            
            // Deselect all columns button
            $('#deselectAllColumns').click(function() {
                $('input[name="columns"]').prop('checked', false);
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
                        // Remove toast attributes from the session after displaying
                        fetch('${pageContext.request.contextPath}/remove-toast', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                        }).then(function(response) {
                            if (!response.ok) {
                                console.error('Failed to remove toast attributes');
                            }
                        }).catch(function(error) {
                            console.error('Error:', error);
                        });
                    }
                });
            }
        });
    </script>
</body>

</html> 