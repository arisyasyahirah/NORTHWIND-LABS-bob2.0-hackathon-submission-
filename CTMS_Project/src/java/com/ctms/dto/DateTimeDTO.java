package com.ctms.dto;

import java.sql.Date;
import java.sql.Time;
import java.time.*;
import java.time.format.TextStyle;
import java.util.Locale;

public class DateTimeDTO {

    private Date showDate;
    private Time startTime;
    private Time endTime;
    private DayOfWeek day;
    private String dayName;
    private String shortDayName;
    private Month month;
    private String monthName;
    private String shortMonthName;

    //Constructor
    public DateTimeDTO(Date showDate, Time startTime, Time endTime) {
        this.showDate = showDate;
        this.startTime = startTime;
        this.endTime = endTime;

        day = showDate.toLocalDate().getDayOfWeek();
        dayName = day.getDisplayName(TextStyle.FULL, Locale.ENGLISH);
        shortDayName = day.getDisplayName(TextStyle.SHORT, Locale.ENGLISH);

        
        month = showDate.toLocalDate().getMonth();
        monthName = month.getDisplayName(TextStyle.FULL, Locale.ENGLISH);
        shortMonthName = month.getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
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

    public DayOfWeek getDay() {
        return day;
    }

    public void setDay(DayOfWeek day) {
        this.day = day;
    }

    public String getDayName() {
        return dayName;
    }

    public void setDayName(String dayName) {
        this.dayName = dayName;
    }

    public String getShortDayName() {
        return shortDayName;
    }

    public void setShortDayName(String shortDayName) {
        this.shortDayName = shortDayName;
    }
    
    public Month getMonth() {
        return month;
    }
    
    public void setMonth(Month month) {
        this.month = month;
    }
    
    public String getMonthName() {
        return monthName;
    }
    
    public void setMonthName(String monthName) {
        this.monthName = monthName;
    }
    
    public String getShortMonthName() {
        return shortMonthName;
    }
    
    public void setShortMonthName(String shortMonthName) {
        this.shortMonthName = shortMonthName;
    }
    
    
    public String getMonthShort() {
        return shortMonthName;
    }
    
    public int getDayOfMonth() {
        return showDate.toLocalDate().getDayOfMonth();
    }

}
