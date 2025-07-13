<div class="modal fade" id="createTopicModal" tabindex="-1" aria-labelledby="createTopicModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createTopicModalLabel">Create Topic</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <g:form controller="topic" action="createTopic" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="topicName" class="form-label">Name *</label>
                        <input type="text" class="form-control" id="topicName" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label for="topicVisibility" class="form-label">Visibility *</label>
                        <select class="form-select" id="topicVisibility" name="visibility" required>
                            <option value="PUBLIC">Public</option>
                            <option value="PRIVATE">Private</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </g:form>
        </div>
    </div>
</div>

<div class="modal fade" id="shareLinkModal" tabindex="-1" aria-labelledby="shareLinkModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="shareLinkModalLabel">Share Link</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <g:form controller="resource" action="saveLinkResource" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="linkUrl" class="form-label">Link *</label>
                        <input type="url" class="form-control" id="linkUrl" name="url" required>
                    </div>
                    <div class="mb-3">
                        <label for="linkDescription" class="form-label">Description *</label>
                        <textarea class="form-control" id="linkDescription" name="description" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="linkTopic" class="form-label">Topic *</label>
                        <select class="form-select" id="linkTopic" name="topicId" required>
                            <option selected disabled>Loading topics...</option>

                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Share</button>
                </div>
            </g:form>
        </div>
    </div>
</div>

<div class="modal fade" id="shareDocumentModal" tabindex="-1" aria-labelledby="shareDocumentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="shareDocumentModalLabel">Share Document</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <g:uploadForm controller="resource" action="saveDocumentResource" method="POST">

                <div class="modal-body">
                    <div class="mb-3">
                        <label for="documentFile" class="form-label">Document *</label>
                        <input type="file" class="form-control" id="documentFile" name="document" required>
                    </div>
                    <div class="mb-3">
                        <label for="documentDescription" class="form-label">Description *</label>
                        <textarea class="form-control" id="documentDescription" name="description" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="documentTopic" class="form-label">Topic *</label>
                        <select class="form-select" id="documentTopic" name="topicId" required>
                            <option selected disabled>Loading topics...</option>

                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Share</button>
                </div>
            </g:uploadForm>
        </div>
    </div>
</div>

<div class="modal fade" id="sendInvitationModal" tabindex="-1" aria-labelledby="sendInvitationModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="sendInvitationModalLabel">Send Invitation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <g:form controller="topic" action="invite" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="invitationEmail" class="form-label">Email *</label>
                        <input type="email" class="form-control" id="invitationEmail" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="invitationTopic" class="form-label">Topic *</label>
                        <select class="form-select" id="invitationTopic" name="topicId" required>
                            <option selected disabled>Loading topics...</option>

                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Invite</button>
                </div>
            </g:form>
        </div>
    </div>
</div>

