<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<main class="page-offset">
    <%-- HERO BANNER SLIDER --%>
    <section class="hero-slider" aria-label="Featured movies">
        <div class="slides-track" id="slidesTrack">

            <div class="slide active" data-index="0">
                <div class="img-placeholder" style="position:absolute;inset:0;height:100%;">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <rect x="2" y="3" width="20" height="14" rx="2"/>
                        <path d="m8 21 4-4 4 4M3 7l5 5-5 5"/>
                    </svg>
                    <span>DUNE BANNER</span>
                </div>
                <div class="slide-content">
                    <div class="slide-genre">Sci-Fi / Epic</div>
                    <h1 class="slide-title">DUNE: PART TWO</h1>
                    <div class="slide-meta">
                        <span>2024</span>
                        <span class="dot"></span>
                        <span>2h 46m</span>
                        <span class="dot"></span>
                        <span>PG-13</span>
                    </div>
                    <p class="slide-desc">Paul Atreides unites with Chani and the Fremen while seeking revenge.</p>
                    <div class="slide-actions">
                        <button class="btn btn-primary" onclick="location.href='booking-schedule.jsp'">Book Now</button>
                        <button class="btn btn-ghost">Watch Trailer</button>
                    </div>
                </div>
            </div>

            <div class="slide" data-index="1">
                <div class="img-placeholder" style="position:absolute;inset:0;height:100%;">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <rect x="2" y="3" width="20" height="14" rx="2"/>
                        <path d="m8 21 4-4 4 4M3 7l5 5-5 5"/>
                    </svg>
                    <span>OPPENHEIMER BANNER</span>
                </div>
                <div class="slide-content">
                    <div class="slide-genre">Drama / History</div>
                    <h1 class="slide-title">OPPENHEIMER</h1>
                    <div class="slide-meta">
                        <span>2023</span>
                        <span class="dot"></span>
                        <span>3h 0m</span>
                        <span class="dot"></span>
                        <span>R</span>
                    </div>
                    <p class="slide-desc">The story of J. Robert Oppenheimer's role in the atomic bomb.</p>
                    <div class="slide-actions">
                        <button class="btn btn-primary" onclick="location.href='movieList.jsp'">Book Now</button>
                        <button class="btn btn-ghost" onclick="location.href='booking-schedule.jsp'">Watch Trailer</button>
                    </div>
                </div>
            </div>

            <div class="slide" data-index="2">
                <div class="img-placeholder" style="position:absolute;inset:0;height:100%;">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <rect x="2" y="3" width="20" height="14" rx="2"/>
                        <path d="m8 21 4-4 4 4M3 7l5 5-5 5"/>
                    </svg>
                    <span>GLADIATOR II BANNER</span>
                </div>
                <div class="slide-content">
                    <div class="slide-genre">Action / Drama</div>
                    <h1 class="slide-title">GLADIATOR II</h1>
                    <div class="slide-meta">
                        <span>2024</span>
                        <span class="dot"></span>
                        <span>2h 28m</span>
                        <span class="dot"></span>
                        <span>R</span>
                    </div>
                    <p class="slide-desc">A man rises through brutal gladiatorial ranks to challenge an empire.</p>
                    <div class="slide-actions">
                        <button class="btn btn-primary" onclick="location.href='movieList.jsp'">Book Now</button>
                        <button class="btn btn-ghost">Watch Trailer</button>
                    </div>
                </div>
            </div>

        </div>

        <button class="slider-arrow prev" id="prevBtn">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M15 18l-6-6 6-6"/>
            </svg>
        </button>
        <button class="slider-arrow next" id="nextBtn">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M9 18l6-6-6-6"/>
            </svg>
        </button>

        <div class="slider-dots" id="sliderDots">
            <button class="dot-btn active" data-slide="0"></button>
            <button class="dot-btn" data-slide="1"></button>
            <button class="dot-btn" data-slide="2"></button>
        </div>
    </section>

    <%-- NOW PLAYING SECTION — 4 posters per row --%>
    <div class="container" style="margin-top: 60px;">
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

            <!-- MOVIE 1: DUNE: PART TWO -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='14'%3EDUNE%3C/text%3E%3C/svg%3E"
                         alt="Dune: Part Two" class="poster-image">
                    <div class="age-badge" data-age="PG-13">PG-13</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">DUNE: PART TWO</div>
                        <div class="overlay-genre">Sci-Fi / Epic</div>
                        <div class="overlay-meta">2 hr 46 min</div>
                        <div class="overlay-languages">ENG &bull; BM &bull; CHI</div>
                        <div class="overlay-age" data-age="PG-13">PG-13</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=1'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 2: OPPENHEIMER -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='12'%3EOPPENHEIMER%3C/text%3E%3C/svg%3E"
                         alt="Oppenheimer" class="poster-image">
                    <div class="age-badge" data-age="R">R</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">OPPENHEIMER</div>
                        <div class="overlay-genre">Drama / History</div>
                        <div class="overlay-meta">3 hr 0 min</div>
                        <div class="overlay-languages">ENG &bull; BM</div>
                        <div class="overlay-age" data-age="R">R</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=2'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 3: GLADIATOR II -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='11'%3EGLADIATOR II%3C/text%3E%3C/svg%3E"
                         alt="Gladiator II" class="poster-image">
                    <div class="age-badge" data-age="R">R</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">GLADIATOR II</div>
                        <div class="overlay-genre">Action / Drama</div>
                        <div class="overlay-meta">2 hr 28 min</div>
                        <div class="overlay-languages">ENG &bull; CHI</div>
                        <div class="overlay-age" data-age="R">R</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=3'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 4: DEADPOOL & WOLVERINE -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='10'%3EDEADPOOL %26 WOLVERINE%3C/text%3E%3C/svg%3E"
                         alt="Deadpool &amp; Wolverine" class="poster-image">
                    <div class="age-badge" data-age="R">R</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">DEADPOOL &amp; WOLVERINE</div>
                        <div class="overlay-genre">Action / Comedy</div>
                        <div class="overlay-meta">2 hr 8 min</div>
                        <div class="overlay-languages">ENG &bull; CHI</div>
                        <div class="overlay-age" data-age="R">R</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=4'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 5: ALIEN: ROMULUS -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='11'%3EALIEN%3C/text%3E%3C/svg%3E"
                         alt="Alien: Romulus" class="poster-image">
                    <div class="age-badge" data-age="R">R</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">ALIEN: ROMULUS</div>
                        <div class="overlay-genre">Horror / Sci-Fi</div>
                        <div class="overlay-meta">1 hr 59 min</div>
                        <div class="overlay-languages">ENG &bull; BM &bull; CHI</div>
                        <div class="overlay-age" data-age="R">R</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=5'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 6: INSIDE OUT 2 -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='11'%3EINSIDE OUT 2%3C/text%3E%3C/svg%3E"
                         alt="Inside Out 2" class="poster-image">
                    <div class="age-badge" data-age="PG">PG</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">INSIDE OUT 2</div>
                        <div class="overlay-genre">Animation / Family</div>
                        <div class="overlay-meta">1 hr 40 min</div>
                        <div class="overlay-languages">ENG &bull; BM &bull; CHI</div>
                        <div class="overlay-age" data-age="PG">PG</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=6'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 7: A QUIET PLACE: DAY ONE -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='10'%3EQUIET PLACE%3C/text%3E%3C/svg%3E"
                         alt="A Quiet Place: Day One" class="poster-image">
                    <div class="age-badge" data-age="R">R</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">A QUIET PLACE: DAY ONE</div>
                        <div class="overlay-genre">Horror / Thriller</div>
                        <div class="overlay-meta">1 hr 39 min</div>
                        <div class="overlay-languages">ENG &bull; BM</div>
                        <div class="overlay-age" data-age="R">R</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=7'">ⓘ</button>
                    </div>
                </div>
            </div>

            <!-- MOVIE 8: KINGDOM OF THE PLANET OF THE APES -->
            <div class="movie-card">
                <div class="card-poster">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 450'%3E%3Crect width='300' height='450' fill='%231a1a2e'/%3E%3Ctext x='150' y='220' text-anchor='middle' fill='%236b6358' font-size='10'%3EKINGDOM OF APES%3C/text%3E%3C/svg%3E"
                         alt="Kingdom of the Planet of the Apes" class="poster-image">
                    <div class="age-badge" data-age="PG-13">PG-13</div>
                    <div class="movie-overlay">
                        <div class="overlay-title">KINGDOM OF THE PLANET OF THE APES</div>
                        <div class="overlay-genre">Sci-Fi / Action</div>
                        <div class="overlay-meta">2 hr 25 min</div>
                        <div class="overlay-languages">ENG &bull; BM</div>
                        <div class="overlay-age" data-age="PG-13">PG-13</div>
                        <button class="overlay-btn" onclick="location.href='booking-schedule.jsp'">BUY NOW</button>
                        <button class="overlay-info-btn" onclick="location.href='movie-details.jsp?id=8'">ⓘ</button>
                    </div>
                </div>
            </div>

        </div>

    </div>
</main>

<script>
(function () {
    const TOTAL = 3;
    let current = 0;
    let autoTimer = null;

    const slides = document.querySelectorAll('.slide');
    const dots   = document.querySelectorAll('.dot-btn');

    function goTo(idx) {
        if (idx < 0) idx = TOTAL - 1;
        if (idx >= TOTAL) idx = 0;
        slides[current].classList.remove('active');
        dots[current].classList.remove('active');
        current = idx;
        slides[current].classList.add('active');
        dots[current].classList.add('active');
    }

    function startAuto() {
        if (autoTimer) clearInterval(autoTimer);
        autoTimer = setInterval(function () { goTo(current + 1); }, 5500);
    }

    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');

    if (prevBtn) prevBtn.addEventListener('click', function () { goTo(current - 1); startAuto(); });
    if (nextBtn) nextBtn.addEventListener('click', function () { goTo(current + 1); startAuto(); });

    dots.forEach(function (btn, index) {
        btn.addEventListener('click', function () { goTo(index); startAuto(); });
    });

    startAuto();
})();
</script>

<%@ include file="footer.jsp" %>