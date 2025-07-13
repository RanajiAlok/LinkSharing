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
    <title>Forgot Password - LinkSharing</title>
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
                    <h4 class="mb-0">Forgot Password</h4>
                </div>
                <div class="card-body">
                    <g:if test="${flash.message}">
                        <div class="alert alert-${flash.messageType ?: 'info'} alert-dismissible fade show" role="alert">
                            ${flash.message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </g:if>

                    <p class="mb-4">Enter your email address below. We'll send you a link to reset your password.</p>

                    <g:form controller="auth" action="sendPassword" method="POST">
                        <div class="mb-3">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">Send Reset Link</button>
                        </div>
                    </g:form>
                </div>
                <div class="card-footer text-center">
                    Remember your password? <a href="${createLink(controller: 'home', action: 'login')}" class="text-decoration-none">Back to Login</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal for Reset Password -->
<div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-labelledby="resetPasswordModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="resetPasswordModalLabel">Reset Your Password</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Please enter your new password below.</p>


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

</body>
</html>