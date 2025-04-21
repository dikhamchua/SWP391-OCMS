<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="courses__sidebar">
    <div class="courses-widget">
        <h4 class="widget-title">Categories</h4>
        <div class="courses-cat-list">
            <ul class="list-wrap">
                <c:forEach items="${allCategories}" var="category">
                    <li>
                        <div class="form-check">
                            <input class="form-check-input category-filter" type="checkbox" 
                                value="${category.id}" id="cat_${category.id}" 
                                onchange="handleFilterChange('category')"
                                <c:if test="${selectedCategories.contains(category.id)}">checked</c:if>>
                            <label class="form-check-label" for="cat_${category.id}">
                                ${category.name}
                            </label>
                        </div>
                    </li>
                </c:forEach>
            </ul>
            <!-- <div class="show-more">
                <a href="#">Show More +</a>
            </div> -->
        </div>
    </div>
    <div class="courses-widget">
        <h4 class="widget-title">Ratings</h4>
        <div class="courses-rating-list">
            <ul class="list-wrap">
                <c:forEach begin="1" end="5" varStatus="loop">
                    <li>
                        <c:set var="ratingValue" value="${6 - loop.index}"/>
                        <c:set var="ratingValueAsInteger" value="${ratingValue.intValue()}"/>
                        <div class="form-check">
                            <input type="checkbox" 
                                   class="form-check-input rating-filter" 
                                   id="rating_${ratingValue}"
                                   value="${ratingValue}"
                                   onchange="handleFilterChange('rating')"
                   <c:if test="${selectedRatings.contains(ratingValueAsInteger)}">checked</c:if>>
                            <div class="rating">
                                <ul class="list-wrap">
                                    <c:forEach begin="1" end="5" varStatus="starLoop">
                                        <li ${starLoop.index <= ratingValue ? '' : 'class="delete"'}>
                                            <i class="fas fa-star"></i>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
</aside>
<script>
    let currentFilters = {
        categories: [],
        ratings: [],
        page: 1
    };

    function handleFilterChange(filterType) {
        // Bỏ dòng event.preventDefault() vì không cần thiết
        console.log('Filter changed:', filterType);

        switch (filterType) {
            case 'category':
                updateCategoryFilters();
                break;
            case 'rating':
                updateRatingFilters();
                break;
            default:
                console.error('Unknown filter type');
                return;
        }

        applyFilters(1);
    }

    function updateCategoryFilters() {
        const categoryCheckboxes = document.querySelectorAll('.category-filter:checked');
        currentFilters.categories = Array.from(categoryCheckboxes).map(cb => cb.value);
        console.log('Categories selected:', currentFilters.categories); // Debug
    }

    function updateRatingFilters() {
        const ratingCheckboxes = document.querySelectorAll('.rating-filter:checked');
        currentFilters.ratings = Array.from(ratingCheckboxes).map(cb => cb.value);
        console.log('Ratings selected:', currentFilters.ratings); // Debug
    }

    function applyFilters(page = 1) {
        currentFilters.page = page;
        const baseUrl = window.location.origin + window.location.pathname;
        const params = new URLSearchParams();

        // Thêm categories nếu có
        if (currentFilters.categories.length > 0) {
            params.set('categories', currentFilters.categories.join(','));
        }

        // Thêm ratings nếu có
        if (currentFilters.ratings.length > 0) {
            params.set('ratings', currentFilters.ratings.join(','));
        }

        // Thêm page
        params.set('page', currentFilters.page);

        // Giữ lại search keyword từ URL hiện tại
        const currentSearch = new URLSearchParams(window.location.search).get('search');
        if (currentSearch) {
            params.set('search', currentSearch);
        }

        // Tạo URL và redirect
        const queryString = params.toString();
        let newUrl = baseUrl;
        if (queryString) {
            newUrl += '?' + queryString;
        }
        window.location.href = newUrl;
    }

    // Initialize filters from URL on page load
    function initializeFilters() {
        const urlParams = new URLSearchParams(window.location.search);

        // Khởi tạo categories
        const categories = urlParams.get('categories');
        if (categories) {
            currentFilters.categories = categories.split(',');
            currentFilters.categories.forEach(id => {
                const checkbox = document.querySelector(`#cat_${id}`);
                if (checkbox)
                    checkbox.checked = true;
            });
        }

        // Khởi tạo ratings
        const ratings = urlParams.get('ratings');
        if (ratings) {
            currentFilters.ratings = ratings.split(',').map(Number); // Chuyển sang number
            currentFilters.ratings.forEach(rating => {
                const checkbox = document.querySelector(`.rating-filter[value="${rating}"]`);
                if (checkbox)
                    checkbox.checked = true;
            });
        }
        console.log('Ratings selected:', currentFilters.ratings);
        // Khởi tạo page
        const page = urlParams.get('page');
        currentFilters.page = page ? parseInt(page) : 1;
    }

    // Call initialization on page load
    document.addEventListener('DOMContentLoaded', initializeFilters);
</script>