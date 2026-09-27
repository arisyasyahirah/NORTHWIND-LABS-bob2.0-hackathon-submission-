<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<main class="page-offset">
    <div class="container" style="max-width:600px;margin:80px auto 60px;">
        <div class="page-title-bar" style="margin-bottom:24px;">
            <h1>CREATE <span>ACCOUNT</span></h1>
        </div>

        <div class="form-card">
            <div class="form-card-header">
                <h2>Join CineOrder</h2>
            </div>
            <div class="form-card-body">
                <div class="form-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group form-col-span-2"><label class="form-label">Full Name</label><input type="text" class="form-input" placeholder="John Doe"></div>
                    <div class="form-group"><label class="form-label">Phone</label><input type="text" class="form-input" placeholder="0123456789"></div>
                    <div class="form-group"><label class="form-label">Date of Birth</label><input type="date" class="form-input"></div>
                    <div class="form-group form-col-span-2"><label class="form-label">Email</label><input type="email" class="form-input" placeholder="john@example.com"></div>
                    <div class="form-group"><label class="form-label">Password</label><input type="password" class="form-input" placeholder="Create password"></div>
                    <div class="form-group"><label class="form-label">Confirm Password</label><input type="password" class="form-input" placeholder="Confirm password"></div>
                </div>
                <div class="form-actions">
                    <button class="btn btn-primary" style="width:100%;" onclick="location.href='profile.jsp'">Register</button>
                </div>
                <div style="text-align:center; margin-top: 20px;">
                    <span class="text-muted">Already have an account? </span>
                    <a href="login.jsp" class="text-khaki">Sign In</a>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="footer.jsp" %>