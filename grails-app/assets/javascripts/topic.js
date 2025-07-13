// File: assets/javascripts/topic.js

$(document).ready(function() {
    initPage();
    setupEventListeners();
});

function initPage() {
    initializeTooltips();
    setupModalPreselection();
}

function setupEventListeners() {
    // Handle pagination clicks for users list
    $('#usersList').on('click', '.pagination a', function(e) {
        e.preventDefault();
        const page = $(this).attr('href').match(/offset=(\d+)/);
        const offset = page ? page[1] : 0;
        loadMoreUsers(offset);
    });

    // Handle pagination clicks for posts list
    $('#postsList').on('click', '.ajax-pagination a', function(e) {
        e.preventDefault();
        const href = $(this).attr('href');
        loadPostsFromUrl(href);
    });

    // Handle mark as read/unread clicks
    $('#postsList').on('click', '.mark-read-btn', function(e) {
        e.preventDefault();
        const resourceId = $(this).data('resource-id');
        toggleReadStatus(resourceId);
    });

    // Handle search button click
    $('#searchPostsBtn').on('click', function() {
        searchPosts();
    });

    // Handle Enter key in search input
    $('#postSearchInput').on('keypress', function(e) {
        if (e.which === 13) {
            e.preventDefault();
            searchPosts();
        }
    });
}

function initializeTooltips() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

function setupModalPreselection() {
    const topicId = $('#currentTopicId').val();

    if (topicId) {
        $('#sendInvitationModal').on('show.bs.modal', function (e) {
            $(this).find('#topicId').val(topicId);
        });

        // Pre-select topic in share link modal
        $('#shareLinkModal').on('show.bs.modal', function (e) {
            $(this).find('#linkTopicId').val(topicId);
        });

        // Pre-select topic in share document modal
        $('#shareDocumentModal').on('show.bs.modal', function (e) {
            $(this).find('#documentTopicId').val(topicId);
        });
    }
}

function loadMoreUsers(offset) {
    const topicId = $('#currentTopicId').val();
    $.ajax({
        url: contextPath + '/topic/getUsers',
        data: {
            id: topicId,
            offset: offset,
            max: 10
        },
        success: function(response) {
            $('#usersList .card-body').html(response);
        },
        error: function() {
            showErrorMessage('Failed to load users. Please try again.');
        }
    });
}

function loadPostsFromUrl(url) {
    $.ajax({
        url: url,
        success: function(response) {
            $('#postsList').html(response);
        },
        error: function() {
            showErrorMessage('Failed to load posts. Please try again.');
        }
    });
}

function searchPosts() {
    const topicId = $('#currentTopicId').val();
    const searchQuery = $('#postSearchInput').val();

    $.ajax({
        url: contextPath + '/topic/getPosts',
        data: {
            id: topicId,
            q: searchQuery,
            max: 10,
            offset: 0
        },
        success: function(response) {
            $('#postsList').html(response);
        },
        error: function() {
            showErrorMessage('Failed to search posts. Please try again.');
        }
    });
}

function toggleReadStatus(resourceId) {
    $.ajax({
        url: contextPath + '/resource/toggleReadStatus',
        data: {
            id: resourceId
        },
        success: function(response) {
            const linkElement = $(`[data-resource-id="${resourceId}"]`);
            if (response.isRead) {
                linkElement.text('Mark as unread');
            } else {
                linkElement.text('Mark as read');
            }
        },
        error: function() {
            showErrorMessage('Failed to update read status. Please try again.');
        }
    });
}

function showErrorMessage(message) {
    const alertHtml = `
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    `;

    $('.container').prepend(alertHtml);

    // Auto-dismiss after 5 seconds
    setTimeout(() => {
        $('.alert-danger').alert('close');
    }, 5000);
}

function showSuccessMessage(message) {
    const alertHtml = `
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    `;

    $('.container').prepend(alertHtml);

    setTimeout(() => {
        $('.alert-success').alert('close');
    }, 3000);
}