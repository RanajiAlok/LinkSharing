<g:if test="${resources && !resources.isEmpty()}">
    <ul class="list-group list-group-flush">
        <g:each in="${resources}" var="res">
            <li class="list-group-item">
                <div class="d-flex">
                    <div class="res-image mr-3">
                        <g:if test="${res?.createdBy?.photo}">
                            <img src="${createLink(controller: 'user', action: 'renderImage', id: res.createdBy.id)}" class="img-fluid rounded-circle" width="50" height="50" alt="Profile"/>
                        </g:if>
                        <g:else>
                            <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}" alt="Profile" class="rounded-circle" style="width: 45px; height: 45px;">
                        </g:else>
                    </div>
                    <div class="flex-grow-1">
                        <div class="d-flex justify-content-between align-items-center">
                            <a href="${createLink(controller: 'topic', action: 'show', id: res.topic.id)}" class="topic-link fw-bold">${res.topic.topicName}</a>
                            <div class="resource-actions">
                                <g:if test="${res.class.simpleName == 'DocumentResource'}">
                                    <a href="${createLink(controller: 'documentResource', action: 'download', id: res.id)}" class="btn btn-sm btn-outline-primary">Download</a>
                                </g:if>
                                <g:else>
                                    <a href="${res.url}" target="_blank" class="btn btn-sm btn-outline-primary">View Full Site</a>
                                </g:else>
                                <g:if test="${!res.isRead}">
                                    <a href="#" class="btn btn-sm btn-outline-primary mark-read-btn" data-item-id="${res.id}" onclick="markAsRead(event)">Mark as Read</a>
                                </g:if>
                                <g:link controller="resource" ,action="index" params="[id: res.id]" class="btn btn-sm btn-outline-primary"> View Post</g:link>
                            </div>
                        </div>
                        <div class="resource-created-by">
                            @${res.createdBy.username} • <g:formatDate date="${res.dateCreated}" format="MMM dd, yyyy"/>
                        </div>
                        <p class="resource-description mt-2">${res.description}</p>
                        <div class="social-links">
                            <a href="#" class="text-decoration-none mr-2"><i class="fab fa-facebook"></i></a>
                            <a href="#" class="text-decoration-none mr-2"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="text-decoration-none"><i class="fab fa-google-plus"></i></a>
                        </div>
                    </div>
                </div>
            </li>
        </g:each>
    </ul>
</g:if>
<g:else>
    <div class="list-group-item text-center">
        No results found for "<span class="font-italic">${params.query}</span>"
    </div>
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