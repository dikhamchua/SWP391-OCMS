<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="col-lg-3">
    <div class="dashboard__sidebar-wrap">
        <div class="dashboard__sidebar-title mb-20">
            <h6 class="title">Welcome, ${sessionScope.account.fullName}</h6>
        </div>
        <nav class="dashboard__sidebar-menu">
            <ul class="list-wrap">
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard">
                        <i class="fas fa-home"></i>
                        Dashboard
                    </a>
                </li>
                
                <!-- Chung cho tất cả các user đã đăng nhập -->
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard-profile?action=view">
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
                
                <!-- Chỉ ADMIN mới thấy -->
                <c:if test="${sessionScope.account.roleId == 1}">
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-registration">
                            <i class="skillgro-avatar"></i>
                            Manage Registration
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-account">
                            <i class="skillgro-book"></i>
                            Manage Account
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-setting">
                            <i class="skillgro-settings"></i>
                            System Settings
                        </a>
                    </li>
                    
                    <!-- Section Marketing dành riêng cho Admin -->
                    <li class="dashboard__sidebar-title mt-30 mb-20">
                        <h6 class="title">Marketing Manager</h6>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-blog">
                            <i class="skillgro-satchel"></i>
                            Manage Blog
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-slider">
                            <i class="skillgro-slider"></i>
                            Manage Slider
                        </a>
                    </li>
                    
                </c:if>
                
                <c:if test="${sessionScope.account.roleId == 4}">
                    <li class="dashboard__sidebar-title mt-30 mb-20">
                        <h6 class="title">Marketing Manager</h6>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-blog">
                            <i class="skillgro-satchel"></i>
                            Manage Blog
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-slider">
                            <i class="skillgro-slider"></i>
                            Manage Slider
                        </a>
                    </li>
                    
                </c:if>
                <!-- TEACHER và ADMIN mới thấy -->
                <c:if test="${sessionScope.account.roleId == 1 || sessionScope.account.roleId == 2}">
                    <li class="dashboard__sidebar-title mt-30 mb-20">
                        <h6 class="title">Course Management</h6>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-question">
                            <i class="skillgro-avatar"></i>
                            Manage Question
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-quiz">
                            <i class="skillgro-avatar"></i>
                            Manage Quiz
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manage-course">
                            <i class="skillgro-avatar"></i>
                            Manage Course
                        </a>
                    </li>
                </c:if>
                
                
                <!-- STUDENT và tất cả người dùng đã đăng nhập thấy -->
                <li class="dashboard__sidebar-title mt-30 mb-20">
                    <h6 class="title">My Learning</h6>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/my-registration">
                        <i class="skillgro-avatar"></i>
                        My Registration
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/my-courses">
                        <i class="skillgro-book"></i>
                        My Courses
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
                    <a href="${pageContext.request.contextPath}/authen?action=logout">
                        <i class="skillgro-logout"></i>
                        Logout
                    </a>
                </li>
            </ul>
        </nav>
        
        <!-- Hiển thị thông báo lỗi/thành công -->
        <%@ include file="/view/common/message.jsp" %>
    </div>
</div>