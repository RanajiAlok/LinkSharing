<div class="card mb-4">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">Subscriptions</h5>
        <a href="javascript:void(0);" class="btn btn-sm btn-outline-primary"
           onclick="loadSubscriptionsModal()">
            View All
        </a>
    </div>

    <div class="card-body p-0" style="overflow: visible; position: relative; z-index: 1;">
        <div id="subscription-list">
            <ul class="list-group list-group-flush">
                <g:if test="${subscriptions}">
                    <g:each in="${subscriptions}" var="sub">
                        <li class="list-group-item">
                            <div class="d-flex">
                                <div class="subscriber-image mr-3">
                                    <g:if test="${sub.topic.createdBy?.photo}">
                                        <img src="${createLink(controller: 'user', action: 'renderImage', id: sub.topic.createdBy.id)}" class="img-fluid rounded-circle" width="50" height="50" alt="Profile"/>
                                    </g:if>
                                    <g:else>
                                        <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}" alt="Profile" class="rounded-circle me-1" style="width: 30px; height: 30px;">
                                    </g:else>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <g:link controller="topic" action="index" id="${sub.topic.id}" class="topic-name-display-subscription fw-bold topic-link" data-topic-id="${sub.topic.id}">
                                            ${sub.topic.topicName}
                                        </g:link>

                                        <input type="text" name="topicName" class="form-control form-control-sm topic-name-input-subscription d-none"
                                               data-topic-id="${sub.topic.id}"
                                               value="${sub.topic.topicName}" />
                                        <g:link controller="subscription"
                                                action="unsubscribe"
                                                params="[topicId: sub.topic.id]"
                                                class="btn btn-sm btn-outline-danger">
                                            Unsubscribe
                                        </g:link>
                                    </div>
                                    <div class="topic-owner">@${sub.topic.createdBy.username}</div>
                                    <div class="subscription-stats">
                                        <small>Subscribers: <span class="badge bg-secondary">${sub.topic.subscriptions.size()}</span></small>
                                        <small class="ml-2">Posts: <span class="badge bg-secondary">${sub.topic.resources.size()}</span></small>
                                    </div>
                                    <div class="d-flex justify-content-between mt-2">
                                        <div class="subscription-actions">
                                            <div class="dropdown d-inline">
                                                <g:form controller="subscription" action="updateSeriousness" method="POST">
                                                    <input type="hidden" name="topicId" value="${sub.topic.id}"/>
                                                    <g:select name="seriousness"
                                                              from="${['SERIOUS', 'CASUAL', 'VERY_SERIOUS']}"
                                                              value="${sub.seriousness}"
                                                              onchange="this.form.submit()"
                                                              class="form-select form-select-sm" />
                                                </g:form>
                                            </div>

                                            <a href="#" class="btn btn-sm btn-outline-secondary ml-2 send-invitation-btn" data-topic-id="${sub.topic.id}">
                                                <i class="fas fa-envelope"></i>
                                            </a>

                                            <g:if test="${user && (user.admin || user.id == sub.topic.createdBy?.id)}">
                                                <div class="dropdown d-inline ml-2">
                                                    <div class="btn-group subscription-visibility-dropdown" data-topic-id="${sub.topic.id}">
                                                        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                                            ${sub.topic.visibility}
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li><a class="dropdown-item" href="#" data-visibility="PUBLIC">Public</a></li>
                                                            <li><a class="dropdown-item" href="#" data-visibility="PRIVATE">Private</a></li>
                                                        </ul>
                                                    </div>
                                                </div>

                                                <button class="btn btn-sm btn-outline-primary ml-2 edit-topic-subscription-btn"
                                                        data-topic-id="${sub.topic.id}">
                                                    <i class="fas fa-edit"></i>
                                                </button>

                                                <g:link controller="topic" action="delete" id="${sub.topic.id}" class="btn btn-sm btn-outline-danger ml-2" onclick="return confirm('Are you sure you want to delete this topic?')">
                                                    <i class="fas fa-trash"></i>
                                                </g:link>
                                            </g:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </g:each>
                </g:if>
                <g:else>
                    <li class="list-group-item text-center">No subscriptions found</li>
                </g:else>
            </ul>
        </div>
    </div>
</div>

