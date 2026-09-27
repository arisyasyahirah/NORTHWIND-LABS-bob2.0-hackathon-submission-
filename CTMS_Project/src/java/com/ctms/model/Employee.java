package com.ctms.model;

public class Employee {
    private String id;
    private String email;
    private String password;
    private String name;
    private String phone_number;
    private String position;
    private String cinemaId; //Syamil
    private int restrictionLevel; //Syamil

    public Employee(String id, String email, String password, String name, String phone_number, String position, String cinemaId, int restrictionLevel) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.name = name;
        this.phone_number = phone_number;
        this.position = position; //Syamil
        this.cinemaId = cinemaId; //Syamil
        this.restrictionLevel = restrictionLevel;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone_number() {
        return phone_number;
    }

    public void setPhone_number(String phone_number) {
        this.phone_number = phone_number;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getCinemaId() {
        return cinemaId;
    }

    public void setCinemaId(String cinemaId) {
        this.cinemaId = cinemaId;
    }

    public int getRestrictionLevel() {
        return restrictionLevel;
    }

    public void setRestrictionLevel(int restrictionLevel) {
        this.restrictionLevel = restrictionLevel;
    }
    
    
    
}
