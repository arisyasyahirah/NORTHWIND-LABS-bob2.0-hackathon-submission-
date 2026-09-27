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
                <tbody>
                    <tr><td class="td-id">F001</td><td>Regular Popcorn</td><td class="price">RM 8.90</td><td><input type="number" class="stock-input" value="245" min="0"></td><td><span class="status instock">In Stock</span></td><td><button class="btn-update" onclick="updateStock(this, 'F001')">Update</button></td></tr>
                    <tr><td class="td-id">F002</td><td>Large Popcorn</td><td class="price">RM 12.90</td><td><input type="number" class="stock-input" value="178" min="0"></td><td><span class="status instock">In Stock</span></td><td><button class="btn-update" onclick="updateStock(this, 'F002')">Update</button></td></tr>
                    <tr><td class="td-id">F003</td><td>Coca-Cola</td><td class="price">RM 5.90</td><td><input type="number" class="stock-input" value="32" min="0"></td><td><span class="status lowstock">Low Stock</span></td><td><button class="btn-update" onclick="updateStock(this, 'F003')">Update</button></td></tr>
                    <tr><td class="td-id">F004</td><td>Nuggets (6pcs)</td><td class="price">RM 11.90</td><td><input type="number" class="stock-input" value="89" min="0"></td><td><span class="status instock">In Stock</span></td><td><button class="btn-update" onclick="updateStock(this, 'F004')">Update</button></td></tr>
                    <tr><td class="td-id">F005</td><td>Nachos</td><td class="price">RM 10.90</td><td><input type="number" class="stock-input" value="15" min="0"></td><td><span class="status lowstock">Low Stock</span></td><td><button class="btn-update" onclick="updateStock(this, 'F005')">Update</button></td></tr>
                </tbody>
            </table>
        </div>

        <div id="addForm" class="add-form" style="display: none;">
            <h3>Add New Food Item</h3>
            <div class="form-grid">
                <div class="form-group"><label>Food ID</label><input type="text" id="newFoodId" class="form-input" placeholder="e.g. F006"></div>
                <div class="form-group"><label>Item Name</label><input type="text" id="newFoodName" class="form-input" placeholder="e.g. Hot Dog"></div>
                <div class="form-group"><label>Price (RM)</label><input type="number" id="newFoodPrice" class="form-input" placeholder="9.90" step="0.01"></div>
                <div class="form-group"><label>Initial Stock</label><input type="number" id="newFoodStock" class="form-input" placeholder="100"></div>
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
}
function showAddForm() { document.getElementById('addForm').style.display = 'block'; }
function hideAddForm() { document.getElementById('addForm').style.display = 'none'; }
function addFoodItem() { alert("New food item added!"); hideAddForm(); location.reload(); }
</script>

<%@ include file="manager-footer.jsp" %>