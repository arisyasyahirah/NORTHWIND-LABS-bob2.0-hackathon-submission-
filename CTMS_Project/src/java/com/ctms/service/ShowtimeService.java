package com.ctms.service;

import java.sql.SQLException;
import java.sql.Time;
import java.sql.Date;
import java.time.LocalTime;
import java.util.*;
import com.ctms.model.*;
import com.ctms.dao.*;
import com.ctms.dto.*;
import com.ctms.util.TimeUtil;

public class ShowtimeService {

    private ShowtimeDAO showtimeDAO;
    private MovieDAO movieDAO;

    //Construct with parameter accepting the DAOs
    public ShowtimeService(ShowtimeDAO showtimeDAO, MovieDAO movieDAO) {
        this.showtimeDAO = showtimeDAO;
        this.movieDAO = movieDAO;
    }

    //You can also crate mulitple constructors that dont require some DAOs
    //This is usally use when we wanted to use a method but dont require all DAOs
    public ShowtimeService(ShowtimeDAO showtimeDAO) {
        this.showtimeDAO = showtimeDAO;
        this.movieDAO = movieDAO;
    }

    //Get showtimes by cinemaID
    public ArrayList<ShowtimeDTO> getShowtimesByCinemaId(String cinemaId) throws SQLException {
        return showtimeDAO.getShowtimesByCinemaId(cinemaId);
    }

    //Get all showtimes
    public ArrayList<ShowtimeDTO> getAllShowtimes() throws SQLException {
        return showtimeDAO.getAllShowtimes();
    }

    //Get all halls
    public ArrayList<ShowtimeHallDTO> getAllHalls() throws SQLException {
        return showtimeDAO.getAllHalls();
    }

    //Get all halls by cinemaId
    public ArrayList<ShowtimeHallDTO> getHallsByCinemaId(String cinemaID) throws SQLException {
        return showtimeDAO.getHallsByCinemaId(cinemaID);
    }

    //Get dates for a movie by movie id
    public ArrayList<DateTimeDTO> getDateTimesByMovieId(String movieId) throws SQLException {

        //Get all current showtimes
        ArrayList<Showtime> showtimes = showtimeDAO.getShowtimesByMovieId(movieId);

        //Extract showtime attributes and insert them into DateTimeDTO
        ArrayList<DateTimeDTO> dateTimes = new ArrayList<>();
        for (Showtime showtime : showtimes) {
            DateTimeDTO dateTimeDTO = new DateTimeDTO(
                    showtime.getShowDate(),
                    showtime.getStartTime(),
                    showtime.getEndTime()
            );

            dateTimes.add(dateTimeDTO);
        }

        return dateTimes;
    }

    // Get showtimes for a movie on a specific date
    public ArrayList<ShowtimeDTO> getShowtimesByMovieAndDate(String movieId, Date showDate) throws SQLException {
        return showtimeDAO.getShowtimesByMovieAndDate(movieId, showDate);
    }

// Get available dates for a movie
    public ArrayList<Date> getAvailableDates(String movieId) throws SQLException {
        return showtimeDAO.getAvailableDatesByMovieId(movieId);
    }

    //Insert Showtime
    public boolean insertShowtime(String movieId, String hallId, Date showDate, Time startTime) throws SQLException {

        //Calculate show end time
        Movie movie = movieDAO.getMovieById(movieId);
        if (movie == null) {
            return false;
        }

        LocalTime localTimeDuration = movie.getDuration().toLocalTime();

        //Check collision
        Showtime showtime = showtimeDAO.getShowtimeByDateTime(hallId, showDate, startTime, startTime);
        if (showtime != null) {
            return false;
        }

        Time showEndTime = TimeUtil.addTimes(startTime, movie.getDuration());

        //Insert showtime
        String showtimeId = showtimeDAO.generateId();
        if (showtimeId == null) {
            return false;
        }
        Showtime newShowtime = new Showtime(
                showtimeId,
                movieId,
                hallId,
                showDate,
                startTime,
                showEndTime
        );

        System.out.println(newShowtime);
        return showtimeDAO.insertShowtime(newShowtime);
    }

    //Update showtime
    public boolean updateShowtime(String showtimeId, String movieId, String hallId, Date showDate, Time startTime) throws SQLException {
        //Retrive movie duration
        Movie movie = movieDAO.getMovieById(movieId);
        if (movie == null) {
            System.out.println("Unable to retrive movie");
            return false;
        }
        Time duration = movie.getDuration();

        //Compute end showtime
        Time endShowtime = TimeUtil.addTimes(startTime, duration);
        System.out.println("End show: " + endShowtime);

        //Check collision date time
        Showtime collisionedShowtime = showtimeDAO.getShowtimeByDateTime(hallId, showDate, startTime, endShowtime);
        if (collisionedShowtime != null) {
            System.out.println("Unabel to update showtime due to time collision with other showtime");
            return false;
        }

        //Update into db
        Showtime updatedShowtime = new Showtime(showtimeId, movieId, hallId, showDate, startTime, endShowtime);
        return showtimeDAO.updateShowtime(updatedShowtime);
    }

}
