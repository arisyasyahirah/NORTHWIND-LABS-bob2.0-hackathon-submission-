<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CineOrder — Premium Movie Experience</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Crimson+Pro:ital,wght@0,300;0,400;1,300&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/master-style.css">
    </head>
    <body>
        <header class="site-header">
            <div class="header-inner">
                <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
                    <div class="logo-mark"></div>
                    <div class="logo-text">CINE<span>ORDER</span></div>
                </a>

                <nav class="site-nav">
                    <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
                    <a href="customer/movieList.jsp">Movies</a>
                    <a href="customer/foodMenu.jsp">Food</a>
                    <a href="customer/cinemaView.jsp">Cinemas</a>

                </nav>

                <div class="header-actions">
                    <div class="search-bar">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"/>
                        <path d="m21 21-4.35-4.35"/>
                        </svg>
                        <input type="text" placeholder="Search movies...">
                    </div>

                    <!-- Profile Icon (for all logged in users) -->
                    <button class="profile-icon-btn" onclick="location.href = 'profile.jsp'">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                        </svg>
                    </button>

                    <div class="user-menu">
                        <span class="role-badge">Customer</span>
                        <span class="user-name">${sessionScope.customer.name}</span>
                        <a href="${pageContext.request.contextPath}/logout.jsp" class="btn-signin">Logout</a>
                    </div>
                </div>
            </div>
        </header>