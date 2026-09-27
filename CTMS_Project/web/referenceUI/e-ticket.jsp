<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<%
    // Generate dummy booking data (matches Figure 39 in your documentation)
    String bookingId = "BK" + System.currentTimeMillis();
    String orderNumber = "ORD" + (int)(Math.random() * 100000);
    String qrData = bookingId + "|" + orderNumber + "|DUNE: PART TWO|A10,B3|7:30PM";
%>

<main class="page-offset">
    <div class="container" style="max-width: 900px; margin: 0 auto; padding: 40px 20px;">
        
        <!-- Success Message (Matches Figure 39) -->
        <div class="alert alert-success" style="text-align: center; justify-content: center; margin-bottom: 30px;">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                <polyline points="22 4 12 14.01 9 11.01"/>
            </svg>
            <strong style="font-size: 16px;">Booking Successful!</strong> Your booking has been confirmed.
        </div>

        <!-- E-Ticket Card (Matches Figure 39 design) -->
        <div class="eticket-card">
            
            <!-- Ticket Header -->
            <div class="eticket-header">
                <div class="eticket-brand">
                    <div class="logo-mark"></div>
                    <div class="logo-text">CINE<span>ORDER</span></div>
                </div>
                <div class="eticket-badge">E-TICKET</div>
            </div>

            <!-- Divider -->
            <div class="eticket-divider"></div>

            <!-- Movie Details -->
            <div class="eticket-movie-section">
                <div class="eticket-movie-title">DUNE: PART TWO</div>
                <div class="eticket-movie-meta">
                    <span class="meta-tag">PG-13</span>
                    <span class="meta-tag">2h 46m</span>
                    <span class="meta-tag">Sci-Fi / Epic</span>
                </div>
            </div>

            <!-- Booking Details Grid -->
            <div class="eticket-details-grid">
                <div class="detail-row">
                    <div class="detail-label">Booking ID</div>
                    <div class="detail-value"><%= bookingId %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Order Number</div>
                    <div class="detail-value"><%= orderNumber %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Cinema</div>
                    <div class="detail-value">Lotus Five Star Cinemas - Paya Bunga Sentral</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Hall</div>
                    <div class="detail-value">Hall 1 - Dolby Atmos</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Date</div>
                    <div class="detail-value">Wednesday, 15 January 2025</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Time</div>
                    <div class="detail-value">7:30 PM - 10:16 PM</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Seat Number(s)</div>
                    <div class="detail-value seat-numbers">A10, B3</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Ticket Type</div>
                    <div class="detail-value">Standard (2 tickets)</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Total Paid</div>
                    <div class="detail-value price">RM 78.00</div>
                </div>
            </div>

            <!-- Divider -->
            <div class="eticket-divider"></div>

            <!-- Food Order Summary (Optional) -->
            <div class="eticket-food-section">
                <div class="food-header">Food & Beverages Ordered</div>
                <div class="food-items">
                    <div class="food-item">
                        <span>Regular Popcorn</span>
                        <span>x1</span>
                        <span>RM 8.90</span>
                    </div>
                    <div class="food-item">
                        <span>Coca-Cola</span>
                        <span>x2</span>
                        <span>RM 11.80</span>
                    </div>
                </div>
            </div>

            <!-- Divider -->
            <div class="eticket-divider"></div>

            <!-- QR Code Section (Matches Figure 39 - QR for validation) -->
            <div class="eticket-qr-section">
                <div class="qr-container" id="qrContainer">
                    <!-- QR Code will be generated here -->
                </div>
                <div class="qr-message">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <circle cx="12" cy="12" r="10"/>
                        <path d="M12 16v-4M12 8h.01"/>
                    </svg>
                    Show this QR code at the cinema entrance for validation
                </div>
            </div>

            <!-- Action Buttons (Matches Figure 39) -->
            <div class="eticket-actions">
                <button class="btn btn-outline" onclick="emailTicket()">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <rect x="2" y="4" width="20" height="16" rx="2"/>
                        <path d="m22 7-10 7L2 7"/>
                    </svg>
                    Email Ticket
                </button>
                <button class="btn btn-outline" onclick="downloadPDF()">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                        <polyline points="7 10 12 15 17 10"/>
                        <line x1="12" y1="15" x2="12" y2="3"/>
                    </svg>
                    Download PDF
                </button>
                <button class="btn btn-primary" onclick="location.href='index.jsp'">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2h-5v-7H9v7H4a2 2 0 0 1-2-2z"/>
                    </svg>
                    Back to Home
                </button>
            </div>

            <!-- Note (Matches Figure 39) -->
            <div class="eticket-note">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="M12 8v4M12 16h.01"/>
                </svg>
                A copy of this ticket has been sent to your registered email address.
            </div>
        </div>
    </div>
