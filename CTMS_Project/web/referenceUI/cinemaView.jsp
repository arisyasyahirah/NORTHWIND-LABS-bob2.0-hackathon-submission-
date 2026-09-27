<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%-- ============================================================
     cinemaView.jsp — CUSTOMER VIEW
     Access level : Public / Customer
     Shows        : All cinemas with address, phone, hall count
     Tables used  : CINEMA, HALL, HALL_TYPE
     ============================================================ --%>

<%@ include file="header.jsp" %>

<link rel="stylesheet" href="master-style.css">
<%@ include file="db_connect.jsp" %>

<main class="page-offset">
<div class="cinema-page">

    <%-- Page Title --%>
    <div class="page-title-bar">
        <div class="page-title-bar-left">
            <div class="page-breadcrumb">
                <a href="index.jsp">Home</a> &rsaquo; <span>Cinemas</span>
            </div>
            <h1>OUR <span>CINEMAS</span></h1>
        </div>
        <span class="role-badge customer">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
            </svg>
            Customer View
        </span>
    </div>

    <%-- Search / Filter bar --%>
    <div class="filter-bar">
        <div class="filter-input">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
            </svg>
            <input type="text" id="searchInput" placeholder="Search cinema or branch...">
        </div>
    </div>

    <%-- Cinema Grid --%>
    <div class="cinema-grid" id="cinemaGrid">
    <%
        if (conn != null) {
            // Query: get all cinemas + count of halls
            String sql = "SELECT c.cinema_id, c.cinema_name, c.branch, " +
                         "c.addr1, c.addr2, c.poscode, c.cinema_ph_number, " +
                         "COUNT(h.hall_id) AS hall_count " +
                         "FROM CINEMA c " +
                         "LEFT JOIN HALL h ON c.cinema_id = h.cinema_id " +
                         "GROUP BY c.cinema_id " +
                         "ORDER BY c.cinema_name";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            boolean hasCinemas = false;

            while (rs.next()) {
                hasCinemas = true;
                String cinemaId   = rs.getString("cinema_id");
                String cinemaName = rs.getString("cinema_name");
                String branch     = rs.getString("branch");
                String addr1      = rs.getString("addr1");
                String addr2      = rs.getString("addr2");
                int    poscode    = rs.getInt("poscode");
                String phone      = rs.getString("cinema_ph_number");
                int    hallCount  = rs.getInt("hall_count");

                // Sub-query: get halls for this cinema
                String hallSql = "SELECT h.hall_id, ht.hall_category, h.hall_availability " +
                                 "FROM HALL h " +
                                 "JOIN HALL_TYPE ht ON h.hall_type = ht.hall_type " +
                                 "WHERE h.cinema_id = ? " +
                                 "ORDER BY h.hall_id";
                PreparedStatement hallPs = conn.prepareStatement(hallSql);
                hallPs.setString(1, cinemaId);
                ResultSet hallRs = hallPs.executeQuery();
    %>
        <div class="cinema-card">

            <div class="cinema-card-header">
                <div>
                    <div class="cinema-card-id"><%= cinemaId %></div>
                    <div class="cinema-card-name"><%= cinemaName %></div>
                    <div class="cinema-card-branch"><%= branch %></div>
                </div>
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="rgba(181,164,138,0.2)" stroke-width="1">
                    <rect x="2" y="3" width="20" height="14" rx="2"/>
                    <path d="m8 21 4-4 4 4M3 7l5 5-5 5"/>
                </svg>
            </div>

            <div class="cinema-card-body">
                <%-- addr1, addr2, poscode from CINEMA table --%>
                <div class="cinema-info-row">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
                    </svg>
                    <span><%= addr1 %>, <%= addr2 %>, <%= poscode %></span>
                </div>

                <%-- hall_count --%>
                <div class="cinema-info-row">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <rect x="2" y="3" width="20" height="14" rx="2"/><path d="m8 21 4-4 4 4"/>
                    </svg>
                    <span><strong><%= hallCount %></strong> Hall<%= hallCount != 1 ? "s" : "" %> Available</span>
                </div>

                <%-- Hall pills: hall_availability 1=available, 0=unavailable --%>
                <div class="hall-pills">
                <% while (hallRs.next()) {
                       String hallId   = hallRs.getString("hall_id");
                       String hallCat  = hallRs.getString("hall_category");
                       String hallAvail = hallRs.getString("hall_availability");
                       String pillClass = "1".equals(hallAvail) ? "available" : "unavailable";
                %>
                    <span class="hall-pill <%= pillClass %>">
                        <span class="hall-pill-dot"></span>
                        <%= hallId %> &mdash; <%= hallCat %>
                    </span>
                <% } %>
                </div>

            </div>

            <div class="cinema-card-footer">
                <%-- cinema_ph_number from CINEMA table --%>
                <div class="cinema-phone">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.77 12.18 19.79 19.79 0 0 1 1.73 3.6 2 2 0 0 1 3.71 1.45h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 9.14a16 16 0 0 0 6 6l1.06-1.06a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 21.73 16.92z"/>
                    </svg>
                    &nbsp;<%= phone %>
                </div>
                <a href="cinemaStaffView.jsp?cinema_id=<%= cinemaId %>" class="btn btn-outline" style="font-size:11px;padding:6px 14px;">
                    View Halls &rarr;
                </a>
            </div>

        </div>
    <%
                hallRs.close();
                hallPs.close();
            } // end while

            if (!hasCinemas) { %>
        <div class="empty-state" style="grid-column:1/-1;">
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                <rect x="2" y="3" width="20" height="14" rx="2"/><path d="m8 21 4-4 4 4"/>
            </svg>
            <h3>No Cinemas Found</h3>
            <p>No cinema data available yet.</p>
        </div>
    <%  }

            rs.close();
            ps.close();
            conn.close();
        }
    %>
    </div><%-- end cinema-grid --%>

</div>
</main>

<script>
    // Live search filter
    document.getElementById('searchInput').addEventListener('input', function () {
        var q = this.value.toLowerCase();
        document.querySelectorAll('.cinema-card').forEach(function (card) {
            var text = card.innerText.toLowerCase();
            card.style.display = text.includes(q) ? '' : 'none';
        });
    });
</script>

<%@ include file="footer.jsp" %>
