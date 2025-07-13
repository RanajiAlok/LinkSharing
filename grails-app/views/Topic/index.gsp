<%--
  Created by IntelliJ IDEA.
  User: alokkumarsingh
  Date: 13/04/25
  Time: 4:36 pm
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Link Sharing - Topic Details</title>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'application.css')}"/>
    <link rel="stylesheet" href="${resource(dir: '/assets/stylesheets' , file: 'topic.css')}"/>


</head>
<body>
<g:render template="/templates/navbar"></g:render>
<g:render template="/templates/flashmessage" model="[message: flash.message, error: flash.error]" ></g:render>

<div class="container content-wrapper">
    <div class="row">
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">Topic: "${topic?.topicName}"</div>
                <div class="card-body p-0">
                    <div class="user-info">
                        <div class="profile-icon">
                            <g:if test="${topic?.createdBy?.photo}">
                                <img src="${createLink(controller: 'user', action: 'renderImage', id: topic?.createdBy?.id)}" alt="Profile" class="img-fluid">
                            </g:if>
                            <g:else>
                                <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}" alt="Profile" class="img-fluid">
                            </g:else>
                        </div>
                        <div class="user-details">
                            <p class="user-name">${topic?.topicName} (${topic?.visibility == 'PRIVATE'?'PRIVATE' : 'PUBLIC'})</p>
                            <p class="user-handle">@${topic?.createdBy?.username}</p>
                            <div class="stats-row">
                                <div class="stats-item">Subscriptions <br> ${topic?.subscriptions?.size() ?: 0}</div>
                                <div class="stats-item">Posts <br> ${topic?.resources?.size() ?: 0}</div>
                            </div>
                        </div>
                    </div>

                    <div class="card-footer d-flex justify-content-between align-items-center p-2">

                        <div>
                            <g:if test="${session.user?.id != topic?.createdBy?.id}">
                                <g:if test="${isSubscribed}">
                                    <g:link controller="subscription"
                                            action="unsubscribe"
                                            params="[topicId:topic.id]"
                                            class="btn btn-sm btn-outline-danger">
                                        Unsubscribe
                                    </g:link>
                                </g:if>
                                <g:else>
                                    <g:link controller="subscription"
                                            action="subscribe"
                                            params="[topicId: topic?.id]"
                                            class="btn btn-sm btn-outline-success">
                                        Subscribe
                                    </g:link>
                                </g:else>
                            </g:if>
                        </div>

                        <!-- Seriousness Dropdown and Mail Icon -->
                        <div class="d-flex align-items-center">
                            <div class="me-2">
                                <g:form controller="subscription" action="updateSeriousness" method="POST" class="mb-0">
                                    <input type="hidden" name="topicId" value="${topic.id}"/>
                                    <select name="seriousness" class="form-select form-select-sm" onchange="this.form.submit()">
                                        <option value="SERIOUS" ${topic.subscriptions?.seriousness == 'SERIOUS' ? 'selected' : ''}>SERIOUS</option>
                                        <option value="CASUAL" ${topic.subscriptions?.seriousness == 'CASUAL' ? 'selected' : ''}>CASUAL</option>
                                        <option value="VERY_SERIOUS" ${topic.subscriptions?.seriousness == 'VERY_SERIOUS' ? 'selected' : ''}>VERY_SERIOUS</option>
                                    </select>
                                </g:form>
                            </div>
                            <div class="mail-icon">
                                <a href="#" data-bs-toggle="modal" data-bs-target="#sendInvitationModal" data-topic-id="${topic?.id}">
                                    <i class="fas fa-envelope"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card mt-3 user-list" id="usersList">
                <div class="card-header">Users: "${topic?.topicName}"</div>
                <div class="card-body p-0">
                    <div id="subscribersListContainer">
                        <g:if test="${subscribers}">
                            <g:each in="${subscribers}" var="subscriber">
                                <div class="user-info">
                                    <div class="profile-icon">
                                        <g:if test="${subscriber?.user?.photo}">
                                            <img src="${createLink(controller: 'user', action: 'renderImage', id: subscriber.user.id)}" alt="Profile" class="img-fluid">
                                        </g:if>
                                        <g:else>
                                            <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}" alt="Profile" class="rounded-circle me-1" style="width: 30px; height: 30px;">

                                        </g:else>
                                    </div>
                                    <div class="user-details">
                                        <p class="user-name">${subscriber.user.firstName} ${subscriber.user.lastName}</p>
                                        <p class="user-handle">@${subscriber.user.username}</p>
                                        <div class="stats-row">
                                            <div class="stats-item">Subscriptions <br> ${subscriber.user.subscriptions?.size() ?: 0}</div>
                                            <div class="stats-item">Topics <br> ${subscriber.user.topics.size() ?: 0}</div>
                                        </div>
                                    </div>
                                </div>
                            </g:each>

                            <div class="pagination-container p-2">
                                <g:paginate total="${subscribersTotal}"
                                            action="loadSubscribers"
                                            id="${params.id}"
                                            params="[tab: 'users']"
                                            max="10"
                                            controller="topic"
                                            next="Next &raquo;"
                                            prev="&laquo; Prev"
                                            class="pagination-sm pagination" />
                            </div>
                        </g:if>
                        <g:else>
                            <div class="p-3 text-center text-muted">
                                No subscribers found for this topic.
                            </div>
                        </g:else>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    Posts: "${topic?.topicName}"

                </div>

                <div class="card-body p-0" id="postsList">
                    <g:render template="/templates/postList"  />
                </div>
            </div>
        </div>

        </div>
    </div>
    <input type="hidden" id="currentTopicId" value="${topic?.id}" />
</div>

<g:render template="/templates/modals"/>
<script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'bootstrap.bundle.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'topic.js')}"></script>
<script>
    $(document).on("click", "#subscribersListContainer .pagination a", function(e) {
        e.preventDefault();
        var url = $(this).attr("href");
        $.get(url, function(data) {
            $("#subscribersListContainer").html(data);
        });
    });
</script>
<script>
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

</script>
</body>
</html>