<%--
  Created by IntelliJ IDEA.
  User: alokkumarsingh
  Date: 25/04/25
  Time: 11:20 am
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>User Profile - Link Sharing</title>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'application.css')}"/>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'profilepage.css')}"/>
    <script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'dashboard.js')}"></script>


</head>
<body>
<g:render template="/templates/navbar"/>
<g:render template="/templates/flashmessage" model="[message: flash.message, error: flash.error]"></g:render>

<div class="container mt-4">
    <div class="row">

        <div class="col-md-4">
            <g:render template="/templates/profileCard"/>
            <g:render template="/templates/Subscriptions"/>
            <div id="topicsListContainer">
                <g:render template="/templates/userTopicsList" model="[topicsList: topicsList, isCurrentUser: isCurrentUser, isAdmin: isAdmin]"/>
            </div>

        <!-- Pagination Buttons -->
            <g:if test="${topicsTotal > 5}">
                <div class="pagination mt-3 text-center">
                    <button class="btn btn-outline-primary btn-sm mx-1" onclick="loadTopicsPage(${(params.offset ?: 0) - 5})" id="prevBtn">Previous</button>
                    <button class="btn btn-outline-primary btn-sm mx-1" onclick="loadTopicsPage(${(params.offset ?: 0) + 5})" id="nextBtn">Next</button>
                </div>
            </g:if>


        </div>

        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    Posts: "${topic?.topicName}"
                    <div>
                        <div class="d-flex">
                            <input type="text" id="postSearchInput" class="form-control form-control-sm me-2"
                                   placeholder="Search posts..." value="${params.q}">
                            <button id="searchPostsBtn" class="btn btn-sm btn-dark">Search</button>
                        </div>
                    </div>
                </div>

                <div class="card-body p-0" id="postsList">
                    <g:render template="/templates/postList" />
                </div>
            </div>
        </div>

    </div>
</div>

<g:render template="/templates/modals"/>

<div class="modal fade" id="subscriptionsModal" tabindex="-1" role="dialog" aria-labelledby="subscriptionsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content shadow">
            <div class="modal-header">
                <h5 class="modal-title" id="subscriptionsModalLabel">All Subscriptions</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="subscriptionsModalBody">
                <div class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                    <p class="mt-3">Loading subscriptions...</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function loadTopicsPage(newOffset) {
        if (newOffset < 0) newOffset = 0;

        $.ajax({
            url: "${createLink(controller: 'user', action: 'profile', id: user.id)}",
            type: 'GET',
            data: { offset: newOffset, max: 5 },
            success: function (response) {
                $('#topicsListContainer').html(response);
            },
            error: function (xhr, status, error) {
                console.error('Failed to load topics:', error);
                alert('Error loading topics. Please try again.');
            }
        });
    }
</script>
<script>
    $(document).ready(function (){
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

    })
</script>

</body>

</html>