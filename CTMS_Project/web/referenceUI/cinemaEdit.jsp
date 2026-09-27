<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%-- ============================================================
     cinemaEdit.jsp — HQ EDIT CINEMA (UPDATE)
     Access level : HQ only (Level 3)
     URL param    : ?cinema_id=C0001
     Pre-fills    : CINEMA fields from DB, shows hall list
     On submit    : Updates CINEMA row, redirects to cinemaManage.jsp
     ============================================================ --%>

<%@ include file="header.jsp" %>


<%@ include file="db_connect.jsp" %>

<%
    String cinemaId = request.getParameter("cinema_id");
    if (cinemaId == null || cinemaId.isEmpty()) {
        response.sendRedirect("cinemaManage.jsp");
        return;
    }

    // ── HANDLE POST (UPDATE) ─────────────────────────────────────
    if ("POST".equals(request.getMethod())) {
        String cinemaName  = request.getParameter("cinema_name");
        String branch      = request.getParameter("branch");
        String addr1       = request.getParameter("addr1");
        String addr2       = request.getParameter("addr2");
        String poscode     = request.getParameter("poscode");
        String phone       = request.getParameter("cinema_ph_number");

        try {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE CINEMA SET cinema_name=?, branch=?, addr1=?, addr2=?, " +
                "poscode=?, cinema_ph_number=? WHERE cinema_id=?");
            ps.setString(1, cinemaName);
            ps.setString(2, branch);
            ps.setString(3, addr1);
            ps.setString(4, addr2);
            ps.setInt(5, Integer.parseInt(poscode));
            ps.setString(6, phone);
            ps.setString(7, cinemaId);
            ps.executeUpdate();
            ps.close();
            conn.close();

            session.setAttribute("successMsg", "Cinema '" + cinemaName + "' updated successfully.");
            response.sendRedirect("cinemaManage.jsp");
            return;
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Update failed: " + e.getMessage());
            response.sendRedirect("cinemaEdit.jsp?cinema_id=" + cinemaId);
            return;
        }
    }

    // ── LOAD cinema data for pre-fill ───────────────────────────
    String dbName = "", dbBranch = "", dbAddr1 = "", dbAddr2 = "",
           dbPoscode = "", dbPhone = "";

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
    }
%>

