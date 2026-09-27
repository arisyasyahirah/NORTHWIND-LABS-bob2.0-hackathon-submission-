package com.ctms.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
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
public class AuthFilter implements Filter {

    private String requiredRole;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Read the predefine user role from xml file
        requiredRole = filterConfig.getInitParameter("role");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse respones, FilterChain chain) throws IOException, ServletException {
        // Need to change the ServletRequest to HttpServletRequest to use setHeader function
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) respones;
        HttpSession session = httpRequest.getSession(false);

        //Protects the page from user clicking previous button when user already logs out
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setHeader("Expires", "0");

        // Determine the userId and userType
        boolean loggedIn = (session != null && session.getAttribute("email") != null);
        String userType = (String) session.getAttribute("userType");

        if (!loggedIn) {
            httpResponse.sendRedirect("login.jsp");
            return;
        }

        if (!requiredRole.equals(userType)) {
            httpResponse.sendRedirect("login.jsp");
            return;
        }

        // Exture the function
        chain.doFilter(request, respones);
    }

    @Override
    public void destroy() {

    }

}