</main>

<!-- QR Code Library -->
<script src="https://cdn.jsdelivr.net/npm/qrious@4.0.2/dist/qrious.min.js"></script>

<script>
    // Generate QR Code
    var qrData = '<%= qrData %>';
    
    var qr = new QRious({
        element: document.getElementById('qrContainer'),
        value: qrData,
        size: 150,
        background: 'white',
        foreground: 'black',
        level: 'H'
    });
    
    // Email Ticket Function
    function emailTicket() {
        alert('Ticket has been sent to your registered email address!');
        // In real implementation: send email with ticket details
    }
    
    // Download PDF Function
    function downloadPDF() {
        alert('PDF download started. Your ticket is being downloaded.');
        // In real implementation: generate PDF and download
    }
</script>

<style>
/* E-Ticket Styles */
.eticket-card {
    background: linear-gradient(135deg, var(--surface) 0%, var(--surface-2) 100%);
    border: 1px solid var(--border);
    border-radius: 12px;
    overflow: hidden;
    margin-bottom: 20px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.3);
}

.eticket-header {
    background: linear-gradient(135deg, rgba(192,57,43,0.15) 0%, rgba(181,164,138,0.05) 100%);
    padding: 24px 28px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.eticket-brand {
    display: flex;
    align-items: center;
    gap: 10px;
}

.eticket-brand .logo-mark {
    width: 40px;
    height: 40px;
    background: var(--red);
    clip-path: polygon(0 0, 70% 0, 100% 50%, 70% 100%, 0 100%, 30% 50%);
}

.eticket-brand .logo-text {
    font-family: var(--font-display);
    font-size: 24px;
    letter-spacing: 3px;
    color: var(--text);
}

.eticket-brand .logo-text span {
    color: var(--red);
}

.eticket-badge {
    background: var(--red);
    color: white;
    padding: 6px 16px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    letter-spacing: 2px;
}

.eticket-divider {
    height: 2px;
    background: repeating-linear-gradient(90deg, var(--border) 0px, var(--border) 10px, transparent 10px, transparent 20px);
}

.eticket-movie-section {
    padding: 24px 28px;
    text-align: center;
    background: rgba(192,57,43,0.03);
}

.eticket-movie-title {
    font-family: var(--font-display);
    font-size: 28px;
    letter-spacing: 2px;
    color: var(--text);
    margin-bottom: 12px;
}

.eticket-movie-meta {
    display: flex;
    justify-content: center;
    gap: 16px;
    flex-wrap: wrap;
}

.meta-tag {
    background: rgba(181,164,138,0.1);
    border: 1px solid var(--border);
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    color: var(--khaki-dim);
}

.eticket-details-grid {
    padding: 20px 28px;
}

.detail-row {
    display: flex;
    justify-content: space-between;
    padding: 10px 0;
    border-bottom: 1px dashed var(--border);
}

.detail-row:last-child {
    border-bottom: none;
}

.detail-label {
    color: var(--muted);
    font-size: 12px;
    letter-spacing: 1px;
}

.detail-value {
    color: var(--text);
    font-weight: 500;
    font-size: 14px;
}

.detail-value.seat-numbers {
    color: var(--red);
    font-family: monospace;
    font-size: 16px;
    font-weight: bold;
}

.detail-value.price {
    color: var(--khaki);
    font-size: 18px;
    font-weight: bold;
}

.eticket-food-section {
    padding: 20px 28px;
}

.food-header {
    font-size: 12px;
    letter-spacing: 2px;
    text-transform: uppercase;
    color: var(--khaki-dim);
    margin-bottom: 12px;
}

.food-items {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.food-item {
    display: flex;
    justify-content: space-between;
    color: var(--text-muted);
    font-size: 13px;
    padding: 4px 0;
}

.food-item span:first-child {
    flex: 2;
}

.food-item span:nth-child(2) {
    flex: 1;
    text-align: center;
}

.food-item span:last-child {
    flex: 1;
    text-align: right;
    color: var(--khaki);
}

.eticket-qr-section {
    padding: 28px;
    text-align: center;
    background: rgba(0,0,0,0.2);
}

.qr-container {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    background: white;
    padding: 15px;
    border-radius: 12px;
    margin-bottom: 16px;
}

.qr-container canvas {
    width: 150px;
    height: 150px;
}

.qr-message {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    font-size: 12px;
    color: var(--khaki-dim);
}

.eticket-actions {
    padding: 24px 28px;
    display: flex;
    gap: 12px;
    justify-content: center;
    flex-wrap: wrap;
}

.eticket-note {
    padding: 16px 28px;
    background: rgba(52,152,219,0.05);
    border-top: 1px solid var(--border);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    font-size: 11px;
    color: var(--muted);
}
</style>

<%@ include file="footer.jsp" %>