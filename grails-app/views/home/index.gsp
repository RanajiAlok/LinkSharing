<%--
  Created by IntelliJ IDEA.
  User: alokkumarsingh
  Date: 09/04/25
  Time: 3:25 pm
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>LinkSharing</title>
</head>
<body>
<g:render template="/templates/navbar"/>

<div class="container mt-5">
    <div class="row">

        <div class="col-md-7 mb-4">

            <g:render template="/templates/recentShares"/>
            <g:render template="/templates/topPosts"/>
        </div>


        <div class="col-md-5">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Welcome to LinkSharing</h4>
                </div>
                <div class="card-body">
                    <div class="mb-4">
                        <h5>Share the Best Resources with Everyone</h5>
                        <p>LinkSharing is a platform where you can share valuable resources, links, and knowledge with your network and the wider community.</p>
                        <p>Discover new content, connect with like-minded people, and expand your knowledge.</p>
                    </div>

                    <div class="mb-3">
                        <h5>Get Started Today</h5>
                        <p>Join our community to start sharing and discovering valuable resources.</p>
                        <div class="d-grid gap-2">
                            <a href="${createLink(controller: 'home', action: 'login')}" class="btn btn-primary mb-2">Login</a>
                            <a href="${createLink(controller: 'home', action: 'register')}" class="btn btn-success">Register</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>