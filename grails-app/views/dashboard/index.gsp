<%--
  Created by IntelliJ IDEA.
  User: alokkumarsingh
  Date: 09/04/25
  Time: 10:33 pm
--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>LinkSharing - Dashboard</title>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'dashboard.css')}"/>
    <script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'dashboard.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'search.js')}"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<body>

<g:render template="/templates/navbar"/>
<g:render template="/templates/flashmessage" model="[flash: flash]" />

<div class="container mt-4">
    <div class="row">

        <div class="col-md-4">

            <g:render template="/templates/profileCard"></g:render>

            <g:render template="/templates/Subscriptions" model="[subscriptions: subscriptions]"></g:render>

            <div id="trendingTopicContainer">
                <g:render template="/templates/trendingPosts" />
            </div>

        </div>
        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Inbox</h5>
                    <div class="form-inline search-container">
                        <form class="ajax-search">
                            <div class="input-group">
                                <input type="text" name="query" class="form-control form-control-sm" placeholder="Search..." id="search-input">
                                <div class="input-group-append">
                                    <button class="btn btn-outline-secondary btn-sm" type="submit"><i class="fas fa-search"></i></button>
                                </div>
                            </div>
                        </form>

                    </div>
                </div>
                <div class="card-body p-0">
                    <div id="search-results">
                        <g:if test="${resources != null}">
                            <div class="bg-primary text-white">
                                <h4 class="mb-0">Search results for "<strong>${params.query}</strong>"</h4>
                            </div>
                            <div class="card-body">
                                <g:render template="/templates/searchResults" model="[query: params.query]"/>
                            </div>
                        </g:if>
                        <g:else>
                            <ul class="list-group list-group-flush">
                                <g:if test="${inboxItems}">
                                    <g:each in="${inboxItems}" var="item">
                                        <li class="list-group-item unread-item" id="item-${item.id}">
                                            <div class="d-flex">
                                                <div class="resource-image mr-3">
                                                    <g:if test="${item.createdBy?.photo}">
                                                        <img src="${createLink(controller: 'user', action: 'renderImage', id: item.createdBy.id)}" class="img-fluid rounded-circle" width="50" height="50" alt="Profile"/>
                                                    </g:if>
                                                    <g:else>
                                                        <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}" alt="Profile" class="rounded-circle me-1" style="width: 30px; height: 30px;">

                                                    </g:else>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <a href="${createLink(controller: 'topic', action: 'show', id: item.topic.id)}" class="topic-link fw-bold">${item.topic.topicName}</a>
                                                        <div class="resource-actions">
                                                            <g:if test="${item.class.simpleName == 'DocumentResource'}">
                                                                <a href="${createLink(controller: 'documentResource', action: 'download', id: item.id)}" class="btn btn-sm btn-outline-primary">Download</a>
                                                            </g:if>
                                                            <g:else>
                                                                <a href="${item.url}" target="_blank" class="btn btn-sm btn-outline-primary">View Full Site</a>
                                                            </g:else>
                                                            <a href="#" class="btn btn-sm btn-outline-primary mark-read-btn" data-item-id="${item.id}" onclick="markAsRead(event)">Mark as Read</a>
                                                            <g:link controller="resource" ,action="index" class="btn btn-sm btn-outline-primary" params="[id: item.id]"> View Post</g:link>
                                                        </div>
                                                    </div>
                                                    <div class="resource-created-by">
                                                        @${item.createdBy.username}
                                                        • <time:getRelativeTime date="${item.dateCreated}" />
                                                    </div>

                                                    <p class="resource-description mt-2">${item.description}</p>
                                                    <div class="social-links">
                                                        <a href="#" class="text-decoration-none mr-2"><i class="fab fa-facebook"></i></a>
                                                        <a href="#" class="text-decoration-none mr-2"><i class="fab fa-twitter"></i></a>
                                                        <a href="#" class="text-decoration-none"><i class="fab fa-google-plus"></i></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                    </g:each>
                                </g:if>
                                <g:else test="${!inboxItems}">
                                    <li class="list-group-item text-center">No unread items</li>
                                </g:else>
                            </ul>
                        </g:else>

                    </div>
                    <div class="pagination-container mt-3 text-center">
                        <g:paginate controller="dashboard" action="index" total="${totalInboxItems}" max="5" />
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="publicTopicsModal" tabindex="-1" aria-labelledby="publicTopicsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" id="publicTopicsModalContent">
            <!-- AJAX content will be loaded here -->
        </div>
    </div>

</div>

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


<g:render template="/templates/modals"/>

<div id="editTopicForm" style="display: none;">
    <form class="d-flex">
        <input type="text" class="form-control form-control-sm me-2" id="editTopicInput">
        <button type="submit" class="btn btn-sm btn-primary me-1">Save</button>
        <button type="button" class="btn btn-sm btn-secondary cancel-edit">Cancel</button>
    </form>
</div>

<div class="modal fade" id="infoModal" tabindex="-1" role="dialog" aria-labelledby="infoModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="infoModalLabel">Details</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body" id="modalContent" style="max-height: 400px; overflow-y: auto;">
                <!-- AJAX content for topics created and subscriptions -->
            </div>

        </div>
    </div>
</div>

<script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'jquery-3.5.1.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'bootstrap.bundle.js')}"></script>
<script>
    function markAsRead(event) {
        event.preventDefault();

        const itemId = $(event.target).data('item-id');

        $.ajax({
            url: '/readingItems/markAsRead',
            method: 'POST',
            data: { itemId: itemId },
            success: function(response) {
                alert('Post marked as read!');
            },
            error: function(error) {
                alert('Error marking as read!');
            }
        });
    }

    $(document).ready(function() {
        $('.modal-header .close').on('click', function() {
            $('#infoModal').modal('hide');
        });
    });

    fetch('/dashboard/showTrendingTopic')
        .then(res => res.text())
        .then(html => {
            document.getElementById('trendingTopicContainer').innerHTML = html;
        });
</script>

<script>
    $(document).ready(function() {

        $('.seriousness-select').change(function() {
            let subscriptionId = $(this).data('subscription-id');
            let seriousness = $(this).val();
            $.ajax({
                url: '${createLink(controller: "subscription", action: "updateSeriousness")}',
                method: 'POST',
                data: {
                    id: subscriptionId,
                    seriousness: seriousness
                }
            });
        });

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

        $('#sendInvitationForm').on('submit', function (e) {
            e.preventDefault();
            const email = $('#invitationEmail').val();
            const topicId = $('#invitationTopic').val();

            $.ajax({
                url: '/dashboard/sendInvitation',
                type: 'POST',
                data: { email, topicId },
                success: function (response) {
                    if (response.success) {
                        alert(response.message);
                        $('#sendInvitationModal').modal('hide');
                    } else {
                        alert(response.message);
                    }
                },
                error: function () {
                    alert('Error sending invitation.');
                }
            });
        });


        $('#createTopicBtn').click(function() {
            $('#sendInvitationModal').modal('hide');
            $('#createTopicModal').modal('show');


            $('#createTopicModal').on('hidden.bs.modal', function() {
                $('#sendInvitationModal').modal('show');

                $.ajax({
                    url: '${createLink(controller: "topic", action: "userTopicsJson")}',
                    success: function(data) {
                        let options = '';
                        $.each(data, function(index, topic) {
                            options += '<option value="' + topic.id + '">' + topic.name + '</option>';
                        });
                        $('#invitationTopic').html(options);
                    }
                });
            });
        });
    });
</script>
</body>
</html>