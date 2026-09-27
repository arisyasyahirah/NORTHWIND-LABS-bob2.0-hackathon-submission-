<%@page import="java.util.ArrayList"%>
<%@page import="model.Food"%>
<%@page import="model.Food"%>
<%@page import="DAO.FoodDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="manager-header.jsp" %>

<main class="page-offset">
    <div class="container">

        <div class="page-header">
            <h1>FOOD <span>INVENTORY</span></h1>
            <span class="role-badge manager">MANAGER ONLY</span>
        </div>

        <div class="staff-panel">
            <div class="panel-header">
                <h3>Current Stock</h3>
                <button class="btn-add" onclick="showAddForm()">+ Add Item</button>
            </div>

            <table class="data-table">
                <thead><tr><th>Food ID</th><th>Item Name</th><th>Price</th><th>Current Stock</th><th>Status</th><th>Action</th></tr></thead>
                <tbody id="tableBody">
                    <%
                        // Gain the food list
                        FoodDAO foodDAO = new FoodDAO();
                        ArrayList<Food> foodList = foodDAO.getFoodList();

                        String id = "";
                        String name = "";
                        float price = 0.0f;
                        int quantity = 0;
                        boolean availability = false;
                        String status = "";

                        for (int i = 0; i < foodList.size(); i++) {
                            System.out.println("Size: " + foodList.size());
                            id = foodList.get(i).getId();
                            name = foodList.get(i).getName();
                            price = foodList.get(i).getPrice();
                            quantity = foodList.get(i).getQuantity();
                            availability = foodList.get(i).getAvailability();

                            status = (quantity > 50) ? "In Stock" : "Low Stock";

                    %>
                    <tr>
                        <td class="td-id"><%= id%></td>
                        <td><%= name%></td>
                        <td class="price">RM <%= price%></td>
                        <td><input type="number" class="stock-input" value=<%= quantity%> min="0"></td>
                            <%
                                if (quantity > 50) {
                            %>  
                                <td><span class="status instock"><%= status%></span></td>
                            <%
                                } else if (quantity <= 50 && quantity > 0) {
                            %>
                                <td><span class="status lowstock"><%= status%></span></td>
                            <%
                                } else {
                            %>
                                <td><span class="status nostock">No stock</span></td>
                            <%
                                }
                            %>
                        <td><button class="btn-update" onclick="updateStock(this, '<%= id%>')">Update</button></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div id="addForm" class="add-form" style="display: none;">
            <h3>Add New Food Item</h3>
            <div class="form-grid">
                <!-- <div class="form-group"><label>Food ID</label><input type="text" id="newFoodId" class="form-input" placeholder="e.g. F006"></div> -->
                <div class="form-group"><label>Item Name</label><input type="text" id="newFoodName" class="form-input" placeholder="e.g. Hot Dog"></div>
                <div class="form-group"><label>Price (RM)</label><input type="number" id="newFoodPrice" class="form-input" placeholder="9.90" step="0.01"></div>
                <div class="form-group"><label>Initial Stock</label><input type="number" id="newFoodStock" class="form-input" placeholder="100"></div>
                <div class="form-group"><label>Category</label>
                    <select id="newFoodCategory" class="form-input">
                        <option value="popcorn" >Popcorn</option>
                        <option value="beverages">Beverages</option>
                        <option value="combo">Combos</option>
                        <option value="snacks">Snacks</option>
                    </select>
                </div>
            </div>
            <div class="form-actions">
                <button class="btn-ghost" onclick="hideAddForm()">Cancel</button>
                <button class="btn-ready" onclick="addFoodItem()">Add Item</button>
            </div>
        </div>

        <div class="alert-info">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/>
            </svg>
            Note: Food prices are set by HQ and cannot be edited by Manager.
        </div>
    </div>
</main>

<script>
    function updateStock(btn, foodId) {
        let row = btn.closest('tr');
        let newStock = row.querySelector('.stock-input').value;
        alert("Stock updated for " + foodId + " to " + newStock + " units");

        // Udpate food current stock
        const formData = new URLSearchParams();

        formData.append("action", "UpdateFoodStock");
        formData.append("foodId", foodId);
        formData.append("foodStock", newStock);

        fetch("${pageContext.request.contextPath}/menuServlet", {
            method: "POST",
            body: formData
        });
    }
    function showAddForm() {
        document.getElementById('addForm').style.display = 'block';
    }
    function hideAddForm() {
        document.getElementById('addForm').style.display = 'none';
    }

    function addFoodItem() {
        var foodName = document.getElementById("newFoodName").value;
        var foodPrice = document.getElementById("newFoodPrice").value;
        var foodStock = document.getElementById("newFoodStock").value;
        var foodCategory = document.getElementById("newFoodCategory").value;
        console.log("Food Category: " + foodCategory);

        // Send the food record to menuServet
        const formData = new URLSearchParams();

        formData.append("action", "AddNewFoodRecord");
        formData.append("foodName", foodName);
        formData.append("foodPrice", foodPrice);
        formData.append("foodStock", foodStock);
        formData.append("foodCategory", foodCategory);

        fetch("${pageContext.request.contextPath}/menuServlet", {
            method: 'POST',
            body: formData
        }).then(function () {
            // Wait a bit and refresh tha page
            alert("New food item added!");
            hideAddForm();
            location.reload();
        });
    }
</script>

<%@ include file="manager-footer.jsp" %>