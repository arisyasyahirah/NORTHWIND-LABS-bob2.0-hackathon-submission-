<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.ctms.dto.*, java.util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CTMS-Homepage</title>

        <%
            ArrayList<BannerDTO> banners = (ArrayList<BannerDTO>) request.getAttribute("banners");
            ArrayList<MovieDTO> movies = (ArrayList<MovieDTO>) request.getAttribute("movies");

            if (banners == null || movies == null) {
                response.sendRedirect(request.getContextPath() + "/HomeServlet");
                return;
            }
            
            for (BannerDTO banner : banners) {
                String formattedBanner = banner.getFomrattedBanner();
                banner.setFormattedBanner(formattedBanner);
                banner.setFormattedDuration(banner.formatDuration());
            }

            for (MovieDTO movie : movies) {
                String formattedPoster = movie.getFomrattedPoster();
                String defaultPoster = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='14'%3E" + movie.getTitle() + "%3C/text%3E%3C/svg%3E";
                movie.setFormattedPoster(formattedPoster != null ? formattedPoster : defaultPoster);
                movie.setFormattedDuration(movie.formatDuration());
            }
        %>

    </head>

    <body>
        <%@ include file="header.jsp" %>

        <main class="page-offset">
            <!-- Slideshow container -->
            <div class="slideshow-container">

                <c:forEach var="banner"  items="${banners}">
                    <div class="mySlides fade active">
                        <img src="${banner.formattedBanner}" style="width:100%" alt="${banner.title}">
                        <div class="text">
                            <h2>${banner.title}</h2>
                            <p>${banner.genere} | ${banner.formattedDuration} | ${banner.rating}</p>
                            <button class="btn btn-primary" onclick="location.href = '${pageContext.request.contextPath}/BookingScheduleServlet?movieId=${banner.id}'" style="margin-top: 10px;">Book Now</button>
                        </div>
                    </div>
                </c:forEach>

                <!-- Next and previous buttons -->
                <a class="prev" onclick="plusSlides(-1)">&#10094;</a>
                <a class="next" onclick="plusSlides(1)">&#10095;</a>
            </div>
            <br>

            <!-- The dots/circles -->
            <div class="dots-container">
                <c:forEach var="banner" items="${banners}" varStatus="status">
                    <span class="dot ${status.first ? 'active' : ''}"
                          onclick="currentSlide(${status.index + 1})"></span>
                </c:forEach>
            </div>

            <%-- NOW PLAYING SECTION — 4 posters per row --%>
            <div class="container">
                <div class="section-header">
                    <div class="section-label">
                        <div>
                            <div class="section-title">Now Playing</div>
                            <div class="section-sub">Hover over a poster for movie details</div>
                        </div>
                    </div>
                    <a href="movieList.jsp" class="see-all-link">View All →</a>
                </div>

                <div class="movie-grid">

                    <c:forEach var="movie" items="${movies}">

                        <div class="movie-card">
                            <div class="card-poster">
                                <img src="${movie.formattedPoster}"
                                     alt="${movie.title}" class="poster-image">
                                <div class="age-badge" data-age="PG-13">${movie.rating}</div>
                                <div class="movie-overlay">
                                    <div class="overlay-title">${movie.title}</div>
                                    <div class="overlay-genre">${movie.genere}</div>
                                    <div class="overlay-meta">${movie.formattedDuration}</div>
                                    <div class="overlay-age">${movie.rating}</div>
                                    <button class="overlay-btn" onclick="location.href = '<%= request.getContextPath() %>/BookingScheduleServlet?movieId=<%= ((MovieDTO)pageContext.getAttribute("movie")).getId() %>'">BUY NOW</button>
                                    <button class="overlay-info-btn" onclick="location.href = 'ViewMovieDetailServlet?movieId=${movie.id}'">ⓘ</button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>




                </div>
        </main>

        <%@ include file="footer.jsp" %>


        <script>
            let slideIndex = 1;
            let autoTimer = null;

            // Show the current slide
            function showSlides(n) {
                let i;
                let slides = document.getElementsByClassName("mySlides");
                let dots = document.getElementsByClassName("dot");

                if (n > slides.length) {
                    slideIndex = 1;
                }
                if (n < 1) {
                    slideIndex = slides.length;
                }

                // Hide all slides
                for (i = 0; i < slides.length; i++) {
                    slides[i].classList.remove("active");
                    slides[i].style.display = "none";
                }

                // Remove active class from all dots
                for (i = 0; i < dots.length; i++) {
                    dots[i].className = dots[i].className.replace(" active", "");
                }

                // Show current slide
                slides[slideIndex - 1].style.display = "block";
                slides[slideIndex - 1].classList.add("active");
                dots[slideIndex - 1].className += " active";
            }

            // Next/previous controls
            function plusSlides(n) {
                slideIndex += n;
                showSlides(slideIndex);
                resetAutoTimer();
            }

            // Dot controls
            function currentSlide(n) {
                slideIndex = n;
                showSlides(slideIndex);
                resetAutoTimer();
            }

            // Auto slide every 5 seconds
            function startAutoSlide() {
                if (autoTimer)
                    clearInterval(autoTimer);
                autoTimer = setInterval(function () {
                    slideIndex++;
                    showSlides(slideIndex);
                }, 5000);
            }

            function resetAutoTimer() {
                if (autoTimer)
                    clearInterval(autoTimer);
                autoTimer = setInterval(function () {
                    slideIndex++;
                    showSlides(slideIndex);
                }, 5000);
            }

            // Initialize the slideshow
            showSlides(slideIndex);
            startAutoSlide();
        </script>

    </body>
</html>






