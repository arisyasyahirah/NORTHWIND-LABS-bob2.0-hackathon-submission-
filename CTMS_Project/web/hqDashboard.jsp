<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="hq-header.jsp" %>

<main class="page-offset">
    <div class="container">
        
        <div class="page-header">
            <h1>HQ <span>DASHBOARD</span></h1>
            <span class="role-badge hq">HQ - LEVEL 3</span>
        </div>


        <h2>Quick Actions</h2>
        <div class="action-grid">
            <div class="action-card" onclick="location.href='cinemaManage.jsp'">
                <div class="action-title">Manage Cinemas</div>
                <span>Add/Edit/Delete</span>
            </div>
            <div class="action-card" onclick="location.href='hqHallManage.jsp'">

                <div class="action-title">Manage Halls</div>
                <span>Full CRUD</span>
            </div>
            <div class="action-card" onclick="location.href='hqMovieManage.jsp'">

                <div class="action-title">Manage Movies</div>
                <span>Add/Edit/Delete</span>
            </div>


        </div>

        <h2>Recent Activity</h2>
        <div class="staff-panel">
            <table class="data-table">
                <thead>
                    <tr><th>Date</th><th>Action</th><th>Details</th></tr>
                </thead>
                <tbody>
                    <tr><td>2025-05-05</span><td>Cinema Added</span><td>New cinema: CineOrder Ipoh</span></tr>
                    <tr><td>2025-05-04</span><td>Movie Added</span><td>New movie: WICKED</span></tr>
                    <tr><td>2025-05-03</span><td>Employee Promoted</span><td>John Doe promoted to Manager</span></tr>
                </tbody>
            </table>
        </div>
    </div>
</main>

<%@ include file="hq-footer.jsp" %>