<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            <!-- MOVIE 1: DUNE: PART TWO -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='14' font-weight='bold'%3EDUNE%3C/text%3E%3Ctext x='150' y='240' text-anchor='middle' fill='%236b6358' font-size='10'%3EPART TWO%3C/text%3E%3C/svg%3E"
                         alt="Dune: Part Two" class="poster-image">
                    <div class="age-badge" data-age="PG-13">PG-13</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">DUNE: PART TWO</div>
                        <div class="overlay-genre">Sci-Fi / Epic</div>
                        <div class="overlay-meta">2 hr 46 min</div>
                        <div class="overlay-languages">ENG • BM • CHI</div>
                        <div class="overlay-age" data-age="PG-13">PG-13</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=1'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 2: OPPENHEIMER -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='225' text-anchor='middle' fill='%236b6358' font-size='12' font-weight='bold'%3EOPPENHEIMER%3C/text%3E%3C/svg%3E"
                         alt="Oppenheimer" class="poster-image">
                    <div class="age-badge" data-age="R">R</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">OPPENHEIMER</div>
                        <div class="overlay-genre">Drama / History</div>
                        <div class="overlay-meta">3 hr 0 min</div>
                        <div class="overlay-languages">ENG • BM</div>
                        <div class="overlay-age" data-age="R">R</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=2'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 3: GLADIATOR II -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='225' text-anchor='middle' fill='%236b6358' font-size='11' font-weight='bold'%3EGLADIATOR II%3C/text%3E%3C/svg%3E"
                         alt="Gladiator II" class="poster-image">
                    <div class="age-badge" data-age="R">R</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">GLADIATOR II</div>
                        <div class="overlay-genre">Action / Drama</div>
                        <div class="overlay-meta">2 hr 28 min</div>
                        <div class="overlay-languages">ENG • CHI</div>
                        <div class="overlay-age" data-age="R">R</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=3'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 4: DEADPOOL & WOLVERINE -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='9' font-weight='bold'%3EDEADPOOL %26%3C/text%3E%3Ctext x='150' y='238' text-anchor='middle' fill='%236b6358' font-size='9' font-weight='bold'%3EWOLVERINE%3C/text%3E%3C/svg%3E"
                         alt="Deadpool &amp; Wolverine" class="poster-image">
                    <div class="age-badge" data-age="R">R</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">DEADPOOL &amp; WOLVERINE</div>
                        <div class="overlay-genre">Action / Comedy</div>
                        <div class="overlay-meta">2 hr 8 min</div>
                        <div class="overlay-languages">ENG • CHI</div>
                        <div class="overlay-age" data-age="R">R</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=4'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 5: ALIEN: ROMULUS -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='225' text-anchor='middle' fill='%236b6358' font-size='11' font-weight='bold'%3EALIEN%3C/text%3E%3Ctext x='150' y='243' text-anchor='middle' fill='%236b6358' font-size='9'%3EROMULUS%3C/text%3E%3C/svg%3E"
                         alt="Alien: Romulus" class="poster-image">
                    <div class="age-badge" data-age="R">R</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">ALIEN: ROMULUS</div>
                        <div class="overlay-genre">Horror / Sci-Fi</div>
                        <div class="overlay-meta">1 hr 59 min</div>
                        <div class="overlay-languages">ENG • BM • CHI</div>
                        <div class="overlay-age" data-age="R">R</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=5'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 6: INSIDE OUT 2 -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='225' text-anchor='middle' fill='%236b6358' font-size='10' font-weight='bold'%3EINSIDE OUT 2%3C/text%3E%3C/svg%3E"
                         alt="Inside Out 2" class="poster-image">
                    <div class="age-badge" data-age="PG">PG</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">INSIDE OUT 2</div>
                        <div class="overlay-genre">Animation / Family</div>
                        <div class="overlay-meta">1 hr 40 min</div>
                        <div class="overlay-languages">ENG • BM • CHI</div>
                        <div class="overlay-age" data-age="PG">PG</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=6'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 7: A QUIET PLACE: DAY ONE -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='215' text-anchor='middle' fill='%236b6358' font-size='8' font-weight='bold'%3EA QUIET PLACE%3C/text%3E%3Ctext x='150' y='233' text-anchor='middle' fill='%236b6358' font-size='9'%3EDAY ONE%3C/text%3E%3C/svg%3E"
                         alt="A Quiet Place: Day One" class="poster-image">
                    <div class="age-badge" data-age="R">R</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">A QUIET PLACE: DAY ONE</div>
                        <div class="overlay-genre">Horror / Thriller</div>
                        <div class="overlay-meta">1 hr 39 min</div>
                        <div class="overlay-languages">ENG • BM</div>
                        <div class="overlay-age" data-age="R">R</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=7'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 8: KINGDOM OF THE PLANET OF THE APES -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='215' text-anchor='middle' fill='%236b6358' font-size='7' font-weight='bold'%3EKINGDOM OF THE%3C/text%3E%3Ctext x='150' y='233' text-anchor='middle' fill='%236b6358' font-size='8' font-weight='bold'%3EPLANET OF THE APES%3C/text%3E%3C/svg%3E"
                         alt="Kingdom of the Planet of the Apes" class="poster-image">
                    <div class="age-badge" data-age="PG-13">PG-13</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">KINGDOM OF THE PLANET OF THE APES</div>
                        <div class="overlay-genre">Sci-Fi / Action</div>
                        <div class="overlay-meta">2 hr 25 min</div>
                        <div class="overlay-languages">ENG • BM</div>
                        <div class="overlay-age" data-age="PG-13">PG-13</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=8'">ⓘ</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="footer.jsp" %>