<!-- Invitation Modal -->
<div class="modal fade" id="invitationModal" tabindex="-1" aria-labelledby="invitationModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="sendInvitationFormSub" >
                <div class="modal-header">
                    <h5 class="modal-title" id="invitationModalLabel">Send Invitation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="invitationTopicId" name="topicId" />
                    <div class="mb-3">
                        <label for="recipientEmail" class="form-label">Recipient Gmail</label>
                        <input type="email" class="form-control" id="recipientEmail" name="email" placeholder="example@gmail.com" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Send</button>
                </div>
            </form>
        </div>
    </div>
</div>
<style>
.visibility-dropdown .dropdown-menu {
    z-index: 1055 !important;
</style>

<script>
    function loadSubscriptionsModal() {
        $('#subscriptionsModal').modal('show');
        $('#subscriptionsModalBody').html(`
        <div class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
                <span class="sr-only">Loading...</span>
            </div>
            <p class="mt-3">Loading subscriptions...</p>
        </div>
    `);

        $.ajax({
            url: '${createLink(controller: 'dashboard', action: 'loadSubscriptionsModalContent')}',
            method: 'GET',
            success: function (data) {
                $('#subscriptionsModalBody').html(data);
            },
            error: function () {
                $('#subscriptionsModalBody').html('<div class="alert alert-danger">Failed to load subscriptions.</div>');
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.subscription-visibility-dropdown .dropdown-item').forEach(item => {
            item.addEventListener('click', function (e) {
                e.preventDefault();

                const visibility = this.getAttribute('data-visibility');
                const dropdown = this.closest('.subscription-visibility-dropdown');
                const topicId = dropdown.getAttribute('data-topic-id');
                const button = dropdown.querySelector('button');

                let body = JSON.stringify({
                    topicId: topicId,
                    visibility: visibility
                });

                console.log("Sending topicId:", topicId);
                console.log("Sending visibility:", visibility);

                fetch('/topic/updateVisibility', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body
                })
                    .then(res => res.text())
                    .then(data => {
                        button.textContent = visibility;
                        console.log(data);
                        alert(data);
                    })
                    .catch(err => {
                        console.error("Error:", err);
                        alert('Error: ' + err);
                    });
            });
        });
    });

</script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.send-invitation-btn').forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                const topicId = this.getAttribute('data-topic-id');
                document.getElementById('invitationTopicId').value = topicId;
                new bootstrap.Modal(document.getElementById('invitationModal')).show();
            });
        });

        document.getElementById('sendInvitationFormSub').addEventListener('submit', function (e) {
            e.preventDefault();
            const email = document.getElementById('recipientEmail').value;
            const topicId = document.getElementById('invitationTopicId').value;

            if (!email || !topicId) {
                alert('Please enter email');
                return;
            }

            $.ajax({
                url: '/invitation/sendInvitationAjax',
                method: 'POST',
                data: {
                    email: email,
                    topicId: topicId
                },
                success: function (res) {
                    if (res.success) {
                        alert(res.message);
                        $('#invitationModal').modal('hide');
                        document.getElementById('sendInvitationForm').reset();
                    } else {
                        alert(res.message);
                    }
                },
                error: function (xhr, status, error) {
                    alert('Failed to send invitation.');
                }
            });
        });
    });
</script>
<script>
    $('.edit-topic-subscription-btn').click(function () {
        const topicId = $(this).data('topic-id');
        const $card = $(this).closest('.list-group-item');

        const $input = $card.find('.topic-name-input-subscription[data-topic-id="' + topicId + '"]');
        const $display = $card.find('.topic-name-display-subscription[data-topic-id="' + topicId + '"]');

        $display.addClass('d-none');
        $input.removeClass('d-none').focus();
    });

    $('.topic-name-input-subscription').on('keypress', function (e) {
        if (e.which === 13) {
            const topicId = $(this).data('topic-id');
            const newName = $(this).val();

            $.ajax({
                url: '/topic/updateName',
                type: 'POST',
                data: {
                    id: topicId,
                    topicName: newName
                },
                success: function (response) {

                    if (response.success) {
                        $('.topic-name-display-subscription[data-topic-id="' + topicId + '"]').text(newName).removeClass('d-none');
                        $('.topic-name-input-subscription[data-topic-id="' + topicId + '"]').addClass('d-none');
                    } else {
                        alert(response.message || 'Update failed.');
                    }
                },
                error: function () {
                    alert('Something went wrong while updating the topic.');
                }
            });
        }
    });
</script>
