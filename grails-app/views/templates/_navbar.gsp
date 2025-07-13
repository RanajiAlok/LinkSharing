<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm rounded-3 sticky-top px-3">
    <div class="container-fluid">

        <g:if test="${session.user}">
            <a class="navbar-brand fw-bold text-primary" href="${createLink(controller: 'dashboard', action: 'index')}" style="font-size: 24px; color: #4285F4;">
                <i class="fa-solid fa-link me-2"></i>Link Sharing
            </a>
        </g:if>
        <g:else>
            <a class="navbar-brand fw-bold text-primary" href="${createLink(controller: 'home', action: 'index')}" style="font-size: 24px; color: #4285F4;">
                <i class="fa-solid fa-link me-2"></i>Link Sharing
            </a>
        </g:else>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">



                <g:if test="${session?.user}"><div class="ms-auto d-flex align-items-center">
                <form class="d-flex me-3" action="${createLink(controller: 'dashboard', action: 'search')}" method="get">
                    <div class="input-group">
                        <input class="form-control" type="search" placeholder="Search" name="query" aria-label="Search" id="navbar-search-input" maxlength="255">
                        <button class="btn btn-dark" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    </form>

                    <div class="d-flex align-items-center me-3">

                        <a class="btn btn-dark me-2" href="#" data-bs-toggle="modal" data-bs-target="#createTopicModal">
                            Create topic
                        </a>


                        <a class="nav-link me-2" href="#" data-bs-toggle="modal" data-bs-target="#sendInvitationModal">
                            <i class="fas fa-envelope fs-4"></i>
                        </a>


                        <a class="nav-link me-2" href="#" data-bs-toggle="modal" data-bs-target="#shareLinkModal">
                            <i class="fas fa-link fs-4"></i>
                        </a>


                        <a class="nav-link me-2" href="#" data-bs-toggle="modal" data-bs-target="#shareDocumentModal">
                            <i class="fas fa-file fs-4"></i>
                        </a>
                    </div>

                    <div class="dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="profileDropdown" role="button" data-bs-toggle="dropdown">
                            <g:if test="${session?.user?.photo}">
                                <img src="${createLink(controller: 'user', action: 'renderImage', id: session.user.id)}" alt="Profile" class="rounded-circle me-1" style="width: 30px; height: 30px;">
                            </g:if>
                            <g:else>
                                <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}" alt="Profile" class="rounded-circle me-1" style="width: 30px; height: 30px;">
                            </g:else>
                            ${session?.user?.username}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                            <li><g:link class="dropdown-item" action="editProfile" controller="user">Profile</g:link></li>
                            <g:if test="${session?.user?.admin}">
                                <li><g:link class="dropdown-item" controller="admin" action="users">Users</g:link></li>
                                <li><g:link class="dropdown-item" action="showTopics" controller="admin">Topics</g:link></li>
                                <li><g:link class="dropdown-item" action="showPosts" controller="admin">Posts</g:link></li>
                            </g:if>
                            <li><hr class="dropdown-divider"></li>
                            <li><g:link class="dropdown-item" action="logout" controller="auth">Logout</g:link></li>
                        </ul>
                    </div>
                </g:if>
                <g:else>
                    <div class="ms-auto d-flex">
                        <a class="btn btn-primary me-2" href="${createLink(controller: 'home', action: 'login')}">Login</a>
                        <a class="btn btn-primary" href="${createLink(controller: 'home', action: 'register')}">Register</a>
                    </div>
                </g:else>
            </div>
        </div>
    </div>
</nav>

