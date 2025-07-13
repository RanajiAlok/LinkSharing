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
    <title>Register - LinkSharing</title>
</head>
<body>
<g:render template="/templates/navbar"/>

<div class="container mt-5">
    <div class="row">

        <div class="col-md-5 mb-4">
            <g:render template="/templates/recentShares" model="[max: 5]"/>
            <g:render template="/templates/topPosts" model="[max: 5]"/>
        </div>

        <div class="col-md-7">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Create an Account</h4>
                </div>
                <div class="card-body">
                    <g:if test="${flash.message}">
                        <div class="alert alert-${flash.messageType ?: 'info'} alert-dismissible fade show" role="alert">
                            ${flash.message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </g:if>
                    <g:else>
                        <div class="alert alert-danger">
                            <ul>
                                <g:each in="${flash.errors}" var="error">
                                    <li>${error}</li>
                                </g:each>
                            </ul>
                        </div>
                    </g:else>

                    <g:uploadForm controller="auth" action="register" method="POST">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="firstName" class="form-label">First Name</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" value="${user?.firstName}" required>

                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="lastName" class="form-label">Last Name</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" value="${user?.lastName}">

                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="userEmail" value="${user?.email}" required>
                            <div class="form-text">Email must be unique</div>

                        </div>

                        <div class="mb-3">
                            <label for="userName" class="form-label">Username</label>
                            <input type="text" class="form-control" id="userName" name="username" value="${user?.username}" required>
                            <div class="form-text">Username must be unique</div>

                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>

                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                <div class="form-text">Make sure your passwords match</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="photo" class="form-label">Profile Picture (Optional)</label>
                            <input type="file" class="form-control" id="photo" name="photo" accept="image/*">
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">Register</button>
                        </div>
                    </g:uploadForm>
                </div>
                <div class="card-footer text-center">
                    Already have an account? <a href="${createLink(controller: 'home', action: 'login')}" class="text-decoration-none">Login</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.querySelector('form').addEventListener('submit', function (event) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        if (password !== confirmPassword) {
            alert("Passwords do not match!");
            event.preventDefault();
        }
    });
</script>
</body>
</html>
