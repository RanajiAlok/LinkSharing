<%--
  Created by IntelliJ IDEA.
  User: alokkumarsingh
  Date: 09/04/25
  Time: 4:47 pm
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<div class="card mb-4">
    <div class="card-header bg-light">
        <div class="d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Recent shares</h5>
            <div class="dropdown">
                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="recentSharesFilter" data-bs-toggle="dropdown" aria-expanded="false">
                    ${selectedFilter ?: 'Today'}
                </button>
                <ul class="dropdown-menu" aria-labelledby="recentSharesFilter">
                    <li><a class="dropdown-item" href="${createLink(controller: controllerName, action: actionName, params: [recentFilter: 'Today'])}">Today</a></li>
                    <li><a class="dropdown-item" href="${createLink(controller: controllerName, action: actionName, params: [recentFilter: '1 week'])}">1 week</a></li>
                    <li><a class="dropdown-item" href="${createLink(controller: controllerName, action: actionName, params: [recentFilter: '1 month'])}">1 month</a></li>
                    <li><a class="dropdown-item" href="${createLink(controller: controllerName, action: actionName, params: [recentFilter: '1 year'])}">1 year</a></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="card-body p-0">
        <g:if test="${!recentShares || recentShares.isEmpty()}">
            <div class="p-4 text-center text-muted">
                No recent shares found for public topics.
            </div>
        </g:if>
        <g:else>
            <div class="list-group list-group-flush">
                <g:each in="${recentShares}" var="res">
                    <div class="list-group-item p-3">
                        <div class="d-flex">
                            <div class="me-3">
                                <g:if test="${res.createdBy?.photo}">
                                    <img src="${createLink(controller: 'user', action: 'renderImage', params: [id: res.createdBy.id])}"
                                         alt="${res.createdBy.firstName} ${res.createdBy.lastName}"
                                         class="rounded" width="70" height="70">
                                </g:if>
                                <g:else>
                                    <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}" class="img-fluid rounded-circle" width="80" height="80" alt="Default Profile"/>
                                </g:else>
                            </div>
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <div>
                                        <span class="fw-bold">${res.createdBy.firstName} ${res.createdBy.lastName}</span>
                                        <span class="ms-2">@${res.createdBy.username}</span>
                                        <span class="ms-2">${res.dateCreated.format('dd MMM yyyy')}</span>
                                    </div>
                                    <div class="text-primary">${res.topic?.topicName}</div>
                                </div>
                                <p class="mb-2">${res.description}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <a href="#" class="me-2"><i class="bi bi-facebook"></i></a>
                                        <a href="#" class="me-2"><i class="bi bi-twitter"></i></a>
                                        <a href="#" class="me-2"><i class="bi bi-google"></i></a>
                                    </div>
                                    <g:if test="${!session.user}">
                                        <a href="${createLink(controller: 'login', action: 'index', params: [redirectUrl: createLink(controller: 'resource', action: 'showRecentShares', id: res.id)])}"
                                           class="text-decoration-none"
                                           onclick="alert('Please log in to view the post')">View post</a>
                                    </g:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </g:else>
    </div>
</div>