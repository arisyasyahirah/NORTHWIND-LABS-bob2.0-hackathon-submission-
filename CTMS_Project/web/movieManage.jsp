<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ctms.dto.*, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CineOrder — Manage Movies</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/WEB-INF/style/master-style.css">
        <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Crimson+Pro:ital@1&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <%
            ArrayList<MovieDTO> movies = (ArrayList<MovieDTO>) request.getAttribute("movies");

            if (movies == null) {
                response.sendRedirect(request.getContextPath() + "/ManageMovie");
                return;
            }

            for (MovieDTO movie : movies) {
                String formattedPoster = movie.getFomrattedPoster();
                String defaultPoster = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='14' font-weight='bold'%3" + movie.getTitle() + "%3C/text%3E%3Ctext x='150' y='240' text-anchor='middle' fill='%236b6358' font-size='10'%3EPART TWO%3C/text%3E%3C/svg%3E";
                movie.setFormattedPoster(formattedPoster != null ? formattedPoster : defaultPoster);
                movie.setFormattedDuration(movie.formatDuration());
            }

        %>
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
                    <c:if test="${sessionUser.restrictionLevel >= 3}">

                    </c:if>

                    <button onclick="openModal('addMovieModal')" class="btn btn-primary">+ Add Movie</button>
                </div>
            </div>

            <div class="container mt-xl">

                <c:if test="${param.status == 'success' && param.action == 'update'}"> <div class="alert alert-success">Successfully updated movie</div> </c:if>
                <c:if test="${param.status == 'failed' && param.action == 'update'}"> <div class="alert alert-danger">Failed to update movie</div> </c:if>
                
                <c:if test="${param.status == 'success' && param.action == 'delete'}"> <div class="alert alert-success">Successfully remove movie</div> </c:if>
                <c:if test="${param.status == 'failed' && param.action == 'delete'}"> <div class="alert alert-danger">Failed to remove movie</div> </c:if>

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
                                <td class="text-muted">${movie.id}</td>
                                <td><strong>${movie.title}</strong></td>
                                <td>${movie.genere}</td>
                                <td><span class="card-rating-badge" style="position:static;display:inline;">${movie.rating}</span></td>
                                <td class="text-muted">${movie.formattedDuration}</td>
                                <td>
                                    <div style="display:flex;gap:8px;">
                                        <button onclick="openEdit('${movie.id}')" class="btn btn-ghost btn-sm">Edit</button>
                                        <c:if test="${3 >= 3}"> <!-- test="${sessionUser.restrictionLevel >= 3}">-->
                                            <form method="post" action="${pageContext.request.contextPath}/DeleteMovieServlet" style="display:inline;" onsubmit="return confirm('Delete this movie?')">
                                                <input type="hidden" name="movieId" value="${movie.id}">
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
        <div class="modal-overlay" id="editMovieModal" style="display:none;" onclick="if (event.target === this)
                    closeModal('editMovieModal')">
            <div class="modal-card">
                <div class="modal-header flex-between">
                    <span class="label">Edit Movie</span>
                    <button onclick="closeModal('editMovieModal')" class="btn-ghost" style="background:none;border:none;color:var(--muted);font-size:20px;cursor:pointer;">×</button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/UpdateMovieServlet" enctype="multipart/form-data">
                    <input type="hidden" name="movieId" id="editMovieId">
                    <div class="form-group">
                        <label class="form-label">Movie Title <span class="text-muted">(HQ only)</span></label>
                        <input type="text" class="form-input" name="movieTitle" id="editTitle" ${4 < 3 ? 'readonly' : ''} required>
                    </div>
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                        <div class="form-group">
                            <label class="form-label">Genre</label>
                            <input type="text" class="form-input" name="genre" id="editGenre" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Rating</label>
                            <select class="form-input" name="rating" id="editRating" required>
                                <option value="U">U</option><option value="PG">PG</option><option value="P13">P13</option><option value="18">18</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Duration</label>
                        <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:8px;">
                            <div>
                                <label class="form-label">Hours</label>
                                <input type="number" class="form-input" id="editHours" min="0" max="23" placeholder="01" required>
                            </div>
                            <div>
                                <label class="form-label">Minutes</label>
                                <input type="number" class="form-input" id="editMinutes" min="0" max="59" placeholder="45" required>
                            </div>
                        </div>
                        <input type="hidden" name="duration" id="editDuration">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Synopsis</label>
                        <textarea class="form-input" name="description" id="editDesc" rows="3" style="resize:vertical;"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">YouTube Trailer ID</label>
                        <input type="text" class="form-input" name="trailer" id="editTrailer" placeholder="e.g. dQw4w9WgXcQ">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Poster Image</label>
                        <input type="file" class="form-input" name="poster" accept="image/*">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Banner Image</label>
                        <input type="file" class="form-input" name="banner" accept="image/*">
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
            <div class="modal-overlay" id="addMovieModal" style="display:none;" onclick="if (event.target === this)
                        closeModal('addMovieModal')">
                <div class="modal-card">
                    <div class="modal-header flex-between">
                        <span class="label">Add New Movie</span>
                        <button onclick="closeModal('addMovieModal')" style="background:none;border:none;color:var(--muted);font-size:20px;cursor:pointer;">×</button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/AddNewMovieServlet" enctype="multipart/form-data">
                        <div class="form-group"><label class="form-label">Movie Title</label><input type="text" class="form-input" name="title" required></div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                            <div class="form-group"><label class="form-label">Genre</label><input type="text" class="form-input" name="genre" required></div>
                            <div class="form-group"><label class="form-label">Rating</label><select class="form-input" name="rating"><option>U</option><option>PG</option><option>P13</option><option>18</option></select></div>
                        </div>
                        <div class="form-group"><label class="form-label">Duration (HH:MM:SS)</label><input type="time" class="form-input" name="duration" placeholder="01:45:00" required></div>
                        <div class="form-group"><label class="form-label">Synopsis</label><textarea class="form-input" name="movieDesc" rows="3" style="resize:vertical;" required></textarea></div>
                        <div class="form-group"><label class="form-label">YouTube Trailer ID</label><input type="text" class="form-input" name="movieTrailer"></div>
                        <div class="form-group"><label class="form-label">Poster</label><input type="file" class="form-input" name="poster" accept="image/*" required></div>
                        <div class="form-group"><label class="form-label">Banner</label><input type="file" class="form-input" name="banner" accept="image/*" required></div>
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
            function openModal(id) {
                document.getElementById(id).style.display = 'flex';
            }
            function closeModal(id) {
                document.getElementById(id).style.display = 'none';
            }

            const moviesData = {};
            <c:forEach var="m" items="${movies}">
            moviesData['${m.id}'] = {
                title: '${m.title.replace("'", "\\'")}',
                genre: '${m.genere}',
                rating: '${m.rating}',
                duration: '${m.formattedDuration}',
                desc: '${m.description.replace("'", "\\'")}',
                trailer: '${m.trailerURL}'
            };
            </c:forEach>

            function openEdit(id) {
                const m = moviesData[id];
                if (!m)
                    return;
                document.getElementById('editMovieId').value = id;
                document.getElementById('editTitle').value = m.title;
                document.getElementById('editGenre').value = m.genre;
                document.getElementById('editRating').value = m.rating.trim();
                document.getElementById('editDesc').value = m.desc;
                document.getElementById('editTrailer').value = m.trailer;

                // Parse duration back into hours and minutes (e.g. "1h 45m" or "01:45:00")
                const parts = m.duration.split(' ');
                document.getElementById('editHours').value = parts[0] ? parseInt(parts[0]) : 0;
                document.getElementById('editMinutes').value = parts[1] ? parseInt(parts[1]) : 0;

                openModal('editMovieModal');
            }

            // Register submit listener ONCE, outside openEdit
            document.getElementById('editMovieModal').querySelector('form').addEventListener('submit', function () {
                const h = (document.getElementById('editHours').value || '0').padStart(2, '0');
                const m = (document.getElementById('editMinutes').value || '0').padStart(2, '0');
                console.log('Hours:', h, 'Minutes:', m); // add this
                document.getElementById('editDuration').value = h + ':' + m + ':00';
                console.log('Duration sent:', document.getElementById('editDuration').value); // and this
            });
        </script>
    </body>
</html>