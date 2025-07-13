<%--
  Created by IntelliJ IDEA.
  User: alokkumarsingh
  Date: 09/04/25
  Time: 4:48 pm
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<div class="card mb-4">
    <div class="card-header bg-light">
        <div class="d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Top posts</h5>
        </div>
    </div>
    <div class="card-body p-0">
        <g:if test="${!topPosts || topPosts.isEmpty()}">
            <div class="p-4 text-center">
                No top posts found for public topics.
            </div>
        </g:if>
        <g:else>
            <ul class="list-group list-group-flush">
                <g:each in="${topPosts}" var="res">
                    <li class="list-group-item" id="item-${res.id}">
                        <div class="d-flex">
                            <div class="resource-image me-3">
                                <g:if test="${res.createdBy?.photo}">
                                    <img src="${createLink(controller: 'user', action: 'renderImage', params: [id: res.createdBy.id])}" class="img-fluid rounded-circle" width="50" height="50" alt="Profile"/>
                                </g:if>
                                <g:else>
                                    <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}" alt="Profile" class="rounded-circle me-1" style="width: 30px; height: 30px;">
                                </g:else>
                            </div>
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="${createLink(controller: 'topic', action: 'index', id: res.topic.id)}" class="topic-link fw-bold">${res.topic?.topicName}</a>

                                </div>

                                <div class="resource-created-by">
                                    <span class="fw-bold">${res.createdBy.firstName} ${res.createdBy.lastName}</span>
                                    <span class="ms-2">@${res.createdBy.username}</span>
                                    • ${res.dateCreated.format('dd MMM yyyy')}
                                </div>
                                <p class="resource-description mt-2">${res.description}</p>
                                <div class="social-links mt-2">
                                    <a href="#" class="text-decoration-none me-2"><i class="fab fa-facebook"></i></a>
                                    <a href="#" class="text-decoration-none me-2"><i class="fab fa-twitter"></i></a>
                                    <a href="#" class="text-decoration-none"><i class="fab fa-google-plus"></i></a>
                                </div>
                                <div class="resource-actions">
                                    <g:if test="${session.user}">
                                        <g:if test="${res.class.simpleName == 'DocumentResource'}">
                                            <a href="${createLink(controller: 'documentResource', action: 'download', id: res.id)}" class="btn btn-sm btn-outline-primary">Download</a>
                                        </g:if>
                                        <g:else>
                                            <a href="${res.url}" target="_blank" class="btn btn-sm btn-outline-primary">View Full Site</a>
                                        </g:else>
                                        <a href="#" class="btn btn-sm btn-outline-primary mark-read-btn" data-item-id="${res.id}" onclick="markAsRead(event)">Mark as Read</a>
                                        <a href="${createLink(controller: 'resource', action: 'index', id: res.id)}" class="btn btn-sm btn-outline-primary">View Post</a>
                                    </g:if>
                                    <g:else>
                                        <a href="#" class="btn btn-sm btn-outline-primary" onclick="showLoginMessage(event)">View Post</a>
                                    </g:else>
                                </div>
                            </div>
                        </div>
                    </li>
                </g:each>
            </ul>
        </g:else>
    </div>

</div>

<script>
        function showLoginMessage(event) {
        event.preventDefault();
        const msg = document.createElement('div');
        msg.className = 'toast align-items-center text-white bg-danger border-0 show position-fixed bottom-0 end-0 m-4';
        msg.setAttribute('role', 'alert');
        msg.innerHTML = `
            <div class="d-flex">
                <div class="toast-body">
                    Please log in to perform this action.
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        `;
        document.body.appendChild(msg);
        setTimeout(() => msg.remove(), 4000); // Auto-hide
    }

</script>