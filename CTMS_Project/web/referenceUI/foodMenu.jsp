<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<%
    String fromBooking = request.getParameter("fromBooking");
    boolean showBackToBooking = "true".equals(fromBooking);
%>

<main class="page-offset">
    <div class="container">
        
        <!-- Back to Booking Alert -->
        <% if (showBackToBooking) { %>
            <div class="alert alert-info alert-booking-return">
                <div class="alert-content">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <circle cx="12" cy="12" r="10"/>
                        <path d="M12 8v4M12 16h.01"/>
                    </svg>
                    <span>Your seats (A10, B3) are reserved. Add food to your order or continue to payment.</span>
                </div>
                <a href="payment.jsp" class="btn btn-primary btn-sm">Skip to Payment →</a>
            </div>
        <% } %>
        
        <div class="page-title-bar">
            <div>
                <div class="page-breadcrumb">
                    <a href="index.jsp">Home</a> › 
                    <% if (showBackToBooking) { %>
                        <a href="booking.jsp">Booking</a> › 
                    <% } %>
                    <span>Snacks & Drinks</span>
                </div>
                <h1>CINEMA <span>MENU</span></h1>
                <div class="section-sub">Add to your movie experience</div>
            </div>
            <span class="role-badge customer">Customer View</span>
        </div>

        <!-- Category tabs -->
        <div class="food-categories">
            <button class="btn-filter active" data-category="all">All Items</button>
            <button class="btn-filter" data-category="popcorn">Popcorn</button>
            <button class="btn-filter" data-category="beverages">Beverages</button>
            <button class="btn-filter" data-category="combo">Combo Sets</button>
            <button class="btn-filter" data-category="snacks">Snacks</button>
        </div>

        <!-- Food Grid -->
        <div class="food-grid" id="foodGrid">
            <!-- Popcorn -->
            <div class="food-card" data-category="popcorn">
                <div class="food-image">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <circle cx="12" cy="12" r="10"/>
                        <path d="M12 6v6l4 2"/>
                    </svg>
                </div>
                <div class="food-info">
                    <div class="food-title">Regular Popcorn</div>
                    <div class="food-price">RM 8.90</div>
                    <div class="food-stock instock">In Stock</div>
                    <div class="food-actions">
                        <div class="quantity-selector">
                            <button class="qty-btn minus">-</button>
                            <span class="qty">0</span>
                            <button class="qty-btn plus">+</button>
                        </div>
                        <button class="btn-cart add-to-cart">Add to Cart</button>
                    </div>
                </div>
            </div>

            <div class="food-card" data-category="popcorn">
                <div class="food-image">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M12 2a10 10 0 0 0-10 10c0 5.5 10 10 10 10s10-4.5 10-10a10 10 0 0 0-10-10z"/>
                        <path d="M12 8v8M8 12h8"/>
                    </svg>
                </div>
                <div class="food-info">
                    <div class="food-title">Large Popcorn</div>
                    <div class="food-price">RM 12.90</div>
                    <div class="food-stock instock">In Stock</div>
                    <div class="food-actions">
                        <div class="quantity-selector">
                            <button class="qty-btn minus">-</button>
                            <span class="qty">0</span>
                            <button class="qty-btn plus">+</button>
                        </div>
                        <button class="btn-cart add-to-cart">Add to Cart</button>
                    </div>
                </div>
            </div>

            <!-- Beverages -->
            <div class="food-card" data-category="beverages">
                <div class="food-image">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M3 18h18M6 8h12M8 4v4M16 4v4"/>
                        <rect x="4" y="10" width="16" height="8" rx="1"/>
                    </svg>
                </div>
                <div class="food-info">
                    <div class="food-title">Coca-Cola</div>
                    <div class="food-price">RM 5.90</div>
                    <div class="food-stock instock">In Stock</div>
                    <div class="food-actions">
                        <div class="quantity-selector">
                            <button class="qty-btn minus">-</button>
                            <span class="qty">0</span>
                            <button class="qty-btn plus">+</button>
                        </div>
                        <button class="btn-cart add-to-cart">Add to Cart</button>
                    </div>
                </div>
            </div>

            <div class="food-card" data-category="beverages">
                <div class="food-image">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M6 6L18 18M18 6L6 18"/>
                    </svg>
                </div>
                <div class="food-info">
                    <div class="food-title">Mineral Water</div>
                    <div class="food-price">RM 3.50</div>
                    <div class="food-stock instock">In Stock</div>
                    <div class="food-actions">
                        <div class="quantity-selector">
                            <button class="qty-btn minus">-</button>
                            <span class="qty">0</span>
                            <button class="qty-btn plus">+</button>
                        </div>
                        <button class="btn-cart add-to-cart">Add to Cart</button>
                    </div>
                </div>
            </div>

            <!-- Combos -->
            <div class="food-card" data-category="combo">
                <div class="food-image">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M18 10v6M6 10v6M4 8h16"/>
                        <rect x="2" y="6" width="20" height="12" rx="1"/>
                    </svg>
                </div>
                <div class="food-info">
                    <div class="food-title">Combo A (Popcorn + Drink)</div>
                    <div class="food-price">RM 13.90</div>
                    <div class="food-stock instock">In Stock</div>
                    <div class="food-actions">
                        <div class="quantity-selector">
                            <button class="qty-btn minus">-</button>
                            <span class="qty">0</span>
                            <button class="qty-btn plus">+</button>
                        </div>
                        <button class="btn-cart add-to-cart">Add to Cart</button>
                    </div>
                </div>
            </div>

            <div class="food-card" data-category="combo">
                <div class="food-image">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <rect x="2" y="3" width="20" height="14" rx="2"/>
                        <path d="m8 21 4-4 4 4"/>
                    </svg>
                </div>
                <div class="food-info">
                    <div class="food-title">Combo B (Popcorn + 2 Drinks)</div>
                    <div class="food-price">RM 18.90</div>
                    <div class="food-stock instock">In Stock</div>
                    <div class="food-actions">
                        <div class="quantity-selector">
                            <button class="qty-btn minus">-</button>
                            <span class="qty">0</span>
                            <button class="qty-btn plus">+</button>
                        </div>
                        <button class="btn-cart add-to-cart">Add to Cart</button>
                    </div>
                </div>
            </div>

            <!-- Snacks -->
            <div class="food-card" data-category="snacks">
                <div class="food-image">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83"/>
                        <circle cx="12" cy="12" r="4"/>
                    </svg>
                </div>
                <div class="food-info">
                    <div class="food-title">Nuggets (6pcs)</div>
                    <div class="food-price">RM 11.90</div>
                    <div class="food-stock instock">In Stock</div>
                    <div class="food-actions">
                        <div class="quantity-selector">
                            <button class="qty-btn minus">-</button>
                            <span class="qty">0</span>
                            <button class="qty-btn plus">+</button>
                        </div>
                        <button class="btn-cart add-to-cart">Add to Cart</button>
                    </div>
                </div>
            </div>

            <div class="food-card" data-category="snacks">
                <div class="food-image">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M12 2c-2 0-4 2-4 4 0 4 4 8 4 8s4-4 4-8c0-2-2-4-4-4z"/>
                        <path d="M8 6h8"/>
                    </svg>
                </div>
                <div class="food-info">
                    <div class="food-title">Nachos</div>
                    <div class="food-price">RM 10.90</div>
                    <div class="food-stock instock">In Stock</div>
                    <div class="food-actions">
                        <div class="quantity-selector">
                            <button class="qty-btn minus">-</button>
                            <span class="qty">0</span>
                            <button class="qty-btn plus">+</button>
                        </div>
                        <button class="btn-cart add-to-cart">Add to Cart</button>
                    </div>
                </div>
            </div>

            <div class="food-card" data-category="snacks">
                <div class="food-image">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M6 12h12"/>
                        <path d="M12 6v12"/>
                    </svg>
                </div>
                <div class="food-info">
                    <div class="food-title">Hot Dog</div>
                    <div class="food-price">RM 9.90</div>
                    <div class="food-stock lowstock">Running Low</div>
                    <div class="food-actions">
                        <div class="quantity-selector">
                            <button class="qty-btn minus">-</button>
                            <span class="qty">0</span>
                            <button class="qty-btn plus">+</button>
                        </div>
                        <button class="btn-cart add-to-cart">Add to Cart</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Floating Cart -->
        <div class="floating-cart" id="floatingCart">
            <div class="cart-header" onclick="toggleCart()">
                <div class="flex-between">
                    <h3 class="cart-title">Your Order</h3>
                    <span class="cart-badge-count" id="cartItemCount">0</span>
                </div>
            </div>
            <div class="cart-items" id="cartItems">
                <div class="empty-cart-msg">No items added yet</div>
            </div>
            <div class="cart-footer" id="cartFooter">
                <div class="cart-total" id="cartTotal">RM 0.00</div>
                <button class="btn btn-primary btn-checkout" onclick="checkout()">Proceed to Payment →</button>
            </div>
        </div>
    </div>
