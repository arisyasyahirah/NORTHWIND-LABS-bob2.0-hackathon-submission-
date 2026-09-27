package com.ctms.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 *
 * @author user
 */
public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession ses = req.getSession(false);

        // Prevent login page from being cached
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setHeader("Expires", "0");

        // Compare user role
        String userType = (ses != null) ? (String) ses.getAttribute("userType") : null;

        // Prevent user from going back to login page after they successfully sign 
        if ("customer".equals(userType)) {
            res.sendRedirect(req.getContextPath() + "/customer/profile.jsp");
        } else if ("employee".equals(userType)) {
            res.sendRedirect(req.getContextPath() + "/employee/employeePage.jsp");
        } else {
            // Ask the server to render the login page
            chain.doFilter(request, response);
        }

    }

    @Override
    public void destroy() {

    }
}
