<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="staff-header.jsp" %>

<main class="page-offset">
    <div class="container">
        
        <div class="page-header">
            <h1>STAFF <span>DASHBOARD</span></h1>
        </div>
        <h2>Quick Actions</h2>
        <div class="action-grid">
            <div class="action-card" onclick="location.href='foodOrders.jsp'">

                <div class="action-title">Food Orders</div>
            </div>
            <div class="action-card" onclick="location.href='ticketValidation.jsp'">

                <div class="action-title">Ticket Validation</div>
            </div>
            <div class="action-card" onclick="location.href='cinemaStaffView.jsp'">

                <div class="action-title">Hall Status</div>
            </div>
        </div>

        <h2>Today's Showtimes</h2>
        <div class="staff-panel">
            <table class="data-table">
                <thead>
                    <tr><th>Time</th><th>Movie</th><th>Hall</th><th>Tickets Sold</th></tr>
                </thead>
                <tbody>
                    <tr><td>11:00 AM</span><td>DUNE: PART TWO</span><td>Hall 1</span><td>156/180</span></tr>
                    <tr><td>2:30 PM</span><td>OPPENHEIMER</span><td>Hall 2</span><td>98/150</span></tr>
                    <tr><td>7:00 PM</span><td>GLADIATOR II</span><td>Hall 1</span><td>142/180</span></tr>
                </tbody>
            </table>
        </div>
    </div>
</main>

<%@ include file="staff-footer.jsp" %>