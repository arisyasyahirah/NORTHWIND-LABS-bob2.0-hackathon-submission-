<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%-- ============================================================
     cinemaAdd.jsp — HQ ADD CINEMA (CREATE)
     Access level : HQ only (Level 3)
     Form covers  : CINEMA table + HALL + HALL_TYPE + SEAT + SEAT_TYPE
     On submit    : Inserts all rows, redirects to cinemaManage.jsp
     ============================================================ --%>

<%@ include file="header.jsp" %>



<%@ include file="db_connect.jsp" %>

<%--
    ════════════════════════════════════════════════════
    FORM SUBMISSION HANDLER (POST)
    ════════════════════════════════════════════════════
--%>
<%
if ("POST".equals(request.getMethod())) {
    // ── CINEMA fields ───────────────────────────────────────────
    String cinemaId      = request.getParameter("cinema_id");       // VARCHAR 5
    String cinemaName    = request.getParameter("cinema_name");     // VARCHAR 50
    String branch        = request.getParameter("branch");          // VARCHAR 50
    String addr1         = request.getParameter("addr1");           // VARCHAR 100
    String addr2         = request.getParameter("addr2");           // VARCHAR 100
    String poscode       = request.getParameter("poscode");         // INT
    String phoneNumber   = request.getParameter("cinema_ph_number");// VARCHAR 11

    // ── Hall arrays (one per hall row added dynamically) ────────
    String[] hallIds          = request.getParameterValues("hall_id[]");
    String[] hallTypes        = request.getParameterValues("hall_type[]");       // FK → HALL_TYPE
    String[] hallAvailability = request.getParameterValues("hall_availability[]"); // CHAR 2: 0 or 1

    // ── Seat arrays ─────────────────────────────────────────────
    // Each hall has a set of seat rows; we use hall index prefix
    // seat_number_0[], seat_type_0[], seat_availability_0[]

    try {
        conn.setAutoCommit(false); // Transaction — all or nothing

        // 1. Insert CINEMA
        PreparedStatement cinemaPs = conn.prepareStatement(
            "INSERT INTO CINEMA (cinema_id, cinema_name, branch, addr1, addr2, poscode, cinema_ph_number) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)");
        cinemaPs.setString(1, cinemaId);
        cinemaPs.setString(2, cinemaName);
        cinemaPs.setString(3, branch);
        cinemaPs.setString(4, addr1);
        cinemaPs.setString(5, addr2);
        cinemaPs.setInt(6, Integer.parseInt(poscode));
        cinemaPs.setString(7, phoneNumber);
        cinemaPs.executeUpdate();
        cinemaPs.close();

        // 2. Insert each HALL + its SEATs
        if (hallIds != null) {
            for (int i = 0; i < hallIds.length; i++) {
                // Insert HALL row
                PreparedStatement hallPs = conn.prepareStatement(
                    "INSERT INTO HALL (hall_id, hall_type, cinema_id, hall_availability) " +
                    "VALUES (?, ?, ?, ?)");
                hallPs.setString(1, hallIds[i]);
                hallPs.setString(2, hallTypes[i]);
                hallPs.setString(3, cinemaId);
                hallPs.setString(4, hallAvailability[i]);
                hallPs.executeUpdate();
                hallPs.close();

                // Insert SEATs for this hall
                String[] seatIds    = request.getParameterValues("seat_id_"    + i + "[]");
                String[] seatNums   = request.getParameterValues("seat_number_" + i + "[]");
                String[] seatTypes  = request.getParameterValues("seat_type_"   + i + "[]");
                String[] seatAvails = request.getParameterValues("seat_availability_" + i + "[]");

                if (seatIds != null) {
                    for (int j = 0; j < seatIds.length; j++) {
                        PreparedStatement seatPs = conn.prepareStatement(
                            "INSERT INTO SEAT (seat_id, seat_number, seat_type, hall_id, seat_availability) " +
                            "VALUES (?, ?, ?, ?, ?)");
                        seatPs.setString(1, seatIds[j]);
                        seatPs.setString(2, seatNums[j]);
                        seatPs.setString(3, seatTypes[j]);
                        seatPs.setString(4, hallIds[i]);
                        seatPs.setString(5, seatAvails[j]);
                        seatPs.executeUpdate();
                        seatPs.close();
                    }
                }
            }
        }

        conn.commit();
        conn.close();
        session.setAttribute("successMsg", "Cinema '" + cinemaName + "' added successfully.");
        response.sendRedirect("cinemaManage.jsp");
        return;

    } catch (Exception e) {
        conn.rollback();
        conn.close();
        session.setAttribute("errorMsg", "Error adding cinema: " + e.getMessage());
        response.sendRedirect("cinemaAdd.jsp");
        return;
    }
}
%>

