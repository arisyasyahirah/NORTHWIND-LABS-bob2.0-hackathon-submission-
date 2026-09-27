<%@page import="java.util.ArrayList"%>
<%@page import="com.ctms.model.Food"%>
<%@page import="com.ctms.dao.FoodDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<%
    String fromBooking = request.getParameter("fromBooking");
    boolean showBackToBooking = "true".equals(fromBooking);

    // Gain the food list
    FoodDAO foodDAO = new FoodDAO();
    ArrayList<Food> foodList = foodDAO.getFoodList();
    
    if (foodList == null){
        System.out.println("The foodlist is empty");
    }
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
                    <% }%>
                    <span>Snacks & Drinks</span>
                </div>
                <h1>CINEMA <span>MENU</span></h1>
                <div class="section-sub">Add to your movie experience</div>
            </div>
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
            <%
                for (int i = 0; i < foodList.size(); i++) {
                    String name = foodList.get(i).getName();
                    float price = foodList.get(i).getPrice();
                    int quantity = foodList.get(i).getQuantity();
                    boolean availability = foodList.get(i).getAvailability();
                    int category = foodList.get(i).getCategory();

                    String status = (quantity >= 100) ? "In Stock" : "Low Stock";
            %> 

            
            <!-- data-category: popcorn, beverages, combos, snacks -->

            <div class="food-card" data-category=<%= category %>>
                <div class="food-image">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="M12 6v6l4 2"/>
                    </svg>
                </div>
                <div class="food-info">
                    <div class="food-title"><%= name%></div>
                    <div class="food-price"><%= price%></div>
                    <%
                        if (quantity >= 100) {
                    %>  
                    <div class="food-stock instock">In Stock</div>
                    <%
                        } else {
                    %>
                    <div class="food-stock lowstock">Low Stock</div>
                    <%
                        }
                    %>
                    
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
            <%
                }
            %>

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
            console.log("Title: ", item.title);
            
            const itemTotal = item.price * item.quantity;
            total += itemTotal;
            itemCount += item.quantity;
            // adding $ will cause the jsp execute the code, add backslash to let jsp ignore the commands
            html += `
            <div class="cart-item">
                <div>
                    <div class="cart-item-title">\${item.title}</div>
                    <div class="cart-item-qty">×\${item.quantity}</div>
                </div>
                <div class="cart-item-actions">
                    <span class="cart-item-price">RM \${itemTotal.toFixed(2)}</span>
                    <button class="cart-remove" onclick="removeFromCart(\${index})">✕</button>
                </div>
            </div>
            `;
        });

        cartItemsDiv.innerHTML = html;
        cartFooter.style.display = 'block';
        document.getElementById('cartTotal').innerHTML = `RM \${total.toFixed(2)}`;
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
        window.location.href = 'payment.jsp' + (<%= showBackToBooking%> ? '?fromFood=true' : '');
    }

    // Event delegation for dynamic elements
    document.addEventListener('click', function (e) {
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

            if (quantity === 0)
                return;

            const existing = cart.findIndex(item => item.title === title);
            if (existing !== -1) {
                cart[existing].quantity += quantity;
            } else {
                cart.push({title: title, price: price, quantity: quantity});
                console.log("Item added.");
            }

            qtySpan.innerText = '0';
            updateCartDisplay();
            
        }
    });

// Load saved cart
    window.onload = function () {
        const saved = sessionStorage.getItem('foodCart');
        if (saved) {
            cart = JSON.parse(saved);
            updateCartDisplay();
        }
    };
</script>

<%@ include file="footer.jsp" %>