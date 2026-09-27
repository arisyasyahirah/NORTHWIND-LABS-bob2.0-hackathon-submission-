<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="manager-header.jsp" %>

<main class="page-offset">
    <div class="container">
        
        <div class="page-header">
            <h1>HALL <span>MANAGEMENT</span></h1>
            <span class="role-badge manager">MANAGER - LEVEL 2</span>
        </div>

        <div class="staff-panel">
            <div class="panel-header">
                <h3>Cinema: TRX - Hall Availability</h3>
                <span class="hall-text-muted">Click toggle to change availability</span>
            </div>
            
            <table class="hall-table">
                <thead>
                    <tr>
                        <th>Hall ID</th>
                        <th>Hall Type</th>
                        <th>Category</th>
                        <th>Total Seats</th>
                        <th>Current Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="td-id">H001</td>
                        <td>IMAX</td>
                        <td>Premium</td>
                        <td>180 seats</td>
                        <td id="status-H001"><span class="status available">Available</span></td>
                        <td><button class="btn-toggle" onclick="toggleHall('H001', 'Available')">Set Unavailable</button></td>
                    </tr>
                    <tr>
                        <td class="td-id">H002</td>
                        <td>Dolby Atmos</td>
                        <td>Premium</td>
                        <td>150 seats</td>
                        <td id="status-H002"><span class="status unavailable">Unavailable</span></td>
                        <td><button class="btn-toggle" onclick="toggleHall('H002', 'Unavailable')">Set Available</button></td>
                    </tr>
                    <tr>
                        <td class="td-id">H003</td>
                        <td>Gold Class</td>
                        <td>Luxury</td>
                        <td>48 seats</td>
                        <td id="status-H003"><span class="status available">Available</span></td>
                        <td><button class="btn-toggle" onclick="toggleHall('H003', 'Available')">Set Unavailable</button></td>
                    </tr>
                    <tr>
                        <td class="td-id">H004</td>
                        <td>Standard</td>
                        <td>Regular</td>
                        <td>200 seats</td>
                        <td id="status-H004"><span class="status available">Available</span></td>
                        <td><button class="btn-toggle" onclick="toggleHall('H004', 'Available')">Set Unavailable</button></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="hall-alert-info">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <circle cx="12" cy="12" r="10"/>
                <path d="M12 16v-4M12 8h.01"/>
            </svg>
            Note: You can only change hall availability (Available/Unavailable). Hall type, category, and price can only be edited by HQ.
        </div>
    </div>
</main>

<script>
function toggleHall(hallId, currentStatus) {
    var newStatus = currentStatus === 'Available' ? 'Unavailable' : 'Available';
    var statusClass = newStatus === 'Available' ? 'available' : 'unavailable';
    var buttonText = newStatus === 'Available' ? 'Set Unavailable' : 'Set Available';
    var newOnclick = "toggleHall('" + hallId + "', '" + newStatus + "')";
    
    var statusCell = document.getElementById('status-' + hallId);
    statusCell.innerHTML = '<span class="status ' + statusClass + '">' + newStatus + '</span>';
    
    var button = event.target;
    button.setAttribute('onclick', newOnclick);
    button.innerText = buttonText;
    
    alert("Hall " + hallId + " is now " + newStatus);
}
</script>

<%@ include file="manager-footer.jsp" %>