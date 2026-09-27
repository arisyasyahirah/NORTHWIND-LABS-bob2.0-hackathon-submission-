<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList, com.ctms.dto.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CineOrder — Manage Showtimes</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/WEB-INF/style/master-style.css">
        <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Crimson+Pro:ital@1&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <%
            ArrayList<ShowtimeDTO> showtimeList = (ArrayList<ShowtimeDTO>) request.getAttribute("showtimeList");
            ArrayList<MovieDTO> movies = (ArrayList<MovieDTO>) request.getAttribute("movieList");
            ArrayList<ShowtimeHallDTO> availableHalls = (ArrayList<ShowtimeHallDTO>) request.getAttribute("hallList");

            if (showtimeList == null || movies == null || availableHalls == null) {
                response.sendRedirect(request.getContextPath() + "/ShowtimeServlet");
                return;
            }

            for (ShowtimeHallDTO hall : availableHalls) {
                System.out.println("Hall :" + hall.getHallId() + " Type: " + hall.getHallType() + " Cinema: " + hall.getCinemaName());
            }

        %>
        <style>
            /* Searchable dropdown — built entirely from existing CSS vars */
            .movie-search-wrapper {
                position: relative;
            }
            .movie-suggestion-list {
                display: none;
                position: absolute;
                top: calc(100% + 4px);
                left: 0;
                right: 0;
                background: var(--surface);
                border: 1px solid var(--border-hover);
                border-radius: 2px;
                max-height: 180px;
                overflow-y: auto;
                z-index: 3000;
                padding: 4px 0;
            }
            .movie-suggestion-list li {
                padding: 9px 14px;
                font-size: 13px;
                color: var(--text-muted);
                cursor: pointer;
                transition: background 0.15s, color 0.15s;
            }
            .movie-suggestion-list li:hover {
                background: rgba(181,164,138,0.08);
                color: var(--text);
            }
            .movie-suggestion-list li.no-result {
                color: var(--muted);
                cursor: default;
                font-style: italic;
            }
            .movie-suggestion-list li.no-result:hover {
                background: none;
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="page-offset">
            <div class="page-title-bar">
                <div class="container flex-between">
                    <div>
                        <span class="eyebrow">Staff Panel</span>
                        <h1 class="text-display" style="font-size:30px;">MANAGE SHOWTIMES</h1>
                    </div>
                    <button onclick="openModal('addShowtimeModal')" class="btn btn-primary">+ Add Showtime</button>
                </div>
            </div>

            <div class="container mt-xl">

                <c:if test="${param.status=='success'}"><div class="alert alert-success">${not empty param.msg ? param.msg : 'Success'}</div></c:if>
                <c:if test="${param.status=='failed'}"><div class="alert alert-danger">${not empty param.msg ? param.msg : 'An error occurred'}</div></c:if>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Movie</th>
                                <th>Hall ID</th>
                                <th>Hall Type</th>
                                <th>Date</th>
                                <th>Start</th>
                                <th>End</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="st" items="${showtimeList}">
                            <tr>
                                <td class="text-muted">${st.showtimeId}</td>
                                <td><strong>${st.movieTitle}</strong></td>
                                <td>${st.hallId}</td>
                                <td>${st.hallType}</td>
                                <td>${st.showDate}</td>
                                <td><fmt:formatDate value="${st.showStartTime}" pattern="hh:mm a"/></td>
                                <td><fmt:formatDate value="${st.showEndTime}" pattern="hh:mm a"/></td>
                                <td>
                                    <div style="display:flex;gap:8px;">
                                        <button onclick="openSTEdit('${st.showtimeId}')" class="btn btn-ghost btn-sm">Edit</button>
                                        <form method="post" action="${pageContext.request.contextPath}/cinema?action=deleteShowtime"
                                              style="display:inline;" onsubmit="return confirm('Delete showtime?')">
                                            <input type="hidden" name="showtimeId" value="${st.showtimeId}">
                                            <button type="submit" class="btn btn-sm"
                                                    style="background:var(--red-dim);color:var(--red);border:1px solid rgba(192,57,43,0.3);">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ══════════════════════════════════════════════
             ADD SHOWTIME MODAL
             ══════════════════════════════════════════════ -->
        <div class="modal-overlay" id="addShowtimeModal" style="display:none;"
             onclick="if (event.target === this)
                         closeModal('addShowtimeModal')">
            <div class="modal-card">
                <div class="modal-header flex-between">
                    <span class="label">Add Showtime</span>
                    <button onclick="closeModal('addShowtimeModal')"
                            style="background:none;border:none;color:var(--muted);font-size:20px;cursor:pointer;">×</button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/AddShowtimeServlet">

                    <!-- Searchable Movie -->
                    <input type="hidden" name="movieId" id="addMId">
                    <div class="form-group">
                        <label class="form-label">Movie</label>
                        <div class="movie-search-wrapper">
                            <input type="text" class="form-input" id="addMovieSearch"
                                   placeholder="Type to search movie…" autocomplete="off">
                            <ul class="movie-suggestion-list" id="addMovieDropdown"></ul>
                        </div>
                    </div>

                    <!-- Hall -->
                    <input type="hidden" name="hallId" id="addHId">
                    <div class="form-group" style="margin-top:14px;">
                        <label class="form-label">Hall</label>
                        <div class="movie-search-wrapper">
                            <input type="text" class="form-input" id="addHallSearch"
                                   placeholder="Search by hall ID, type or cinema…" autocomplete="off">
                            <ul class="movie-suggestion-list" id="addHallDropdown"></ul>
                        </div>
                    </div>

                    <div class="form-group" style="margin-top:14px;">
                        <label class="form-label">Show Date</label>
                        <input type="date" class="form-input" name="showDate" required>
                    </div>

                    <div class="form-group" style="margin-top:14px;">
                        <label class="form-label">Start Time</label>
                        <input type="time" class="form-input" name="showStartTime" required>
                    </div>

                    <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:20px;">
                        <button type="button" onclick="closeModal('addShowtimeModal')" class="btn btn-ghost">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Showtime</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- ══════════════════════════════════════════════
             EDIT SHOWTIME MODAL
             ══════════════════════════════════════════════ -->
        <div class="modal-overlay" id="editShowtimeModal" style="display:none;"
             onclick="if (event.target === this)
                         closeModal('editShowtimeModal')">
            <div class="modal-card">
                <div class="modal-header flex-between">
                    <span class="label">Edit Showtime</span>
                    <button onclick="closeModal('editShowtimeModal')"
                            style="background:none;border:none;color:var(--muted);font-size:20px;cursor:pointer;">×</button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/UpdateShowtimeServlet">
                    <input type="hidden" name="showtimeId" id="editSTId">
                    <input type="hidden" name="hallId"     id="editHId">

                    <!-- Searchable Movie -->
                    <input type="hidden" name="movieId" id="editMId">
                    <div class="form-group">
                        <label class="form-label">Movie</label>
                        <div class="movie-search-wrapper">
                            <input type="text" class="form-input" id="editMovieSearch"
                                   placeholder="Type to search movie…" autocomplete="off">
                            <ul class="movie-suggestion-list" id="editMovieDropdown"></ul>
                        </div>
                    </div>

                    <div class="form-group" style="margin-top:14px;">
                        <label class="form-label">Show Date</label>
                        <input type="date" class="form-input" name="showDate" id="editSTDate" required>
                    </div>

                    <div class="form-group" style="margin-top:14px;">
                        <label class="form-label">Start Time</label>
                        <input type="time" class="form-input" name="showStartTime" id="editSTStart" required>
                    </div>

                    <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:20px;">
                        <button type="button" onclick="closeModal('editShowtimeModal')" class="btn btn-ghost">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="footer.jsp" %>

        <script>
            /* ── Modal helpers ───────────────────────────────── */
            function openModal(id) {
                document.getElementById(id).style.display = 'flex';
            }
            function closeModal(id) {
                document.getElementById(id).style.display = 'none';
            }

            /* ── Movie list from server ──────────────────────── */
            const movieList = [
            <c:forEach var="m" items="${movieList}">
                {id: '${m.id}', title: '${m.title}'},
            </c:forEach>
            ];

            /* ── Showtime data for edit pre-fill ─────────────── */
            const stData = {};
            <c:forEach var="st" items="${showtimeList}">
            stData['${st.showtimeId}'] = {
                movieId: '${st.movieId}',
                movieTitle: '${st.movieTitle}',
                hallId: '${st.hallId}',
                date: '${st.showDate}',
                start: '${st.showStartTime}'
            };
            </c:forEach>

            const hallList = [
            <c:forEach var="h" items="${hallList}">
                {id: '${h.hallId}', type: '${h.hallType}', cinema: '${not empty h.cinemaName ? h.cinemaName : ""}'},
            </c:forEach>
            ];

            function initHallSearch(searchInputId, dropdownId, hiddenInputId) {
                const searchEl = document.getElementById(searchInputId);
                const dropdownEl = document.getElementById(dropdownId);
                const hiddenEl = document.getElementById(hiddenInputId);

                searchEl.addEventListener('input', function () {
                    const query = this.value.trim().toLowerCase();
                    dropdownEl.innerHTML = '';

                    if (!query) {
                        dropdownEl.style.display = 'none';
                        return;
                    }

                    const matches = hallList.filter(h => {
                        const cinema = h.cinema || ''; // guard against null/empty
                        return h.id.toLowerCase().includes(query)
                                || h.type.toLowerCase().includes(query)
                                || cinema.toLowerCase().includes(query);
                    });

                    if (matches.length === 0) {
                        const li = document.createElement('li');
                        li.className = 'no-result';
                        li.textContent = 'No halls found';
                        dropdownEl.appendChild(li);
                    } else {
                        matches.forEach(h => {
                            const li = document.createElement('li');
                            // show hallId + type, and cinema only if present
                            li.textContent = h.cinema
                                    ? h.id + ' — ' + h.type + ' (' + h.cinema + ')'
                                    : h.id + ' — ' + h.type;
                            li.addEventListener('mousedown', function (e) {
                                e.preventDefault();
                                searchEl.value = li.textContent; // show the full label
                                hiddenEl.value = h.id;           // store only hallId
                                dropdownEl.style.display = 'none';
                            });
                            dropdownEl.appendChild(li);
                        });
                    }

                    dropdownEl.style.display = 'block';
                });

                document.addEventListener('click', function (e) {
                    if (!searchEl.contains(e.target) && !dropdownEl.contains(e.target)) {
                        dropdownEl.style.display = 'none';
                    }
                });
            }

            initHallSearch('addHallSearch', 'addHallDropdown', 'addHId');

            /* ── Reusable searchable-dropdown factory ─────────
             searchInputId  – text input the user types in
             dropdownId     – <ul> that shows suggestions
             hiddenInputId  – hidden input that holds the chosen movieId
             ─────────────────────────────────────────────────── */
            function initMovieSearch(searchInputId, dropdownId, hiddenInputId) {
                const searchEl = document.getElementById(searchInputId);
                const dropdownEl = document.getElementById(dropdownId);
                const hiddenEl = document.getElementById(hiddenInputId);

                searchEl.addEventListener('input', function () {
                    const query = this.value.trim().toLowerCase();
                    renderDropdown(dropdownEl, hiddenEl, searchEl, query);
                });

                // Close when clicking outside
                document.addEventListener('click', function (e) {
                    if (!searchEl.contains(e.target) && !dropdownEl.contains(e.target)) {
                        dropdownEl.style.display = 'none';
                    }
                });
            }

            function renderDropdown(dropdownEl, hiddenEl, searchEl, query) {
                dropdownEl.innerHTML = '';

                if (!query) {
                    dropdownEl.style.display = 'none';
                    return;
                }

                const matches = movieList.filter(m => m.title.toLowerCase().includes(query));

                if (matches.length === 0) {
                    const li = document.createElement('li');
                    li.className = 'no-result';
                    li.textContent = 'No movies found';
                    dropdownEl.appendChild(li);
                } else {
                    matches.forEach(m => {
                        const li = document.createElement('li');
                        li.textContent = m.title;
                        li.addEventListener('mousedown', function (e) {
                            e.preventDefault(); // prevent blur before click fires
                            searchEl.value = m.title;
                            hiddenEl.value = m.id;
                            dropdownEl.style.display = 'none';
                        });
                        dropdownEl.appendChild(li);
                    });
                }

                dropdownEl.style.display = 'block';
            }

            /* ── Wire up both modals ─────────────────────────── */
            initMovieSearch('addMovieSearch', 'addMovieDropdown', 'addMId');
            initMovieSearch('editMovieSearch', 'editMovieDropdown', 'editMId');

            /* ── Open edit modal and pre-fill all fields ─────── */
            function openSTEdit(id) {
                const s = stData[id];
                if (!s)
                    return;

                document.getElementById('editSTId').value = id;
                document.getElementById('editHId').value = s.hallId;
                document.getElementById('editMId').value = s.movieId;
                document.getElementById('editMovieSearch').value = s.movieTitle;
                document.getElementById('editSTDate').value = s.date;
                document.getElementById('editSTStart').value = s.start;

                openModal('editShowtimeModal');
            }
        </script>
    </body>
</html>
