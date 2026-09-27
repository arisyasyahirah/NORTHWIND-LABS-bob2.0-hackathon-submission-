<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="hq-header.jsp" %>

<main class="page-offset">
    <div class="container">
        
        <div class="page-header">
            <h1>HALL <span>MANAGEMENT</span></h1>
            <span class="role-badge hq">HQ - FULL CONTROL</span>
        </div>

        <div class="staff-panel">
            <div class="panel-header">
                <h3>All Halls</h3>
                <button class="hq-btn-add" id="addHallBtn">+ Add Hall</button>
            </div>
            
            <table class="hq-hall-table" id="hallTable">
                <thead>
                    <tr>
                        <th>Hall ID</th>
                        <th>Hall Type</th>
                        <th>Category</th>
                        <th>Price (RM)</th>
                        <th>Seats</th>
                        <th>Availability</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="hallTableBody">
                    <tr data-id="H001">
                        <td class="td-id">H001</td>
                        <td>IMAX</td>
                        <td>Premium</td>
                        <td class="price">28.00</td>
                        <td>180</td>
                        <td><span class="status available">Available</span></td>
                        <td>
                            <button class="edit-btn" data-id="H001">Edit</button>
                            <button class="delete-btn" data-id="H001">Delete</button>
                        </td>
                    </tr>
                    <tr data-id="H002">
                        <td class="td-id">H002</td>
                        <td>Dolby Atmos</td>
                        <td>Premium</td>
                        <td class="price">24.00</td>
                        <td>150</td>
                        <td><span class="status available">Available</span></td>
                        <td>
                            <button class="edit-btn" data-id="H002">Edit</button>
                            <button class="delete-btn" data-id="H002">Delete</button>
                        </td>
                    </tr>
                    <tr data-id="H003">
                        <td class="td-id">H003</td>
                        <td>Gold Class</td>
                        <td>Luxury</td>
                        <td class="price">45.00</td>
                        <td>48</td>
                        <td><span class="status available">Available</span></td>
                        <td>
                            <button class="edit-btn" data-id="H003">Edit</button>
                            <button class="delete-btn" data-id="H003">Delete</button>
                        </td>
                    </tr>
                    <tr data-id="H004">
                        <td class="td-id">H004</td>
                        <td>Standard</td>
                        <td>Regular</td>
                        <td class="price">18.00</td>
                        <td>200</td>
                        <td><span class="status unavailable">Unavailable</span></td>
                        <td>
                            <button class="edit-btn" data-id="H004">Edit</button>
                            <button class="delete-btn" data-id="H004">Delete</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- Modal -->
<div id="hallModal" class="modal" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="modalTitle">Add New Hall</h3>
            <button class="modal-close" id="closeModalBtn">&times;</button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="editingId">
            <div class="form-group">
                <label class="form-label">Hall ID</label>
                <input type="text" id="hallId" class="form-input" placeholder="e.g. H005">
            </div>
            <div class="form-group">
                <label class="form-label">Hall Type</label>
                <select id="hallType" class="form-input">
                    <option>IMAX</option>
                    <option>Dolby Atmos</option>
                    <option>Gold Class</option>
                    <option>Standard</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Category</label>
                <select id="hallCategory" class="form-input">
                    <option>Premium</option>
                    <option>Luxury</option>
                    <option>Regular</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Price (RM)</label>
                <input type="number" id="hallPrice" class="form-input" step="0.01">
            </div>
            <div class="form-group">
                <label class="form-label">Total Seats</label>
                <input type="number" id="hallSeats" class="form-input">
            </div>
            <div class="form-group">
                <label class="form-label">Availability</label>
                <select id="hallStatus" class="form-input">
                    <option value="Available">Available</option>
                    <option value="Unavailable">Unavailable</option>
                </select>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-ghost" id="cancelModalBtn">Cancel</button>
            <button class="btn-primary" id="saveHallBtn">Save Hall</button>
        </div>
    </div>
</div>

<script>
// Get elements
var addBtn = document.getElementById('addHallBtn');
var modal = document.getElementById('hallModal');
var closeBtn = document.getElementById('closeModalBtn');
var cancelBtn = document.getElementById('cancelModalBtn');
var saveBtn = document.getElementById('saveHallBtn');
var modalTitle = document.getElementById('modalTitle');
var editingId = document.getElementById('editingId');
var hallIdInput = document.getElementById('hallId');
var hallTypeSelect = document.getElementById('hallType');
var hallCategorySelect = document.getElementById('hallCategory');
var hallPriceInput = document.getElementById('hallPrice');
var hallSeatsInput = document.getElementById('hallSeats');
var hallStatusSelect = document.getElementById('hallStatus');

