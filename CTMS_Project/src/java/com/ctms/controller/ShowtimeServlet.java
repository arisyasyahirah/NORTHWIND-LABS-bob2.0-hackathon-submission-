package com.ctms.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.ctms.dao.*;
import com.ctms.dto.MovieDTO;
import com.ctms.dto.ShowtimeDTO;
import com.ctms.dto.ShowtimeHallDTO;
import com.ctms.model.Employee;
import com.ctms.service.*;
import jakarta.servlet.RequestDispatcher;
import java.util.ArrayList;

public class ShowtimeServlet extends HttpServlet {

    private MovieDAO movieDAO;
    private ShowtimeDAO showtimeDAO;
    private ShowtimeService showtimeService;
    private MovieService movieService;

    public void init() {
        //Initialize everything that you need here
        movieDAO = new MovieDAO();
        showtimeDAO = new ShowtimeDAO();
        movieService = new MovieService(movieDAO);
        showtimeService = new ShowtimeService(showtimeDAO, movieDAO);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Do the main logic
        //Servlets are places for try catch blocks. The rest use throws instead
        try {
            //Get employee
            Employee employee = (Employee) request.getSession().getAttribute("employee");
            if (employee == null) {
                response.sendRedirect(request.getContextPath() + "/HomeServlet");
                System.out.println("Unable to find employee");
                return;
            }

            //Get cinema id from employer
            String cinemaId = employee.getCinemaId();

            //Get showtime list
            ArrayList<ShowtimeDTO> list;
            ArrayList<ShowtimeHallDTO> halls;
            if (cinemaId != null) {
                list = showtimeService.getShowtimesByCinemaId(cinemaId);
                halls = showtimeService.getHallsByCinemaId(cinemaId);
                
                for (ShowtimeHallDTO hall : halls){
                    hall.setCinemaName("");
                }
            } else {
                list = showtimeService.getAllShowtimes();
                halls = showtimeService.getAllHalls();
            }
            
            //Get movie list
            ArrayList<MovieDTO> movies = movieService.getAllMovies();

            request.setAttribute("showtimeList", list);
            request.setAttribute("movieList", movies);
            request.setAttribute("hallList", halls);
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("showtimeManage.jsp");
            requestDispatcher.forward(request, response);

        } catch (SQLException ex) {
            Logger.getLogger(ShowtimeServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
