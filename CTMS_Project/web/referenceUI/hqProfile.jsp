<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="hq-header.jsp" %>

<%
    String hqName = "Admin HQ";
    String hqEmail = "admin@cineorder.com";
    String hqPhone = "03-8888 1234";
    String hqId = "ADMIN001";
    String hqPosition = "HQ Administrator";
    String joinDate = "01 January 2020";
%>

<main class="page-offset">
    <div class="container" style="max-width: 1000px; margin: 0 auto; padding: 40px 20px;">
        
        <div class="page-header">
            <h1>MY <span>PROFILE</span></h1>
            <span class="role-badge hq">HQ - LEVEL 3</span>
        </div>

        <div class="profile-layout">
            
            <div class="profile-sidebar">
                <div class="profile-avatar-section">
                    <div class="profile-avatar" id="avatarLetter">A</div>
                    <div class="profile-name-sidebar" id="sidebarName"><%= hqName %></div>
                    <div class="profile-email-sidebar" id="sidebarEmail"><%= hqEmail %></div>
                    <div class="profile-cinema">Headquarters</div>
                    <div class="profile-role-badge-hq"><span class="hq-role-badge">HQ ADMIN</span></div>
                </div>
                
                <div class="profile-nav">
                    <button class="profile-nav-item active" onclick="showTab('info')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                        Personal Info
                    </button>
                    <button class="profile-nav-item" onclick="showTab('activity')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <rect x="3" y="4" width="18" height="18" rx="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/>
                            <line x1="8" y1="2" x2="8" y2="6"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                        Recent Activity
                    </button>
                </div>
            </div>

            <div class="profile-main">
                
                <div id="tab-info" class="profile-tab-pane active">
                    <div class="profile-pane-header">
                        <div class="profile-pane-title">PERSONAL INFORMATION</div>
                        <div class="profile-pane-sub">HQ Administrator ID: <%= hqId %></div>
                    </div>
                    <div class="profile-pane-body">
                        <div class="profile-form-grid">
                            <div class="form-group">
                                <label class="form-label">Full Name</label>
                                <input type="text" id="fullName" class="form-input" value="<%= hqName %>" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email Address</label>
                                <input type="email" id="email" class="form-input" value="<%= hqEmail %>" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" id="phone" class="form-input" value="<%= hqPhone %>" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Position</label>
                                <input class="form-input" value="<%= hqPosition %>" disabled>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Join Date</label>
                                <input class="form-input" value="<%= joinDate %>" disabled>
                            </div>
                        </div>
                        <div class="profile-actions">
                            <button class="btn-edit-profile" id="editBtn" onclick="enableEdit()">Edit Profile</button>
                            <button class="btn-save" id="saveBtn" style="display:none;" onclick="saveProfile()">Save Changes</button>
                            <button class="btn-cancel" id="cancelBtn" style="display:none;" onclick="cancelEdit()">Cancel</button>
                        </div>
                    </div>
                </div>

                <div id="tab-activity" class="profile-tab-pane">
                    <div class="profile-pane-header">
                        <div class="profile-pane-title">RECENT ACTIVITY</div>
                        <div class="profile-pane-sub">System changes made by you</div>
                    </div>
                    <div class="profile-pane-body">
                        <table class="employee-table">
                            <thead>
                                <tr><th>Date</th><th>Action</th><th>Details</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>2025-05-05</span><td>Cinema Added</span><td>Added CineOrder Ipoh</span></tr>
                                <tr><td>2025-05-04</span><td>Movie Added</span><td>Added WICKED to movies list</span></tr>
                                <tr><td>2025-05-03</span><td>Employee Promoted</span><td>John Doe promoted to Manager</span></tr>
                                <tr><td>2025-05-02</span><td>Food Price Updated</span><td>Updated popcorn prices</span></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
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

function cancelEdit() { location.reload(); }

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
}
</script>

<%@ include file="hq-footer.jsp" %>