// Open modal for Add
addBtn.onclick = function() {
    modalTitle.innerText = 'Add New Hall';
    editingId.value = '';
    hallIdInput.value = '';
    hallTypeSelect.value = 'IMAX';
    hallCategorySelect.value = 'Premium';
    hallPriceInput.value = '';
    hallSeatsInput.value = '';
    hallStatusSelect.value = 'Available';
    modal.style.display = 'flex';
}

// Close modal
function closeModal() {
    modal.style.display = 'none';
}

closeBtn.onclick = closeModal;
cancelBtn.onclick = closeModal;

// Click outside to close
modal.onclick = function(e) {
    if (e.target === modal) {
        closeModal();
    }
}

// Edit buttons
document.querySelectorAll('.edit-btn').forEach(function(btn) {
    btn.onclick = function() {
        var id = this.getAttribute('data-id');
        var row = document.querySelector('tr[data-id="' + id + '"]');
        
        modalTitle.innerText = 'Edit Hall';
        editingId.value = id;
        hallIdInput.value = row.cells[0].innerText;
        hallTypeSelect.value = row.cells[1].innerText;
        hallCategorySelect.value = row.cells[2].innerText;
        hallPriceInput.value = row.cells[3].innerText;
        hallSeatsInput.value = row.cells[4].innerText;
        
        var statusSpan = row.cells[5].querySelector('span');
        hallStatusSelect.value = statusSpan.innerText;
        
        modal.style.display = 'flex';
    }
});

// Delete buttons
document.querySelectorAll('.delete-btn').forEach(function(btn) {
    btn.onclick = function() {
        var id = this.getAttribute('data-id');
        if (confirm('Delete hall ' + id + '? This cannot be undone.')) {
            var row = document.querySelector('tr[data-id="' + id + '"]');
            row.remove();
            alert('Hall ' + id + ' deleted.');
        }
    }
});

// Save button
saveBtn.onclick = function() {
    var isEdit = editingId.value !== '';
    var hallId = hallIdInput.value;
    var hallType = hallTypeSelect.value;
    var hallCategory = hallCategorySelect.value;
    var hallPrice = parseFloat(hallPriceInput.value).toFixed(2);
    var hallSeats = hallSeatsInput.value;
    var hallStatus = hallStatusSelect.value;
    
    if (!hallId || !hallPrice || !hallSeats) {
        alert('Please fill all fields');
        return;
    }
    
    var statusClass = hallStatus === 'Available' ? 'available' : 'unavailable';
    var statusHtml = '<span class="status ' + statusClass + '">' + hallStatus + '</span>';
    
    if (isEdit) {
        // Update existing row
        var row = document.querySelector('tr[data-id="' + editingId.value + '"]');
        row.cells[0].innerText = hallId;
        row.cells[1].innerText = hallType;
        row.cells[2].innerText = hallCategory;
        row.cells[3].innerText = hallPrice;
        row.cells[4].innerText = hallSeats;
        row.cells[5].innerHTML = statusHtml;
        row.setAttribute('data-id', hallId);
        
        // Update buttons data-id
        row.querySelector('.edit-btn').setAttribute('data-id', hallId);
        row.querySelector('.delete-btn').setAttribute('data-id', hallId);
        
        alert('Hall updated successfully!');
    } else {
        // Add new row
        var tbody = document.getElementById('hallTableBody');
        var newRow = tbody.insertRow();
        newRow.setAttribute('data-id', hallId);
        newRow.innerHTML = `
            <td class="td-id">${hallId}</td>
            <td>${hallType}</td>
            <td>${hallCategory}</td>
            <td class="price">${hallPrice}</td>
            <td>${hallSeats}</td>
            <td>${statusHtml}</td>
            <td>
                <button class="edit-btn" data-id="${hallId}">Edit</button>
                <button class="delete-btn" data-id="${hallId}">Delete</button>
            </td>
        `;
        
        // Attach events to new buttons
        newRow.querySelector('.edit-btn').onclick = function() {
            var id = this.getAttribute('data-id');
            var row = document.querySelector('tr[data-id="' + id + '"]');
            modalTitle.innerText = 'Edit Hall';
            editingId.value = id;
            hallIdInput.value = row.cells[0].innerText;
            hallTypeSelect.value = row.cells[1].innerText;
            hallCategorySelect.value = row.cells[2].innerText;
            hallPriceInput.value = row.cells[3].innerText;
            hallSeatsInput.value = row.cells[4].innerText;
            var span = row.cells[5].querySelector('span');
            hallStatusSelect.value = span.innerText;
            modal.style.display = 'flex';
        };
        
        newRow.querySelector('.delete-btn').onclick = function() {
            var id = this.getAttribute('data-id');
            if (confirm('Delete hall ' + id + '? This cannot be undone.')) {
                document.querySelector('tr[data-id="' + id + '"]').remove();
                alert('Hall ' + id + ' deleted.');
            }
        };
        
        alert('New hall added successfully!');
    }
    
    closeModal();
    location.reload();
}
</script>

<%@ include file="hq-footer.jsp" %>