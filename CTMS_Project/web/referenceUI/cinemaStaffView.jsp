<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%-- ============================================================
     cinemaStaffView.jsp — STAFF VIEW (Level 1 & 2)
     Access level : Staff / Manager
     Shows        : Halls (with hall_type, availability) +
                    Showtimes (movie, hall, date, start/end time)
     Tables used  : CINEMA, HALL, HALL_TYPE, SHOWTIME, MOVIE
     ============================================================ --%>

<%@ include file="header.jsp" %>


<%@ include file="db_connect.jsp" %>

<%
    // Get cinema_id from URL param e.g. cinemaStaffView.jsp?cinema_id=C0001
    String filterCinemaId = request.getParameter("cinema_id");
    if (filterCinemaId == null) filterCinemaId = "";

    // Cinema details for page heading
    String cinemaName = "All Cinemas";
    String cinemaBranch = "";
    if (!filterCinemaId.isEmpty() && conn != null) {
        PreparedStatement cps = conn.prepareStatement(
            "SELECT cinema_name, branch FROM CINEMA WHERE cinema_id = ?");
        cps.setString(1, filterCinemaId);
        ResultSet crs = cps.executeQuery();
        if (crs.next()) {
            cinemaName   = crs.getString("cinema_name");
            cinemaBranch = crs.getString("branch");
        }
        crs.close(); cps.close();
    }
%>

