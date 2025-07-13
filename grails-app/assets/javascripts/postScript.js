/**
 * Post View Page JavaScript Functions
 * Handles post and topic interactions including edit, delete, rating, and property updates
 */

function editPost(id) {
    $('#editPostModal').modal('show');
}

function confirmDelete(id) {
    if (confirm('Are you sure you want to delete this post?')) {
        window.location.href = contextPath + "/resource/delete/" + id;
    }
}

function editTopic(id) {
    // Implement topic edit functionality
    $('#editTopicModal').modal('show');
}

function confirmDeleteTopic(id) {
    if (confirm('Are you sure you want to delete this topic?')) {
        window.location.href = contextPath + "/topic/delete/" + id;
    }
}

function ratePost(resourceId, rating) {
    // Check if user is logged in
    if (!isUserLoggedIn) {
        alert('Please login to rate posts');
        return;
    }

    $.ajax({
        url: contextPath + "/resourceRating/save",
        method: "POST",
        data: { resourceId: resourceId, score: rating },
        success: function(data) {
            // Update UI to show filled hearts
            $('.heart').removeClass('filled');
            $('.heart').each(function() {
                if ($(this).data('rating') <= rating) {
                    $(this).addClass('filled');
                }
            });
        },
        error: function() {
            alert('Error rating post. Please try again.');
        }
    });
}

function changeSeriousness(topicId, value) {
    $.ajax({
        url: contextPath + "/topic/updateSeriousness",
        method: "POST",
        data: { id: topicId, seriousness: value },
        success: function(data) {
            // Success notification can be added here
            showNotification('Topic seriousness updated successfully');
        }
    });
}

function changeVisibility(topicId, value) {
    $.ajax({
        url: contextPath + "/topic/updateVisibility",
        method: "POST",
        data: { id: topicId, visibility: value },
        success: function(data) {
            // Success notification can be added here
            showNotification('Topic visibility updated successfully');
        }
    });
}

// Helper function to show notifications
function showNotification(message) {
    if ($('#notification-area').length === 0) {
        $('body').append('<div id="notification-area" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>');
    }

    const notificationId = 'notification-' + new Date().getTime();
    const notification = $(`
        <div id="${notificationId}" class="alert alert-success" style="margin-bottom: 10px; opacity: 0; transition: opacity 0.3s ease-in-out;">
            ${message}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    `);

    $('#notification-area').append(notification);
    setTimeout(() => { $(`#${notificationId}`).css('opacity', '1'); }, 100);

    // Auto-hide notification after 3 seconds
    setTimeout(() => {
        $(`#${notificationId}`).css('opacity', '0');
        setTimeout(() => { $(`#${notificationId}`).remove(); }, 300);
    }, 3000);
}