<main class="page-offset">
<div class="cinema-page form-page">

    <%-- Page Title --%>
    <div class="page-title-bar">
        <div class="page-title-bar-left">
            <div class="page-breadcrumb">
                <a href="index.jsp">Home</a> &rsaquo;
                <a href="cinemaManage.jsp">Manage Cinemas</a> &rsaquo;
                <span>Add Cinema</span>
            </div>
            <h1>ADD <span>CINEMA</span></h1>
        </div>
        <span class="role-badge hq">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
            </svg>
            HQ Only
        </span>
    </div>

    <form method="POST" action="cinemaAdd.jsp" id="cinemaForm">

        <%-- ══════════════════════════════════════════
             CARD 1: CINEMA details
             Fields from CINEMA table in data dictionary
             ══════════════════════════════════════════ --%>
        <div class="form-card">
            <div class="form-card-header">
                <div class="form-card-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="2" y="3" width="20" height="14" rx="2"/><path d="m8 21 4-4 4 4"/>
                    </svg>
                </div>
                <h2>Cinema Details</h2>
            </div>
            <div class="form-card-body">
                <div class="form-grid">

                    <%-- cinema_id: VARCHAR 5 PK --%>
                    <div class="form-group">
                        <label class="form-label">
                            Cinema ID 
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="cinema_id" class="form-input"
                               placeholder="e.g. C0001" maxlength="5" required>
                        
                    </div>

                    <%-- cinema_name: VARCHAR 50 --%>
                    <div class="form-group">
                        <label class="form-label">
                            Cinema Name 
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="cinema_name" class="form-input"
                               placeholder="e.g. CineOrder TRX" maxlength="50" required>
                        
                    </div>

                    <%-- branch: VARCHAR 50 --%>
                    <div class="form-group">
                        <label class="form-label">
                            Branch <span class="field-name">branch</span>
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="branch" class="form-input"
                               placeholder="e.g. Kuala Lumpur" maxlength="50" required>
                        
                    </div>

                    <%-- cinema_ph_number: VARCHAR 11 --%>
                    <div class="form-group">
                        <label class="form-label">
                            Phone Number
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="cinema_ph_number" class="form-input"
                               placeholder="e.g. 0321234567" maxlength="11" required>
                        
                    </div>

                    <%-- addr1: VARCHAR 100 --%>
                    <div class="form-group form-col-span-2">
                        <label class="form-label">
                            Address Line 1 <span class="field-name">addr1</span>
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="addr1" class="form-input"
                               placeholder="e.g. Level 3, TRX Exchange Mall" maxlength="100" required>
                        
                    </div>

                    <%-- addr2: VARCHAR 100 --%>
                    <div class="form-group">
                        <label class="form-label">
                            Address Line 2 <span class="field-name">addr2</span>
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="addr2" class="form-input"
                               placeholder="e.g. Jalan Tun Razak" maxlength="100" required>
                        
                    </div>

                    <%-- poscode: INT --%>
                    <div class="form-group">
                        <label class="form-label">
                            Postcode 
                            <span class="required-star">*</span>
                        </label>
                        <input type="number" name="poscode" class="form-input"
                               placeholder="e.g. 50450" min="10000" max="99999" required>
                        
                    </div>

                </div>
            </div>
        </div>

        <%-- ══════════════════════════════════════════
             CARD 2: HALL rows (dynamic)
             Fields from HALL + HALL_TYPE tables
             ══════════════════════════════════════════ --%>
        <div class="form-card">
            <div class="form-card-header">
                <div class="form-card-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="2" y="7" width="20" height="14" rx="2"/>
                        <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                    </svg>
                </div>
                <h2>Halls</h2>
            </div>
            <div class="form-card-body">

                <div id="hallContainer">
                    <%-- First hall row rendered by default, JS adds more --%>
                </div>

                <button type="button" class="btn-add-row" onclick="addHall()">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M12 5v14M5 12h14"/>
                    </svg>
                    Add Hall
                </button>

            </div>
        </div>

        <%-- Form actions --%>
        <div class="form-actions">
            <a href="cinemaManage.jsp" class="btn btn-ghost">Cancel</a>
            <button type="submit" class="btn btn-primary">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                    <polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/>
                </svg>
                Save Cinema
            </button>
        </div>

    </form>

    <%-- ── Load hall type options for JS ── --%>
    <%
        // Build hall type options string to inject into JS
        StringBuilder hallTypeOptions = new StringBuilder();
        StringBuilder seatTypeOptions = new StringBuilder();
        if (conn != null && !conn.isClosed()) {
            // Reopen if needed
        }
        if (conn != null) {
            try {
                PreparedStatement htps = conn.prepareStatement(
                    "SELECT hall_type, hall_category, hall_price FROM HALL_TYPE ORDER BY hall_category");
                ResultSet htrs = htps.executeQuery();
                while (htrs.next()) {
                    hallTypeOptions.append("<option value='")
                        .append(htrs.getString("hall_type")).append("'>")
                        .append(htrs.getString("hall_category"))
                        .append(" (RM ").append(String.format("%.2f", htrs.getDouble("hall_price"))).append(")")
                        .append("</option>");
                }
                htrs.close(); htps.close();

                PreparedStatement stps = conn.prepareStatement(
                    "SELECT seat_type, seat_category, seat_price FROM SEAT_TYPE ORDER BY seat_category");
                ResultSet strs = stps.executeQuery();
                while (strs.next()) {
                    seatTypeOptions.append("<option value='")
                        .append(strs.getString("seat_type")).append("'>")
                        .append(strs.getString("seat_category"))
                        .append(" (RM ").append(String.format("%.2f", strs.getDouble("seat_price"))).append(")")
                        .append("</option>");
                }
                strs.close(); stps.close();
                conn.close();
            } catch (Exception e) { /* ignore */ }
        }
    %>

