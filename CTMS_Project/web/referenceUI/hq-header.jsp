<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CTMS — HQ Admin Portal</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Crimson+Pro:ital,wght@0,300;0,400;1,300&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="master-style.css">
</head>
<body>

<header class="site-header">
    <div class="header-inner">
        <a href="dashboard.jsp" class="logo">
            <div class="logo-mark"></div>
            <div class="logo-text">CT<span>MS</span></div>
        </a>
        <nav class="site-nav">
            <a href="hqDashboard.jsp">Dashboard</a>
            <a href="cinemaManage.jsp">Cinemas</a>
            <a href="hqMovieManage.jsp">Movies</a>
            <a href="hqHallManage.jsp">Halls</a>

        </nav>
        <div class="header-actions">
            <span class="role-badge hq">HQ - LEVEL 3</span>
            <button class="profile-icon-btn" onclick="location.href='profile.jsp'">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                    <circle cx="12" cy="7" r="4"/>
                </svg>
            </button>
        </div>
    </div>
</header>