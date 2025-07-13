<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Reset Password - LinkSharing</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<g:render template="/templates/navbar"/>

<div class="container mt-5">
    <div class="row">
        <div class="col-md-7 mb-4">
            <g:render template="/templates/recentShares" model="[max: 5]"/>
            <g:render template="/templates/topPosts" model="[max: 5]"/>
        </div>

        <div class="col-md-5">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Reset Password</h4>
                </div>
                <div class="card-body">
                    <g:if test="${flash.message}">
                        <div class="alert alert-${flash.messageType ?: 'info'} alert-dismissible fade show" role="alert">
                            ${flash.message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </g:if>

                    <p class="mb-4">Please enter your new password below and confirm it.</p>

                    <g:form controller="auth" action="updatePassword" method="POST">
                        <g:hiddenField name="token" value="${params.token}"/>

                        <div class="mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <g:passwordField name="newPassword" id="newPassword" class="form-control" required="required"/>
                        </div>

                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <g:passwordField name="confirmPassword" id="confirmPassword" class="form-control" required="required"/>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">Reset Password</button>
                        </div>
                    </g:form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
