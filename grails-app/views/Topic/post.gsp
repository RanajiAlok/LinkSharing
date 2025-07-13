<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <meta name="_csrf" content="${csrfToken}" />
    <title>View Post - Link Sharing</title>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'post.css')}"/>
    <link rel="stylesheet" href="${resource(dir: 'assets/stylesheets', file: 'dashboard.css')}"/>

    <script>
        var contextPath = "${request.contextPath}";
        var isUserLoggedIn = ${session.user ? 'true' : 'false'};
    </script>
    <script src="${resource(dir: '/assets/javascripts', file: 'postScript.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'assets/javascripts', file: 'dashboard.js')}"></script>

</head>
<body>

<g:render template="/templates/navbar"/>
<g:render template="/templates/flashmessage" model="[message: flash.message, error: flash.error]" ></g:render>

<div class="container">

    <div class="row mt-4">
        <div class="col-md-8">
            <div class="card shadow rounded-lg border-0 p-3 mb-4" style="background-color: #ffffff;">
                <div class="d-flex align-items-center mb-3">
                    <div class="me-3">
                        <g:if test="${resource?.createdBy?.photo}">
                            <img src="${createLink(controller: 'user', action: 'renderImage', id: resource.createdBy.id)}" class="rounded-circle" alt="User Image" style="width: 45px; height: 45px;">
                        </g:if>
                        <g:else>
                            <img src="${resource(dir: 'assets/images', file: 'Default-image.png')}" alt="Profile" class="rounded-circle" style="width: 45px; height: 45px;">
                        </g:else>
                    </div>
                    <div class="flex-grow-1">
                        <h6 class="mb-0 fw-bold">${resource?.createdBy?.firstName} ${resource?.createdBy?.lastName}</h6>
                        <small>@${resource?.createdBy?.username} · ${resource?.dateCreated.format('hh:mm a dd MMM yyyy')}</small>
                    </div>
                    <div>
                        <span class="badge bg-primary">${resource.topic.topicName}</span>
                    </div>
                </div>

                <div class="mb-3">
                    <p class="mb-0">${resource?.description}</p>
                </div>

                <div class="d-flex align-items-center mb-3">

                    <div class="rating-wrapper">
                        <div class="row">
                            <g:if test="${isSubscribed}">
                                <div class="col-7">
                                    <g:form controller="resourceRating" action="rate" data-resource-id="${resource.id}">
                                        <input type="hidden" name="score" id="ratingValue" value="${userRating?.score ?: 0}">
                                        <span class="fa fa-star ${userRating?.score >= 1 ? 'checked' : ''}"
                                              onclick="setRating(1, this)"
                                              onmouseover="highlightStars(1)"
                                              onmouseout="resetStars()"></span>
                                        <span class="fa fa-star ${userRating?.score >= 2 ? 'checked' : ''}"
                                              onclick="setRating(2, this)"
                                              onmouseover="highlightStars(2)"
                                              onmouseout="resetStars()"></span>
                                        <span class="fa fa-star ${userRating?.score >= 3 ? 'checked' : ''}"
                                              onclick="setRating(3, this)"
                                              onmouseover="highlightStars(3)"
                                              onmouseout="resetStars()"></span>
                                        <span class="fa fa-star ${userRating?.score >= 4 ? 'checked' : ''}"
                                              onclick="setRating(4, this)"
                                              onmouseover="highlightStars(4)"
                                              onmouseout="resetStars()"></span>
                                        <span class="fa fa-star ${userRating?.score >= 5 ? 'checked' : ''}"
                                              onclick="setRating(5, this)"
                                              onmouseover="highlightStars(5)"
                                              onmouseout="resetStars()"></span>
                                    </g:form>
                                </div>
                            </g:if>
                            <div class="col-5">
                                <h6>Average Rating: <span class="average-rating">${ratingValue}</span></h6>
                            </div>
                        </div>

                    </div>



                    <div class="social-icons ms-auto">
                        <a href="#" class="text-secondary me-2"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="text-secondary me-2"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="text-secondary"><i class="fab fa-google-plus"></i></a>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <g:if test="${session.user?.id == resource?.createdBy?.id || session.user?.admin}">
                            <a href="#" onclick="editPost('${resource?.id}')" class="text-decoration-none me-3">✏️ Edit</a>
                            <a href="#" onclick="confirmDelete('${resource?.id}')" class="text-danger text-decoration-none me-3">🗑️ Delete</a>
                        </g:if>

                        <g:if test="${resource?.class.simpleName == 'LinkResource'}">
                            <a href="${resource?.url}" target="_blank" class="text-decoration-none">🌐 View Full Site</a>
                        </g:if>
                        <g:else>
                            <a href="${createLink(controller: 'documentResource', action: 'download', id: resource?.id)}" class="text-decoration-none me-3">⬇️ Download</a>
                        </g:else>
                    </div>
                </div>
            </div>

        </div>

        <div class="col-md-4">
            <g:render template="/templates/trendingPosts"/>
        </div>
    </div>
</div>

