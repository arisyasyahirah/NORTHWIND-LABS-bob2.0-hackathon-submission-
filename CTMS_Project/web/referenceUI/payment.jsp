<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<main class="page-offset">
    <div class="container" style="max-width:1000px;margin:0 auto;padding:40px 20px;">
        <div class="page-title-bar">
            <div>
                <div class="page-breadcrumb">
                    <a href="index.jsp">Home</a> › <a href="booking.jsp">Booking</a> › <span>Payment</span>
                </div>
                <h1>CHECK<span>OUT</span></h1>
            </div>
            <span class="role-badge customer">Customer</span>
        </div>

        <div class="flex" style="display: flex; gap: 32px; flex-wrap: wrap;">
            <!-- Left: Payment Form -->
            <div style="flex: 2; min-width: 300px;">
                <div class="form-card">
                    <div class="form-card-header">
                        <h2>Payment Method</h2>
                    </div>
                    <div class="form-card-body">
                        <div class="payment-methods" style="display: flex; gap: 16px; margin: 20px 0;">
                            <div class="payment-method selected" style="flex:1; padding:16px; background:rgba(255,255,255,0.03); border:1px solid var(--border); border-radius:4px; text-align:center; border-color:var(--red); background:var(--red-dim);">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"><rect x="1" y="4" width="22" height="16" rx="2"/><circle cx="8" cy="12" r="2"/><path d="M18 12h-4"/></svg>
                                <div>Credit Card</div>
                            </div>
                            <div class="payment-method" style="flex:1; padding:16px; background:rgba(255,255,255,0.03); border:1px solid var(--border); border-radius:4px; text-align:center;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 0 0 3-3V8a3 3 0 0 0-3-3H6a3 3 0 0 0-3 3v8a3 3 0 0 0 3 3z"/></svg>
                                <div>Online Banking</div>
                            </div>
                            <div class="payment-method" style="flex:1; padding:16px; background:rgba(255,255,255,0.03); border:1px solid var(--border); border-radius:4px; text-align:center;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="2"/><path d="M12 5v14M5 12h14"/></svg>
                                <div>e-Wallet</div>
                            </div>
                        </div>
                        <div class="form-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top:24px;">
                            <div class="form-group"><label class="form-label">Card Number</label><input class="form-input" placeholder="4242 4242 4242 4242" value="4242 4242 4242 4242"></div>
                            <div class="form-group"><label class="form-label">Cardholder Name</label><input class="form-input" placeholder="JOHN DOE" value="JOHN DOE"></div>
                            <div class="form-group"><label class="form-label">Expiry Date</label><input class="form-input" placeholder="MM/YY" value="12/28"></div>
                            <div class="form-group"><label class="form-label">CVV</label><input class="form-input" placeholder="123" value="123"></div>
                        </div>
                    </div>
                </div>
                <div class="form-actions" style="margin-top:0;">
                    <button class="btn btn-primary" style="width:100%;" onclick="alert('Payment Successful! Thank you for your order.')">Pay RM 78.00 →</button>
                </div>
            </div>

            <!-- Right: Order Summary -->
            <div style="flex: 1; min-width: 260px;">
                <div class="cart-summary" style="background: var(--surface); border: 1px solid var(--border); border-radius: 4px; padding: 24px;">
                    <h3 style="color:var(--khaki);font-family:var(--font-display);letter-spacing:2px;margin-bottom:20px;">Order Summary</h3>
                    <div class="cart-item" style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border);">DUNE: PART TWO<span>RM 28.00</span></div>
                    <div class="cart-item" style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border);">Seat A10<span>RM 28.00</span></div>
                    <div class="cart-item" style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border);">Seat B3<span>RM 28.00</span></div>
                    <div class="cart-item" style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border);">VIP Upgrade (2 seats)<span>+RM 20.00</span></div>
                    <div class="cart-item" style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border);">Service Fee<span>RM 2.00</span></div>
                    <div class="divider" style="margin:16px 0;"></div>
                    <div class="cart-item" style="display: flex; justify-content: space-between; padding: 12px 0;">
                        <strong style="font-size:18px;">Total</strong>
                        <strong style="font-size:22px;color:var(--khaki);">RM 78.00</strong>
                    </div>
                    <div class="alert alert-info" style="margin-top:20px;font-size:12px; display:flex; gap:10px; background:rgba(52,152,219,0.08); border:1px solid rgba(52,152,219,0.25); border-radius:3px; padding:12px;">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>
                        Secure SSL encryption
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="footer.jsp" %>