</main>

<script>
let cart = [];

function filterFood(category) {
    document.querySelectorAll('.food-card').forEach(card => {
        card.style.display = category === 'all' || card.dataset.category === category ? '' : 'none';
    });
    document.querySelectorAll('.btn-filter').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.category === category);
    });
}

function updateCartDisplay() {
    const cartItemsDiv = document.getElementById('cartItems');
    const cartFooter = document.getElementById('cartFooter');
    const cartItemCount = document.getElementById('cartItemCount');
    
    if (cart.length === 0) {
        cartItemsDiv.innerHTML = '<div class="empty-cart-msg">No items added yet</div>';
        cartFooter.style.display = 'none';
        cartItemCount.innerText = '0';
        return;
    }
    
    let total = 0;
    let itemCount = 0;
    let html = '';
    
    cart.forEach((item, index) => {
        const itemTotal = item.price * item.quantity;
        total += itemTotal;
        itemCount += item.quantity;
        html += `
            <div class="cart-item">
                <div>
                    <div class="cart-item-title">${item.title}</div>
                    <div class="cart-item-qty">×${item.quantity}</div>
                </div>
                <div class="cart-item-actions">
                    <span class="cart-item-price">RM ${itemTotal.toFixed(2)}</span>
                    <button class="cart-remove" onclick="removeFromCart(${index})">✕</button>
                </div>
            </div>
        `;
    });
    
    cartItemsDiv.innerHTML = html;
    cartFooter.style.display = 'block';
    document.getElementById('cartTotal').innerHTML = `RM ${total.toFixed(2)}`;
    cartItemCount.innerText = itemCount;
    sessionStorage.setItem('foodCart', JSON.stringify(cart));
}

