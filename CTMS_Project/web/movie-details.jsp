<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ctms.dto.*, java.util.*"%>
<%@ include file="header.jsp" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CTMS-Movie-Detail</title>
        <link rel="stylesheet" href="css/movie-detail.css">

        <%
            MovieDTO movie = (MovieDTO) request.getAttribute("MovieDetails");

            if (movie == null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                System.out.println("Unable to get movie details");
                return;
            }
            
            movie.setFormattedDuration(movie.formatDuration());
            
            String formattedPoster = movie.getFomrattedPoster();
            String defaultPoster =  "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 280 420'%3E%3Crect width='280' height='420' fill='%231a1a2e'/%3E%3Ctext x='140' y='210' text-anchor='middle' fill='%236b6358' font-size='10'%3EPOSTER%3C/text%3E%3C/svg%3E";
            movie.setFormattedPoster(formattedPoster != null ? formattedPoster : defaultPoster);

            String videoId = "";
            String ytUrl = movie.getTrailerURL();
            if (ytUrl != null) {
                videoId = ytUrl.split("v=")[1];
                int ampIndex = videoId.indexOf("&");
                if (ampIndex != -1) {
                    videoId = videoId.substring(0, ampIndex);
                }
            }

        %>
    </head>
    <body>
        <main class="page-offset detail-page">

            <%-- ── BREADCRUMB ─────────────────────────────────────────── --%>
            <nav class="detail-breadcrumb">
                <a href="index.jsp">Home</a>
                <span class="bc-sep">›</span>
                <a href="movieList.jsp">Now Playing</a>
                <span class="bc-sep">›</span>
                <span class="bc-current"><%=movie.getTitle()%></span>
            </nav>

            <%-- ── POSTER + INFO GRID ─────────────────────────────────── --%>
            <div class="detail-main">

                <%-- LEFT: Poster --%>
                <div class="detail-poster-col">
                    <%--
                        Replace src with ${movie.posterUrl} in production.
                        Placeholder SVG used here for demo.
                    --%>
                    <img class="detail-poster"
                         src= "<%=movie.getFomrattedPoster()%>"
                         alt="<%= movie.getTitle()%> Poster">
                </div>

                <%-- RIGHT: Movie info --%>
                <div class="detail-info-col">

                    <%-- Title + classification badge --%>
                    <div class="detail-title-row">
                        <div class="detail-age-badge"><%= movie.getRating()%></div>
                        <h1 class="detail-title"><%= movie.getTitle()%></h1>
                    </div>

                    <%-- Metadata grid: 2 columns, 3 rows --%>
                    <div class="detail-meta-grid">

                        <div class="detail-meta-row">
                            <%-- Clock icon --%>
                            <svg class="detail-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>
                            </svg>
                            Running Time:&nbsp;<span class="detail-meta-label"><%=movie.getFormattedDuration()%></span>
                        </div>

                        <div class="detail-meta-row">
                            <%-- Tag icon --%>
                            <svg class="detail-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7.01" y2="7"/>
                            </svg>
                            Genre:&nbsp;<span class="detail-meta-label"><%=movie.getGenere()%></span>
                        </div>

                        <div class="detail-meta-row">
                            <%-- Classification icon --%>
                            <svg class="detail-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <rect x="2" y="3" width="20" height="14" rx="2"/><path d="M8 21h8M12 17v4"/>
                            </svg>
                            Classification:&nbsp;<span class="detail-meta-label"><%= movie.getRating()%></span>
                        </div>

                    </div>

                    <%-- Synopsis --%>
                    <div class="detail-section">
                        <div class="detail-section-label">Synopsis</div>
                        <div class="detail-section-body">
                            <%=movie.getDescription()%>
                        </div>
                    </div>

                </div><%-- end detail-info-col --%>
            </div><%-- end detail-main --%>

            <%-- ── DIVIDER ─────────────────────────────────────────────── --%>
            <div class="detail-divider"></div>

            <%-- ── TRAILER SECTION ────────────────────────────────────── --%>
            <div class="detail-trailer-section">
                <div class="detail-trailer-heading">Trailer</div>

                <div class="trailer-embed-wrap">
                    <iframe
                        src="https://www.youtube.com/embed/<%=videoId%>"
                        title="<%= movie.getTitle()%> — Official Trailer"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowfullscreen>
                    </iframe>
                </div>
            </div>

            <%-- Bottom padding so sticky bar doesn't cover content --%>
            <div style="height:80px;"></div>

        </main>

        <%-- ── STICKY BUY TICKETS BAR ──────────────────────────────────── --%>
        <div class="detail-buy-bar">
            <div class="detail-buy-inner">
                <div class="detail-buy-info">
                    <div class="detail-buy-title"><%= movie.getTitle()%></div>
                    <div class="detail-buy-sub">Select your cinema and showtime to proceed</div>
                </div>
                    <button class="detail-buy-btn" onclick="location.href = '<%= request.getContextPath() %>/BookingScheduleServlet?movieId=<%=movie.getId()%>'">
                    BUY TICKETS NOW
                </button>
            </div>
        </div>


        <%@ include file="footer.jsp" %>

        <script>
            function toggleFaq(questionEl) {
                var item = questionEl.parentElement;
                var wasOpen = item.classList.contains('open');

                /* Close all open items */
                document.querySelectorAll('.faq-item.open').forEach(function (el) {
                    el.classList.remove('open');
                });

                /* Open clicked item if it was closed */
                if (!wasOpen) {
                    item.classList.add('open');
                }
            }
        </script>
    </body>
</html>