<div class="modal fade" id="editPostModal" tabindex="-1" role="dialog" aria-labelledby="editPostModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content" style="border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.15);">
            <div class="modal-header d-flex justify-content-between align-items-center">
                <h5 class="modal-title" id="editPostModalLabel">Edit Post</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <g:form controller="resource" action="update" method="POST">
                <div class="modal-body" style="padding: 1.5rem;">
                    <g:hiddenField name="id" value="${resource?.id}"/>
                    <div class="form-group mb-4">
                        <label for="description" style="font-weight: 500; color: #495057; margin-bottom: 0.5rem;">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="4"
                                  style="border-radius: 8px; border: 1px solid #e0e0e0; padding: 0.75rem;
                                  transition: border-color 0.3s ease; font-size: 14px;
                                  &:focus { border-color: #80bdff; box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25); }">
                        ${resource?.description}
                        </textarea>
                    </div>
                </div>
                <div class="modal-footer" style="border-top: 1px solid #e9ecef; padding: 1rem 1.5rem;">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary"
                            style="padding: 0.5rem 1.25rem; border-radius: 6px; font-weight: 500;
                            background-color: #007bff; border-color: #007bff; transition: all 0.3s ease;">Save Changes</button>
                </div>
            </g:form>
        </div>
    </div>
</div>

<g:render template="/templates/modals"/>

<div class="modal fade" id="publicTopicsModal" tabindex="-1" aria-labelledby="publicTopicsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" id="publicTopicsModalContent">
            <!-- AJAX content will be loaded here -->
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    fetch('/dashboard/showTrendingTopic')
        .then(res => res.text())
        .then(html => {
            document.getElementById('trendingTopicContainer').innerHTML = html;
        });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        if (typeof $().tooltip === 'function') {
            $('[data-toggle="tooltip"]').tooltip();
            $('[data-toggle="popover"]').popover();
        }


    });

    function highlightStars(score) {
        const stars = document.querySelectorAll('.fa-star');
        stars.forEach((star, index) => {
            star.classList.toggle('hovered', index < score);
        });
    }

    function resetStars() {
        document.querySelectorAll('.fa-star').forEach(star => {
            star.classList.remove('hovered');
        });
    }

    function setRating(score, element) {
        const $form = $(element).closest('form');
        const resourceId = $form.data('resource-id');
        $.ajax({
            url: $form.attr('action'),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({ resourceId: resourceId, score: score }),
            success: function(response) {
                if (response.success) {
                    $form.find('.fa-star').each(function(index) {
                        $(this).toggleClass('checked', index < response.userRating);
                    });
                    $form.find('#ratingValue').val(response.userRating);
                    $('.average-rating').text(response.newAverage);
                } else {
                    alert(response.error);
                }
            },
            error: function() {
                alert("Failed to submit rating. Try again later.");
            }
        });
    }


    function editPost(resourceId) {
        if (!isUserLoggedIn) {
            window.location.href = contextPath + '/home/login';
        }

        $('#editPostModal').modal('show');
        console.log("edit modal opened");
    }

    function confirmDelete(resourceId) {
        console.log("Resource ID for delete:", resourceId)
        if (!isUserLoggedIn) {
            window.location.href = contextPath + '/home/login';
        }

        if (confirm('Are you sure you want to delete this resource? This action cannot be undone.')) {
            console.log("ADADADADs")
            window.location.href = contextPath + '/resource/delete/' + resourceId;
        }
    }


    function showToast(title, message) {
        if (typeof bootstrap !== 'undefined' && bootstrap.Toast) {
            const toastEl = document.getElementById('notification-toast');
            if (toastEl) {
                const toastTitle = toastEl.querySelector('.toast-header strong');
                const toastBody = toastEl.querySelector('.toast-body');

                if (toastTitle) toastTitle.textContent = title;
                if (toastBody) toastBody.textContent = message;

                const toast = new bootstrap.Toast(toastEl);
                toast.show();
            } else {
                alert(`${title}: ${message}`);
            }
        } else {
            alert(`${title}: ${message}`);
        }
    }



</script>
<script>
    $(document).ready(function () {
        let userSubscribedTopics = ${raw(userTopicJson)};

        $('#sendInvitationModal').on('shown.bs.modal', function () {
            const $select = $(this).find('select[name="topicId"]');
            $select.empty();

            if (userSubscribedTopics && userSubscribedTopics.length > 0) {
                $select.append($('<option>', {
                    disabled: true,
                    selected: true,
                    text: 'Select a topic'
                }));

                $.each(userSubscribedTopics, function (i, topic) {
                    $select.append($('<option>', {
                        value: topic.id,
                        text: topic.name
                    }));
                });
            } else {
                $select.append($('<option>', {
                    disabled: true,
                    selected: true,
                    text: 'No subscribed topics found'
                }));
            }
        });

        $('#shareLinkModal, #shareDocumentModal').on('shown.bs.modal', function () {
            const $select = $(this).find('select[name="topicId"]');
            $select.empty();

            if (userSubscribedTopics && userSubscribedTopics.length > 0) {
                $select.append($('<option>', {
                    disabled: true,
                    selected: true,
                    text: 'Select a topic'
                }));

                $.each(userSubscribedTopics, function (i, topic) {
                    $select.append($('<option>', {
                        value: topic.id,
                        text: topic.name
                    }));
                });
            } else {
                $select.append($('<option>', {
                    disabled: true,
                    selected: true,
                    text: 'No subscribed topics found'
                }));
            }
        });
    });

</script>
</body>
</html>


