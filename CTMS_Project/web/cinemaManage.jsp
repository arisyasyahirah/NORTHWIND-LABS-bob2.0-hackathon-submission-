<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%-- ============================================================
     cinemaManage.jsp — HQ MANAGE (READ / list)
     Access level : HQ only (Level 3)
     Shows        : All cinemas in a table with Edit / Delete actions
     Tables used  : CINEMA, HALL
     ============================================================ --%>

<%@ include file="hq-header.jsp" %>

<%@ include file="db_connect.jsp" %>

<%-- Check for success/error message passed via redirect --%>
<%
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg");
    session.removeAttribute("errorMsg");
%>

<main class="page-offset">
<div class="cinema-page">

    <%-- Page Title --%>
    <div class="page-title-bar">
        <div class="page-title-bar-left">
            <div class="page-breadcrumb">
                <a href="index.jsp">Home</a> &rsaquo; <span>Manage Cinemas</span>
            </div>
            <h1>MANAGE <span>CINEMAS</span></h1>
        </div>
        <div style="display:flex;align-items:center;gap:12px;">
            <span class="role-badge hq">
                <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                </svg>
                HQ Access
            </span>
            <%-- Add new cinema button --%>
            <a href="cinemaAdd.jsp" class="btn btn-primary">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <path d="M12 5v14M5 12h14"/>
                </svg>
                Add Cinema
            </a>
        </div>
    </div>

    <%-- Alert messages from redirect --%>
    <% if (successMsg != null) { %>
        <div class="alert alert-success">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>
            </svg>
            <%= successMsg %>
        </div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div class="alert alert-error">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>
            </svg>
            <%= errorMsg %>
        </div>
    <% } %>

    <%-- Filter bar --%>
    <div class="filter-bar">
        <div class="filter-input">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
            </svg>
            <input type="text" id="searchInput" placeholder="Search cinema, branch, address...">
        </div>
    </div>

    <%-- Cinemas Table --%>
    <div class="staff-panel">
        <div class="staff-panel-header">
            <div class="staff-panel-title">All Cinemas</div>
            <span style="font-size:12px;color:var(--muted);">CINEMA table</span>
        </div>

        <table class="data-table" id="cinemaTable">
            <thead>
                <tr>
                    <th>Cinema ID</th>
                    <th>Cinema Name</th>
                    <th>Branch</th>
                    <th>Address</th>
                    <th>Poscode</th>
                    <th>Phone Number</th>
                    <th>Halls</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (conn != null) {
                    String sql = "SELECT c.cinema_id, c.cinema_name, c.branch, " +
                                 "c.addr1, c.addr2, c.poscode, c.cinema_ph_number, " +
                                 "COUNT(h.hall_id) AS hall_count " +
                                 "FROM CINEMA c " +
                                 "LEFT JOIN HALL h ON c.cinema_id = h.cinema_id " +
                                 "GROUP BY c.cinema_id " +
                                 "ORDER BY c.cinema_name";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    boolean hasData = false;

                    while (rs.next()) {
                        hasData = true;
                        String cid = rs.getString("cinema_id");
            %>
                <tr>
                    <td class="td-id"><%= cid %></td>
                    <td class="td-name"><%= rs.getString("cinema_name") %></td>
                    <td><%= rs.getString("branch") %></td>
                    <td style="font-size:12px;">
                        <%= rs.getString("addr1") %>,
                        <%= rs.getString("addr2") %>
                    </td>
                    <td><%= rs.getInt("poscode") %></td>
                    <td><%= rs.getString("cinema_ph_number") %></td>
                    <td>
                        <span style="color:var(--khaki);font-family:var(--font-display);font-size:16px;">
                            <%= rs.getInt("hall_count") %>
                        </span>
                    </td>
                    <td>
                        <div class="manage-actions">
                            <%-- Edit — goes to cinemaEdit.jsp with cinema_id --%>
                            <a href="cinemaEdit.jsp?cinema_id=<%= cid %>"
                               class="action-btn action-edit" title="Edit Cinema">
                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                </svg>
                            </a>
                            <%-- Delete — goes to cinemaDelete.jsp with cinema_id --%>
                            <a href="cinemaDelete.jsp?cinema_id=<%= cid %>"
                               class="action-btn action-delete" title="Delete Cinema">
                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="3 6 5 6 21 6"/>
                                    <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>
                                    <path d="M10 11v6M14 11v6"/>
                                    <path d="M9 6V4h6v2"/>
                                </svg>
                            </a>
                        </div>
                    </td>
                </tr>
            <%
                    }
                    if (!hasData) { %>
                <tr><td colspan="8">
                    <div class="empty-state" style="padding:40px;">
                        <h3>No Cinemas Yet</h3>
                        <p>Click <strong>Add Cinema</strong> above to get started.</p>
                    </div>
                </td></tr>
            <%  }
                rs.close(); ps.close(); conn.close();
                }
            %>
            </tbody>
        </table>
    </div>

</div>
</main>

<script>
    document.getElementById('searchInput').addEventListener('input', function () {
        var q = this.value.toLowerCase();
        document.querySelectorAll('#cinemaTable tbody tr').forEach(function (row) {
            row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
        });
    });
</script>

<%@ include file="hq-footer.jsp" %>
