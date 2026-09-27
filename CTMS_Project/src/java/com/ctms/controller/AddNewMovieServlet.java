package com.ctms.controller;

import com.ctms.dao.MovieDAO;
import com.ctms.service.MovieService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.sql.*;
import java.text.ParseException;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig
public class AddNewMovieServlet extends HttpServlet {
    
    private final SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
    private MovieService movieService;
    private MovieDAO movieDAO;
    
    
    public void init(){
        movieDAO = new MovieDAO();
        movieService = new MovieService(movieDAO);
    }
    
    private byte[] convertToByteHelper(Part imagePart) throws IOException{
        InputStream inputStream = imagePart.getInputStream();
        return inputStream.readAllBytes();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        String title = request.getParameter("title");
        String strDuration = request.getParameter("duration");
        String rating = request.getParameter("rating");
        String genre = request.getParameter("genre");
        String description = request.getParameter("description");
        String trailerLink = request.getParameter("trailer");
        Part partPoster = request.getPart("poster");
        Part partBanner = request.getPart("banner");
        
        long ms = 0;
        try {
            ms = sdf.parse(strDuration).getTime();
        } catch (ParseException ex) {
            Logger.getLogger(AddNewMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        Time timeDuration = new Time(ms);
        
        byte[] bytePoster = convertToByteHelper(partPoster);
        byte[] byteBanner = convertToByteHelper(partBanner);
        
        boolean success = false;
        try {
            success = movieService.insertMovie(title, timeDuration, rating, genre, description, trailerLink, bytePoster, byteBanner);
        } catch (SQLException ex) {
            Logger.getLogger(AddNewMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        if (success){
            System.out.println("Sucess");
        }else{
            System.out.println("Failed");
        }
       
    }

    
}
