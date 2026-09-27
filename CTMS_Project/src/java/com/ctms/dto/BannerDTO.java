package com.ctms.dto;

import java.sql.Time;
import java.time.LocalTime;
import java.util.Base64;

public class BannerDTO {

    private String id;
    private String title;
    private Time duration;
    private String rating;
    private String genere;
    private String description;
    private String trailer;
    private byte[] banner;
    private String formattedBanner;
    private String formattedDuration;

    public BannerDTO(String id, String title, Time duration, String rating, String genere, String description, String trailer, byte[] banner) {
        this.id = id;
        this.title = title;
        this.duration = duration;
        this.rating = rating;
        this.genere = genere;
        this.description = description;
        this.trailer = trailer;
        this.banner = banner;
    }

    public String getFomrattedBanner() {
        String imageTag = null;
        byte[] posterBytes = banner;
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

    public Time getDuration() {
        return duration;
    }

    public void setDuration(Time duration) {
        this.duration = duration;
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

    public String getTrailer() {
        return trailer;
    }

    public void setTrailer(String trailer) {
        this.trailer = trailer;
    }

    public byte[] getBanner() {
        return banner;
    }

    public void setBanner(byte[] banner) {
        this.banner = banner;
    }

    public String getFormattedBanner() {
        return formattedBanner;
    }

    public void setFormattedBanner(String formattedBanner) {
        this.formattedBanner = formattedBanner;
    }

    public String getFormattedDuration() {
        return formattedDuration;
    }

    public void setFormattedDuration(String formattedDurarion) {
        this.formattedDuration = formattedDurarion;
    }

}
