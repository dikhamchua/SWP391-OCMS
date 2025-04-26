<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Hiển thị thông báo lỗi từ request attribute -->
<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <strong>Lỗi!</strong> ${errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<!-- Hiển thị thông báo thành công từ request attribute -->
<c:if test="${not empty successMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <strong>Thành công!</strong> ${successMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<!-- Script để tự động ẩn thông báo sau 5 giây -->
<script>
    // Đợi 5 giây sau đó ẩn các thông báo
    setTimeout(function() {
        var alerts = document.getElementsByClassName('alert');
        for (var i = 0; i < alerts.length; i++) {
            var alert = alerts[i];
            if (alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }
    }, 5000);
</script> 