<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="col-lg-3">
    <div class="dashboard__sidebar-wrap">
        <div class="dashboard__sidebar-title mb-20">
            <h6 class="title">Welcome, Emily Hannah</h6>
        </div>
        <nav class="dashboard__sidebar-menu">
            <ul class="list-wrap">
                <li>
                    <a href="${pageContext.request.contextPath}/student-dashboard.html">
                        <i class="fas fa-home"></i>
                        Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard-profile?action=view.html">
                        <i class="skillgro-avatar"></i>
                        My Profile
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard-profile?action=change-pw">
                        <i class="skillgro-avatar"></i>
                        Change password
                    </a>
                </li>
                <c:if test="${sessionScope.account.role == 'Admin' }">
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-account">
                            <i class="skillgro-book"></i>
                            Manage Account
                        </a>
                    </li>
                </c:if>

                <li>
                    <a href="${pageContext.request.contextPath}/student-wishlist.html">
                        <i class="skillgro-label"></i>
                        Wishlist
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/student-review.html">
                        <i class="skillgro-book-2"></i>
                        Reviews
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/student-attempts.html">
                        <i class="skillgro-question"></i>
                        My Quiz Attempts
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/student-history.html">
                        <i class="skillgro-satchel"></i>
                        Order History
                    </a>
                </li>
            </ul>
        </nav>
        <div class="dashboard__sidebar-title mt-30 mb-20">
            <h6 class="title">User</h6>
        </div>
        <nav class="dashboard__sidebar-menu">
            <ul class="list-wrap">
                <li>
                    <a href="${pageContext.request.contextPath}/student-setting.html">
                        <i class="skillgro-settings"></i>
                        Settings
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/index.html">
                        <i class="skillgro-logout"></i>
                        Logout
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</div>