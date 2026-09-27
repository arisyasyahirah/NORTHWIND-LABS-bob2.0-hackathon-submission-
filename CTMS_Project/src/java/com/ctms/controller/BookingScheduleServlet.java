package com.ctms.controller;

import com.ctms.dao.MovieDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ctms.dao.ShowtimeDAO;
import com.ctms.dto.DateTimeDTO;
import com.ctms.dto.MovieDTO;
import com.ctms.model.Showtime;
import com.ctms.dto.ShowtimeDTO;
import com.ctms.dto.ShowtimeHallDTO;
import com.ctms.service.MovieService;
import com.ctms.service.ShowtimeService;
import jakarta.servlet.annotation.WebServlet;
import java.util.ArrayList;
import java.sql.Date;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;

public class BookingScheduleServlet extends HttpServlet {

    private ShowtimeDAO showtimeDAO;
    private MovieDAO movieDAO;
    private ShowtimeService showtimeService;
    private MovieService movieService;

    public void init() {
        System.out.println("=== BookingScheduleServlet init() called ===");
        showtimeDAO = new ShowtimeDAO();
        movieDAO = new MovieDAO();
        showtimeService = new ShowtimeService(showtimeDAO);
        movieService = new MovieService(movieDAO);

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            System.out.println("=== BookingScheduleServlet doGet() started ===");

            // Getting the movieId from the url from the previous page which is movie-details.jsp
            // This thing works as the "BUY NOW" btn clicked... 
            String movieId = request.getParameter("movieId");
            System.out.println("Movie ID: " + movieId);
            if (movieId == null || movieId.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }

            // Getting available date for the movie     
            ArrayList<DateTimeDTO> availableDates = showtimeService.getDateTimesByMovieId(movieId);

            // Getting the Date from button click too
            Date selectedDate = null;
            String dateParam = request.getParameter("date");
            if (dateParam != null && !dateParam.trim().isEmpty()) {
                selectedDate = Date.valueOf(dateParam);
            } else if (!availableDates.isEmpty()) {
                selectedDate = availableDates.get(0).getShowDate();
            }

            ArrayList<ShowtimeDTO> showtimeList = showtimeService.getShowtimesByMovieAndDate(movieId, selectedDate);

            LinkedHashMap<String, List<ShowtimeDTO>> showtimesByCinema = new LinkedHashMap<>();
            for (ShowtimeDTO st : showtimeList) {
                String key = st.getCinemaName() + " - " + st.getBranch();
                if (!showtimesByCinema.containsKey(key)) {
                    showtimesByCinema.put(key, new ArrayList<>());
                }
                showtimesByCinema.get(key).add(st);
            }

            request.setAttribute("showtimesByCinema", showtimesByCinema);

            MovieDTO movie = movieService.getMovieById(movieId);

            request.setAttribute("movie", movie);
            request.setAttribute("availableDates", availableDates);
            request.setAttribute("selectedDate", selectedDate != null ? selectedDate.toString() : "");
            

            request.getRequestDispatcher("/booking-schedule.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("BookingScheduleServlet doGet() failed", e);
        }

    }
}
