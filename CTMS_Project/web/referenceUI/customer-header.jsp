<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineOrder — Premium Movie Experience</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Crimson+Pro:ital,wght@0,300;0,400;1,300&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="master-style.css">
</head>
<body>

<%
    // Get user from session (set by LoginServlet)
    Object userObj = session.getAttribute("user");
    String userRole = null;
    String userName = null;
    boolean isLoggedIn = false;
    
    if (userObj != null) {
        isLoggedIn = true;
        userRole = (String) session.getAttribute("role");
        userName = (String) session.getAttribute("userName");
        if (userName == null) userName = "User";
    }
%>

<header class="site-header">
    <div class="header-inner">
        <a href="index.jsp" class="logo">
            <div class="logo-mark"></div>
            <div class="logo-text">CINE<span>ORDER</span></div>
        </a>

        <nav class="site-nav">
            <% if (!isLoggedIn || "customer".equals(userRole)) { %>
                <a href="index.jsp">Home</a>
                <a href="customer/movieList.jsp">Movies</a>
                <a href="customer/foodMenu.jsp">Food</a>
                <a href="customer/cinemaView.jsp">Cinemas</a>
            <% } else if ("staff".equals(userRole)) { %>
                <a href="employee/index.jsp">Dashboard</a>
                <a href="employee/showtimeManage.jsp">Showtimes</a>
                <a href="employee/foodOrders.jsp">Food Orders</a>
                <a href="employee/ticketValidation.jsp">Validate</a>
            <% } else if ("manager".equals(userRole)) { %>
                <a href="employee/managerDashboard.jsp">Dashboard</a>
                <a href="employee/showtimeManage.jsp">Showtimes</a>
                <a href="employee/foodInventory.jsp">Inventory</a>
                <a href="employee/reports.jsp">Reports</a>
                <a href="employee/staffManage.jsp">Staff</a>
            <% } else if ("hq".equals(userRole)) { %>
                <a href="hq/dashboard.jsp">Dashboard</a>
                <a href="hq/cinemaManage.jsp">Cinemas</a>
                <a href="hq/movieManage.jsp">Movies</a>
                <a href="hq/foodManage.jsp">Food</a>
                <a href="hq/employeeManage.jsp">Employees</a>
                <a href="hq/globalReports.jsp">Reports</a>
            <% } %>
        </nav>

        <div class="header-actions">
            <div class="search-bar">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"/>
                    <path d="m21 21-4.35-4.35"/>
                </svg>
                <input type="text" placeholder="Search movies...">
            </div>

            <% if (isLoggedIn) { %>
                <!-- Profile Icon (for all logged in users) -->
                <button class="profile-icon-btn" onclick="location.href='profile.jsp'">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                </button>
                
                <div class="user-menu">
                    <span class="role-badge <%= userRole %>"><%= userRole != null ? userRole.toUpperCase() : "USER" %></span>
                    <span class="user-name"><%= userName %></span>
                    <a href="logout.jsp" class="btn-signin">Logout</a>
                </div>
            <% } else { %>
                <div class="auth-buttons">
                    <a href="login.jsp" class="btn-signin">Sign In</a>
                    <a href="register.jsp" class="btn btn-primary btn-sm">Register</a>
                </div>
            <% } %>
        </div>
    </div>
</header>