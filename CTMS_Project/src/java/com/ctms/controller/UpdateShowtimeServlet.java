package com.ctms.controller;

import com.ctms.dao.MovieDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import com.ctms.service.ShowtimeService;
import com.ctms.dao.ShowtimeDAO;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UpdateShowtimeServlet extends HttpServlet {
    
    private ShowtimeService showtimeService;
    private ShowtimeDAO showtimeDAO;
    private MovieDAO movieDAO;
    
    public void init(){
        showtimeDAO = new ShowtimeDAO();
        movieDAO = new MovieDAO();
        showtimeService = new ShowtimeService(showtimeDAO, movieDAO);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //Get input
        String showtimeId = request.getParameter("showtimeId");
        String movieId = request.getParameter("movieId");
        String hallId = request.getParameter("hallId");

        String showDateStr = request.getParameter("showDate");
        String showStartTimeStr = request.getParameter("showStartTime");
        
        // Normalize to HH:mm:ss
        if (showStartTimeStr.length() == 5) {
            showStartTimeStr += ":00";  // "14:30" → "14:30:00"
        }

        //Convert String to proper date time
        Date showDate = Date.valueOf(showDateStr);
        Time showStartTime = Time.valueOf(showStartTimeStr);
        
        //Update showtime
        boolean success = false;
        try {
            success = showtimeService.updateShowtime(showtimeId, movieId, hallId, showDate, showStartTime);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateShowtimeServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        if (success){
            String message = "Showtime  updated.";
            response.sendRedirect(request.getContextPath()+"/ShowtimeServlet?status=success&msg="+message);
        }else{
            String message = "Failed to update showtime.";
            response.sendRedirect(request.getContextPath()+"/ShowtimeServlet?status=failed&msg="+message);
        }
        
    }
}
