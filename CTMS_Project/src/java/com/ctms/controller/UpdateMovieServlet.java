package com.ctms.controller;

import com.ctms.dao.MovieDAO;
import com.ctms.service.MovieService;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.sql.SQLException;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig
public class UpdateMovieServlet extends HttpServlet {

    private final SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
    private MovieService movieService;
    private MovieDAO movieDAO;

    public void init() {
        movieDAO = new MovieDAO();
        movieService = new MovieService(movieDAO);
    }

    private byte[] convertToByteHelper(Part imagePart) throws IOException {
        InputStream inputStream = imagePart.getInputStream();
        return inputStream.readAllBytes();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("movieId");
        String title = request.getParameter("movieTitle");
        String strDuration = request.getParameter("duration");
        String rating = request.getParameter("rating");
        String genre = request.getParameter("genre");
        String description = request.getParameter("description");
        String trailerLink = request.getParameter("trailer");
        Part partPoster = request.getPart("poster");
        Part partBanner = request.getPart("banner");

        System.out.println(strDuration);

        long ms = 0;
        try {
            ms = sdf.parse(strDuration).getTime();
        } catch (ParseException ex) {
            Logger.getLogger(AddNewMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        Time timeDuration = new Time(ms);

        byte[] bytePoster = partPoster != null && partPoster.getSize() > 0
                ? convertToByteHelper(partPoster) : null;
        byte[] byteBanner = partBanner != null && partBanner.getSize() > 0
                ? convertToByteHelper(partBanner) : null;

        boolean success = false;
        try {
            success = movieService.updateMovie(id, title, timeDuration, rating, genre, description, trailerLink, bytePoster, byteBanner);
        } catch (SQLException ex) {
            Logger.getLogger(AddNewMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/ManageMovie?status=success&action=update");
        } else {
            response.sendRedirect(request.getContextPath() + "/ManageMovie?status=failed&action=update");
        }

    }

}
