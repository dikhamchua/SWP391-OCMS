<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Modal Setting View -->
<div class="modal fade" id="settingModal" tabindex="-1" aria-labelledby="settingModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="settingModalLabel">Table Settings</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/manage-registration" method="GET">
                    <input type="hidden" name="action" value="list">
                    
                    <!-- Preserve existing filters -->
                    <c:if test="${not empty param.category}">
                        <input type="hidden" name="category" value="${param.category}">
                    </c:if>
                    <c:if test="${not empty param.fromDate}">
                        <input type="hidden" name="fromDate" value="${param.fromDate}">
                    </c:if>
                    <c:if test="${not empty param.toDate}">
                        <input type="hidden" name="toDate" value="${param.toDate}">
                    </c:if>
                    <c:if test="${not empty param.status}">
                        <input type="hidden" name="status" value="${param.status}">
                    </c:if>
                    <c:if test="${not empty param.search}">
                        <input type="hidden" name="search" value="${param.search}">
                    </c:if>
                    <c:if test="${not empty param.pageSize}">
                        <input type="hidden" name="pageSize" value="${param.pageSize}">
                    </c:if>
                    
                    <div class="mb-3">
                        <label class="form-label">Select columns to display:</label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="idChoice" 
                                   ${not empty listColum && listColum.contains('idChoice') ? 'checked' : ''}>
                            <label class="form-check-label">ID</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="nameChoice" 
                                   ${not empty listColum && listColum.contains('nameChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Name</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="emailChoice" 
                                   ${not empty listColum && listColum.contains('emailChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Email</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="registrationTimeChoice" 
                                   ${not empty listColum && listColum.contains('registrationTimeChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Registration Time</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="categoryChoice" 
                                   ${not empty listColum && listColum.contains('categoryChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Category</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="packageChoice" 
                                   ${not empty listColum && listColum.contains('packageChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Package</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="totalCostChoice" 
                                   ${not empty listColum && listColum.contains('totalCostChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Total Cost</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="statusChoice" 
                                   ${not empty listColum && listColum.contains('statusChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Status</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="validFromChoice" 
                                   ${not empty listColum && listColum.contains('validFromChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Valid From</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="validToChoice" 
                                   ${not empty listColum && listColum.contains('validToChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Valid To</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="lastUpdatedByChoice" 
                                   ${not empty listColum && listColum.contains('lastUpdatedByChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Last Updated By</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="optionChoice" value="actionChoice" 
                                   ${not empty listColum && listColum.contains('actionChoice') ? 'checked' : ''}>
                            <label class="form-check-label">Action</label>
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Apply</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>