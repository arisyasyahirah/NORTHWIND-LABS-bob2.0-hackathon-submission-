<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineOrder — Manage Movies</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/WEB-INF/style/master-style.css">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Crimson+Pro:ital@1&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body>
<%@ include file="hq-header.jsp" %>

<div class="page-offset">
    <div class="page-title-bar">
        <div class="container flex-between">
            <div>
                <span class="eyebrow">Staff Panel</span>
                <h1 class="text-display" style="font-size:30px;">MANAGE MOVIES</h1>
            </div>
            <!-- HQ only: add movie -->
            <c:if test="${sessionUser.restrictionLevel >= 3}">
                <button onclick="openModal('addMovieModal')" class="btn btn-primary">+ Add Movie</button>
            </c:if>
        </div>
    </div>

    <div class="container mt-xl">

        <c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div></c:if>
        <c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div></c:if>

        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Genre</th>
                    <th>Rating</th>
                    <th>Duration</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="movie" items="${movies}">
                <tr>
                    <td class="text-muted">${movie.movieId}</td>
                    <td><strong>${movie.movieTitle}</strong></td>
                    <td>${movie.genre}</td>
                    <td><span class="card-rating-badge" style="position:static;display:inline;">${movie.rating}</span></td>
                    <td class="text-muted">${movie.movieDuration}</td>
                    <td>
                        <div style="display:flex;gap:8px;">
                            <button onclick="openEdit('${movie.movieId}')" class="btn btn-ghost btn-sm">Edit</button>
                            <!-- HQ can delete -->
                            <c:if test="${sessionUser.restrictionLevel >= 3}">
                                <form method="post" action="${pageContext.request.contextPath}/movies?action=delete" style="display:inline;" onsubmit="return confirm('Delete this movie?')">
                                    <input type="hidden" name="movieId" value="${movie.movieId}">
                                    <button type="submit" class="btn btn-sm" style="background:var(--red-dim);color:var(--red);border:1px solid rgba(192,57,43,0.3);">Delete</button>
                                </form>
                            </c:if>
                        </div>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Edit Movie Modal -->
<div class="modal-overlay" id="editMovieModal" style="display:none;" onclick="if(event.target===this)closeModal('editMovieModal')">
    <div class="modal-card">
        <div class="modal-header flex-between">
            <span class="label">Edit Movie</span>
            <button onclick="closeModal('editMovieModal')" class="btn-ghost" style="background:none;border:none;color:var(--muted);font-size:20px;cursor:pointer;">×</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/movies?action=update" enctype="multipart/form-data">
            <input type="hidden" name="movieId" id="editMovieId">
            <div class="form-group">
                <label class="form-label">Movie Title <span class="text-muted">(HQ only)</span></label>
                <input type="text" class="form-input" name="movieTitle" id="editTitle" ${sessionUser.restrictionLevel < 3 ? 'readonly' : ''}>
            </div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                <div class="form-group">
                    <label class="form-label">Genre</label>
                    <input type="text" class="form-input" name="genre" id="editGenre">
                </div>
                <div class="form-group">
                    <label class="form-label">Rating</label>
                    <select class="form-input" name="rating" id="editRating">
                        <option>U</option><option>PG</option><option>P13</option><option>18</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Duration (HH:MM:SS)</label>
                <input type="text" class="form-input" name="movieDuration" id="editDuration" placeholder="01:45:00">
            </div>
            <div class="form-group">
                <label class="form-label">Synopsis</label>
                <textarea class="form-input" name="movieDesc" id="editDesc" rows="3" style="resize:vertical;"></textarea>
            </div>
            <div class="form-group">
                <label class="form-label">YouTube Trailer ID</label>
                <input type="text" class="form-input" name="movieTrailer" id="editTrailer" placeholder="e.g. dQw4w9WgXcQ">
            </div>
            <div class="form-group">
                <label class="form-label">Poster Image</label>
                <input type="file" class="form-input" name="moviePoster" accept="image/*">
            </div>
            <div class="form-group">
                <label class="form-label">Banner Image</label>
                <input type="file" class="form-input" name="movieBanner" accept="image/*">
            </div>
            <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:20px;">
                <button type="button" onclick="closeModal('editMovieModal')" class="btn btn-ghost">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<!-- Add Movie Modal (HQ only) -->
<c:if test="${sessionUser.restrictionLevel >= 3}">
<div class="modal-overlay" id="addMovieModal" style="display:none;" onclick="if(event.target===this)closeModal('addMovieModal')">
    <div class="modal-card">
        <div class="modal-header flex-between">
            <span class="label">Add New Movie</span>
            <button onclick="closeModal('addMovieModal')" style="background:none;border:none;color:var(--muted);font-size:20px;cursor:pointer;">×</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/movies?action=add" enctype="multipart/form-data">
            <div class="form-group"><label class="form-label">Movie Title</label><input type="text" class="form-input" name="movieTitle" required></div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                <div class="form-group"><label class="form-label">Genre</label><input type="text" class="form-input" name="genre" required></div>
                <div class="form-group"><label class="form-label">Rating</label><select class="form-input" name="rating"><option>U</option><option>PG</option><option>P13</option><option>18</option></select></div>
            </div>
            <div class="form-group"><label class="form-label">Duration (HH:MM:SS)</label><input type="text" class="form-input" name="movieDuration" placeholder="01:45:00" required></div>
            <div class="form-group"><label class="form-label">Synopsis</label><textarea class="form-input" name="movieDesc" rows="3" style="resize:vertical;" required></textarea></div>
            <div class="form-group"><label class="form-label">YouTube Trailer ID</label><input type="text" class="form-input" name="movieTrailer"></div>
            <div class="form-group"><label class="form-label">Poster</label><input type="file" class="form-input" name="moviePoster" accept="image/*" required></div>
            <div class="form-group"><label class="form-label">Banner</label><input type="file" class="form-input" name="movieBanner" accept="image/*" required></div>
            <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:20px;">
                <button type="button" onclick="closeModal('addMovieModal')" class="btn btn-ghost">Cancel</button>
                <button type="submit" class="btn btn-primary">Add Movie</button>
            </div>
        </form>
    </div>
</div>
</c:if>

<%@ include file="hq-footer.jsp" %>

<script>
    function openModal(id) { document.getElementById(id).style.display = 'flex'; }
    function closeModal(id) { document.getElementById(id).style.display = 'none'; }

    // Populate edit modal
    const moviesData = {};
    <c:forEach var="m" items="${movies}">
    moviesData['${m.movieId}'] = {
        title:    '${m.movieTitle.replace("'", "\\'")}',
        genre:    '${m.genre}',
        rating:   '${m.rating}',
        duration: '${m.movieDuration}',
        desc:     '${m.movieDesc.replace("'", "\\'")}',
        trailer:  '${m.movieTrailer}'
    };
    </c:forEach>

    function openEdit(id) {
        const m = moviesData[id];
        if (!m) return;
        document.getElementById('editMovieId').value  = id;
        document.getElementById('editTitle').value    = m.title;
        document.getElementById('editGenre').value    = m.genre;
        document.getElementById('editRating').value   = m.rating;
        document.getElementById('editDuration').value = m.duration;
        document.getElementById('editDesc').value     = m.desc;
        document.getElementById('editTrailer').value  = m.trailer;
        openModal('editMovieModal');
    }
</script>
</body>
</html>