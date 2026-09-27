<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="maanger-header.jsp" %>

<main class="page-offset">
    <div class="container">
        
        <div class="page-header">
            <h1>MANAGE <span>STAFF</span></h1>
            <span class="role-badge manager">MANAGER VIEW</span>
        </div>

        <!-- Staff List -->
        <div class="staff-panel">
            <div class="panel-header">
                <h3>Staff List - TRX Cinema</h3>
                <button class="btn-add" onclick="showAddStaffForm()">+ Add Staff</button>
            </div>
            
            <table class="staff-table" id="staffTable">
                <thead>
                    <tr><th>Employee ID</th><th>Name</th><th>Position</th><th>Phone</th><th>Level</th><th>Actions</th></tr>
                </thead>
                <tbody>
                    <tr><td class="td-id">E001</td><td class="td-name">John Staff</td><td>Cashier</td><td>012-3456789</td><td><span class="status instock">Level 1</span></td>
                        <td class="action-icons"><button class="edit-icon" onclick="openEditModal('E001', 'John Staff', 'Cashier', '012-3456789', '1')">✎</button><button class="delete-icon" onclick="deleteStaff('E001')">🗑</button></td>
                    </tr>
                    <tr><td class="td-id">E002</td><td class="td-name">Sarah Cashier</td><td>Cashier</td><td>013-4567890</td><td><span class="status instock">Level 1</span></td>
                        <td class="action-icons"><button class="edit-icon" onclick="openEditModal('E002', 'Sarah Cashier', 'Cashier', '013-4567890', '1')">✎</button><button class="delete-icon" onclick="deleteStaff('E002')">🗑</button></td>
                    </tr>
                    <tr><td class="td-id">E003</td><td class="td-name">Mike Supervisor</td><td>Supervisor</td><td>014-5678901</td><td><span class="status lowstock">Level 2</span></td>
                        <td class="action-icons"><button class="edit-icon" onclick="openEditModal('E003', 'Mike Supervisor', 'Supervisor', '014-5678901', '2')">✎</button><button class="delete-icon" onclick="deleteStaff('E003')">🗑</button></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Add Staff Form (Hidden by default) -->
        <div id="addStaffForm" class="add-form" style="display: none;">
            <h3>Add New Staff Member</h3>
            <div class="form-grid">
                <div class="form-group"><label>Employee ID</label><input type="text" id="newEmpId" class="form-input" placeholder="e.g. E004"></div>
                <div class="form-group"><label>Full Name</label><input type="text" id="newEmpName" class="form-input" placeholder="Full name"></div>
                <div class="form-group"><label>Email</label><input type="email" id="newEmpEmail" class="form-input" placeholder="email@cineorder.com"></div>
                <div class="form-group"><label>Phone</label><input type="text" id="newEmpPhone" class="form-input" placeholder="0123456789"></div>
                <div class="form-group"><label>Position</label>
                    <select id="newEmpPosition" class="form-input">
                        <option>Cashier</option>
                        <option>Supervisor</option>
                        <option>Ticket Checker</option>
                    </select>
                </div>
                <div class="form-group"><label>Level</label>
                    <select id="newEmpLevel" class="form-input">
                        <option value="1">Level 1 - Staff</option>
                        <option value="2">Level 2 - Manager</option>
                    </select>
                </div>
            </div>
            <div class="form-actions">
                <button class="btn-ghost" onclick="hideAddStaffForm()">Cancel</button>
                <button class="btn-ready" onclick="addStaff()">Add Staff</button>
            </div>
        </div>
    </div>
</main>

<!-- Edit Modal -->
<div id="editModal" class="modal" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Edit Staff Member</h3>
            <button class="modal-close" onclick="closeEditModal()">×</button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="editEmpId">
            <div class="form-group"><label>Full Name</label><input type="text" id="editEmpName" class="form-input"></div>
            <div class="form-group"><label>Phone</label><input type="text" id="editEmpPhone" class="form-input"></div>
            <div class="form-group"><label>Position</label>
                <select id="editEmpPosition" class="form-input">
                    <option>Cashier</option>
                    <option>Supervisor</option>
                    <option>Ticket Checker</option>
                </select>
            </div>
            <div class="form-group"><label>Level</label>
                <select id="editEmpLevel" class="form-input">
                    <option value="1">Level 1 - Staff</option>
                    <option value="2">Level 2 - Manager</option>
                </select>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-ghost" onclick="closeEditModal()">Cancel</button>
            <button class="btn-ready" onclick="saveEdit()">Save Changes</button>
        </div>
    </div>
