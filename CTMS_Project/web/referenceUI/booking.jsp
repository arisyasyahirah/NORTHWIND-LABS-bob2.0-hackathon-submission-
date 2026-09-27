<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<main class="page-offset">
    <div class="container" style="max-width:1200px;margin:0 auto;padding:40px 20px;">
        <div class="page-title-bar">
            <div>
                <div class="page-breadcrumb">
                    <a href="index.jsp">Home</a> › 
                    <a href="movieList.jsp">Movies</a> › 
                    <span>Select Seats</span>
                </div>
                <h1>DUNE: <span>PART TWO</span></h1>
                <div class="text-muted" style="margin-top:8px;">Hall H001 — IMAX | Today, 7:30 PM</div>
            </div>
            <span class="role-badge customer">Customer View</span>
        </div>

        <div class="flex" style="display: flex; gap: 32px; flex-wrap: wrap;">
            <!-- Left: Seat Map -->
            <div style="flex: 2; min-width: 300px;">
                <div class="seat-map-container">
                    <div class="screen">SCREEN</div>
                    
                    <div class="seat-row">
                        <span class="seat-row-label">A</span>
                        <div class="seat available">1</div>
                        <div class="seat available">2</div>
                        <div class="seat available">3</div>
                        <div class="seat vip">4</div>
                        <div class="seat vip">5</div>
                        <div class="seat unavailable">6</div>
                        <div class="seat available">7</div>
                        <div class="seat available">8</div>
                        <div class="seat available">9</div>
                        <div class="seat selected">10</div>
                    </div>
                    
                    <div class="seat-row">
                        <span class="seat-row-label">B</span>
                        <div class="seat available">1</div>
                        <div class="seat available">2</div>
                        <div class="seat selected">3</div>
                        <div class="seat vip">4</div>
                        <div class="seat vip">5</div>
                        <div class="seat unavailable">6</div>
                        <div class="seat available">7</div>
                        <div class="seat available">8</div>
                        <div class="seat available">9</div>
                        <div class="seat available">10</div>
                    </div>
                    
                    <div class="seat-row">
                        <span class="seat-row-label">C</span>
                        <div class="seat available">1</div>
                        <div class="seat available">2</div>
                        <div class="seat available">3</div>
                        <div class="seat vip">4</div>
                        <div class="seat vip">5</div>
                        <div class="seat vip">6</div>
                        <div class="seat available">7</div>
                        <div class="seat available">8</div>
                        <div class="seat available">9</div>
                        <div class="seat available">10</div>
                    </div>
                    
                    <div class="seat-row">
                        <span class="seat-row-label">D</span>
                        <div class="seat available">1</div>
                        <div class="seat available">2</div>
                        <div class="seat available">3</div>
                        <div class="seat available">4</div>
                        <div class="seat available">5</div>
                        <div class="seat unavailable">6</div>
                        <div class="seat available">7</div>
                        <div class="seat available">8</div>
                        <div class="seat available">9</div>
                        <div class="seat available">10</div>
                    </div>
                    
                    <div class="seat-row">
                        <span class="seat-row-label">E</span>
                        <div class="seat available">1</div>
                        <div class="seat available">2</div>
                        <div class="seat available">3</div>
                        <div class="seat available">4</div>
                        <div class="seat available">5</div>
                        <div class="seat available">6</div>
                        <div class="seat available">7</div>
                        <div class="seat available">8</div>
                        <div class="seat available">9</div>
                        <div class="seat available">10</div>
                    </div>
                    
                    <div style="margin-top: 32px; display: flex; gap: 24px; justify-content: center;">
                        <div class="flex" style="display:flex; gap:8px;">
                            <div class="seat available" style="width:20px;height:20px;"></div>
                            <span class="text-xs">Available</span>
                        </div>
                        <div class="flex" style="display:flex; gap:8px;">
                            <div class="seat selected" style="width:20px;height:20px;background:var(--red);"></div>
                            <span class="text-xs">Selected</span>
                        </div>
                        <div class="flex" style="display:flex; gap:8px;">
                            <div class="seat unavailable" style="width:20px;height:20px;"></div>
                            <span class="text-xs">Taken</span>
                        </div>
                        <div class="flex" style="display:flex; gap:8px;">
                            <div class="seat vip" style="width:20px;height:20px;"></div>
                            <span class="text-xs">VIP (+RM10)</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: Booking Summary with Choice -->
            <div style="flex: 1; min-width: 280px;">
                <div class="cart-summary">
                    <h3 style="color:var(--khaki);font-family:var(--font-display);letter-spacing:2px;margin-bottom:20px;">Booking Summary</h3>
                    
                    <div class="cart-item">DUNE: PART TWO<span>RM 28.00</span></div>
                    <div class="cart-item">Hall H001 (IMAX)<span>—</span></div>
                    <div class="cart-item">Today, 7:30 PM<span>—</span></div>
                    
                    <div style="margin: 12px 0;">
                        <div class="text-xs text-muted" style="margin-bottom:8px;">Selected Seats</div>
                        <div class="flex" style="display:flex; gap:8px;flex-wrap:wrap;">
                            <span class="avail-badge avail-1">A10</span>
                            <span class="avail-badge avail-1">B3</span>
                        </div>
                    </div>
                    
                    <div class="divider"></div>
                    
                    <div class="cart-item"><strong>Subtotal</strong><strong>RM 56.00</strong></div>
                    <div class="cart-item">VIP Upgrade (A4, B4)<span>+RM 20.00</span></div>
                    <div class="cart-item">Service Fee<span>RM 2.00</span></div>
                    
                    <div class="divider"></div>
                    
                    <div class="cart-item">
                        <strong style="font-size:18px;">Total</strong>
                        <strong style="font-size:22px;color:var(--khaki);">RM 78.00</strong>
                    </div>

                    <!-- ═══════════════════════════════════════ -->
                    <!-- CHOICE SECTION: Food or Payment       -->
                    <!-- ═══════════════════════════════════════ -->
                    <div style="margin-top: 24px;">
                        <div class="text-xs text-muted" style="margin-bottom: 12px; text-align: center;">
                            Would you like to add snacks & drinks?
                        </div>
                        
                        <div style="display: flex; gap: 12px; flex-direction: column;">
                            <!-- Option 1: Add Food -->
                            <button class="btn btn-outline" style="width:100%; justify-content: center; gap: 8px;" onclick="location.href='foodMenu.jsp?fromBooking=true'">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"/>
                                    <path d="M12 6v6l4 2"/>
                                    <path d="M16 12h-4"/>
                                </svg>
                                 Add Food & Drinks
                            </button>
                            
                            <!-- Divider or OR -->
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <div style="flex: 1; height: 1px; background: var(--border);"></div>
                                <span class="text-xs text-muted">OR</span>
                                <div style="flex: 1; height: 1px; background: var(--border);"></div>
                            </div>
                            
                            <!-- Option 2: Skip to Payment -->
                            <button class="btn btn-primary" style="width:100%; justify-content: center; gap: 8px;" onclick="location.href='payment.jsp'">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M5 12h14"/>
                                    <path d="M12 5l7 7-7 7"/>
                                </svg>
                                Proceed to Payment → No Food
                            </button>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="footer.jsp" %>