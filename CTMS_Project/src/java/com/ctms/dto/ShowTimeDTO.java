package com.ctms.dto;

import java.sql.Date;
import java.sql.Time;

public class ShowtimeDTO {

    private String showtimeId;
    private String movieTitle;
    private String movieId;
    private String hallType;
    private String hallId;
    private Date showDate;
    private Time showStartTime;
    private Time showEndTime;
    private String cinemaName;
    private String branch;
    private boolean soldOut;
    private boolean lastShow;

    public ShowtimeDTO(String showtimeId, String movieTitle, String movieId, String hallType, String hallId, Date showDate, Time showStartTime, Time showEndTime) {
        this.showtimeId = showtimeId;
        this.movieTitle = movieTitle;
        this.movieId = movieId;
        this.hallType = hallType;
        this.hallId = hallId;
        this.showDate = showDate;
        this.showStartTime = showStartTime;
        this.showEndTime = showEndTime;
    }

    public String getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(String showtimeId) {
        this.showtimeId = showtimeId;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public String getMovieId() {
        return movieId;
    }

    public void setMovieId(String movieId) {
        this.movieId = movieId;
    }

    public String getHallType() {
        return hallType;
    }

    public void setHallType(String hallType) {
        this.hallType = hallType;
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

    public Time getShowStartTime() {
        return showStartTime;
    }

    public void setShowStartTime(Time showStartTime) {
        this.showStartTime = showStartTime;
    }

    public Time getShowEndTime() {
        return showEndTime;
    }

    public void setShowEndTime(Time showStartEndTime) {
        this.showEndTime = showStartEndTime;
    }

    public String getCinemaName() {
        return cinemaName;
    }

    public void setCinemaName(String cinemaName) {
        this.cinemaName = cinemaName;
    }

    public String getBranch() {
        return branch;
    }

    public void setBranch(String branch) {
        this.branch = branch;
    }

    public boolean isSoldOut() {
        return soldOut;
    }

    public void setSoldOut(boolean soldOut) {
        this.soldOut = soldOut;
    }

    public boolean isLastShow() {
        return lastShow;
    }

    public void setLastShow(boolean lastShow) {
        this.lastShow = lastShow;
    }
                                    
}
