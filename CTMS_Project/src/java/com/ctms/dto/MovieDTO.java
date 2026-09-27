package com.ctms.dto;

import java.sql.Time;
import java.time.LocalTime;
import java.util.Base64;

public class MovieDTO {

    private String id;
    private String title;
    private byte[] poster;
    private String rating;
    private String genere;
    private String description;
    private String trailerURL;
    private Time duration;
    private String formattedPoster;
    private String formattedDuration;

    public MovieDTO(String id, String title, byte[] poster, String rating, String genere, String description, Time duration, String trailerURL) {
        this.id = id;
        this.title = title;
        this.poster = poster;
        this.rating = rating;
        this.description = description;
        this.genere = genere;
        this.duration = duration;
        this.trailerURL = trailerURL;

    }

    public String getFomrattedPoster() {
        String imageTag = null;
        byte[] posterBytes = poster;
        if (posterBytes != null && posterBytes.length > 0) {
            String base64Image = java.util.Base64.getEncoder().encodeToString(posterBytes);
            imageTag = "data:image/jpeg;base64," + base64Image;
        }
        return imageTag;
    }

    public String formatDuration() {
        if (duration == null) {
            return "";
        }

        LocalTime localDuration = duration.toLocalTime();

        int hours = localDuration.getHour();
        int minutes = localDuration.getMinute();

        return String.format("%dH %02dM", hours, minutes);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public byte[] getPoster() {
        return poster;
    }

    public void setPoster(byte[] poster) {
        this.poster = poster;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public String getGenere() {
        return genere;
    }

    public void setGenere(String genere) {
        this.genere = genere;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Time getDuration() {
        return duration;
    }

    public void setDuration(Time duration) {
        this.duration = duration;
    }

    public String getTrailerURL() {
        return trailerURL;
    }

    public void setTrailerURL(String trailerURL) {
        this.trailerURL = trailerURL;
    }

    public String getFormattedPoster() {
        return formattedPoster;
    }

    public void setFormattedPoster(String formattedPoster) {
        this.formattedPoster = formattedPoster;
    }

    public String getFormattedDuration() {
        return formattedDuration;
    }

    public void setFormattedDuration(String formattedDuration) {
        this.formattedDuration = formattedDuration;
    }

}
