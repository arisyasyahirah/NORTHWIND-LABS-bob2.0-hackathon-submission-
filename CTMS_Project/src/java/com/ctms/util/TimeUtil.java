package com.ctms.util;

import java.sql.Time;
import java.time.LocalTime;

public class TimeUtil {

    public static Time addTimes(Time t1, Time t2) {
        LocalTime result = t1.toLocalTime()
                .plusHours(t2.toLocalTime().getHour())
                .plusMinutes(t2.toLocalTime().getMinute())
                .plusSeconds(t2.toLocalTime().getSecond());
        return Time.valueOf(result);
    }

    public static Time subtractTimes(Time t1, Time t2) {
        LocalTime result = t1.toLocalTime()
                .minusHours(t2.toLocalTime().getHour())
                .minusMinutes(t2.toLocalTime().getMinute())
                .minusSeconds(t2.toLocalTime().getSecond());
        return Time.valueOf(result);
    }

    public static Time parseTime(String time) {
        String[] parts = time.split(":");
        String normalized = parts[0] + ":" + parts[1] + ":" + (parts.length >= 3 ? parts[2] : "00");
        return Time.valueOf(normalized);
    }
}
