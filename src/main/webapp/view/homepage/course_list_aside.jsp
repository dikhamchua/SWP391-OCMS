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
                            <input class="form-check-input" type="checkbox" value="${category.id}" id="cat_${category.id}">
                            <label class="form-check-label" for="cat_${category.id}">
                                ${category.name} 
                                <!-- (${categoryCounts[category] != null ? categoryCounts[category] : 0}) -->
                            </label>
                        </div>
                    </li>
                </c:forEach>
            </ul>
            <div class="show-more">
                <a href="#">Show More +</a>
            </div>
        </div>
    </div>
    <div class="courses-widget">
        <h4 class="widget-title">Language</h4>
        <div class="courses-cat-list">
            <ul class="list-wrap">
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="lang_1">
                        <label class="form-check-label" for="lang_1">All Language</label>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="lang_2">
                        <label class="form-check-label" for="lang_2">Arabic (11)</label>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="lang_3">
                        <label class="form-check-label" for="lang_3">English (53)</label>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="lang_4">
                        <label class="form-check-label" for="lang_4">Spanish (22)</label>
                    </div>
                </li>
            </ul>
        </div>
        <div class="show-more">
            <a href="#">Show More +</a>
        </div>
    </div>
    <div class="courses-widget">
        <h4 class="widget-title">Price</h4>
        <div class="courses-cat-list">
            <ul class="list-wrap">
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="price_1">
                        <label class="form-check-label" for="price_1">All Price</label>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="price_2">
                        <label class="form-check-label" for="price_2">Free</label>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="price_3">
                        <label class="form-check-label" for="price_3">Paid</label>
                    </div>
                </li>
            </ul>
        </div>
    </div>
    <div class="courses-widget">
        <h4 class="widget-title">Skill level</h4>
        <div class="courses-cat-list">
            <ul class="list-wrap">
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="difficulty_1">
                        <label class="form-check-label" for="difficulty_1">All Skills</label>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="difficulty_2">
                        <label class="form-check-label" for="difficulty_2">Beginner (55)</label>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="difficulty_3">
                        <label class="form-check-label" for="difficulty_3">Intermediate (22)</label>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" id="difficulty_4">
                        <label class="form-check-label" for="difficulty_4">High (42)</label>
                    </div>
                </li>
            </ul>
        </div>
    </div>
    <div class="courses-widget">
        <h4 class="widget-title">Ratings</h4>
        <div class="courses-rating-list">
            <ul class="list-wrap">
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="">
                        <div class="rating">
                            <ul class="list-wrap">
                                <li><i class="fas fa-star"></i></li>
                                <li><i class="fas fa-star"></i></li>
                                <li><i class="fas fa-star"></i></li>
                                <li><i class="fas fa-star"></i></li>
                                <li><i class="fas fa-star"></i></li>
                            </ul>
                            <span>(42)</span>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="">
                        <div class="rating">
                            <ul class="list-wrap">
                                <li><i class="fas fa-star"></i></li>
                                <li><i class="fas fa-star"></i></li>
                                <li><i class="fas fa-star"></i></li>
                                <li><i class="fas fa-star"></i></li>
                                <li class="delete"><i class="fas fa-star"></i></li>
                            </ul>
                            <span>(23)</span>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="">
                        <div class="rating">
                            <ul class="list-wrap">
                                <li><i class="fas fa-star"></i></li>
                                <li><i class="fas fa-star"></i></li>
                                <li><i class="fas fa-star"></i></li>
                                <li class="delete"><i class="fas fa-star"></i></li>
                                <li class="delete"><i class="fas fa-star"></i></li>
                            </ul>
                            <span>(11)</span>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="">
                        <div class="rating">
                            <ul class="list-wrap">
                                <li><i class="fas fa-star"></i></li>
                                <li><i class="fas fa-star"></i></li>
                                <li class="delete"><i class="fas fa-star"></i></li>
                                <li class="delete"><i class="fas fa-star"></i></li>
                                <li class="delete"><i class="fas fa-star"></i></li>
                            </ul>
                            <span>(7)</span>
                        </div>
                    </div>
                </li>
                <li>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="">
                        <div class="rating">
                            <ul class="list-wrap">
                                <li><i class="fas fa-star"></i></li>
                                <li class="delete"><i class="fas fa-star"></i></li>
                                <li class="delete"><i class="fas fa-star"></i></li>
                                <li class="delete"><i class="fas fa-star"></i></li>
                                <li class="delete"><i class="fas fa-star"></i></li>
                            </ul>
                            <span>(3)</span>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</aside>
