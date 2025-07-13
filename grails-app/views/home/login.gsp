<%--
  Created by IntelliJ IDEA.
  User: alokkumarsingh
  Date: 09/04/25
  Time: 2:10 pm
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Login - LinkSharing</title>
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
                    <h4 class="mb-0">Login</h4>
                </div>
                <div class="card-body">
                    <g:if test="${flash.message}">
                        <div class="alert alert-${flash.messageType ?: 'info'} alert-dismissible fade show" role="alert">
                            ${flash.message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </g:if>

                    <g:form controller="auth" action="login" method="POST">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username or Email</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <g:hiddenField name="targetUri" value="${params.targetUri}" />
                        <div class="d-flex justify-content-between align-items-center">
                            <button type="submit" class="btn btn-primary">Login</button>
                            <a href="${createLink(controller: 'home', action: 'forgotPassword')}" class="text-decoration-none">Forgot Password?</a>
                        </div>
                    </g:form>
                </div>
                <div class="card-footer text-center">
                    Don't have an account? <a href="${createLink(controller: 'home', action: 'register')}" class="text-decoration-none">Register</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>