<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Link Sharing - Topics</title>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'application.css')}"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<g:render template="/templates/navbar"/>
<g:render template="/templates/flashmessage" model="[message: flash.message, error: flash.error]" ></g:render>

<div class="container mt-4">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span>All Topics</span>
            <!-- Moved the search bar to the right side -->
%{--            <div class="ml-auto d-flex align-items-center">--}%
%{--                <input type="text" class="search-input form-control" placeholder="Search">--}%
%{--                <button class="search-btn btn btn-primary ml-2">--}%
%{--                    Search--}%
%{--                </button>--}%
%{--            </div>--}%
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="table-header">
                    <tr>
                        <th>Id</th>
                        <th>Topic Name</th>
                        <th>Created By</th>
                        <th>Visibility</th>
                        <th>Date Created</th>
                        <th>Manage</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${topics}" var="topic">
                        <tr>
                            <td>${topic.id}</td>
                            <td>${topic.topicName}</td>
                            <td>${topic.createdBy?.username}</td>
                            <td>${topic.visibility}</td>
                            <td>${topic.dateCreated.format("dd-MM-yyyy HH:mm")}</td>
                            <td>
                                <g:link controller="topic" action="delete" id="${topic.id}" class="btn-delete">
                                    <i class="fa fa-trash"></i> Delete
                                </g:link>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>

            <div class="pagination">
                <g:paginate total="${topicCount ?: 0}" max="20"/>
            </div>
        </div>
    </div>
</div>
<g:render template="/templates/modals"/>
<script>
    $(document).ready(function() {
        $('.btn-delete').on('click', function(e) {
            if (!confirm('Are you sure you want to delete this topic?')) {
                e.preventDefault();
            }
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
