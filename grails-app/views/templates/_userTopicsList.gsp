<div class="card my-3 p-3">
    <div class="card-header mb-3">
        <h4>Topics</h4>
    </div>

    <div class="topics-list">
        <g:each in="${topicsList}" var="topic">
            <div class="card mb-2 p-2 d-flex flex-row justify-content-between align-items-center">
                <div class="topic-name">
                    <a href="${createLink(controller: 'topic', action: 'index', id: topic.id)}"
                       class="text-primary fw-bold">
                        ${topic.topicName}
                    </a>
                </div>

                <div class="d-flex align-items-center">
                    <g:if test="${isCurrentUser || isAdmin}">
                        <div class="btn-group visibility-dropdown me-2" data-topic-id="${topic.id}">
                            <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                ${topic.visibility}
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" data-visibility="PUBLIC">Public</a></li>
                                <li><a class="dropdown-item" href="#" data-visibility="PRIVATE">Private</a></li>
                            </ul>
                        </div>

                        <a href="${createLink(controller: 'topic', action: 'delete', id: topic.id)}"
                           onclick="return confirm('Are you sure you want to delete this topic?');"
                           class="btn btn-outline-danger btn-sm">
                            <i class="fa fa-trash"></i>
                        </a>
                    </g:if>
                </div>
            </div>
        </g:each>
    </div>
</div>