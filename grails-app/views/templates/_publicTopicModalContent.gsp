<div class="modal-header">
    <h5 class="modal-title">All Public Topics</h5>
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<div class="modal-body">
    <ul class="list-group">
        <g:each in="${publicTopics}" var="topic">
            <li class="list-group-item d-flex justify-content-between align-items-center">
                <a href="${createLink(controller: 'topic', action: 'index', params: [id: topic.id])}" class="text-decoration-none">
                    ${topic.topicName}
                </a>
                <span class="badge bg-primary">@${topic.createdBy.username}</span>
            </li>
        </g:each>
    </ul>
</div>
