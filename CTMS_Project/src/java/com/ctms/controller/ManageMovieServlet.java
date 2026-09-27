package com.ctms.controller;

import com.ctms.dao.MovieDAO;
import com.ctms.dto.MovieDTO;
import com.ctms.service.MovieService;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.ArrayList;

public class ManageMovieServlet extends HttpServlet {

    private MovieDAO movieDAO;
    private MovieService movieService;

    public void init() {
        //Initialize everything that you need here
        movieDAO = new MovieDAO();
        movieService = new MovieService(movieDAO);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            ArrayList<MovieDTO> movies = movieService.getAvailableMovies(5);

            request.setAttribute("movies", movies);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("movieManage.jsp");
            requestDispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
