
<div class="subscriptions-wrapper">
    <div class="mb-3">
        <div class="input-group">
            <input type="text" class="form-control" placeholder="Filter subscriptions..." id="subscription-filter">
            <div class="input-group-prepend">
                <span class="input-group-text bg-primary text-white">
                    <i class="fas fa-search"></i>
                </span>
            </div>

        </div>
    </div>

    <div class="list-group subscription-list">
        <g:each in="${topics}" var="topic">
            <div class="list-group-item subscription-item mb-2 border-left-accent">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center">
                        <div class="topic-icon mr-3">
                            <i class="fas fa-${topic.topicName}
                                 fa-lg text-primary"></i>
                        </div>
                        <div>
                            <a href="${createLink(controller: 'topic', action: 'index', params: [id: topic.id])}"
                               class="topic-title font-weight-bold">${topic.topicName}</a>
                            <div class="creator-info small mt-1">
                                <span><i class="fas fa-user-edit"></i> @${topic.createdBy.username}</span>
                                <span class="ml-2"><i class="fas fa-book"></i> Resources: ${topic.resources?.size() ?: 0}</span>
                            </div>
                        </div>
                    </div>
                    <div>
                        <span class="badge badge-pill ${topic.visibility == 'PUBLIC' ? 'badge-success' : 'badge-secondary'} mr-2">
                            <i class="${topic.visibility == 'PUBLIC' ? 'fas fa-globe' : 'fas fa-lock'}"></i>
                            ${topic.visibility}
                        </span>
                        <button class="btn btn-sm btn-outline-danger unsubscribe-btn"
                                onclick="unsubscribeTopic(${topic.id}, this)">
                            Unsubscribe
                        </button>
                    </div>
                </div>
            </div>
        </g:each>
    </div>

    <g:if test="${!topics || topics.isEmpty()}">
        <div class="alert alert-info text-center">
            <i class="fas fa-info-circle mr-2"></i>
            You haven't subscribed to any topics yet.
        </div>
    </g:if>
</div>

<style>
.modal-header {
    border-bottom: 1px solid #dee2e6;
    padding: 1rem;
}

.modal-header .close {
    padding: 1rem;
    margin: -1rem -1rem -1rem auto;
    font-size: 1.5rem;
    font-weight: 700;
    line-height: 1;
    color: #000;
    text-shadow: 0 1px 0 #fff;
    opacity: .5;
    background-color: transparent;
    border: 0;
    cursor: pointer;
}

.modal-header .close:hover {
    opacity: .75;
}

.modal-title {
    margin-bottom: 0;
    line-height: 1.5;
}
.subscription-item {
    transition: all 0.2s ease;
    border-radius: 6px;
    border-left: 4px solid #3a7bd5 !important;
}

.subscription-item:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    background-color: #f8f9fa;
}

.topic-title {
    color: #2c3e50;
    font-size: 1.1rem;
    text-decoration: none;
}

.topic-title:hover {
    color: #3a7bd5;
    text-decoration: none;
}

.unsubscribe-btn:hover {
    background-color: #dc3545;
    color: white;
}

.creator-info i {
    width: 16px;
    text-align: center;
    margin-right: 4px;
}
</style>

<script>
    $(document).ready(function() {
        $("#subscription-filter").on("keyup", function() {
            var value = $(this).val().toLowerCase();
            $(".subscription-item").filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
            });
        });
    });

    function unsubscribeTopic(topicId, button) {
        if (confirm('Are you sure you want to unsubscribe from this topic?')) {
            $.ajax({
                url: '${createLink(controller: 'subscription', action: 'unsubscribe')}',
                method: 'POST',
                data: { topicId: topicId },
                success: function(response) {
                    if (response.success) {
                        $(button).closest('.subscription-item').fadeOut(300, function() {
                            $(this).remove();

                            var currentCount = parseInt($('.user-stats a:first-child span').text());
                            $('.user-stats a:first-child span').text(currentCount - 1);


                            if ($('.subscription-item').length === 0) {
                                $('.subscription-list').append(
                                    '<div class="alert alert-info text-center">' +
                                    '<i class="fas fa-info-circle mr-2"></i>' +
                                    'You haven\'t subscribed to any topics yet.' +
                                    '</div>'
                                );
                            }
                        });
                    } else {
                        alert('Failed to unsubscribe: ' + response.message);
                    }
                },
                error: function() {
                    alert('An error occurred while processing your request.');
                }
            });
        }
    }
</script>