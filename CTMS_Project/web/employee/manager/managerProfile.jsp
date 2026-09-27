<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="manager-header.jsp" %>

<%
    String managerPosition = "Cinema Manager";
    String managerCinema = "TRX";
    String joinDate = "10 January 2022";
    String staffCount = "12";
%>

<main class="page-offset">
    <div class="container" style="max-width: 1000px; margin: 0 auto; padding: 40px 20px;">

        <div class="page-header">
            <h1>MY <span>PROFILE</span></h1>
            <span class="role-badge manager">MANAGER - LEVEL 2</span>
        </div>

        <div class="profile-layout">

            <div class="profile-sidebar">
                <div class="profile-avatar-section">
                    <div class="profile-avatar" id="avatarLetter">S</div>
                    <div class="profile-name-sidebar" id="sidebarName">${sessionScope.employee.name}</div>
                    <div class="profile-email-sidebar" id="sidebarEmail">${sessionScope.employee.email}</div>
                    <div class="profile-cinema"><%= managerCinema%> Cinema</div>
                    <div class="profile-role-badge"><span class="role-manager-badge">MANAGER</span></div>
                </div>

                <div class="profile-nav">
                    <button class="profile-nav-item active" onclick="showTab('info')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                        </svg>
                        Personal Info
                    </button>
                    <button class="profile-nav-item" onclick="showTab('team')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                        My Team
                    </button>
                    <button class="profile-nav-item" onclick="showTab('schedule')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <rect x="3" y="4" width="18" height="18" rx="2"/>
                        <line x1="16" y1="2" x2="16" y2="6"/>
                        <line x1="8" y1="2" x2="8" y2="6"/>
                        <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                        My Schedule
                    </button>
                    <button class="profile-nav-item" onclick="location.href = '${pageContext.request.contextPath}/Logout.jsp'">Logout</button>
                </div>
            </div>

            <div class="profile-main">

                <div id="tab-info" class="profile-tab-pane active">
                    <div class="profile-pane-header">
                        <div class="profile-pane-title">PERSONAL INFORMATION</div>
                        <div class="profile-pane-sub">Employee ID: ${sessionScope.employee.id}</div>
                    </div>
                    <div class="profile-pane-body">
                        <div class="profile-form-grid">
                            <div class="form-group">
                                <label class="form-label">Full Name</label>
                                <input type="text" id="fullName" class="form-input" value="${sessionScope.employee.name}" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email Address</label>
                                <input type="email" id="email" class="form-input" value="${sessionScope.employee.email}" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" id="phone" class="form-input" maxlength="15" value="${sessionScope.employee.phoneNumber}" disabled>
                                <p id="errorMessage" style="display: none; margin: 0px;">Phone number cannot more that 15 character. </p>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Position</label>
                                <input class="form-input" value="<%= managerPosition%>" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Cinema</label>
                                <input class="form-input" value="<%= managerCinema%>" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Join Date</label>
                                <input class="form-input" value="<%= joinDate%>" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Team Size</label>
                                <input class="form-input" value="<%= staffCount%> staff members" disabled>
                            </div>
                        </div>
                        <div class="profile-actions">
                            <button class="btn-edit-profile" id="editBtn" onclick="enableEdit()">Edit Profile</button>
                            <button class="btn-save" id="saveBtn" style="display:none;" onclick="saveProfile()">Save Changes</button>
                            <button class="btn-cancel" id="cancelBtn" style="display:none;" onclick="cancelEdit()">Cancel</button>
                        </div>
                    </div>
                </div>

                <div id="tab-team" class="profile-tab-pane">
                    <div class="profile-pane-header">
                        <div class="profile-pane-title">MY TEAM</div>
                        <div class="profile-pane-sub">Staff members at <%= managerCinema%> Cinema</div>
                    </div>
                    <div class="profile-pane-body">
                        <table class="employee-table">
                            <thead><tr><th>Employee ID</th><th>Name</th><th>Position</th><th>Phone</th></tr></thead>
                            <tbody>
                                <tr><td class="td-id">E001</td><td>John Staff</td><td>Cashier</td><td>012-3456789</td></tr>
                                <tr><td class="td-id">E002</td><td>Sarah Cashier</td><td>Cashier</td><td>013-4567890</td></tr>
                                <tr><td class="td-id">E003</td><td>Mike Supervisor</td><td>Supervisor</td><td>014-5678901</td></tr>
                                <tr><td class="td-id">E004</td><td>Lisa Ticket</td><td>Ticket Checker</td><td>015-6789012</td></tr>
                                <tr><td class="td-id">E005</td><td>Tom Cleaner</td><td>Cleaner</td><td>016-7890123</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="tab-schedule" class="profile-tab-pane">
                    <div class="profile-pane-header">
                        <div class="profile-pane-title">MY SCHEDULE</div>
                        <div class="profile-pane-sub">Upcoming shifts</div>
                    </div>
                    <div class="profile-pane-body">
                        <table class="employee-table">
                            <thead><tr><th>Date</th><th>Start Time</th><th>End Time</th><th>Notes</th></tr></thead>
                            <tbody>
                                <tr><td>Monday, 05 May 2025</td><td>9:00 AM</td><td>6:00 PM</td><td>Manager on Duty</td></tr>
                                <tr><td>Tuesday, 06 May 2025</td><td>1:00 PM</td><td>10:00 PM</td><td>Staff Meeting at 2PM</td></tr>
                                <tr><td>Wednesday, 07 May 2025</td><td>9:00 AM</td><td>6:00 PM</td><td>Inventory Check</td></tr>
                                <tr><td>Thursday, 08 May 2025</td><td>OFF</td><td>OFF</td><td>Day Off</td></tr>
                                <tr><td>Friday, 09 May 2025</td><td>2:00 PM</td><td>11:00 PM</td><td>Weekend Shift</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    // Add listener for phone input
    var phoneInput = document.getElementById("phone");
    var errorMessage = document.getElementById("errorMessage");

    phoneInput.addEventListener("input", function () {
        var phoneNumberLength = phoneInput.value.length;
        if (phoneNumberLength >= 15) {
            errorMessage.style.display = "block";
            errorMessage.style.marginTop = "5px";
            errorMessage.style.marginBottom = "5px";
        }
    });
    
    function showTab(tabName) {
        document.querySelectorAll('.profile-tab-pane').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.profile-nav-item').forEach(b => b.classList.remove('active'));
        document.getElementById('tab-' + tabName).classList.add('active');
        event.currentTarget.classList.add('active');
    }

    function enableEdit() {
        document.getElementById('fullName').disabled = false;
        document.getElementById('email').disabled = false;
        document.getElementById('phone').disabled = false;
        document.getElementById('editBtn').style.display = 'none';
        document.getElementById('saveBtn').style.display = 'inline-block';
        document.getElementById('cancelBtn').style.display = 'inline-block';
    }

    function cancelEdit() {
        location.reload();
    }

    function saveProfile() {
        var newName = document.getElementById('fullName').value;
        var newEmail = document.getElementById('email').value;
        var newPhone = document.getElementById('phone').value;
        document.getElementById('sidebarName').innerText = newName;
        document.getElementById('sidebarEmail').innerText = newEmail;
        document.getElementById('avatarLetter').innerText = newName.charAt(0).toUpperCase();
        alert("Profile updated successfully!");
        document.getElementById('fullName').disabled = true;
        document.getElementById('email').disabled = true;
        document.getElementById('phone').disabled = true;
        document.getElementById('editBtn').style.display = 'inline-block';
        document.getElementById('saveBtn').style.display = 'none';
        document.getElementById('cancelBtn').style.display = 'none';

        // Save the hq info to database
        const formData = new URLSearchParams();

        // 1. Save the special instruction to servlet
        formData.append("action", "saveEmployeeProfile");
        formData.append("name", newName);
        formData.append("email", newEmail);
        formData.append("phoneNumber", newPhone);

        fetch("${pageContext.request.contextPath}/ProfileServlet", {
            method: 'POST',
            body: formData
        });
        
        // Hide the error message
        errorMessage.style.display = "none";
        errorMessage.style.marginTop = "0px";
        errorMessage.style.marginBottom = "0px";
    }
</script>

<%@ include file="manager-footer.jsp" %>