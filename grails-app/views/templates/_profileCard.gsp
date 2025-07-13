<div class="card mb-4">
    <div class="card-body">
        <div class="d-flex">
            <div class="profile-image mr-3">
                <g:if test="${user?.photo}">
                    <a href="${createLink(controller: 'user', action: 'index', id: user?.id)}">
                        <img src="${createLink(controller: 'user', action: 'renderImage', id: user.id)}" class="img-fluid rounded-circle" width="80" height="80" alt="Profile Image"/>
                    </a>
                </g:if>
                <g:else>
                    <a href="${createLink(controller: 'user', action: 'index', id: user?.id)}">
                        <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}" class="img-fluid rounded-circle" width="80" height="80" alt="Default Profile"/>
                    </a>
                </g:else>
            </div>
            <div>
                <h5 class="card-title"><a href="${createLink(controller: 'user', action: 'index', id: user?.id)}" class="text-decoration-none text-dark">
                    ${session.user?.firstName} ${session.user?.lastName}
                </a></h5>
                <p class="card-text"><a href="${createLink(controller: 'user', action: 'index', id: user?.id)}" class="text-decoration-none">
                    @${session.user?.username}
                </a></p>
                <div class="user-stats">
                    <a href="#" class="text-decoration-none" onclick="openSubscriptionModal()">
                        Subscriptions: <span>${userSubscriptionCount ?: 0}</span>
                    </a>

                    <a href="#" class="text-decoration-none ml-3" onclick="loadTopics()">
                        Topics: <span>${userTopicCount ?: 0}</span>
                    </a>

                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function openSubscriptionModal() {
        $.ajax({
            url: '/dashboard/loadSubscriptionsModalContent',
            success: function(data) {
                $('#infoModalLabel').text('Your Subscriptions');
                $('#modalContent').html(data);
                $('#infoModal').modal('show');
            }
        });
    }

    function loadTopics() {
        $.ajax({
            url: '/topic/userTopics',
            success: function(data) {
                $('#infoModalLabel').text('Your Topics');
                $('#modalContent').html(data);
                $('#infoModal').modal('show');
            }
        });
    }

</script>