<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.ctms.model.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CTMS — Premium Movie Experience</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Crimson+Pro:ital,wght@0,300;0,400;1,300&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/master-style.css">
</head>
<body>

<%
    // Get user from session
    Object userObj = session.getAttribute("customer") != null ? session.getAttribute("customer") : null;
    String userType = null;
    boolean isLoggedIn = false;
    
    if (userObj != null) {
        isLoggedIn = true;
        userType = (String) session.getAttribute("userType");
    }
%>

<header class="site-header">
    <div class="header-inner">
        <a href="index.jsp" class="logo">
            <div class="logo-mark"></div>
            <div class="logo-text">CT<span>MS</span></div>
        </a>

        <nav class="site-nav">
            <a href="index.jsp">Home</a>
            <a href="movieList.jsp">Movies</a>
            <a href="foodMenu.jsp">Food</a>
            <a href="cinemaView.jsp">Cinemas</a>
            <% if (isLoggedIn) { %>
                <a href="myBookings.jsp">My Bookings</a>
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

            <% if (isLoggedIn && userType.equals("customer")) { %>
            <div class="header-actions">
                <div class="user-menu">
                    <span class="user-name">${sessionScope.customer.name}</span>                    
                </div>
                <button class="profile-icon-btn" onclick="location.href='customer/profile.jsp'">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                </button>
                <a href="logout.jsp" class="btn-signin">Logout</a>
            </div>
                
            <% } else { %>
                <div class="auth-buttons">
                    <a href="login.jsp" class="btn-signin">Sign In</a>
                    <a href="register.jsp" class="btn-signin btn-primary btn-sm">Register</a>
                </div>
            <% } %>
        </div>
    </div>
</header>

<!-- Add this div after header to push content down -->
<div class="page-offset"></div>

<script>
    // Detects when page is restored from bfcache (back button)
    window.addEventListener('pageshow', function (event) {
        console.log("page fired...");
        if (event.persisted) {
            // Page was loaded from bfcache, force a fresh request
            window.location.replace(window.location.href);
        }
    });
</script>