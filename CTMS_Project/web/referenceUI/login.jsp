<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<main class="page-offset">
    <div class="container" style="max-width:500px;margin:80px auto 60px;">
        <div class="page-title-bar" style="margin-bottom:24px;">
            <h1>SIGN <span>IN</span></h1>
        </div>

        <div class="form-card">
            <div class="form-card-header">
                <h2>Welcome Back</h2>
            </div>
            <div class="form-card-body">
                <div class="form-group">
                    <label class="form-label">Email <span class="required-star">*</span></label>
                    <input type="email" class="form-input" placeholder="customer@cineorder.com" value="customer@cineorder.com">
                </div>
                <div class="form-group">
                    <label class="form-label">Password <span class="required-star">*</span></label>
                    <input type="password" class="form-input" placeholder="••••••••" value="password123">
                </div>
                <div class="flex-between" style="display: flex; justify-content: space-between; margin-top: 12px;">
                    <label style="font-size:12px;"><input type="checkbox"> Remember me</label>
                    <a href="#" class="text-khaki" style="font-size:12px;">Forgot password?</a>
                </div>
                <div class="form-actions" style="margin-top: 24px;">
                    <button class="btn btn-primary" style="width:100%;" onclick="location.href='profile.jsp'">Sign In</button>
                </div>
                <div style="text-align:center; margin-top: 20px;">
                    <span class="text-muted">Don't have an account? </span>
                    <a href="register.jsp" class="text-khaki">Register</a>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="footer.jsp" %>