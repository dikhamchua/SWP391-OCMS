<aside class="blog-sidebar">
    <div class="blog-widget widget_search">
        <div class="sidebar-search-form">
            <form action="blog" method="post">
                <input type="text" name="search" placeholder="Search here" value="${searchTerm}">
                <button type="submit"><i class="flaticon-search"></i></button>
            </form>
        </div>
    </div>
    <div class="blog-widget">
        <h4 class="widget-title">Categories</h4>
        <div class="shop-cat-list">
            <ul class="list-wrap">
                <li>
                    <a href="blog" ${categoryId == null ? 'class="active"' : ''}>
                        <i class="flaticon-angle-right"></i>All Categories
                    </a>
                </li>
                <c:forEach var="entry" items="${blogCategoryMap}">
                    <li>
                        <a href="blog?category=${entry.key}" ${categoryId == entry.key ? 'class="active"' : ''}>
                            <i class="flaticon-angle-right"></i>${entry.value.name}
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
    <div class="blog-widget">
        <h4 class="widget-title">Latest Posts</h4>
        <c:forEach items="${latestBlogs}" var="latestBlog">
            <div class="rc-post-item">
                <div class="rc-post-thumb">
                    <a href="blog-details?id=${latestBlog.id}">
                        <img src="${latestBlog.thumbnail}" alt="blog">
                    </a>
                </div>
                <div class="rc-post-content">
                    <span class="date">
                        <i class="flaticon-calendar"></i>
                        ${fn:formatDate(blog.createdDate, "dd-MM-yyyy HH:mm:ss")}
                    </span>
                    <h4 class="title">
                        <a href="blog-details?id=${latestBlog.id}">${latestBlog.title}</a>
                    </h4>
                </div>
            </div>
        </c:forEach>
    </div>
</aside>