</div>

<style>
.modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.8);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
}
.modal-content {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 8px;
    width: 90%;
    max-width: 500px;
    overflow: hidden;
}
.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 20px;
    border-bottom: 1px solid var(--border);
    background: rgba(0,0,0,0.2);
}
.modal-header h3 {
    margin: 0;
    color: var(--khaki-light);
}
.modal-close {
    background: none;
    border: none;
    color: var(--text-muted);
    font-size: 24px;
    cursor: pointer;
}
.modal-close:hover {
    color: var(--red);
}
.modal-body {
    padding: 20px;
}
.modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    padding: 16px 20px;
    border-top: 1px solid var(--border);
}
</style>

<script>
// Edit Modal Functions
function openEditModal(id, name, position, phone, level) {
    document.getElementById('editEmpId').value = id;
    document.getElementById('editEmpName').value = name;
    document.getElementById('editEmpPhone').value = phone;
    document.getElementById('editEmpPosition').value = position;
    document.getElementById('editEmpLevel').value = level;
    document.getElementById('editModal').style.display = 'flex';
}

function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
}

function saveEdit() {
    var id = document.getElementById('editEmpId').value;
    var newName = document.getElementById('editEmpName').value;
    var newPhone = document.getElementById('editEmpPhone').value;
    var newPosition = document.getElementById('editEmpPosition').value;
    var newLevel = document.getElementById('editEmpLevel').value;
    
    // Find the row in the table and update it
    var rows = document.querySelectorAll('#staffTable tbody tr');
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        var rowId = row.querySelector('.td-id').innerText;
        if (rowId === id) {
            // Update name
            row.querySelector('.td-name').innerText = newName;
            // Update position (2nd column)
            row.cells[2].innerHTML = newPosition;
            // Update phone (3rd column)
            row.cells[3].innerHTML = newPhone;
            // Update level badge
            var levelText = newLevel === '1' ? 'Level 1' : 'Level 2';
            var levelClass = newLevel === '1' ? 'instock' : 'lowstock';
            row.cells[4].innerHTML = '<span class="status ' + levelClass + '">' + levelText + '</span>';
            break;
        }
    }
    
    alert("Staff member " + id + " updated successfully!");
    closeEditModal();
}

// Add Staff Functions
function showAddStaffForm() {
    document.getElementById('addStaffForm').style.display = 'block';
}

function hideAddStaffForm() {
    document.getElementById('addStaffForm').style.display = 'none';
}

function addStaff() {
    var newId = document.getElementById('newEmpId').value;
    var newName = document.getElementById('newEmpName').value;
    var newEmail = document.getElementById('newEmpEmail').value;
    var newPhone = document.getElementById('newEmpPhone').value;
    var newPosition = document.getElementById('newEmpPosition').value;
    var newLevel = document.getElementById('newEmpLevel').value;
    
    if (!newId || !newName) {
        alert("Please fill in Employee ID and Name");
        return;
    }
    
    var levelText = newLevel === '1' ? 'Level 1' : 'Level 2';
    var levelClass = newLevel === '1' ? 'instock' : 'lowstock';
    
    // Add new row to table
    var table = document.querySelector('#staffTable tbody');
    var newRow = table.insertRow();
    newRow.innerHTML = `
        <td class="td-id">${newId}</td>
        <td class="td-name">${newName}</td>
        <td>${newPosition}</td>
        <td>${newPhone}</td>
        <td><span class="status ${levelClass}">${levelText}</span></td>
        <td class="action-icons">
            <button class="edit-icon" onclick="openEditModal('${newId}', '${newName}', '${newPosition}', '${newPhone}', '${newLevel}')">✎</button>
            <button class="delete-icon" onclick="deleteStaff('${newId}')">🗑</button>
        </td>
    `;
    
    alert("Staff member " + newName + " added successfully!");
    hideAddStaffForm();
    
    // Clear form
    document.getElementById('newEmpId').value = '';
    document.getElementById('newEmpName').value = '';
    document.getElementById('newEmpEmail').value = '';
    document.getElementById('newEmpPhone').value = '';
}

// Delete Staff
function deleteStaff(id) {
    if (confirm("Delete staff member " + id + "? This action cannot be undone.")) {
        var rows = document.querySelectorAll('#staffTable tbody tr');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            var rowId = row.querySelector('.td-id').innerText;
            if (rowId === id) {
                row.remove();
                alert("Staff member " + id + " deleted.");
                break;
            }
        }
    }
}
</script>

<%@ include file="manager-footer.jsp" %>