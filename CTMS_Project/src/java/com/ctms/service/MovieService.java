package com.ctms.service;

import com.ctms.dao.MovieDAO;
import com.ctms.dto.*;
import com.ctms.model.Movie;
import java.sql.*;
import java.util.ArrayList;

public class MovieService {

    private MovieDAO movieDAO;

    public MovieService(MovieDAO movieDAO) {
        this.movieDAO = movieDAO;
    }

    //Get current movies that are playing.
    public ArrayList<MovieDTO> getAvailableMovies(int numberOfMovies) throws SQLException {
        ArrayList<MovieDTO> movieList = new ArrayList<>();

        ArrayList<Movie> movies = movieDAO.getCurrentPlayingMovies(numberOfMovies);

        for (Movie movie : movies) {
            MovieDTO movieDTO = new MovieDTO(
                    movie.getId(),
                    movie.getTitle(),
                    movie.getPoster(),
                    movie.getRating(),
                    movie.getGenere(),
                    movie.getDescription(),
                    movie.getDuration(),
                    movie.getTrailer()
            );

            movieList.add(movieDTO);
        }

        return movieList;
    }

    //Get all movies
    public ArrayList<MovieDTO> getAllMovies() throws SQLException {
        ArrayList<MovieDTO> movieList = new ArrayList<>();

        ArrayList<Movie> movies = movieDAO.getAllMovies();

        for (Movie movie : movies) {
            MovieDTO movieDTO = new MovieDTO(
                    movie.getId(),
                    movie.getTitle(),
                    movie.getPoster(),
                    movie.getRating(),
                    movie.getGenere(),
                    movie.getDescription(),
                    movie.getDuration(),
                    movie.getTrailer()
            );

            movieList.add(movieDTO);
        }

        return movieList;
    }

    //Get movie banners from current available movies
    public ArrayList<BannerDTO> getBannersFromAvailableMovies() throws SQLException {
        ArrayList<Movie> movies = movieDAO.getCurrentPlayingMovies(5);

        ArrayList<BannerDTO> banners = new ArrayList<>();
        for (Movie movie : movies) {
            BannerDTO bannerDTO = new BannerDTO(
                    movie.getId(),
                    movie.getTitle(),
                    movie.getDuration(),
                    movie.getRating(),
                    movie.getGenere(),
                    movie.getDescription(),
                    movie.getTrailer(),
                    movie.getBanner()
            );
            banners.add(bannerDTO);
        }

        return banners;
    }

    // Add this to MovieService.java
    public MovieDTO getMovieById(String movieId) throws SQLException {
        Movie movie = movieDAO.getMovieById(movieId);
        if (movie == null) {
            return null;
        }

        return new MovieDTO(
                movie.getId(),
                movie.getTitle(),
                movie.getPoster(),
                movie.getRating(),
                movie.getGenere(),
                movie.getDescription(),
                movie.getDuration(),
                movie.getTrailer()
        );
    }

    //Insert movie
    public boolean insertMovie(String title, Time duration, String rating, String genere, String description, String trailer,
            byte[] poster, byte[] banner) throws SQLException {
        String movieId = movieDAO.generateId();
        Movie movie = new Movie(
                movieId,
                title,
                duration,
                rating,
                genere,
                description,
                trailer,
                poster,
                banner
        );

        return movieDAO.insertMovie(movie);
    }

    //Delete movie
    public boolean deleteMovie(String movieId) throws SQLException {
        return movieDAO.deleteMovieById(movieId);
    }

    //Update movie
    public boolean updateMovie(String movieId, String title, Time duration, String rating, String genere, String description, String trailer,
            byte[] poster, byte[] banner) throws SQLException {

        //Create basic movie object
        Movie movie = new Movie(
                movieId,
                title,
                duration,
                rating,
                genere,
                description,
                trailer,
                poster,
                banner
        );

        //Update movie
        boolean success = movieDAO.basicUpdateMovie(movie);

        //Check if poster is empty
        boolean isPosterUpdated = true; //Default is true for nothing to be updated
        if (poster != null) {
            Movie moviePoster = new Movie();
            moviePoster.setId(movieId);
            moviePoster.setPoster(poster);
            isPosterUpdated = movieDAO.updateMoviePoster(moviePoster);
        }

        //Check if banner is empty
        boolean isBannerUpdated = true; //Default is true for nothing to be updated
        if (banner != null) {
            Movie movieBanner = new Movie();
            movieBanner.setId(movieId);
            movieBanner.setBanner(banner);
            isBannerUpdated = movieDAO.updateMovieBanner(movieBanner);
        }

        return success && isPosterUpdated && isBannerUpdated;
    }
}
