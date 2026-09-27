<%@page import="com.ctms.model.Customer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="customer-header.jsp" %>

<main class="page-offset">
    <div style="max-width: 1000px; margin: 0 auto; padding: 40px 20px;">

        <h1 style="margin-bottom: 30px;">MY PROFILE</h1>

        <div class="profile-layout">

            <!-- Sidebar -->
            <div class="profile-sidebar">
                <div class="profile-avatar" id="avatarLetter">${ sessionScope.firstCharacter }</div>
                <div class="profile-name" id="sidebarName">${ sessionScope.customer.name }</div>
                <div class="profile-email" id="sidebarEmail">${ sessionScope.customer.email }</div>

                <div class="profile-nav">
                    <button class="profile-nav-item active" onclick="showTab('info')">Personal Info</button>
                    <button class="profile-nav-item" onclick="showTab('bookings')">My Bookings</button>
                    <button class="profile-nav-item" onclick="location.href = '../logout.jsp'">Logout</button>
                </div>
            </div>

            <!-- Main Content -->
            <div class="profile-main">

                <!-- Personal Info Tab -->
                <div id="tab-info" class="profile-tab-pane active">
                    <h2>Personal Information</h2>

                    <form id="profileForm">
                        <div class="form-group">
                            <label class="form-label">Full Name</label>
                            <input type="text" id="fullName" class="form-input" value="${ sessionScope.customer.name }" disabled>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" id="email" class="form-input" value="${ sessionScope.customer.email }" disabled>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Phone</label>
                            <input type="text" id="phone" class="form-input" maxlength="15" value="${ sessionScope.customer.phoneNumber }" disabled>
                            <p id="errorMessage" style="display: none; margin: 0px;">Phone number cannot more that 15 character. </p>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Member Since</label>
                            <input class="form-input" value="15 March 2024" disabled>
                        </div>

                        <div style="display: flex; gap: 12px; margin-top: 20px;">
                            <button type="button" class="btn btn-outline" id="editBtn" onclick="enableEdit()">Edit Profile</button>
                            <button type="button" class="btn btn-primary" id="saveBtn" style="display:none;" onclick="saveProfile()">Save Changes</button>
                            <button type="button" class="btn btn-ghost" id="cancelBtn" style="display:none;" onclick="cancelEdit()">Cancel</button>
                        </div>
                    </form>
                </div>

                <!-- Bookings Tab -->
                <div id="tab-bookings" class="profile-tab-pane">
                    <h2>My Bookings</h2>
                    <table class="booking-table">
                        <thead>
                            <tr><th>Booking ID</th><th>Movie</th><th>Date</th><th>Time</th><th>Seats</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="td-id">BK001</td>
                                <td>DUNE: PART TWO</td>
                                <td>15 May 2025</td>
                                <td>7:30 PM</td>
                                <td>A10, B3</td>
                                <td class="status-valid">Valid</td>
                            </tr>
                            <tr>
                                <td class="td-id">BK002</td>
                                <td>OPPENHEIMER</td>
                                <td>01 May 2025</td>
                                <td>4:00 PM</td>
                                <td>C5, C6</td>
                                <td class="status-expired">Expired</td>
                            </tr>
                        </tbody>
                    </table>
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
        // Enable input fields
        document.getElementById('fullName').disabled = false;
        document.getElementById('email').disabled = false;
        document.getElementById('phone').disabled = false;

        // Show/hide buttons
        document.getElementById('editBtn').style.display = 'none';
        document.getElementById('saveBtn').style.display = 'inline-block';
        document.getElementById('cancelBtn').style.display = 'inline-block';
    }

    function cancelEdit() {
        // Reload page to reset original values
        location.reload();
    }

    function saveProfile() {
        // Get new values
        var newName = document.getElementById('fullName').value;
        var newEmail = document.getElementById('email').value;
        var newPhone = document.getElementById('phone').value;
        var firstLetter = newName.charAt(0).toUpperCase();

        // Update sidebar
        document.getElementById('sidebarName').innerText = newName;
        document.getElementById('sidebarEmail').innerText = newEmail;
        document.getElementById('avatarLetter').innerText = firstLetter;

        // Show success message
        alert('Profile updated successfully!\n\nName: ' + newName + '\nEmail: ' + newEmail + '\nPhone: ' + newPhone);

        // Disable inputs again
        document.getElementById('fullName').disabled = true;
        document.getElementById('email').disabled = true;
        document.getElementById('phone').disabled = true;

        // Show/hide buttons back
        document.getElementById('editBtn').style.display = 'inline-block';
        document.getElementById('saveBtn').style.display = 'none';
        document.getElementById('cancelBtn').style.display = 'none';

        // Save the user info to database
        const formData = new URLSearchParams();

        // 1. Save the special instruction to servlet
        formData.append("action", "saveCustomerProfile");
        formData.append("name", newName);
        formData.append("email", newEmail);
        formData.append("phoneNumber", newPhone);

        fetch("${pageContext.request.contextPath}/profileServlet", {
            method: 'POST',
            body: formData
        });

        // Hide the error message
        errorMessage.style.display = "none";
        errorMessage.style.marginTop = "0px";
        errorMessage.style.marginBottom = "0px";
    }

</script>

<%@ include file="/footer.jsp" %>