<main class="page-offset">
<div class="cinema-page form-page">

    <div class="page-title-bar">
        <div class="page-title-bar-left">
            <div class="page-breadcrumb">
                <a href="index.jsp">Home</a> &rsaquo;
                <a href="cinemaManage.jsp">Manage Cinemas</a> &rsaquo;
                <span>Edit Cinema</span>
            </div>
            <h1>EDIT <span><%= dbName.toUpperCase() %></span></h1>
        </div>
        <span class="role-badge hq">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
            </svg>
            HQ Only
        </span>
    </div>

    <div class="alert alert-info">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/>
        </svg>
        Editing cinema <strong><%= cinemaId %></strong>.
        Cinema ID cannot be changed — it is the Primary Key.
        To edit halls, go to the Hall management section.
    </div>

    <form method="POST" action="cinemaEdit.jsp?cinema_id=<%= cinemaId %>">

        <%-- CINEMA details card --%>
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

                    <%-- cinema_id: disabled — PK, cannot change --%>
                    <div class="form-group">
                        <label class="form-label">
                            Cinema ID <span class="field-name">cinema_id</span>
                        </label>
                        <input type="text" class="form-input" value="<%= cinemaId %>" disabled>
                        <span class="form-hint">Primary Key — read only</span>
                    </div>

                    <%-- cinema_name --%>
                    <div class="form-group">
                        <label class="form-label">
                            Cinema Name <span class="field-name">cinema_name</span>
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="cinema_name" class="form-input"
                               value="<%= dbName %>" maxlength="50" required>
                    </div>

                    <%-- branch --%>
                    <div class="form-group">
                        <label class="form-label">
                            Branch <span class="field-name">branch</span>
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="branch" class="form-input"
                               value="<%= dbBranch %>" maxlength="50" required>
                    </div>

                    <%-- cinema_ph_number --%>
                    <div class="form-group">
                        <label class="form-label">
                            Phone Number <span class="field-name">cinema_ph_number</span>
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="cinema_ph_number" class="form-input"
                               value="<%= dbPhone %>" maxlength="11" required>
                    </div>

                    <%-- addr1 --%>
                    <div class="form-group form-col-span-2">
                        <label class="form-label">
                            Address Line 1 <span class="field-name">addr1</span>
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="addr1" class="form-input"
                               value="<%= dbAddr1 %>" maxlength="100" required>
                    </div>

                    <%-- addr2 --%>
                    <div class="form-group">
                        <label class="form-label">
                            Address Line 2 <span class="field-name">addr2</span>
                            <span class="required-star">*</span>
                        </label>
                        <input type="text" name="addr2" class="form-input"
                               value="<%= dbAddr2 %>" maxlength="100" required>
                    </div>

                    <%-- poscode --%>
                    <div class="form-group">
                        <label class="form-label">
                            Postcode <span class="field-name">poscode</span>
                            <span class="required-star">*</span>
                        </label>
                        <input type="number" name="poscode" class="form-input"
                               value="<%= dbPoscode %>" min="10000" max="99999" required>
                    </div>

                </div>
            </div>
        </div>

        <%-- Halls read-only view for reference --%>
        <div class="form-card">
            <div class="form-card-header">
                <div class="form-card-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="2" y="7" width="20" height="14" rx="2"/>
                        <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                    </svg>
                </div>
                <h2>Halls in This Cinema <span style="color:var(--muted);font-size:13px;">(read only)</span></h2>
            </div>
            <div class="form-card-body" style="padding:0;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Hall ID</th>
                            <th>Hall Type</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Availability</th>
                            <th>Seats</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (conn != null) {
                            PreparedStatement hps = conn.prepareStatement(
                                "SELECT h.hall_id, h.hall_type, ht.hall_category, ht.hall_price, " +
                                "h.hall_availability, " +
                                "(SELECT COUNT(*) FROM SEAT s WHERE s.hall_id = h.hall_id) AS seat_count " +
                                "FROM HALL h " +
                                "JOIN HALL_TYPE ht ON h.hall_type = ht.hall_type " +
                                "WHERE h.cinema_id = ? ORDER BY h.hall_id");
                            hps.setString(1, cinemaId);
                            ResultSet hrs = hps.executeQuery();
                            boolean hasHalls = false;
                            while (hrs.next()) {
                                hasHalls = true;
                                String avail = hrs.getString("hall_availability");
                    %>
                        <tr>
                            <td class="td-id"><%= hrs.getString("hall_id") %></td>
                            <td><%= hrs.getString("hall_type") %></td>
                            <td><%= hrs.getString("hall_category") %></td>
                            <td style="color:var(--khaki);">RM <%= String.format("%.2f", hrs.getDouble("hall_price")) %></td>
                            <td>
                                <span class="avail-badge <%= "1".equals(avail) ? "avail-1" : "avail-0" %>">
                                    <%= "1".equals(avail) ? "Available" : "Unavailable" %>
                                </span>
                            </td>
                            <td><%= hrs.getInt("seat_count") %></td>
                        </tr>
                    <%
                            }
                            if (!hasHalls) { %>
                        <tr><td colspan="6" style="text-align:center;padding:20px;color:var(--muted);">
                            No halls assigned yet.
                        </td></tr>
                    <%  }
                            hrs.close(); hps.close();
                            conn.close();
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="form-actions">
            <a href="cinemaManage.jsp" class="btn btn-ghost">Cancel</a>
            <button type="submit" class="btn btn-primary">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                    <polyline points="17 21 17 13 7 13 7 21"/>
                    <polyline points="7 3 7 8 15 8"/>
                </svg>
                Save Changes
            </button>
        </div>

    </form>

</div>
</main>

<%@ include file="footer.jsp" %>
