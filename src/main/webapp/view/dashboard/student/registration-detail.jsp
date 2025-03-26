<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Registration Details</title>
    <meta name="description" content="SkillGro - Registration Details">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/css-file.jsp"></jsp:include>

    <!-- Custom CSS for status indicators -->
    <style>
        .registration-status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 14px;
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
        
        .details-card {
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .details-card .card-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .details-card .card-body {
            padding: 25px;
        }
        
        .details-section {
            margin-bottom: 30px;
        }
        
        .details-section h5 {
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
            color: #343a40;
        }
        
        .info-row {
            margin-bottom: 15px;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #212529;
        }
        
        .action-button {
            margin-right: 10px;
            padding: 8px 16px;
            border-radius: 4px;
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
                                <!-- Title and Buttons Row -->
                                <div class="row mb-4">
                                    <div class="col">
                                        <div class="dashboard__content-title">
                                            <h4 class="title">Registration Details</h4>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <a href="${pageContext.request.contextPath}/my-registration?${param.returnQueryString}" class="btn btn-secondary rounded-pill">
                                            <i class="fa fa-arrow-left me-2"></i> Back to My Registrations
                                        </a>
                                    </div>
                                </div>

                                <!-- Registration Detail Card -->
                                <div class="row">
                                    <div class="col-12">
                                        <div class="card details-card">
                                            <div class="card-header">
                                                <h5 class="mb-0">Registration #${registration.id}</h5>
                                            </div>
                                            <div class="card-body">
                                                <!-- Status Badge -->
                                                <div class="text-end mb-4">
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
                                                </div>
                                                
                                                <!-- Course Information Section -->
                                                <div class="details-section">
                                                    <h5>Course Information</h5>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Course Name</div>
                                                                <div class="info-value">${courseName}</div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Course ID</div>
                                                                <div class="info-value">${course.id}</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Package</div>
                                                                <div class="info-value">${registration.packages}</div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Total Cost</div>
                                                                <div class="info-value"><fmt:formatNumber value="${registration.totalCost}" type="currency"/></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Student Information Section -->
                                                <div class="details-section">
                                                    <h5>Student Information</h5>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Full Name</div>
                                                                <div class="info-value">${accountName}</div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Email</div>
                                                                <div class="info-value">${registration.email}</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Registration Information Section -->
                                                <div class="details-section">
                                                    <h5>Registration Information</h5>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Registration Date</div>
                                                                <div class="info-value"><fmt:formatDate value="${registration.registrationTime}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Registration Status</div>
                                                                <div class="info-value">${registration.status}</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Valid From</div>
                                                                <div class="info-value"><fmt:formatDate value="${registration.validFrom}" pattern="yyyy-MM-dd"/></div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Valid To</div>
                                                                <div class="info-value"><fmt:formatDate value="${registration.validTo}" pattern="yyyy-MM-dd"/></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="info-row">
                                                                <div class="info-label">Last Updated By</div>
                                                                <div class="info-value">${lastUpdatedByName}</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Action Buttons Section -->
                                                <div class="mt-4 text-end">
                                                    <a href="${pageContext.request.contextPath}/course-details?id=${registration.courseId}" class="btn btn-info action-button">
                                                        <i class="fa fa-eye"></i> View Course
                                                    </a>
                                                    <c:if test="${registration.status eq 'Active'}">
                                                        <a href="${pageContext.request.contextPath}/course-content?courseId=${registration.courseId}" class="btn btn-success action-button">
                                                            <i class="fa fa-play"></i> Access Course Content
                                                        </a>
                                                    </c:if>
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