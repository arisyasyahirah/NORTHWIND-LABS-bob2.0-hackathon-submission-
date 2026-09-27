package com.ctms.controller;

import com.ctms.dao.MovieDAO;
import com.ctms.service.MovieService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DeleteMovieServlet extends HttpServlet {

    private MovieService movieService;
    private MovieDAO movieDAO;

    public void init() {
        movieDAO = new MovieDAO();
        movieService = new MovieService(movieDAO);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String movieId = request.getParameter("movieId");

        boolean success = false;
        try {
            success = movieService.deleteMovie(movieId);
        } catch (SQLException ex) {
            Logger.getLogger(DeleteMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/ManageMovie?status=success&action=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/ManageMovie?status=failed&action=delete");
        }
    }

}
