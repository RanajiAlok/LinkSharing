<%--
  Created by IntelliJ IDEA.
  User: alokkumarsingh
  Date: 23/04/25
  Time: 8:19 pm
--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="layout" content="main"/>
    <title>Link Sharing - Search</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'application.css')}"/>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'main.css')}"/>
    <link rel="stylesheet" href="${resource(dir:  'assets/stylesheets', file: 'search.css')}"/>
    <script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'search.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'dashboard.js')}"></script>



</head>
<body>
<g:render template="/templates/navbar"/>
<g:render template="/templates/flashmessage" ></g:render>

<div class="container mt-4">
    <div class="row">

        <div class="col-md-4">
            <div class="mb-4">
                <g:render template="/templates/trendingPosts"/>
            </div>
            <div>
                <g:render template="/templates/topPosts"/>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Search results for "<strong>${params.query}</strong>"</h4>
                </div>
                <div class="card-body">
                    <g:render template="/templates/searchResults" model="[query: params.query]"/>
                </div>
            </div>
        </div>
    </div>
</div>


<g:render template="/templates/modals"/>

<script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'jquery-3.5.1.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'bootstrap.bundle.js')}"></script>
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