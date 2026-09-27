package com.ctms.dao;

import java.sql.*;
import java.util.*;
import com.ctms.model.Movie;
import com.ctms.util.ConnectionDB;

public class MovieDAO {

    private Connection connection;

    public MovieDAO() {
        this.connection = new ConnectionDB().getConnection();
    }

    // Retrieve all movies from DB
    public ArrayList<Movie> getAllMovies() throws SQLException {
        String sql = "SELECT * FROM movie";
        try (PreparedStatement pstmt = connection.prepareStatement(sql); ResultSet result = pstmt.executeQuery()) {
            ArrayList<Movie> movies = new ArrayList<>();
            while (result.next()) {
                movies.add(new Movie(
                        result.getString("movie_id"),
                        result.getString("movie_title"),
                        result.getTime("movie_duration"),
                        result.getString("rating"),
                        result.getString("genre"),
                        result.getString("movie_desc"),
                        result.getString("movie_trailer"),
                        result.getBytes("movie_poster"),
                        result.getBytes("movie_banner")
                ));
            }
            return movies;
        }
    }

// Retrieve a movie based on movie id
    public Movie getMovieById(String id) throws SQLException {
        String sql = "SELECT * FROM movie WHERE movie_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet result = pstmt.executeQuery()) {
                if (result.next()) {
                    return new Movie(
                            result.getString("movie_id"),
                            result.getString("movie_title"),
                            result.getTime("movie_duration"),
                            result.getString("rating"),
                            result.getString("genre"),
                            result.getString("movie_desc"),
                            result.getString("movie_trailer"),
                            result.getBytes("movie_poster"),
                            result.getBytes("movie_banner")
                    );
                }
            }
        }
        return null;
    }

// Insert movie into Database
    public boolean insertMovie(Movie movie) throws SQLException {
        String sql = "INSERT INTO movie VALUE (?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, movie.getId());
            pstmt.setString(2, movie.getTitle());
            pstmt.setTime(3, movie.getDuration());
            pstmt.setString(4, movie.getRating());
            pstmt.setString(5, movie.getGenere());
            pstmt.setString(6, movie.getDescription());
            pstmt.setString(7, movie.getTrailer());
            pstmt.setBytes(8, movie.getPoster());
            pstmt.setBytes(9, movie.getBanner());
            int rows = pstmt.executeUpdate();
            return rows > 0;
        }
    }

    // Update movie by movie id
    public boolean updateMovie(Movie movie) throws SQLException {
        String sql = "UPDATE movie SET movie_title = ?, movie_duration = ?, rating = ?, genre = ?, movie_desc = ?, movie_trailer = ?, movie_poster = ?, movie_banner = ? WHERE movie_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, movie.getTitle());
            pstmt.setTime(2, movie.getDuration());
            pstmt.setString(3, movie.getRating());
            pstmt.setString(4, movie.getGenere());
            pstmt.setString(5, movie.getDescription());
            pstmt.setString(6, movie.getTrailer());
            pstmt.setBytes(7, movie.getPoster());
            pstmt.setBytes(8, movie.getBanner());
            pstmt.setString(9, movie.getId());
            int rows = pstmt.executeUpdate();
            return rows > 0;
        }
    }

    //Update small movie by id
    public boolean basicUpdateMovie(Movie movie) throws SQLException {
        String sql = "UPDATE movie SET movie_title = ?, movie_duration = ?, rating = ?, genre = ?, movie_desc = ?, movie_trailer = ? WHERE movie_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, movie.getTitle());
            pstmt.setTime(2, movie.getDuration());
            pstmt.setString(3, movie.getRating());
            pstmt.setString(4, movie.getGenere());
            pstmt.setString(5, movie.getDescription());
            pstmt.setString(6, movie.getTrailer());
            pstmt.setString(7, movie.getId());
            int rows = pstmt.executeUpdate();
            return rows > 0;
        }
    }

    //Update movie poster
    public boolean updateMoviePoster(Movie movie) throws SQLException {
        String sql = "UPDATE movie SET movie_poster = ? WHERE movie_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setBytes(1, movie.getPoster());
            pstmt.setString(2, movie.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

    //Update movie banner
    public boolean updateMovieBanner(Movie movie) throws SQLException {
        String sql = "UPDATE movie SET movie_banner = ? WHERE movie_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setBytes(1, movie.getBanner());
            pstmt.setString(2, movie.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

// Delete movie by movie id
    public boolean deleteMovieById(String movieId) throws SQLException {
        String sql = "DELETE FROM movie WHERE movie_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, movieId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            if (e.getSQLState().startsWith("23")) { // 23000 = integrity constraint violation
                System.out.println("Cannot delete: movie is still referenced by other records.");
                return false;
            }
            throw e; // rethrow anything else unexpected
        }
    }

// Get current and playing movies (it will not return 2 same movies)
    public ArrayList<Movie> getCurrentPlayingMovies(int numberOfMovies) throws SQLException {
        String sql = "SELECT m.* FROM movie m JOIN showtime s USING (movie_id) WHERE s.show_date >= CURRENT_DATE GROUP BY m.movie_id LIMIT ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, numberOfMovies);
            try (ResultSet result = pstmt.executeQuery()) {
                ArrayList<Movie> movies = new ArrayList<>();
                while (result.next()) {
                    movies.add(new Movie(
                            result.getString("movie_id"),
                            result.getString("movie_title"),
                            result.getTime("movie_duration"),
                            result.getString("rating"),
                            result.getString("genre"),
                            result.getString("movie_desc"),
                            result.getString("movie_trailer"),
                            result.getBytes("movie_poster"),
                            result.getBytes("movie_banner")
                    ));
                }
                return movies;
            }
        }
    }

// Generate movie id
    public String generateId() throws SQLException {
        String sql = "SELECT counter FROM id_counter WHERE table_name = 'movie'";
        try (PreparedStatement pstmt = connection.prepareStatement(sql); ResultSet result = pstmt.executeQuery()) {
            if (result.next()) {
                int counter = result.getInt("counter") + 1;
                return "M" + String.format("%03d", counter);
            }
        }
        return null;
    }
}
