<g:if test="${postItems}">
    <g:each in="${postItems}" var="item">
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
                        <a href="${createLink(controller: 'topic', action: 'index', id: item.topic.id)}" class="topic-link fw-bold">${item.topic.topicName}</a>
                        <div class="resource-actions">
                            <g:if test="${item.class.simpleName == 'DocumentResource'}">
                                <a href="${createLink(controller: 'documentResource', action: 'download', id: item.id)}" class="btn btn-sm btn-outline-primary">Download</a>
                            </g:if>
                            <g:else>
                                <a href="${item.url}" target="_blank" class="btn btn-sm btn-outline-primary">View Full Site</a>
                            </g:else>
                            <a href="#" class="btn btn-sm btn-outline-primary mark-read-btn" data-item-id="${item.id}" onclick="markAsRead(event)">Mark as Read</a>
                            <g:link controller="resource" ,action="index" params="[id: item.id]" class="btn btn-sm btn-outline-primary"> View Post</g:link>
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
<g:else test="${!postItems}">
    <li class="list-group-item text-center">No Resources
    </li>
</g:else>

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
</script>