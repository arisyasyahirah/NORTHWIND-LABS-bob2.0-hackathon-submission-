package com.ctms.model;

import java.sql.Time;

// model/Movie.java
public class Movie {

    private String id;
    private String title;
    private Time duration;
    private String rating;
    private String genere;
    private String description;
    private String trailer;
    private byte[] poster;
    private byte[] banner;

    // Constructors
    public Movie() {
    }

    public Movie(String id, String title, Time duration, String rating,
            String genere, String description, String trailer,
            byte[] poster, byte[] banner) {
        this.id = id;
        this.title = title;
        this.duration = duration;
        this.rating = rating;
        this.genere = genere;
        this.description = description;
        this.trailer = trailer;
        this.poster = poster;
        this.banner = banner;
    }

    // Getters & Setters
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

    public byte[] getPoster() {
        return poster;
    }

    public void setPoster(byte[] poster) {
        this.poster = poster;
    }

    public byte[] getBanner() {
        return banner;
    }

    public void setBanner(byte[] banner) {
        this.banner = banner;
    }
}