function removeFromCart(index) {
    cart.splice(index, 1);
    updateCartDisplay();
}

function toggleCart() {
    document.getElementById('floatingCart').classList.toggle('expanded');
}

function checkout() {
    window.location.href = 'payment.jsp' + (<%= showBackToBooking %> ? '?fromFood=true' : '');
}

// Event delegation for dynamic elements
document.addEventListener('click', function(e) {
    // Filter buttons
    if (e.target.classList.contains('btn-filter')) {
        filterFood(e.target.dataset.category);
    }
    
    // Quantity buttons
    if (e.target.classList.contains('qty-btn')) {
        const qtySpan = e.target.parentElement.querySelector('.qty');
        let qty = parseInt(qtySpan.innerText);
        qty = Math.max(0, qty + (e.target.classList.contains('plus') ? 1 : -1));
        qtySpan.innerText = qty;
    }
    
    // Add to cart
    if (e.target.classList.contains('add-to-cart')) {
        const card = e.target.closest('.food-card');
        const title = card.querySelector('.food-title').innerText;
        const priceText = card.querySelector('.food-price').innerText;
        const price = parseFloat(priceText.replace('RM ', ''));
        const qtySpan = card.querySelector('.qty');
        const quantity = parseInt(qtySpan.innerText);
        
        if (quantity === 0) return;
        
        const existing = cart.findIndex(item => item.title === title);
        if (existing !== -1) {
            cart[existing].quantity += quantity;
        } else {
            cart.push({ title, price, quantity });
        }
        
        qtySpan.innerText = '0';
        updateCartDisplay();
    }
});

// Load saved cart
window.onload = function() {
    const saved = sessionStorage.getItem('foodCart');
    if (saved) {
        cart = JSON.parse(saved);
        updateCartDisplay();
    }
};
</script>

<%@ include file="footer.jsp" %>