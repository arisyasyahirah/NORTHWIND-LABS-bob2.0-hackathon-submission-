package com.ctms.dto;

public class ShowtimeHallDTO {

    private String hallId;
    private String hallType;
    private String cinemaName;

    public ShowtimeHallDTO(String hallId, String hallType, String cinemaName) {
        this.hallId = hallId;
        this.hallType = hallType;
        this.cinemaName = cinemaName;
    }

    public String getHallId() {
        return hallId;
    }

    public void setHallId(String hallId) {
        this.hallId = hallId;
    }

    public String getHallType() {
        return hallType;
    }

    public void setHallType(String hallType) {
        this.hallType = hallType;
    }

    public String getCinemaName() {
        return cinemaName;
    }

    public void setCinemaName(String cinemaName) {
        this.cinemaName = cinemaName;
    }

}
