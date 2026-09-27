<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<main class="page-offset">
    <div class="container" style="max-width: 800px;">
        
        <div class="page-header">
            <h1>TICKET <span>VALIDATION</span></h1>
            <span class="role-badge staff">STAFF VIEW</span>
        </div>

        <div class="validation-card">
            <div class="card-header">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
                <h3>Scan or Enter Booking ID</h3>
            </div>
            <div class="card-body">
                <input type="text" id="bookingId" class="validation-input" placeholder="Enter Booking ID (e.g. BK001)">
                <button class="btn-validate" onclick="validateTicket()">Validate Ticket →</button>
            </div>
        </div>

        <div id="result" class="result-card" style="display: none;">
            <div class="result-header">
                <span class="result-icon">✓</span>
                <span id="resultMessage">Ticket Validated!</span>
            </div>
            <div id="resultDetails" class="result-details"></div>
        </div>

        <div class="recent-card">
            <h3>Recent Validations</h3>
            <table class="recent-table">
                <thead><tr><th>Time</th><th>Booking ID</th><th>Movie</th><th>Seats</th><th>Status</th></tr></thead>
                <tbody>
                    <tr><td>7:20 PM</td><td class="td-id">BK001</td><td>DUNE: PART TWO</td><td>A10, B3</td><td><span class="valid-badge">✓ Validated</span></td></tr>
                    <tr><td>6:55 PM</td><td class="td-id">BK002</td><td>OPPENHEIMER</td><td>C5, C6</td><td><span class="valid-badge">✓ Validated</span></td></tr>
                    <tr><td>6:30 PM</td><td class="td-id">BK003</td><td>GLADIATOR II</td><td>D2</td><td><span class="valid-badge">✓ Validated</span></td></tr>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script>
function validateTicket() {
    let bookingId = document.getElementById('bookingId').value;
    if (!bookingId) { alert("Enter a Booking ID"); return; }
    let resultDiv = document.getElementById('result');
    resultDiv.style.display = 'block';
    document.getElementById('resultMessage').innerHTML = 'Ticket Validated Successfully!';
    document.getElementById('resultDetails').innerHTML = `
        <div><strong>Booking ID:</strong> ${bookingId}</div>
        <div><strong>Movie:</strong> DUNE: PART TWO</div>
        <div><strong>Seats:</strong> A10, B3</div>
        <div><strong>Hall:</strong> Hall 1 - IMAX</div>
        <div><strong>Time:</strong> 7:30 PM</div>
    `;
    document.getElementById('bookingId').value = '';
    setTimeout(() => { resultDiv.style.display = 'none'; }, 5000);
}
</script>

<%@ include file="footer.jsp" %>