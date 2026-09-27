package com.ctms.dao;

import com.ctms.dto.ShowtimeDTO;
import com.ctms.dto.ShowtimeHallDTO;
import java.sql.*;
import java.util.ArrayList;
import com.ctms.model.Showtime;
import com.ctms.util.ConnectionDB;

public class ShowtimeDAO {

    private Connection connection;

    public ShowtimeDAO() {
        this.connection = new ConnectionDB().getConnection();
    }

    //Return all showtimeDTOs from DB
    public ArrayList<ShowtimeDTO> getAllShowtimes() throws SQLException {
        String sql = "SELECT * FROM showtime s INNER JOIN hall h USING(hall_id)INNER JOIN halltype USING(hall_type_id) INNER JOIN movie m USING(movie_id)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql); ResultSet result = pstmt.executeQuery()) {
            ArrayList<ShowtimeDTO> showtimes = new ArrayList<>();
            while (result.next()) {
                ShowtimeDTO showtime = new ShowtimeDTO(
                        result.getString("showtime_id"),
                        result.getString("movie_title"),
                        result.getString("movie_id"),
                        result.getString("hall_type"),
                        result.getString("hall_id"),
                        result.getDate("show_date"),
                        result.getTime("show_start_time"),
                        result.getTime("show_end_time")
                );
                showtimes.add(showtime);
            }
            return showtimes;
        }
    }

    //Return a list of showtimeDTO (current and future) for a cinema
    public ArrayList<ShowtimeDTO> getShowtimesByCinemaId(String cinemaId) throws SQLException {
        String sql = "SELECT * FROM showtime s INNER JOIN hall h USING(hall_id)INNER JOIN halltype USING(hall_type_id) INNER JOIN movie m USING(movie_id) WHERE h.cinema_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, cinemaId);

            try (ResultSet result = pstmt.executeQuery()) {
                ArrayList<ShowtimeDTO> showtimes = new ArrayList<>();
                while (result.next()) {
                    ShowtimeDTO showtime = new ShowtimeDTO(
                            result.getString("showtime_id"),
                            result.getString("movie_title"),
                            result.getString("movie_id"),
                            result.getString("hall_type"),
                            result.getString("hall_id"),
                            result.getDate("show_date"),
                            result.getTime("show_start_time"),
                            result.getTime("show_end_time")
                    );
                    showtimes.add(showtime);
                }
                return showtimes;

            } catch (SQLException e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Return a showtime based on showtime id
    public Showtime getShowtimeById(String id) throws SQLException {
        String sql = "SELECT * FROM showtime WHERE showtime_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet result = pstmt.executeQuery()) {
                if (result.next()) {
                    return new Showtime(
                            result.getString("showtime_id"),
                            result.getString("movie_id"),
                            result.getString("hall_id"),
                            result.getDate("show_date"),
                            result.getTime("show_start_time"),
                            result.getTime("show_end_time")
                    );
                }
            }
        }
        return null;
    }

    public ArrayList<ShowtimeDTO> getShowtimesByMovieAndDate(String movieId, Date showDate) throws SQLException {
        String sql = "SELECT s.showtime_id, m.movie_title, s.movie_id, "
                + "ht.hall_type, s.hall_id, "
                + "s.show_date, s.show_start_time, s.show_end_time, "
                + "c.cinema_name, c.branch "
                + "FROM showtime s "
                + "INNER JOIN hall h USING(hall_id) "
                + "INNER JOIN halltype ht USING(hall_type_id) "
                + "INNER JOIN cinema c USING(cinema_id) "
                + "INNER JOIN movie m USING(movie_id) "
                + "WHERE s.movie_id = ? AND s.show_date = ? "
                + "ORDER BY c.branch, c.cinema_name, s.show_start_time";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, movieId);
            pstmt.setDate(2, showDate);

            try (ResultSet result = pstmt.executeQuery()) {
                ArrayList<ShowtimeDTO> showtimes = new ArrayList<>();
                while (result.next()) {
                    ShowtimeDTO showtime = new ShowtimeDTO(
                            result.getString("showtime_id"),
                            result.getString("movie_title"),
                            result.getString("movie_id"),
                            result.getString("hall_type"),
                            result.getString("hall_id"),
                            result.getDate("show_date"),
                            result.getTime("show_start_time"),
                            result.getTime("show_end_time")
                    );
                    showtime.setCinemaName(result.getString("cinema_name"));
                    showtime.setBranch(result.getString("branch"));
                    showtimes.add(showtime);
                }
                return showtimes;
            }
        }
    }

    public ArrayList<Date> getAvailableDatesByMovieId(String movieId) throws SQLException {
        String sql = "SELECT DISTINCT show_date FROM showtime "
                + "WHERE movie_id = ? AND show_date >= CURRENT_DATE "
                + "ORDER BY show_date ASC LIMIT 7";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, movieId);

            try (ResultSet result = pstmt.executeQuery()) {
                ArrayList<Date> dates = new ArrayList<>();
                while (result.next()) {
                    dates.add(result.getDate("show_date"));
                }
                return dates;
            }
        }
    }

    // Insert showtime into DB
    public boolean insertShowtime(Showtime showtime) throws SQLException {
        String sql = "INSERT INTO showtime (showtime_id, movie_id, hall_id, show_date, show_start_time, show_end_time) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, showtime.getId());
            pstmt.setString(2, showtime.getMovieId());
            pstmt.setString(3, showtime.getHallId());
            pstmt.setDate(4, showtime.getShowDate());
            pstmt.setTime(5, showtime.getStartTime());
            pstmt.setTime(6, showtime.getEndTime());
            int rows = pstmt.executeUpdate();

            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update showtime from DB by ID
    public boolean updateShowtime(Showtime showtime) throws SQLException {
        String sql = "UPDATE showtime SET movie_id = ?, hall_id = ?, show_date = ?, show_start_time = ?, show_end_time = ? WHERE showtime_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, showtime.getMovieId());
            pstmt.setString(2, showtime.getHallId());
            pstmt.setDate(3, showtime.getShowDate());
            pstmt.setTime(4, showtime.getStartTime());
            pstmt.setTime(5, showtime.getEndTime());
            pstmt.setString(6, showtime.getId());
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Delete showtime from DB based on showtime id
    public boolean deleteShowtimeById(String showtimeId) throws SQLException {
        String sql = "DELETE FROM showtime WHERE showtime_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, showtimeId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        }
    }

    // Returns all showtimes based on movie id. It only returns current and future showtime dates
    public ArrayList<Showtime> getShowtimesByMovieId(String movieId) throws SQLException {
        String sql = "SELECT * FROM showtime WHERE show_date >= CURRENT_DATE AND movie_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, movieId);
            try (ResultSet result = pstmt.executeQuery()) {
                ArrayList<Showtime> showtimes = new ArrayList<>();
                while (result.next()) {
                    Showtime showtime = new Showtime(
                            result.getString("showtime_id"),
                            result.getString("movie_id"),
                            result.getString("hall_id"),
                            result.getDate("show_date"),
                            result.getTime("show_start_time"),
                            result.getTime("show_end_time")
                    );
                    showtimes.add(showtime);
                }
                return showtimes;
            }
        }
    }

    //Get showtime by date time (Use for to check time collision)
    public Showtime getShowtimeByDateTime(String hallId, Date showDate, Time startTime, Time endTime) throws SQLException {
        String sql = "SELECT * FROM showtime WHERE hall_id = ? AND show_date = ? AND show_start_time < ? AND show_end_time > ? LIMIT 1";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, hallId);
            pstmt.setDate(2, showDate);
            pstmt.setTime(3, startTime);
            pstmt.setTime(4, endTime);

            try (ResultSet result = pstmt.executeQuery()) {
                if (result.next()) {
                    return new Showtime(
                            result.getString("showtime_id"),
                            result.getString("movie_id"),
                            result.getString("hall_id"),
                            result.getDate("show_date"),
                            result.getTime("show_start_time"),
                            result.getTime("show_end_time")
                    );
                }
            }
        }

        return null;
    }

    //Get all halls based
    public ArrayList<ShowtimeHallDTO> getAllHalls() throws SQLException {
        String sql = "SELECT * FROM hall h INNER JOIN halltype ht USING(hall_type_id) INNER JOIN cinema c USING(cinema_id)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql); ResultSet result = pstmt.executeQuery()) {

            ArrayList<ShowtimeHallDTO> halls = new ArrayList<>();
            while (result.next()) {
                halls.add(new ShowtimeHallDTO(
                        result.getString("hall_id"),
                        result.getString("hall_type"),
                        result.getString("cinema_name")
                ));
            }

            return halls;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    //Get all halls based on cinema id
    public ArrayList<ShowtimeHallDTO> getHallsByCinemaId(String cinemaId) throws SQLException {
        String sql = "SELECT * FROM hall h INNER JOIN halltype ht USING(hall_type_id) INNER JOIN cinema c USING(cinema_id) WHERE cinema_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, cinemaId);

            try (ResultSet result = pstmt.executeQuery()) {
                ArrayList<ShowtimeHallDTO> halls = new ArrayList<>();
                while (result.next()) {
                    halls.add(new ShowtimeHallDTO(
                            result.getString("hall_id"),
                            result.getString("hall_type"),
                            result.getString("cinema_name")
                    ));
                }

                return halls;
            } catch (SQLException e) {
                e.printStackTrace();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Generate showtime id
    public String generateId() throws SQLException {
        String sql = "SELECT counter FROM idcounter WHERE table_name = 'showtime'";
        try (PreparedStatement pstmt = connection.prepareStatement(sql); ResultSet result = pstmt.executeQuery()) {
            if (result.next()) {
                int counter = result.getInt("counter") + 1;
                return "ST" + String.format("%03d", counter);
            }
        }
        return null;
    }
}
