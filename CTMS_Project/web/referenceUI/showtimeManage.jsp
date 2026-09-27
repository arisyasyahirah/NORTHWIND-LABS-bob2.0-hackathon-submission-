<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineOrder — Manage Showtimes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/WEB-INF/style/master-style.css">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Crimson+Pro:ital@1&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body>
<%@ include file="../header.jsp" %>

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

        <c:if test="${not empty successMsg}"><div class="alert alert-success">${successMsg}</div></c:if>
        <c:if test="${not empty errorMsg}"><div class="alert alert-danger">${errorMsg}</div></c:if>

        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Movie</th>
                    <th>Hall</th>
                    <th>Date</th>
                    <th>Start</th>
                    <th>End</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="st" items="${showtimes}">
                <tr>
                    <td class="text-muted">${st.showtimeId}</td>
                    <td><strong>${st.movieTitle}</strong></td>
                    <td>${st.hallType}</td>
                    <td>${st.showDate}</td>
                    <td>${st.showStartTime}</td>
                    <td>${st.showEndTime}</td>
                    <td>
                        <div style="display:flex;gap:8px;">
                            <button onclick="openSTEdit('${st.showtimeId}')" class="btn btn-ghost btn-sm">Edit</button>
                            <form method="post" action="${pageContext.request.contextPath}/cinema?action=deleteShowtime" style="display:inline;" onsubmit="return confirm('Delete showtime?')">
                                <input type="hidden" name="showtimeId" value="${st.showtimeId}">
                                <button type="submit" class="btn btn-sm" style="background:var(--red-dim);color:var(--red);border:1px solid rgba(192,57,43,0.3);">Delete</button>
                            </form>
                        </div>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Add Showtime Modal -->
<div class="modal-overlay" id="addShowtimeModal" style="display:none;" onclick="if(event.target===this)closeModal('addShowtimeModal')">
    <div class="modal-card">
        <div class="modal-header flex-between">
            <span class="label">Add Showtime</span>
            <button onclick="closeModal('addShowtimeModal')" style="background:none;border:none;color:var(--muted);font-size:20px;cursor:pointer;">×</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/cinema?action=addShowtime">
            <div class="form-group">
                <label class="form-label">Movie</label>
                <select class="form-input" name="movieId" required>
                    <option value="">— Select Movie —</option>
                    <c:forEach var="m" items="${movies}">
                    <option value="${m.movieId}">${m.movieTitle}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Hall</label>
                <select class="form-input" name="hallId" required>
                    <option value="">— Select Hall —</option>
                    <c:forEach var="h" items="${availableHalls}">
                    <option value="${h.hallId}">${h.hallType} (${h.cinemaName})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group"><label class="form-label">Show Date</label><input type="date" class="form-input" name="showDate" required></div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                <div class="form-group"><label class="form-label">Start Time</label><input type="time" class="form-input" name="showStartTime" required></div>
                <div class="form-group"><label class="form-label">End Time</label><input type="time" class="form-input" name="showEndTime" required></div>
            </div>
            <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:20px;">
                <button type="button" onclick="closeModal('addShowtimeModal')" class="btn btn-ghost">Cancel</button>
                <button type="submit" class="btn btn-primary">Add Showtime</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Showtime Modal -->
<div class="modal-overlay" id="editShowtimeModal" style="display:none;" onclick="if(event.target===this)closeModal('editShowtimeModal')">
    <div class="modal-card">
        <div class="modal-header flex-between">
            <span class="label">Edit Showtime</span>
            <button onclick="closeModal('editShowtimeModal')" style="background:none;border:none;color:var(--muted);font-size:20px;cursor:pointer;">×</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/cinema?action=updateShowtime">
            <input type="hidden" name="showtimeId" id="editSTId">
            <div class="form-group"><label class="form-label">Show Date</label><input type="date" class="form-input" name="showDate" id="editSTDate" required></div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                <div class="form-group"><label class="form-label">Start Time</label><input type="time" class="form-input" name="showStartTime" id="editSTStart" required></div>
                <div class="form-group"><label class="form-label">End Time</label><input type="time" class="form-input" name="showEndTime" id="editSTEnd" required></div>
            </div>
            <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:20px;">
                <button type="button" onclick="closeModal('editShowtimeModal')" class="btn btn-ghost">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../footer.jsp" %>
<script>
    function openModal(id) { document.getElementById(id).style.display = 'flex'; }
    function closeModal(id) { document.getElementById(id).style.display = 'none'; }

    const stData = {};
    <c:forEach var="st" items="${showtimes}">
    stData['${st.showtimeId}'] = { date: '${st.showDate}', start: '${st.showStartTime}', end: '${st.showEndTime}' };
    </c:forEach>

    function openSTEdit(id) {
        const s = stData[id];
        if (!s) return;
        document.getElementById('editSTId').value    = id;
        document.getElementById('editSTDate').value  = s.date;
        document.getElementById('editSTStart').value = s.start;
        document.getElementById('editSTEnd').value   = s.end;
        openModal('editShowtimeModal');
    }
</script>
</body>
</html>
