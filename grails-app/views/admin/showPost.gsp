<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Link Sharing - ShowPosts</title>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'application.css')}"/>
    <link rel="stylesheet" href="${resource(dir:  'assets/stylesheets' , file: 'users.css')}"/>
    <link rel="stylesheet" href="${resource(dir:  'assets/stylesheets' , file: 'main.css')}"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
    .description-ellipsis {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 300px;
        display: inline-block;
    }

    </style>
</head>
<body>

<g:render template="/templates/navbar"/>
<g:render template="/templates/flashmessage" model="[message: flash.message, error: flash.error]" ></g:render>

<div class="container mt-4">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span>Posts</span>
            <div class="col-md-6">
                <div class="d-flex justify-content-end">
%{--                    <div class="input-group">--}%
%{--                        <input type="text" class="search-input" placeholder="Search">--}%
%{--                        <button class="search-btn">--}%
%{--                            Search--}%
%{--                        </button>--}%
%{--                    </div>--}%
                </div>
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
                                Resource_Id
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                Description
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                Link
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                Document
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                CreatedBy
                                <a href="#" class="text-white ml-1">
                                    <i class="fa fa-sort"></i>
                                </a>
                            </div>
                        </th>
                        <th>
                            <div class="d-flex align-items-center">
                                View Post
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
                    <tbody>
                    <g:each in="${resources}" var="res">
                        <tr>
                            <td>${res.id}</td>
                            <td><div class="description-ellipsis" title="${res.description}">
                                ${res.description}
                            </div></td>
                            <td>
                                <g:if test="${res.class.simpleName == 'LinkResource'}">
                                    <a href="${res.url}" target="_blank">View Full Site</a>
                                </g:if>
                            </td>

                            <td>
                                <g:if test="${res.class.simpleName == 'DocumentResource'}">
                                    <g:link controller="document" action="download" id="${res.id}">
                                        Download
                                    </g:link>
                                </g:if>
                            </td>
                            <td>${res.createdBy?.username}</td>
                            <td>
                                <g:link controller="resource" action="index" id="${res.id}" class="btn btn-info btn-sm">
                                    View
                                </g:link>
                            </td>
                            <td>
                                <g:link controller="admin" action="deleteResource" id="${res.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this resource?')">
                                    Delete
                                </g:link>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>

                </tbody>
                </table>
            </div>

            <div class="pagination">
                <g:paginate total="${resourceCount ?: 0}" max="20" />
            </div>

        </div>
    </div>
</div>
<g:render template="/templates/modals"/>
<script src="https://kit.fontawesome.com/d91e41b8a6.js" crossorigin="anonymous"></script>
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