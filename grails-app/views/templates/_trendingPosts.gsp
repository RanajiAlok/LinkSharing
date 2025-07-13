<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">Trending Topics</h5>
        <a href="#" class="btn btn-sm btn-outline-primary" onclick="loadPublicTopicsModal()">View All</a>
    </div>
    <div class="card-body p-0">
        <ul class="list-group list-group-flush">
            <g:each in="${trendingTopics}" var="topicData">
                <li class="list-group-item">
                    <div class="d-flex">
                        <div class="trending-image mr-3">
                            <g:if test="${topicData.topic.createdBy.photo}">
                                <img src="${createLink(controller: 'user', action: 'renderImage', id: topicData.topic.createdBy.id)}"
                                     class="img-fluid rounded-circle"
                                     width="50"
                                     height="50"
                                     alt="Profile"/>
                            </g:if>
                            <g:else>
                                <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}"
                                     alt="Profile"
                                     class="rounded-circle me-1"
                                     style="width: 30px; height: 30px;">
                            </g:else>
                        </div>
                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between align-items-center">
                                <g:link controller="topic" action="index" id="${topicData.topic.id}" class="topic-name-display fw-bold topic-link" data-topic-id="${topicData.topic.id}">
                                    ${topicData.topic.topicName}
                                </g:link>

                                <input type="text" class="form-control form-control-sm topic-name-input d-none"
                                       data-topic-id="${topicData.topic.id}"
                                       value="${topicData.topic.topicName}" />


                                <g:if test="${user}">
                                    <g:if test="${!topicData.isSubscribed}">
                                        <g:link controller="subscription"
                                                action="subscribe"
                                                params="[topicId: topicData.topic.id]"
                                                class="btn btn-sm btn-outline-success">
                                            Subscribe
                                        </g:link>
                                    </g:if>
                                    <g:else>
                                        <g:link controller="subscription"
                                                action="unsubscribe"
                                                params="[topicId: topicData.topic.id]"
                                                class="btn btn-sm btn-outline-danger">
                                            Unsubscribe
                                        </g:link>
                                    </g:else>
                                </g:if>
                            </div>
                            <div class="topic-owner">@${topicData.topic.createdBy.username}</div>
                            <div class="d-flex justify-content-between mt-2">
                                <div class="subscription-stats">
                                    <small>Subscribers:
                                        <span class="badge bg-secondary">
                                            ${topicData.topic.subscriptions?.size() ?: 0}
                                        </span>
                                    </small>
                                    <small class="ms-2">Posts:
                                        <span class="badge bg-secondary">
                                            ${topicData.topic.resources?.size() ?: 0}
                                        </span>
                                    </small>
                                </div>
                            </div>

                            <g:if test="${topicData.isOwner || user?.admin}">
                                <div class="btn-group">
                                    <button class="btn btn-sm btn-outline-primary ml-2 edit-topic-inline-btn"
                                            data-topic-id="${topicData.topic.id}">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <g:link class="btn btn-sm btn-outline-danger"
                                            controller="topic"
                                            action="delete"
                                            id="${topicData.topic.id}">
                                        Delete
                                    </g:link>
                                    <div class="btn-group visibility-dropdown" data-topic-id="${topicData.topic.id}">
                                        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                            ${topicData.topic.visibility}
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#" data-visibility="PUBLIC">Public</a></li>
                                            <li><a class="dropdown-item" href="#" data-visibility="PRIVATE">Private</a></li>
                                        </ul>
                                    </div>

                                </div>
                            </g:if>
                        </div>
                    </div>
                </li>
            </g:each>
            <g:if test="${!trendingTopics}">
                <li class="list-group-item text-center">No trending topics found</li>
            </g:if>
        </ul>
    </div>
</div>
<script>
    $(document).ready(function () {
        $('.edit-topic-inline-btn').click(function () {
            console.log("trending edit button is clicked");
            const topicId = $(this).data('topic-id');
            const $card = $(this).closest('.list-group-item');

            const $input = $card.find('.topic-name-input[data-topic-id="' + topicId + '"]');
            const $display = $card.find('.topic-name-display[data-topic-id="' + topicId + '"]');

            $display.addClass('d-none');
            $input.removeClass('d-none').focus();
        });

        $('.topic-name-input').on('keypress', function (e) {
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
                            $('.topic-name-display[data-topic-id="' + topicId + '"]').text(newName).removeClass('d-none');
                            $('.topic-name-input[data-topic-id="' + topicId + '"]').addClass('d-none');
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
    });

</script>
<script>
    document.querySelectorAll('.visibility-dropdown .dropdown-item').forEach(item => {
        item.addEventListener('click', function (e) {
            e.preventDefault();

            const visibility = this.getAttribute('data-visibility');
            const dropdown = this.closest('.visibility-dropdown');
            const topicId = dropdown.getAttribute('data-topic-id');
            const button = dropdown.querySelector('button');

            let body = JSON.stringify({
                topicId: topicId,
                visibility: visibility
            });

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
                    alert(data);
                })
                .catch(err => {
                    console.error("Error:", err);
                    alert('Error: ' + err);
                });
        });
    });

    function loadPublicTopicsModal() {
        $.ajax({
            url: "${createLink(controller: 'topic', action: 'showAllPublicTopic')}",
            method: 'GET',
            success: function (response) {
                $('#publicTopicsModalContent').html(response);
                $('#publicTopicsModal').modal('show');
            },
            error: function () {
                alert('Failed to load topics. Please try again later.');
            }
        });
    }


</script>
