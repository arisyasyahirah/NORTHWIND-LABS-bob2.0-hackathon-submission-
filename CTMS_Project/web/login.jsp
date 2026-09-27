<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<main class="page-offset">
    <div class="container" style="max-width:500px;margin:80px auto 60px;">
        <div class="page-title-bar" style="margin-bottom:24px;">
            <h1>SIGN <span>IN</span></h1>
        </div>

        <form action="LoginServlet" method="POST">
            <div class="form-card">
                <div class="form-card-header">
                    <h2>Welcome Back</h2>
                </div>
                <div class="form-card-body">
                    <div class="form-group">
                        <label class="form-label">Email <span class="required-star">*</span></label>
                        <input name="email" type="email" class="form-input" placeholder="customer@cineorder.com">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Password <span class="required-star">*</span></label>
                        <input name="password" type="password" class="form-input" placeholder="••••••••">
                    </div>
                    <div class="flex-between" style="display: flex; justify-content: space-between; margin-top: 12px;">
                        <label style="font-size:12px;"><input type="checkbox"> Remember me</label>
                        <a href="#" class="text-khaki" style="font-size:12px;">Forgot password?</a>
                    </div>
                    
                    <p id="errorMessage" style="display: none; margin: 0px;">Somethings went wrong. Please double check your email or password. </p>
                    
                    <div class="form-actions" style="margin-top: 24px;">
                        <!--
                        <button class="btn btn-primary" style="width:100%;" onclick="location.href = '${pageContent.request.contextPath}/customer/profile.jsp'">Sign In</button>
                        -->
                        <input type="submit" class="btn btn-primary" style="width:100%;" value="Sign In">
                    </div>

                    <div style="text-align:center; margin-top: 20px;">
                        <span class="text-muted">Don't have an account? </span>
                        <a href="register.jsp" class="text-khaki">Register</a>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
        // Block back button function
        window.addEventListener('pageshow', function (event) {
            if (event.persisted) {
                // Page restored from bfcache, force a real server request
                // This triggers LoginFilter which redirects to profile
                window.location.replace(window.location.href);
            }
        });
        
        // Show error message if email or password type wrongly
        const params = new URLSearchParams(window.location.search);
        
        if (params.get("error") === "1") {
            var errorMessage = document.getElementById("errorMessage");
            errorMessage.style.display = "block";
            errorMessage.style.marginTop = "10px";
            errorMessage.style.marginBottom = "10px";
            console.log("Error detech")
        }
        
        console.log("Not error")
    </script>
</main>

<%@ include file="footer.jsp" %>