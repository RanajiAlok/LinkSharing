<g:each in="${topics}" var="topic">

</g:each>

<g:if test="${topics?.size() == 0}">
    <div class="alert alert-info text-center">
        <i class="fas fa-info-circle mr-2"></i>
        You haven't created any topics yet.
    </div>
</g:if>

<g:if test="${total > max}">
    <div class="d-flex justify-content-center mt-3">
        <g:each in="${(0..(Math.ceil(total / max) - 1))}" var="i">
            <button class="btn btn-sm btn-outline-primary mx-1 pagination-btn" data-page="${i}">
                ${i + 1}
            </button>
        </g:each>
    </div>
</g:if>
