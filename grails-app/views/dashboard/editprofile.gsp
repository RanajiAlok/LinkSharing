<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Edit Profile - Link Sharing</title>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'application.css')}"/>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'editProfile.css')}"/>
</head>
<body>

<g:render template="/templates/navbar"/>
<g:render template="/templates/flashmessage" model="[message: flash.message, error: flash.error]"></g:render>


<div class="container-fluid mt-4">
    <div class="row justify-content-center">
        <div class="col-md-3 mr-4">

            <g:render template="/templates/profileCard"></g:render>

%{--            <div class="card mt-4">--}%
%{--                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">--}%
%{--                    <h5 class="mb-0">Topics</h5>--}%
%{--                </div>--}%
%{--                <div class="card-body">--}%

%{--                    <div class="topics-wrapper">--}%
%{--                        <div class="mb-3">--}%
%{--                            <div class="input-group">--}%
%{--                                <input type="text" class="form-control" placeholder="Filter topics..." id="topic-filter">--}%
%{--                                <div class="input-group-prepend">--}%
%{--                                    <span class="input-group-text bg-primary text-white">--}%
%{--                                        <i class="fas fa-search"></i>--}%
%{--                                    </span>--}%
%{--                                </div>--}%
%{--                            </div>--}%
%{--                        </div>--}%

%{--                        <div id="user-topics-container">--}%
%{--                            <!-- Content will be loaded here via AJAX -->--}%
%{--                        </div>--}%
%{--                    </div>--}%
%{--                </div>--}%
%{--            </div>--}%

        </div>

        <div class="col-md-7 ml-4">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Edit Profile</h4>
                </div>
                <div class="card-body">
                    <g:form controller="user" action="updateProfile" enctype="multipart/form-data" method="POST">
                        <div class="form-group">
                            <label for="firstName">First name *</label>
                            <input type="text" class="form-control" id="firstName" name="firstName" value="${user?.firstName}" required/>
                        </div>
                        <div class="form-group">
                            <label for="lastName">Last name *</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" value="${user?.lastName}" required/>
                        </div>
                        <div class="form-group">
                            <label for="username">Username *</label>
                            <input type="text" class="form-control" id="username" name="username" value="${user?.username}" required readonly/>
                        </div>
                        <div class="form-group">
                            <label for="photo">Photo</label>
                            <div class="input-group">
                                <input type="file" id="photo" name="photo"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Update</button>
                        </div>
                    </g:form>

                    <hr/>

                    <div class="card mt-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Change Password</h5>
                        </div>
                        <div class="card-body">
                            <g:form controller="user" action="updatePassword" method="POST">
                                <div class="form-group">
                                    <label for="password">Password *</label>
                                    <input type="password" class="form-control" id="password" name="password" required/>
                                </div>
                                <div class="form-group">
                                    <label for="confirmPassword">Confirm password *</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required/>
                                </div>
                                <div class="form-group">
                                    <button type="submit" class="btn btn-primary">Update</button>
                                </div>
                            </g:form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<g:render template="/templates/modals"/>
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
<script>
    %{--function loadTopics(page = 0, query = '') {--}%
    %{--    $.ajax({--}%
    %{--        url: "${createLink(controller: 'user', action: 'paginatedUserTopics')}",--}%
    %{--        data: {--}%
    %{--            offset: page * 10,--}%
    %{--            max: 10,--}%
    %{--            query: query--}%
    %{--        },--}%
    %{--        success: function(html) {--}%
    %{--            $("#user-topics-container").html(html);--}%
    %{--        },--}%
    %{--        error: function() {--}%
    %{--            alert("Failed to load topics.");--}%
    %{--        }--}%
    %{--    });--}%
    %{--}--}%

    // $(document).ready(function() {
    //     loadTopics();
    //
    //     $("#topic-filter").on("input", function() {
    //         const val = $(this).val();
    //         loadTopics(0, val);
    //     });
    //
    //     $(document).on("click", ".pagination-btn", function() {
    //         const page = $(this).data("page");
    //         const query = $("#topic-filter").val();
    //         loadTopics(page, query);
    //     });
    // });

    $(document).ready(function() {

        $("#topic-filter").on("input", function() {
            const val = $(this).val();
            loadTopics(0, val);
        });

        $(document).on("click", ".pagination-btn", function() {
            const page = $(this).data("page");
            const query = $("#topic-filter").val();
            loadTopics(page, query);
        });

        $('#photo').on('change', function() {
            if (this.files && this.files[0]) {
                $('#photoPath').val(this.files[0].name);
            } else {
                $('#photoPath').val('');
            }
        });
    });

    document.addEventListener('DOMContentLoaded', function () {
        const fileInput = document.getElementById('photo');
        const fileNameDisplay = document.getElementById('photoPath');

        fileInput.addEventListener('change', function () {
            if (fileInput.files.length > 0) {
                fileNameDisplay.value = fileInput.files[0].name;
            } else {
                fileNameDisplay.value = '';
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