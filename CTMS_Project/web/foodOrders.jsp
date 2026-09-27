<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="staff-header.jsp" %>

<main class="page-offset">
    <div class="container">
        
        <div class="page-header">
            <h1>FOOD <span>ORDERS</span></h1>
            <span class="role-badge staff">STAFF VIEW</span>
        </div>

        <div class="staff-panel">
            <div class="panel-header">
                <h3>Pending Orders</h3>
                <input type="text" id="searchOrder" class="search-input" placeholder="Search order...">
            </div>
            
            <table class="data-table" id="ordersTable">
                <thead>
                    <tr><th>Order ID</th><th>Time</th><th>Items</th><th>Total</th><th>Status</th><th>Action</th></tr>
                </thead>
                <tbody>
                    <tr><td class="td-id">FO001</td><td>7:15 PM</td><td>Regular Popcorn (x1), Coke (x2)</td><td class="price">RM 20.70</td><td><span class="status pending">Pending</span></td><td><button class="btn-ready" onclick="markReady('FO001')">Mark Ready</button></td></tr>
                    <tr><td class="td-id">FO002</td><td>7:30 PM</td><td>Large Popcorn (x1), Nachos (x1)</td><td class="price">RM 23.80</td><td><span class="status preparing">Preparing</span></td><td><button class="btn-ready" onclick="markReady('FO002')">Mark Ready</button></td></tr>
                    <tr><td class="td-id">FO003</td><td>7:45 PM</td><td>Combo A (x2), Water (x1)</td><td class="price">RM 31.30</td><td><span class="status ready">Ready</span></td><td><button class="btn-collected" onclick="markCollected('FO003')">Collected</button></td></tr>
                    <tr><td class="td-id">FO004</td><td>8:00 PM</td><td>Nuggets (x1), Coke (x1)</td><td class="price">RM 17.80</td><td><span class="status pending">Pending</span></td><td><button class="btn-ready" onclick="markReady('FO004')">Mark Ready</button></td></tr>
                </tbody>
            </table>
        </div>

        <div class="staff-panel" style="margin-top: 30px;">
            <div class="panel-header"><h3>Completed Orders</h3></div>
            <table class="data-table">
                <thead><tr><th>Order ID</th><th>Time</th><th>Items</th><th>Total</th><th>Status</th></tr></thead>
                <tbody>
                    <tr><td class="td-id">FO000</td><td>6:30 PM</td><td>Popcorn (x1)</td><td class="price">RM 8.90</td><td><span class="status completed">Completed</span></td></tr>
                    <tr><td class="td-id">FO001</td><td>6:45 PM</td><td>Combo B (x1)</td><td class="price">RM 18.90</td><td><span class="status completed">Completed</span></td></tr>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script>
function markReady(orderId) { alert("Order " + orderId + " marked as READY"); location.reload(); }
function markCollected(orderId) { alert("Order " + orderId + " marked as COLLECTED"); location.reload(); }
document.getElementById('searchOrder')?.addEventListener('input', function() {
    let q = this.value.toLowerCase();
    document.querySelectorAll('#ordersTable tbody tr').forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
    });
});
</script>

<%@ include file="staff-footer.jsp" %>