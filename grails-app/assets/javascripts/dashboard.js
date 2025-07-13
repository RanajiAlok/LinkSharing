document.addEventListener('DOMContentLoaded', function() {

    var modals = document.querySelectorAll('.modal');
    modals.forEach(function(modal) {
        new bootstrap.Modal(modal);
    });

    setupModalTriggers();
    setupAjaxSearch();
    setupMarkAsRead();
    setupDropdownHandlers();



    document.querySelectorAll('[data-time]').forEach(function (el) {
        const time = new Date(el.getAttribute('data-time'));
        const now = new Date();
        const diffMs = now - time;
        const minutes = Math.floor(diffMs / 60000);
        const hours = Math.floor(diffMs / (60 * 60000));
        const days = Math.floor(diffMs / (24 * 60 * 60000));

        let display = 'Just now';
        if (days > 0) display = `${days} day${days > 1 ? 's' : ''} ago`;
        else if (hours > 0) display = `${hours} hour${hours > 1 ? 's' : ''} ago`;
        else if (minutes > 0) display = `${minutes} min ago`;

        el.textContent = display;
    });



    function showTopicDetails(topicId) {
        const topicContainer = $('#topicDetails');

        topicContainer.html('<div class="text-center p-3"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>');

        $.ajax({
            type: 'GET',
            url: '/topic/index',
            data: { id: topicId },
            success: function (response) {
                topicContainer.html(response);
            },
            error: function (xhr, status, error) {
                console.error("Error loading topic:", error);
                topicContainer.html('<div class="alert alert-danger">Failed to load topic details. Please try again later.</div>');
            }
        });
    }
});



function setupModalTriggers() {

    const modalTriggers = [
        { selector: '[data-action="create-topic"]', modalId: 'createTopicModal' },
        { selector: '[data-action="share-link"]', modalId: 'shareLinkModal' },
        { selector: '[data-action="share-document"]', modalId: 'shareDocumentModal' },
        { selector: '[data-action="send-invitation"]', modalId: 'sendInvitationModal' }
    ];

    modalTriggers.forEach(function(trigger) {
        document.querySelector(trigger.selector).addEventListener('click', function(e) {
            e.preventDefault();
            var modal = new bootstrap.Modal(document.getElementById(trigger.modalId));
            modal.show();
        });
    });

    document.getElementById('createTopicBtn').addEventListener('click', function() {
        var invitationModal = bootstrap.Modal.getInstance(document.getElementById('sendInvitationModal'));
        invitationModal.hide();

        var createTopicModal = new bootstrap.Modal(document.getElementById('createTopicModal'));
        createTopicModal.show();

        document.getElementById('createTopicModal').addEventListener('hidden.bs.modal', function onceHandler() {
            document.getElementById('createTopicModal').removeEventListener('hidden.bs.modal', onceHandler);
            invitationModal.show();
            refreshTopicsDropdown();
        });
    });
}

function setupAjaxSearch() {
    const searchInput = document.getElementById('search-input');
    const searchForm = document.querySelector('.ajax-search')
    let searchTimeout;
    if(!searchInput || !searchForm) return ;

    searchInput.addEventListener('keyup', function() {
        clearTimeout(searchTimeout);
        const query = this.value;

        searchTimeout = setTimeout(function() {
            if (query.length >= 3) {
                performSearch(query);
            }
        }, 300);
    });

    searchForm.addEventListener('submit', function(e) {
        e.preventDefault();
        const query = searchInput.value;

        if (query.length >= 3) {
            performSearch(query);
        }
    });
}

function performSearch(query) {
    fetch(contextPath + '/dashboard/index?query=' + encodeURIComponent(query), {
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
        .then(response => response.text())
        .then(html => {
            document.getElementById('search-results').innerHTML = html;
        })
        .catch(error => {
            console.error('Error performing search:', error);
        });
}


function setupMarkAsRead() {
    document.addEventListener('click', function(e) {
        if (e.target && e.target.classList.contains('mark-read-btn')) {
            e.preventDefault();
            var itemId = e.target.getAttribute('data-item-id');

            fetch(contextPath + '/readingItem/markAsRead/' + itemId, {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Remove the item from the view with animation
                        var item = document.getElementById('item-' + itemId);
                        item.style.transition = 'opacity 0.3s ease';
                        item.style.opacity = '0';

                        setTimeout(function() {
                            item.remove();

                            // Check if there are no more items
                            var items = document.querySelectorAll('.unread-item');
                            if (items.length === 0) {
                                document.getElementById('search-results').innerHTML =
                                    '<li class="list-group-item text-center">No unread items</li>';
                            }
                        }, 300);
                    }
                })
                .catch(error => {
                    console.error('Error marking item as read:', error);
                });
        }
    });
}

/**
 * Dropdown selection handlers
 */
function setupDropdownHandlers() {
    // Seriousness dropdown handlers
    document.querySelectorAll('.seriousness-select').forEach(function(select) {
        select.addEventListener('change', function() {
            var subscriptionId = this.getAttribute('data-subscription-id');
            var seriousness = this.value;

            fetch(contextPath + '/subscription/updateSeriousness', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: new URLSearchParams({
                    'id': subscriptionId,
                    'seriousness': seriousness
                })
            })
                .then(response => response.json())
                .then(data => {
                    if (!data.success) {
                        alert(data.message || 'Failed to update seriousness');
                    }
                })
                .catch(error => {
                    console.error('Error updating seriousness:', error);
                });
        });
    });

    // Visibility dropdown handlers
    document.querySelectorAll('.visibility-select').forEach(function(select) {
        select.addEventListener('change', function() {
            var topicId = this.getAttribute('data-topic-id');
            var visibility = this.value;

            fetch(contextPath + '/topic/updateVisibility', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: new URLSearchParams({
                    'id': topicId,
                    'visibility': visibility
                })
            })
                .then(response => response.json())
                .then(data => {
                    if (!data.success) {
                        alert(data.message || 'Failed to update visibility');
                    }
                })
                .catch(error => {
                    console.error('Error updating visibility:', error);
                });
        });
    });
}

function refreshTopicsDropdown() {
    fetch(contextPath + '/topic/userTopicsJson', {
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
        .then(response => response.json())
        .then(data => {
            var dropdown = document.getElementById('invitationTopic');
            dropdown.innerHTML = '';

            data.forEach(function(topic) {
                var option = document.createElement('option');
                option.value = topic.id;
                option.textContent = topic.name;
                dropdown.appendChild(option);
            });
        })
        .catch(error => {
            console.error('Error refreshing topics dropdown:', error);
        });
}