package com.ctms.model;

import java.sql.*;

public class Showtime {

    private String id;
    private String movieId;
    private String hallId;
    private Date showDate;
    private Time startTime;
    private Time endTime;

    public Showtime(String id, String movieId, String hallId, Date showDate,
            Time startTime, Time endTime) {
        this.id = id;
        this.movieId = movieId;
        this.hallId = hallId;
        this.showDate = showDate;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    // Getters & Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMovieId() {
        return movieId;
    }

    public void setMovieId(String movieId) {
        this.movieId = movieId;
    }

    public String getHallId() {
        return hallId;
    }

    public void setHallId(String hallId) {
        this.hallId = hallId;
    }

    public Date getShowDate() {
        return showDate;
    }

    public void setShowDate(Date showDate) {
        this.showDate = showDate;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }
}
