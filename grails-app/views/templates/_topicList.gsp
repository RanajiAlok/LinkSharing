<div class="topics-wrapper">
    <div class="mb-3">
        <div class="input-group">
            <input type="text" class="form-control" placeholder="Filter topics..." id="topic-filter">
            <div class="input-group-prepend">
                <span class="input-group-text bg-primary text-white">
                    <i class="fas fa-search"></i>
                </span>
            </div>

        </div>
    </div>

    <div class="list-group topic-list">
        <g:each in="${topics}" var="topic">
            <div class="list-group-item topic-item mb-2">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center">
                        <div class="topic-icon mr-3">
                            <i class="fas fa-${topic.topicName}
                                 fa-lg text-success"></i>
                        </div>
                        <div>
                            <a href="${createLink(controller: 'topic', action: 'index', params: [id: topic.id])}"
                               class="topic-title font-weight-bold">${topic.topicName}</a>
                            <input type="text" class="form-control form-control-sm topic-name-input d-none mt-1"
                                   data-topic-id="${topic.id}" value="${topic.topicName}" />
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
                        <div class="btn-group btn-group-sm">
                            <button class="btn btn-outline-danger"
                                    onclick="deleteTopic(${topic.id}, this)">
                                <i class="fas fa-trash"></i>
                            </button>

                        </div>
                    </div>
                </div>
            </div>
        </g:each>
    </div>

    <g:if test="${!topics || topics.isEmpty()}">
        <div class="alert alert-info text-center">
            <i class="fas fa-info-circle mr-2"></i>
            You haven't created any topics yet.
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
.topic-item {
    transition: all 0.2s ease;
    border-radius: 6px;
    border-left: 4px solid #28a745 !important;
}

.topic-item:hover {
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
    color: #28a745;
    text-decoration: none;
}

.creator-info i {
    width: 16px;
    text-align: center;
    margin-right: 4px;
}
</style>

<script>
    $(document).ready(function() {
        $("#topic-filter").on("keyup", function() {
            var value = $(this).val().toLowerCase();
            $(".topic-item").filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
            });
        });
    });

    function deleteTopic(topicId, button) {
        if (confirm('Are you sure you want to delete this topic? This action cannot be undone.')) {
            $.ajax({
                url: '${createLink(controller: 'topic', action: 'delete')}',
                method: 'POST',
                data: { id: topicId },
                success: function(response) {
                    if (response.success) {
                        $(button).closest('.topic-item').fadeOut(300, function() {
                            $(this).remove();

                            var currentCount = parseInt($('.user-stats a:nth-child(2) span').text());
                            $('.user-stats a:nth-child(2) span').text(currentCount - 1);

                            // Show empty message if no topics left
                            if ($('.topic-item').length === 0) {
                                $('.topic-list').append(
                                    '<div class="alert alert-info text-center">' +
                                    '<i class="fas fa-info-circle mr-2"></i>' +
                                    'You haven\'t created any topics yet.' +
                                    '</div>'
                                );
                            }
                        });
                    } else {
                        alert('Failed to delete topic: ' + response.message);
                    }
                },
                error: function() {
                    alert('An error occurred while processing your request.');
                }
            });
        }
    }
</script>
<script>

    $('.edit-topic-inline-btn').click(function () {
        const topicId = $(this).data('topic-id');
        const $card = $(this).closest('.list-group-item');

        const $input = $card.find('.topic-name-input[data-topic-id="' + topicId + '"]');
        const $display = $card.find('.topic-name-display[data-topic-id="' + topicId + '"]');

        $display.addClass('d-none');
        $input.removeClass('d-none').focus();
    });

    $('.topic-name-input').on('keypress', function (e) {
        if (e.which === 13) {
            const topicId = $(this).data('topic-id');
            const newName = $(this).val();

            $.ajax({
                url: '/topic/updateName',
                type: 'POST',
                data: {
                    id: topicId,
                    topicName: newName
                },
                success: function (response) {

                    if (response.success) {
                        $('.topic-name-display[data-topic-id="' + topicId + '"]').text(newName).removeClass('d-none');
                        $('.topic-name-input[data-topic-id="' + topicId + '"]').addClass('d-none');
                    } else {
                        alert(response.message || 'Update failed.');
                    }
                },
                error: function () {
                    alert('Something went wrong while updating the topic.');
                }
            });
        }
    });

</script>