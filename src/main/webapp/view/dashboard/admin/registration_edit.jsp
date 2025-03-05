<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>SkillGro - Edit Registration</title>
    <meta name="description" content="SkillGro - Edit Registration">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon"
        href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <!-- Place favicon.ico in the root directory -->

    <!-- CSS here -->
    <jsp:include page="../../common/css-file.jsp"></jsp:include>

    <!-- Bootstrap CSS -->
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
                                            <h4 class="title">Edit Registration</h4>
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <a href="${pageContext.request.contextPath}/manage-registration" class="btn btn-secondary rounded-pill">
                                            <i class="fa fa-arrow-left me-2"></i> Back to List
                                        </a>
                                    </div>
                                </div>

                                <!-- Registration Edit Form -->
                                <div class="row">
                                    <div class="col-12">
                                        <div class="card">
                                            <div class="card-body p-4">
                                                <div class="registration-details mb-4">
                                                    <h5 class="mb-3">Registration R${registration.id}</h5>
                                                    
                                                    <div class="row mb-3">
                                                        <div class="col-md-6">
                                                            <div class="mb-2">
                                                                <strong>Subject:</strong> ${categoryName}
                                                            </div>
                                                            <div class="mb-2">
                                                                <strong>Package:</strong> ${registration.packages}
                                                            </div>
                                                            <div class="mb-2">
                                                                <strong>Total Cost:</strong> <fmt:formatNumber value="${registration.totalCost}" type="currency"/>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="mb-2">
                                                                <strong>Full Name:</strong> ${accountName}
                                                            </div>
                                                            <div class="mb-2">
                                                                <strong>Email:</strong> ${registration.email}
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="row mb-3">
                                                        <div class="col-md-6">
                                                            <div class="mb-2">
                                                                <strong>Registration Time:</strong> <fmt:formatDate value="${registration.registrationTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                                            </div>
                                                            <div class="mb-2">
                                                                <strong>Status:</strong> 
                                                                <span class="badge ${registration.status == 'Active' ? 'bg-success' : 'bg-danger'}">
                                                                    ${registration.status}
                                                                </span>
                                                                <button class="btn btn-sm btn-outline-primary ms-2" id="editStatusBtn">Edit</button>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="mb-2">
                                                                <strong>Valid From:</strong> <fmt:formatDate value="${registration.validFrom}" pattern="yyyy-MM-dd"/>
                                                            </div>
                                                            <div class="mb-2">
                                                                <strong>Valid To:</strong> <fmt:formatDate value="${registration.validTo}" pattern="yyyy-MM-dd"/>
                                                                <button class="btn btn-sm btn-outline-primary ms-2" id="editDatesBtn">Edit</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="row">
                                                        <div class="col-12">
                                                            <div class="mb-2">
                                                                <strong>Notes:</strong> 
                                                                <span id="notesText">First-time user</span>
                                                                <button class="btn btn-sm btn-outline-primary ms-2" id="editNotesBtn">Edit</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Edit Forms (initially hidden) -->
                                                <form action="${pageContext.request.contextPath}/manage-registration" method="POST" id="registrationEditForm">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="id" value="${registration.id}">
                                                    
                                                    <!-- Status Edit Section -->
                                                    <div class="edit-section mb-3" id="statusEditSection" style="display: none;">
                                                        <h6>Edit Status</h6>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Status</label>
                                                                    <select class="form-select" name="status">
                                                                        <option value="Active" ${registration.status == 'Active' ? 'selected' : ''}>Active</option>
                                                                        <option value="Inactive" ${registration.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="mb-3">
                                                            <button type="button" class="btn btn-sm btn-secondary" id="cancelStatusBtn">Cancel</button>
                                                            <button type="submit" class="btn btn-sm btn-primary">Save Changes</button>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Dates Edit Section -->
                                                    <div class="edit-section mb-3" id="datesEditSection" style="display: none;">
                                                        <h6>Edit Validity Period</h6>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Valid From</label>
                                                                    <input type="date" class="form-control" name="validFrom" 
                                                                           value="<fmt:formatDate value="${registration.validFrom}" pattern="yyyy-MM-dd"/>">
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Valid To</label>
                                                                    <input type="date" class="form-control" name="validTo" 
                                                                           value="<fmt:formatDate value="${registration.validTo}" pattern="yyyy-MM-dd"/>">
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="mb-3">
                                                            <button type="button" class="btn btn-sm btn-secondary" id="cancelDatesBtn">Cancel</button>
                                                            <button type="submit" class="btn btn-sm btn-primary">Save Changes</button>
                                                        </div>
                                                    </div>
                                                    
                                                    <!-- Notes Edit Section -->
                                                    <div class="edit-section mb-3" id="notesEditSection" style="display: none;">
                                                        <h6>Edit Notes</h6>
                                                        <div class="row">
                                                            <div class="col-12">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Notes</label>
                                                                    <textarea class="form-control" name="notes" rows="3">First-time user</textarea>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="mb-3">
                                                            <button type="button" class="btn btn-sm btn-secondary" id="cancelNotesBtn">Cancel</button>
                                                            <button type="submit" class="btn btn-sm btn-primary">Save Changes</button>
                                                        </div>
                                                    </div>
                                                </form>
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

    <!-- 1. First jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- 2. Then other JS files -->
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

    <!-- Custom scripts for edit functionality -->
    <script>
        $(document).ready(function() {
            console.log("Document ready, initializing edit functionality");
            
            // Edit Status button
            $('#editStatusBtn').click(function() {
                console.log("Status edit button clicked");
                $('#statusEditSection').show();
            });
            
            // Edit Dates button
            $('#editDatesBtn').click(function() {
                console.log("Dates edit button clicked");
                $('#datesEditSection').show();
            });
            
            // Edit Notes button
            $('#editNotesBtn').click(function() {
                console.log("Notes edit button clicked");
                $('#notesEditSection').show();
            });
            
            // Cancel buttons - using direct IDs instead of class and data attributes
            $('#cancelStatusBtn').click(function() {
                console.log("Cancel status button clicked");
                $('#statusEditSection').hide();
            });
            
            $('#cancelDatesBtn').click(function() {
                console.log("Cancel dates button clicked");
                $('#datesEditSection').hide();
            });
            
            $('#cancelNotesBtn').click(function() {
                console.log("Cancel notes button clicked");
                $('#notesEditSection').hide();
            });
        });
    </script>
</body>

</html> 