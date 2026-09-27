package com.ctms.controller;

import com.ctms.dao.MovieDAO;
import com.ctms.dto.MovieDTO;
import com.ctms.model.Movie;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;

public class ViewMovieDetailServlet extends HttpServlet {

    private MovieDAO movieDAO;

    public void init() {
        movieDAO = new MovieDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String movieId = request.getParameter("movieId");
        
        if (movieId == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            System.out.println("Servlet: Movie id is missing");
            return;
        }
        

        try {
            Movie movie = movieDAO.getMovieById(movieId);
            MovieDTO movieDTO = null;

            if (movie != null) {
                movieDTO = new MovieDTO(
                        movie.getId(),
                        movie.getTitle(),
                        movie.getPoster(),
                        movie.getRating(),
                        movie.getGenere(),
                        movie.getDescription(),
                        movie.getDuration(),
                        movie.getTrailer()
                );
            }else{
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                System.out.println("Servlet: Movie does not exist");
                return;
            }
            
            request.setAttribute("MovieDetails", movieDTO);
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("/movie-details.jsp");
            requestDispatcher.forward(request, response);
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

    }

}
