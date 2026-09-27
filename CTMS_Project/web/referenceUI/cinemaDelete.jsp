<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%-- ============================================================
     cinemaDelete.jsp — HQ DELETE CINEMA (DELETE)
     Access level : HQ only (Level 3)
     URL param    : ?cinema_id=C0001
     Shows        : Cinema details + hall count warning
     On confirm   : Deletes CINEMA row (cascades to HALL, SEAT
                    if FK ON DELETE CASCADE is set in DB)
     ============================================================ --%>

<%@ include file="header.jsp" %>


<%@ include file="db_connect.jsp" %>

<%
    String cinemaId = request.getParameter("cinema_id");
    if (cinemaId == null || cinemaId.isEmpty()) {
        response.sendRedirect("cinemaManage.jsp");
        return;
    }

    // ── HANDLE POST (CONFIRM DELETE) ─────────────────────────────
    if ("POST".equals(request.getMethod())) {
        String confirmed = request.getParameter("confirm_delete");
        if ("yes".equals(confirmed)) {
            try {
                // Delete seats → halls → cinema (if no CASCADE in DB)
                PreparedStatement delSeats = conn.prepareStatement(
                    "DELETE s FROM SEAT s " +
                    "JOIN HALL h ON s.hall_id = h.hall_id " +
                    "WHERE h.cinema_id = ?");
                delSeats.setString(1, cinemaId);
                delSeats.executeUpdate();
                delSeats.close();

                PreparedStatement delHalls = conn.prepareStatement(
                    "DELETE FROM HALL WHERE cinema_id = ?");
                delHalls.setString(1, cinemaId);
                delHalls.executeUpdate();
                delHalls.close();

                PreparedStatement delCinema = conn.prepareStatement(
                    "DELETE FROM CINEMA WHERE cinema_id = ?");
                delCinema.setString(1, cinemaId);
                delCinema.executeUpdate();
                delCinema.close();

                conn.close();
                session.setAttribute("successMsg", "Cinema " + cinemaId + " and all related halls/seats deleted.");
                response.sendRedirect("cinemaManage.jsp");
                return;

            } catch (Exception e) {
                conn.close();
                session.setAttribute("errorMsg", "Delete failed: " + e.getMessage());
                response.sendRedirect("cinemaManage.jsp");
                return;
            }
        } else {
            response.sendRedirect("cinemaManage.jsp");
            return;
        }
    }

    // ── LOAD cinema data to show in confirmation ─────────────────
    String dbName = "", dbBranch = "", dbAddr1 = "", dbAddr2 = "",
           dbPoscode = "", dbPhone = "";
    int hallCount = 0, seatCount = 0;

    if (conn != null) {
        PreparedStatement ps = conn.prepareStatement(
            "SELECT * FROM CINEMA WHERE cinema_id = ?");
        ps.setString(1, cinemaId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            dbName    = rs.getString("cinema_name");
            dbBranch  = rs.getString("branch");
            dbAddr1   = rs.getString("addr1");
            dbAddr2   = rs.getString("addr2");
            dbPoscode = String.valueOf(rs.getInt("poscode"));
            dbPhone   = rs.getString("cinema_ph_number");
        } else {
            response.sendRedirect("cinemaManage.jsp"); return;
        }
        rs.close(); ps.close();

        // Count halls
        PreparedStatement hps = conn.prepareStatement(
            "SELECT COUNT(*) FROM HALL WHERE cinema_id = ?");
        hps.setString(1, cinemaId);
        ResultSet hrs = hps.executeQuery();
        if (hrs.next()) hallCount = hrs.getInt(1);
        hrs.close(); hps.close();

        // Count seats
        PreparedStatement sps = conn.prepareStatement(
            "SELECT COUNT(*) FROM SEAT s JOIN HALL h ON s.hall_id = h.hall_id WHERE h.cinema_id = ?");
        sps.setString(1, cinemaId);
        ResultSet srs = sps.executeQuery();
        if (srs.next()) seatCount = srs.getInt(1);
        srs.close(); sps.close();

        conn.close();
    }
%>

<main class="page-offset">
<div class="cinema-page" style="display:flex;align-items:flex-start;justify-content:center;padding-top:60px;">

    <div style="width:100%;max-width:580px;">

        <div class="page-breadcrumb" style="margin-bottom:24px;">
            <a href="index.jsp">Home</a> &rsaquo;
            <a href="cinemaManage.jsp">Manage Cinemas</a> &rsaquo;
            <span>Delete Cinema</span>
        </div>

        <div class="delete-confirm-card">

            <%-- Header --%>
            <div class="delete-confirm-header">
                <div class="delete-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="3 6 5 6 21 6"/>
                        <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>
                        <path d="M10 11v6M14 11v6"/>
                        <path d="M9 6V4h6v2"/>
                    </svg>
                </div>
                <div>
                    <h2>Delete Cinema</h2>
                    <p>This action cannot be undone</p>
                </div>
            </div>

            <%-- Body --%>
            <div class="delete-confirm-body">

                <%-- Cinema info preview --%>
                <div class="delete-target-info">
                    <div class="info-row">
                        <span class="info-label">Cinema ID</span>
                        <span class="info-value" style="font-family:var(--font-display);color:var(--red);">
                            <%= cinemaId %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Cinema Name</span>
                        <span class="info-value"><%= dbName %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Branch</span>
                        <span class="info-value"><%= dbBranch %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Address</span>
                        <span class="info-value" style="font-size:12px;">
                            <%= dbAddr1 %>, <%= dbAddr2 %>, <%= dbPoscode %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Phone</span>
                        <span class="info-value"><%= dbPhone %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Halls</span>
                        <span class="info-value" style="color:var(--red);">
                            <%= hallCount %> hall<%= hallCount != 1 ? "s" : "" %> will be deleted
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Seats</span>
                        <span class="info-value" style="color:var(--red);">
                            <%= seatCount %> seat<%= seatCount != 1 ? "s" : "" %> will be deleted
                        </span>
                    </div>
                </div>

                <%-- Warning --%>
                <div class="delete-warning">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink:0;margin-top:1px;">
                        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                        <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
                    </svg>
                    Deleting this cinema will permanently remove
                    <strong> <%= hallCount %> hall(s)</strong> and
                    <strong><%= seatCount %> seat(s)</strong> associated with it.
                    Any active showtimes in these halls may also be affected.
                </div>

            </div>

            <%-- Confirm / Cancel buttons --%>
            <div class="delete-confirm-footer">
                <a href="cinemaManage.jsp" class="btn btn-ghost">Cancel</a>

                <form method="POST" action="cinemaDelete.jsp?cinema_id=<%= cinemaId %>"
                      style="display:inline;">
                    <input type="hidden" name="confirm_delete" value="yes">
                    <button type="submit" class="btn btn-primary"
                            style="background:var(--red);">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="3 6 5 6 21 6"/>
                            <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>
                        </svg>
                        Yes, Delete Cinema
                    </button>
                </form>
            </div>

        </div>
    </div>
</div>
</main>

<%@ include file="footer.jsp" %>
