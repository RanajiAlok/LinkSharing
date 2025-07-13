document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById("search-bar");
    const suggestionsBox = document.getElementById("suggestions-box");

    searchInput.addEventListener("keyup", function () {
        const query = this.value.trim();
        if (query.length === 0) {
            suggestionsBox.innerHTML = '';
            return;
        }

        fetch(`/dashboard/searchSuggestions?query=${encodeURIComponent(query)}`)
            .then(response => response.json())
            .then(data => {
                suggestionsBox.innerHTML = data.map(topic => `
                    <div class="suggestion-item" onclick="location.href='/topic/show/${topic.id}'">
                        ${topic.name}
                    </div>`).join('');
            })
            .catch(err => {
                console.error("Error fetching suggestions:", err);
                suggestionsBox.innerHTML = '';
            });
    });
});