</div>
</main>

<script>
var hallCount = 0;
var hallTypeOpts = '<%= hallTypeOptions.toString() %>';
var seatTypeOpts = '<%= seatTypeOptions.toString() %>';

function addHall() {
    var i = hallCount++;
    var html = 
    <div class="repeatable-section" id="hall_${i}">
        <div class="repeatable-header">
            <span>Hall <span class="row-number">#${i + 1}</span></span>
            <button type="button" class="btn-remove-row" onclick="removeHall(${i})" title="Remove Hall">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <path d="M18 6 6 18M6 6l12 12"/>
                </svg>
            </button>
        </div>
        <div class="repeatable-body">
            <div class="form-grid cols-3">

                <div class="form-group">
                    <label class="form-label">
                        Hall ID <span class="field-name">hall_id</span>
                        <span class="required-star">*</span>
                    </label>
                    <input type="text" name="hall_id[]" class="form-input"
                           placeholder="e.g. H000${i+1}" maxlength="5" required>
                    <span class="form-hint">VARCHAR(5) — PK</span>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        Hall Type <span class="field-name">hall_type</span>
                        <span class="required-star">*</span>
                    </label>
                    <select name="hall_type[]" class="form-input" required>
                        <option value="">— Select Hall Type —</option>
                        ${hallTypeOpts}
                    </select>
                    <span class="form-hint">CHAR(2) — FK → HALL_TYPE</span>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        Availability <span class="field-name">hall_availability</span>
                        <span class="required-star">*</span>
                    </label>
                    <select name="hall_availability[]" class="form-input" required>
                        <option value="1">1 — Available</option>
                        <option value="0">0 — Unavailable</option>
                    </select>
                    <span class="form-hint">CHAR(2) — use 0 or 1</span>
                </div>

            </div>

            <%-- Seat rows for this hall --%>
            <div style="margin-top:16px;">
                <div style="font-size:10px;letter-spacing:2px;text-transform:uppercase;color:var(--khaki-dim);margin-bottom:10px;">
                    Seats for this Hall
                </div>
                <div id="seatContainer_${i}"></div>
                <button type="button" class="btn-add-row" onclick="addSeat(${i})">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M12 5v14M5 12h14"/>
                    </svg>
                    Add Seat Row
                </button>
            </div>
        </div>
    </div>`;
    document.getElementById('hallContainer').insertAdjacentHTML('beforeend', html);
}

function removeHall(i) {
    var el = document.getElementById('hall_' + i);
    if (el) el.remove();
}

var seatCounts = {};
function addSeat(hallIndex) {
    if (!seatCounts[hallIndex]) seatCounts[hallIndex] = 0;
    var j = seatCounts[hallIndex]++;
    var html = 
    <div class="repeatable-section" id="seat_${hallIndex}_${j}" style="margin-bottom:8px;">
        <div class="repeatable-header">
            <span>Seat <span class="row-number">#${j + 1}</span></span>
            <button type="button" class="btn-remove-row" onclick="removeSeat(${hallIndex},${j})">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <path d="M18 6 6 18M6 6l12 12"/>
                </svg>
            </button>
        </div>
        <div class="repeatable-body">
            <div class="form-grid" style="grid-template-columns:1fr 1fr 1fr 1fr;gap:14px;">

                <div class="form-group">
                    <label class="form-label">Seat ID <span class="field-name">seat_id</span> <span class="required-star">*</span></label>
                    <input type="text" name="seat_id_${hallIndex}[]" class="form-input"
                           placeholder="e.g. S000${j+1}" maxlength="5" required>
                    <span class="form-hint">VARCHAR(5) PK</span>
                </div>

                <div class="form-group">
                    <label class="form-label">Seat No. <span class="field-name">seat_number</span> <span class="required-star">*</span></label>
                    <input type="text" name="seat_number_${hallIndex}[]" class="form-input"
                           placeholder="e.g. A01" maxlength="4" required>
                    <span class="form-hint">VARCHAR(4)</span>
                </div>

                <div class="form-group">
                    <label class="form-label">Seat Type <span class="field-name">seat_type</span> <span class="required-star">*</span></label>
                    <select name="seat_type_${hallIndex}[]" class="form-input" required>
                        <option value="">— Type —</option>
                        ${seatTypeOpts}
                    </select>
                    <span class="form-hint">CHAR(2) FK → SEAT_TYPE</span>
                </div>

                <div class="form-group">
                    <label class="form-label">Availability <span class="field-name">seat_availability</span> <span class="required-star">*</span></label>
                    <select name="seat_availability_${hallIndex}[]" class="form-input" required>
                        <option value="AV">AV — Available</option>
                        <option value="NA">NA — Not Available</option>
                    </select>
                    <span class="form-hint">VARCHAR(2)</span>
                </div>

            </div>
        </div>
    </div>`;
    document.getElementById('seatContainer_' + hallIndex).insertAdjacentHTML('beforeend', html);
}

function removeSeat(hallIndex, j) {
    var el = document.getElementById('seat_' + hallIndex + '_' + j);
    if (el) el.remove();
}

// Start with one hall by default
addHall();
</script>

<%@ include file="footer.jsp" %>
