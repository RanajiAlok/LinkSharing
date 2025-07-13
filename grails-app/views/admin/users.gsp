<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Link Sharing - Users</title>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'application.css')}"/>
    <link rel="stylesheet" href="${resource(dir:  'assets/stylesheets' , file: 'users.css')}"/>
    <link rel="stylesheet" href="${resource(dir:  'assets/stylesheets' , file: 'main.css')}"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'dashboard.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'topic.js')}"></script>
</head>
<body>

<g:render template="/templates/navbar"/>
<g:render template="/templates/flashmessage" model="[message: flash.message, error: flash.error]" ></g:render>

<div class="container mt-4">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span>Users</span>
            <div class="col-md-6">
%{--                <div class="d-flex justify-content-end">--}%
%{--                    <div class="mr-2">--}%
%{--                        <select class="form-control">--}%
%{--                            <option>All Users</option>--}%
%{--                            <option>Active Users</option>--}%
%{--                            <option>Inactive Users</option>--}%
%{--                        </select>--}%
%{--                    </div>--}%
%{--                    <div class="input-group">--}%
%{--                        <input type="text" class="search-input" placeholder="Search">--}%
%{--                        <button class="search-btn">--}%
%{--                            Search--}%
%{--                        </button>--}%
%{--                    </div>--}%
%{--                </div>--}%
            </div>
        </div>
        <div class="card-body">
            <div class="row mb-3">

            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="table-header">
                    <tr>
                        <th>
                            <div class="d-flex align-items-center">
                                Id
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                Username
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                Email
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                Firstname
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                Lastname
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                Active
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                Admin
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                Manage
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${users}" var="user" status="i">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.username}</td>
                            <td>${user.userEmail}</td>
                            <td>${user.firstName}</td>
                            <td>${user.lastName}</td>
                            <td>${user.active ? 'Yes' : 'No'}</td>
                            <td><g:if test="${user.admin}">
                                <g:link controller="admin" action="removeAdmin" id="${user.id}" class="btn-remove-admin btn btn-sm btn-danger">
                                    Remove Admin
                                </g:link>
                            </g:if>
                                <g:else>
                                    <g:link controller="admin" action="makeAdmin" id="${user.id}" class="btn-make-admin btn btn-sm btn-primary">
                                        Make Admin
                                    </g:link>
                                </g:else></td>
                            <td>
                                <g:if test="${user.active}">
                                    <g:link controller="admin" action="deactivate" id="${user.id}" class="btn-deactivate">
                                        Deactivate
                                    </g:link>
                                </g:if>
                                <g:else>
                                    <g:link controller="admin" action="activate" id="${user.id}" class="btn-activate">
                                        Activate
                                    </g:link>
                                </g:else>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>

            <div class="pagination">
                <g:paginate total="${userCount ?: 0}" max="20" />
            </div>

        </div>
    </div>
</div>

<g:render template="/templates/modals"/>
<script src="https://kit.fontawesome.com/d91e41b8a6.js" crossorigin="anonymous"></script>
<script>
    $(document).ready(function() {
        $('.btn-activate, .btn-deactivate,.btn-make-admin, .btn-remove-admin').on('click', function(e) {
            const message = $(this).hasClass('btn-make-admin') ? 'make this user an Admin?' :
                $(this).hasClass('btn-remove-admin') ? 'remove this user from Admin role?' :
                    'change this user\'s status?';
            if (!confirm('Are you sure you want to change this user\'s status?')) {
                e.preventDefault();
            }
        });
        $('.table-header a').on('click', function(e) {
            e.preventDefault();
        });


    });
</script>
<script>
    $(document).ready(function () {
        let userSubscribedTopics = ${raw(userTopicJson)};

        $('#sendInvitationModal').on('shown.bs.modal', function () {
            const $select = $(this).find('select[name="topicId"]');
            $select.empty();

            if (userSubscribedTopics && userSubscribedTopics.length > 0) {
                $select.append($('<option>', {
                    disabled: true,
                    selected: true,
                    text: 'Select a topic'
                }));

                $.each(userSubscribedTopics, function (i, topic) {
                    $select.append($('<option>', {
                        value: topic.id,
                        text: topic.name
                    }));
                });
            } else {
                $select.append($('<option>', {
                    disabled: true,
                    selected: true,
                    text: 'No subscribed topics found'
                }));
            }
        });

        $('#shareLinkModal, #shareDocumentModal').on('shown.bs.modal', function () {
            const $select = $(this).find('select[name="topicId"]');
            $select.empty();

            if (userSubscribedTopics && userSubscribedTopics.length > 0) {
                $select.append($('<option>', {
                    disabled: true,
                    selected: true,
                    text: 'Select a topic'
                }));

                $.each(userSubscribedTopics, function (i, topic) {
                    $select.append($('<option>', {
                        value: topic.id,
                        text: topic.name
                    }));
                });
            } else {
                $select.append($('<option>', {
                    disabled: true,
                    selected: true,
                    text: 'No subscribed topics found'
                }));
            }
        });
    });

</script>

</body>
</html>