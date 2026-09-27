<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.ctms.dto.*, java.util.*"%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CTMS-Movie List</title>

        <%
            ArrayList<MovieDTO> movies = (ArrayList<MovieDTO>) request.getAttribute("movies");

            if (movies == null) {
                response.sendRedirect(request.getContextPath() + "/ViewMovieListServlet");
                return;
            }
            
            for (MovieDTO movie : movies) {
                String formattedPoster = movie.getFomrattedPoster();
                String defaultPoster = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='14' font-weight='bold'%3" + movie.getTitle() + "%3C/text%3E%3Ctext x='150' y='240' text-anchor='middle' fill='%236b6358' font-size='10'%3EPART TWO%3C/text%3E%3C/svg%3E";
                movie.setFormattedPoster(formattedPoster != null ? formattedPoster : defaultPoster);
                movie.setFormattedDuration(movie.formatDuration());
            }
        %>
    </head>

    <body>
        <%@ include file="header.jsp" %>

        <main class="page-offset">
            <div class="container" style="max-width:1400px;margin:0 auto;padding:40px 20px;">

                <%-- PAGE TITLE BAR (like food menu) --%>
                <div class="page-title-bar">
                    <div>
                        <div class="page-breadcrumb">
                            <a href="index.jsp">Home</a> › 
                            <span>Movies</span>
                        </div>
                        <h1>NOW <span>PLAYING</span></h1>
                        <div class="section-sub">Currently showing in cinemas near you</div>
                    </div>
                    <span class="role-badge customer">Customer View</span>
                </div><br><br>

                <div class="movie-grid">

                    <c:forEach var="movie" items="${movies}">
                        <div class="movie-card">
                            <div class="card-poster">
                                <img src="${movie.formattedPoster}"
                                     alt="Dune: Part Two" class="poster-image">
                                <div class="age-badge" data-age="PG-13">${movie.rating}</div>
                                <div class="movie-overlay">
                                    <div class="overlay-title">${movie.title}</div>
                                    <div class="overlay-genre">${movie.genere}</div>
                                    <div class="overlay-meta">${movie.formattedDuration}</div>
                                    <div class="overlay-age" data-age="PG-13">${movie.rating}</div>
                                    <button class="overlay-btn" onclick="location.href = '<%= request.getContextPath() %>/BookingScheduleServlet?movieId=<%= ((MovieDTO)pageContext.getAttribute("movie")).getId() %>'">BUY NOW</button>
                                    <button class="overlay-info-btn" onclick="location.href = 'ViewMovieDetailServlet?movieId=${movie.id}'">ⓘ</button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                </div>
            </div>
        </main>

        <%@ include file="footer.jsp" %>

    </body>
</html>