<main class="page-offset">
<div class="cinema-page">

    <%-- Page Title --%>
    <div class="page-title-bar">
        <div class="page-title-bar-left">
            <div class="page-breadcrumb">
                <a href="index.jsp">Home</a> &rsaquo;
                <a href="cinemaView.jsp">Cinemas</a> &rsaquo;
                <span>Staff View</span>
            </div>
            <h1><span><%= cinemaName.toUpperCase() %></span>
                <%= !cinemaBranch.isEmpty() ? "— " + cinemaBranch : "" %>
            </h1>
        </div>
        <span class="role-badge staff">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
            </svg>
            Staff View
        </span>
    </div>

    <%-- Filter bar --%>
    <div class="filter-bar">
        <div class="filter-input">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="2" y="3" width="20" height="14" rx="2"/>
            </svg>
            <select id="cinemaFilter" onchange="window.location='cinemaStaffView.jsp?cinema_id='+this.value">
                <option value="">All Cinemas</option>
                <%
                    if (conn != null) {
                        PreparedStatement fps = conn.prepareStatement(
                            "SELECT cinema_id, cinema_name, branch FROM CINEMA ORDER BY cinema_name");
                        ResultSet frs = fps.executeQuery();
                        while (frs.next()) {
                            String cid = frs.getString("cinema_id");
                            String cname = frs.getString("cinema_name") + " — " + frs.getString("branch");
                            String sel = cid.equals(filterCinemaId) ? "selected" : "";
                %>
                        <option value="<%= cid %>" <%= sel %>><%= cname %></option>
                <%      }
                        frs.close(); fps.close();
                    }
                %>
            </select>
        </div>
        <div class="filter-input">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
            </svg>
            <input type="text" id="tableSearch" placeholder="Search halls or movies...">
        </div>
    </div>


    <%-- ══════════════════════════════════════════════
         SECTION 1: HALLS TABLE
         Columns: hall_id | hall_category | hall_price | hall_availability
         ══════════════════════════════════════════════ --%>
    <div class="staff-panel" id="hallPanel">
        <div class="staff-panel-header">
            <div class="staff-panel-title">Movie Halls</div>
            <span style="font-size:12px;color:var(--muted);letter-spacing:0.5px;">
                HALL &times; HALL_TYPE tables
            </span>
        </div>

        <%
            if (conn != null) {
                String hallSql = "SELECT h.hall_id, h.cinema_id, ht.hall_category, " +
                                 "ht.hall_price, h.hall_availability, " +
                                 "c.cinema_name, c.branch, " +
                                 "(SELECT COUNT(*) FROM SEAT s WHERE s.hall_id = h.hall_id) AS seat_count " +
                                 "FROM HALL h " +
                                 "JOIN HALL_TYPE ht ON h.hall_type = ht.hall_type " +
                                 "JOIN CINEMA c    ON h.cinema_id  = c.cinema_id " +
                                 (!filterCinemaId.isEmpty() ? "WHERE h.cinema_id = ? " : "") +
                                 "ORDER BY h.cinema_id, h.hall_id";
                PreparedStatement hps = conn.prepareStatement(hallSql);
                if (!filterCinemaId.isEmpty()) hps.setString(1, filterCinemaId);
                ResultSet hrs = hps.executeQuery();
                boolean hasHalls = false;
        %>
        <table class="data-table" id="hallTable">
            <thead>
                <tr>
                    <th>Hall ID</th>
                    <th>Cinema</th>
                    <th>Hall Category</th>
                    <th>Price / Ticket</th>
                    <th>Total Seats</th>
                    <th>Availability</th>
                </tr>
            </thead>
            <tbody>
            <%  while (hrs.next()) {
                    hasHalls = true;
                    String availVal = hrs.getString("hall_availability");
                    // hall_availability uses 0 and 1 per data dictionary
                    boolean isAvail = "1".equals(availVal);
            %>
                <tr>
                    <td class="td-id"><%= hrs.getString("hall_id") %></td>
                    <td class="td-name">
                        <%= hrs.getString("cinema_name") %>
                        <span style="color:var(--muted);font-size:11px;"> — <%= hrs.getString("branch") %></span>
                    </td>
                    <td><%= hrs.getString("hall_category") %></td>
                    <td>
                        <span style="color:var(--khaki);">
                            RM <%= String.format("%.2f", hrs.getDouble("hall_price")) %>
                        </span>
                    </td>
                    <td><%= hrs.getInt("seat_count") %> seats</td>
                    <td>
                        <%-- hall_availability: 1 = available, 0 = unavailable --%>
                        <span class="avail-badge <%= isAvail ? "avail-1" : "avail-0" %>">
                            <svg width="7" height="7" viewBox="0 0 10 10">
                                <circle cx="5" cy="5" r="4" fill="currentColor"/>
                            </svg>
                            <%= isAvail ? "Available" : "Unavailable" %>
                        </span>
                    </td>
                </tr>
            <%  }
                if (!hasHalls) { %>
                <tr><td colspan="6">
                    <div class="empty-state" style="padding:30px;">
                        <p>No halls found for this cinema.</p>
                    </div>
                </td></tr>
            <%  }
                hrs.close(); hps.close();
            }
        %>
            </tbody>
        </table>
    </div><%-- end staff-panel --%>


    <%-- ══════════════════════════════════════════════
         SECTION 2: SHOWTIMES TABLE
         Columns: showtime_id | movie_title | hall_id | show_date | start | end
         ══════════════════════════════════════════════ --%>
    <div class="staff-panel" id="showtimePanel">
        <div class="staff-panel-header">
            <div class="staff-panel-title">Showtimes</div>
            <span style="font-size:12px;color:var(--muted);letter-spacing:0.5px;">
                SHOWTIME &times; MOVIE &times; HALL tables
            </span>
        </div>

        <%
            if (conn != null) {
                String showSql = "SELECT st.showtime_id, st.show_date, " +
                                 "st.show_start_time, st.show_end_time, " +
                                 "m.movie_title, m.rating, m.genre, " +
                                 "h.hall_id, ht.hall_category, " +
                                 "c.cinema_name, c.branch " +
                                 "FROM SHOWTIME st " +
                                 "JOIN MOVIE    m  ON st.movie_id = m.movie_id " +
                                 "JOIN HALL     h  ON st.hall_id  = h.hall_id " +
                                 "JOIN HALL_TYPE ht ON h.hall_type = ht.hall_type " +
                                 "JOIN CINEMA   c  ON h.cinema_id = c.cinema_id " +
                                 (!filterCinemaId.isEmpty() ? "WHERE c.cinema_id = ? " : "") +
                                 "ORDER BY st.show_date DESC, st.show_start_time";
                PreparedStatement sps = conn.prepareStatement(showSql);
                if (!filterCinemaId.isEmpty()) sps.setString(1, filterCinemaId);
                ResultSet srs = sps.executeQuery();
                boolean hasShows = false;
        %>
        <table class="data-table" id="showtimeTable">
            <thead>
                <tr>
                    <th>Showtime ID</th>
                    <th>Movie</th>
                    <th>Genre / Rating</th>
                    <th>Hall</th>
                    <th>Date</th>
                    <th>Start &rarr; End</th>
                </tr>
            </thead>
            <tbody>
            <%  while (srs.next()) {
                    hasShows = true;
            %>
                <tr>
                    <td class="td-id"><%= srs.getString("showtime_id") %></td>
                    <td class="td-name"><%= srs.getString("movie_title") %></td>
                    <td>
                        <span style="color:var(--khaki-dim);font-size:12px;">
                            <%= srs.getString("genre") %> &bull; <%= srs.getString("rating") %>
                        </span>
                    </td>
                    <td>
                        <%= srs.getString("hall_id") %>
                        <span style="color:var(--muted);font-size:11px;">
                            (<%= srs.getString("hall_category") %>)
                        </span>
                    </td>
                    <td><%= srs.getDate("show_date") %></td>
                    <td>
                        <%-- show_start_time and show_end_time from SHOWTIME --%>
                        <span class="time-pill"><%= srs.getTime("show_start_time") %></span>
                        <span style="color:var(--muted);">&#8594;</span>
                        <span class="time-pill"><%= srs.getTime("show_end_time") %></span>
                    </td>
                </tr>
            <%  }
                if (!hasShows) { %>
                <tr><td colspan="6">
                    <div class="empty-state" style="padding:30px;">
                        <p>No showtimes scheduled yet.</p>
                    </div>
                </td></tr>
            <%  }
                srs.close(); sps.close();
                conn.close();
            }
        %>
            </tbody>
        </table>
    </div><%-- end staff-panel --%>

</div>
</main>

<script>
    // Search both tables
    document.getElementById('tableSearch').addEventListener('input', function () {
        var q = this.value.toLowerCase();
        ['hallTable','showtimeTable'].forEach(function (id) {
            document.querySelectorAll('#' + id + ' tbody tr').forEach(function (row) {
                row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
            });
        });
    });
</script>

<%@ include file="footer.jsp" %>
