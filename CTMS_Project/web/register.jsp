<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<main class="page-offset">
    <div class="container" style="max-width:600px;margin:80px auto 60px;">
        <div class="page-title-bar" style="margin-bottom:24px;">
            <h1>CREATE <span>ACCOUNT</span></h1>
        </div>

        <form method="POST" action="RegisterServlet">
            <div class="form-card">
                <div class="form-card-header">
                    <h2>Join CineOrder</h2>
                </div>
                <div class="form-card-body">
                    <div class="form-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group form-col-span-2">
                            <label class="form-label">Full Name</label>
                            <input type="text" class="form-input" name="userName" placeholder="John Doe" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Phone</label>
                            <input type="text" class="form-input" name="phoneNumber" placeholder="0123456789" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Date of Birth</label>
                            <input type="date" class="form-input" name="dob">
                        </div>
                        <div class="form-group form-col-span-2">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-input" name="email" placeholder="john@example.com" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-input" name="password" placeholder="Create password" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Confirm Password</label>
                            <input type="password" class="form-input" placeholder="Confirm password" required>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button class="btn btn-primary" style="width:100%;" onclick="registerNewCustomer(); location.href='profile.jsp'">Register</button>
                    </div>
                    <div style="text-align:center; margin-top: 20px;">
                        <span class="text-muted">Already have an account? </span>
                        <a href="login.jsp" class="text-khaki">Sign In</a>
                    </div>
                </div>
            </div>
        </form>
    </div>
    
    <script>
        function registerNewCustomer() {
            const params = new URLSearchParams(window.location.search);
            if (params.get("error") === "1") {
                window.alert("Duplicate record found. Please enter a new valid email....");
            } else {
                window.alert("New account create successfully. ");
            }
        }
    </script>
</main>

<%@ include file="footer.jsp" %>