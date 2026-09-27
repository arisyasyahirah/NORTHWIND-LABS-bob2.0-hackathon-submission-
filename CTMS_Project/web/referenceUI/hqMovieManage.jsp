<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="hq-header.jsp" %>

<main class="page-offset">
    <div class="container">
        
        <div class="page-header">
            <h1>MOVIE <span>MANAGEMENT</span></h1>
            <span class="role-badge hq">HQ - FULL CONTROL</span>
        </div>

        <div style="margin-bottom: 24px; text-align: right;">
            <button class="hq-btn-add" id="addMovieBtn">+ Add New Movie</button>
        </div>

        <!-- Add/Edit Movie Form (Hidden by default) -->
        <div id="movieForm" class="movie-form-card" style="display: none;">
            <div class="movie-form-header">
                <h3 id="formTitle">Add New Movie</h3>
                <button class="modal-close" onclick="hideMovieForm()" style="background:none; border:none; font-size:20px; cursor:pointer;">&times;</button>
            </div>
            <div class="movie-form-body">
                <input type="hidden" id="editMovieId">
                <div class="movie-form-grid">
                    <div class="form-group">
                        <label class="form-label">Movie ID</label>
                        <input type="text" id="movieId" class="form-input" placeholder="e.g. M001">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Movie Title</label>
                        <input type="text" id="movieTitle" class="form-input" placeholder="Movie title">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Duration (minutes)</label>
                        <input type="number" id="movieDuration" class="form-input" placeholder="e.g. 166">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Rating</label>
                        <select id="movieRating" class="form-input">
                            <option value="G">G - General Audience</option>
                            <option value="PG">PG - Parental Guidance</option>
                            <option value="PG-13">PG-13 - 13+</option>
                            <option value="R">R - Restricted (18+)</option>
                            <option value="R-18">R-18 - 18+ Only</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Genre</label>
                        <select id="movieGenre" class="form-input">
                            <option>Action</option>
                            <option>Adventure</option>
                            <option>Comedy</option>
                            <option>Drama</option>
                            <option>Horror</option>
                            <option>Sci-Fi</option>
                            <option>Thriller</option>
                            <option>Animation</option>
                            <option>Romance</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Trailer URL (YouTube ID)</label>
                        <input type="text" id="movieTrailer" class="form-input" placeholder="e.g. dQw4w9WgXcQ">
                    </div>
                    <div class="movie-form-field-full">
                        <label class="form-label">Synopsis</label>
                        <textarea id="movieDesc" class="form-input" rows="4" placeholder="Movie description..."></textarea>
                    </div>
                </div>
                <div class="movie-form-actions">
                    <button class="btn-ghost" onclick="hideMovieForm()">Cancel</button>
                    <button class="btn-primary" onclick="saveMovie()">Save Movie</button>
                </div>
            </div>
        </div>

        <!-- Movies Grid -->
        <div class="movie-grid-admin" id="moviesGrid">
            <div class="movie-admin-card" data-id="M001">
                <div class="movie-admin-poster" style="height: 200px; display: flex; align-items: center; justify-content: center; background: #1a1a2e;">
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <rect x="2" y="3" width="20" height="14" rx="2"/>
                    </svg>
                </div>
                <div class="movie-admin-info">
                    <div class="movie-admin-title">DUNE: PART TWO</div>
                    <div class="movie-admin-meta">2h 46m | PG-13 | Sci-Fi</div>
                    <div class="movie-admin-actions">
                        <button class="edit-btn" onclick="editMovie('M001')">Edit</button>
                        <button class="delete-btn" onclick="deleteMovie('M001')">Delete</button>
                    </div>
                </div>
            </div>

            <div class="movie-admin-card" data-id="M002">
                <div class="movie-admin-poster" style="height: 200px; display: flex; align-items: center; justify-content: center; background: #1a1a2e;">
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <rect x="2" y="3" width="20" height="14" rx="2"/>
                    </svg>
                </div>
                <div class="movie-admin-info">
                    <div class="movie-admin-title">OPPENHEIMER</div>
                    <div class="movie-admin-meta">3h 0m | R | Drama</div>
                    <div class="movie-admin-actions">
                        <button class="edit-btn" onclick="editMovie('M002')">Edit</button>
                        <button class="delete-btn" onclick="deleteMovie('M002')">Delete</button>
                    </div>
                </div>
            </div>

            <div class="movie-admin-card" data-id="M003">
                <div class="movie-admin-poster" style="height: 200px; display: flex; align-items: center; justify-content: center; background: #1a1a2e;">
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <rect x="2" y="3" width="20" height="14" rx="2"/>
                    </svg>
                </div>
                <div class="movie-admin-info">
                    <div class="movie-admin-title">GLADIATOR II</div>
                    <div class="movie-admin-meta">2h 28m | R | Action</div>
                    <div class="movie-admin-actions">
                        <button class="edit-btn" onclick="editMovie('M003')">Edit</button>
                        <button class="delete-btn" onclick="deleteMovie('M003')">Delete</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function showAddMovieForm() {
    document.getElementById('formTitle').innerText = 'Add New Movie';
    document.getElementById('editMovieId').value = '';
    document.getElementById('movieId').value = '';
    document.getElementById('movieTitle').value = '';
    document.getElementById('movieDuration').value = '';
    document.getElementById('movieRating').value = 'PG-13';
    document.getElementById('movieGenre').value = 'Action';
    document.getElementById('movieTrailer').value = '';
    document.getElementById('movieDesc').value = '';
    document.getElementById('movieForm').style.display = 'block';
    document.getElementById('movieForm').scrollIntoView({ behavior: 'smooth' });
}

function hideMovieForm() {
    document.getElementById('movieForm').style.display = 'none';
}

function editMovie(movieId) {
    // For demo, just pre-fill with sample data
    document.getElementById('formTitle').innerText = 'Edit Movie';
    document.getElementById('editMovieId').value = movieId;
    document.getElementById('movieId').value = movieId;
    document.getElementById('movieTitle').value = 'Sample Movie Title';
    document.getElementById('movieDuration').value = '120';
    document.getElementById('movieRating').value = 'PG-13';
    document.getElementById('movieGenre').value = 'Action';
    document.getElementById('movieTrailer').value = '';
    document.getElementById('movieDesc').value = 'Sample movie description...';
    document.getElementById('movieForm').style.display = 'block';
    document.getElementById('movieForm').scrollIntoView({ behavior: 'smooth' });
}

function saveMovie() {
    var isEdit = document.getElementById('editMovieId').value !== '';
    alert(isEdit ? 'Movie updated successfully!' : 'New movie added successfully!');
    hideMovieForm();
    location.reload();
}

function deleteMovie(movieId) {
    if (confirm('Delete movie ' + movieId + '? This action cannot be undone.')) {
        alert('Movie ' + movieId + ' deleted.');
        location.reload();
    }
}

document.getElementById('addMovieBtn').onclick = showAddMovieForm;
</script>

<%@ include file="hq-footer.jsp" %>