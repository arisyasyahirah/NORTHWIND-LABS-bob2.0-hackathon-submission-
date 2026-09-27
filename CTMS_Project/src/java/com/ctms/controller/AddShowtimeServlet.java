package com.ctms.controller;

import com.ctms.dao.MovieDAO;
import com.ctms.dao.ShowtimeDAO;
import com.ctms.service.MovieService;
import com.ctms.service.ShowtimeService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AddShowtimeServlet extends HttpServlet {

    private MovieDAO movieDAO;
    private ShowtimeDAO showtimeDAO;
    private ShowtimeService showtimeService;
    private MovieService movieService;

    public void init() {
        //Initialize everything that you need here
        movieDAO = new MovieDAO();
        showtimeDAO = new ShowtimeDAO();
        movieService = new MovieService(movieDAO);
        showtimeService = new ShowtimeService(showtimeDAO, movieDAO);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //Get info
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
            success = showtimeService.insertShowtime(movieId, hallId, showDate, showStartTime);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateShowtimeServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        if (success){
            String message = "Showtime successfully added.";
            response.sendRedirect(request.getContextPath()+"/ShowtimeServlet?status=success&msg="+message);
        }else{
            String message = "Failed to add showtime.";
            response.sendRedirect(request.getContextPath()+"/ShowtimeServlet?status=failed&msg="+message);
        }

    }

}
