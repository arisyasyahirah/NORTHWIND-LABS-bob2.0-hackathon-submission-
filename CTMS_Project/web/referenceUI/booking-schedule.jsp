<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<%-- Link this page's own stylesheet (after master-style.css in header.jsp) --%>
<link rel="stylesheet" href="css/booking-schedule.css">

<main class="page-offset schedule-page">

    <%-- ── MOVIE SUMMARY STRIP ───────────────────────────────── --%>
    <div class="movie-hero-strip">
        <div class="movie-hero-inner">
            <%--
                Replace the src below with a real poster URL or EL expression, e.g.:
                <img src="${movie.posterUrl}" ...>
                For now a placeholder SVG is used.
            --%>
            <img class="movie-hero-thumb"
                 src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 60 90'%3E%3Crect width='60' height='90' fill='%231a1a2e'/%3E%3Ctext x='30' y='48' text-anchor='middle' fill='%236b6358' font-size='7'%3EPOSTER%3C/text%3E%3C/svg%3E"
                 alt="Movie Poster">

            <div class="movie-hero-info">
                <%-- Replace static text with ${movie.title}, ${movie.genre} etc. --%>
                <div class="movie-hero-title">DUNE: PART TWO</div>
                <div class="movie-hero-meta">
                    <span>Sci-Fi / Epic</span>
                    <span class="meta-sep"></span>
                    <span>2 hr 46 min</span>
                    <span class="meta-sep"></span>
                    <span>ENG &bull; BM &bull; CHI</span>
                    <span class="meta-sep"></span>
                    <div class="movie-hero-age" data-age="PG-13">PG-13</div>
                </div>
            </div>
        </div>
    </div>

    <div class="schedule-container">

        <%-- ══════════════════════════════════════════════════════
             SECTION 1 — SELECT DATE
             ══════════════════════════════════════════════════════ --%>
        <div class="sched-section-title">Select Date</div>

        <div class="date-strip" id="dateStrip">
            <%--
                In production, generate these dynamically from a loop, e.g.:
                <c:forEach var="d" items="${availableDates}">
                    <button class="date-btn" data-date="${d.isoDate}">
                        <span class="day-label">${d.dayShort}</span>
                        <span class="day-num">${d.dayNum}</span>
                        <span class="month-label">${d.monthShort}</span>
                    </button>
                </c:forEach>
            --%>
            <button class="date-btn active" data-date="2026-05-05">
                <span class="day-label">TUE</span>
                <span class="day-num">05</span>
                <span class="month-label">May</span>
            </button>
            <button class="date-btn" data-date="2026-05-06">
                <span class="day-label">WED</span>
                <span class="day-num">06</span>
                <span class="month-label">May</span>
            </button>
            <button class="date-btn" data-date="2026-05-07">
                <span class="day-label">THU</span>
                <span class="day-num">07</span>
                <span class="month-label">May</span>
            </button>
            <button class="date-btn" data-date="2026-05-08">
                <span class="day-label">FRI</span>
                <span class="day-num">08</span>
                <span class="month-label">May</span>
            </button>
            <button class="date-btn" data-date="2026-05-09">
                <span class="day-label">SAT</span>
                <span class="day-num">09</span>
                <span class="month-label">May</span>
            </button>
            <button class="date-btn" data-date="2026-05-10">
                <span class="day-label">SUN</span>
                <span class="day-num">10</span>
                <span class="month-label">May</span>
            </button>
            <button class="date-btn" data-date="2026-05-11">
                <span class="day-label">MON</span>
                <span class="day-num">11</span>
                <span class="month-label">May</span>
            </button>
        </div>

        <div class="sched-divider"></div>

        <%-- ══════════════════════════════════════════════════════
             SECTION 2 — SELECT EXPERIENCE / FORMAT
             ══════════════════════════════════════════════════════ --%>
        <div class="sched-section-title">Select Experience</div>

        <div class="experience-strip" id="experienceStrip">
            <button class="exp-btn active" data-exp="2D">2D</button>
            <button class="exp-btn" data-exp="3D">3D</button>
            <button class="exp-btn" data-exp="IMAX">IMAX</button>
            <button class="exp-btn" data-exp="IMAX 3D">IMAX 3D</button>
            <button class="exp-btn" data-exp="DOLBY">DOLBY ATMOS</button>
            <button class="exp-btn" data-exp="4DX">4DX</button>
        </div>

        <div class="sched-divider"></div>

        <%-- ══════════════════════════════════════════════════════
             SECTION 3 — SELECT CINEMA & SHOWTIME
             ══════════════════════════════════════════════════════ --%>
        <div class="cinemas-topbar">
            <div class="sched-section-title" style="margin-bottom:0;">Select Cinemas &amp; Time</div>

            <div class="region-select-wrap">
                <span class="region-label">Regions</span>
                <select class="region-select" id="regionSelect" onchange="filterByRegion(this.value)">
                    <option value="all">All</option>
                    <option value="klang-valley">Klang Valley</option>
                    <option value="northern">Northern</option>
                    <option value="southern">Southern</option>
                    <option value="east-coast">East Coast</option>
                    <option value="east-malaysia">East Malaysia</option>
                    <option value="sabah">Sabah</option>
                    <option value="sarawak">Sarawak</option>
                </select>
            </div>
        </div>

        <%-- Cinema list ─────────────────────────────────────────
             In production, render these from a DB loop, e.g.:
             <c:forEach var="cinema" items="${cinemas}">
                 <div class="cinema-block" data-region="${cinema.regionKey}">
                     ...showtimes loop...
                 </div>
             </c:forEach>
        --%>
        <div id="cinemaList">

            <!-- CINEMA: Kuala Lumpur - Mid Valley Megamall -->
            <div class="cinema-block" data-region="klang-valley">
                <div class="cinema-header">
                    <div class="cinema-name-wrap">
                        <button class="fav-btn" onclick="toggleFav(this)" title="Add to favourites">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                            </svg>
                        </button>
                        <span class="cinema-name">Kuala Lumpur - Mid Valley Megamall</span>
                    </div>
                    <button class="cinema-toggle" onclick="toggleCinema(this)" title="Collapse">&#8722;</button>
                </div>
                <div class="showtime-grid">
                    <div class="showtime-card" onclick="selectShowtime(this, 'Mid Valley Megamall', '3:05PM', '2D')">
                        <span class="st-time">3:05PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, 'Mid Valley Megamall', '7:45PM', '2D')">
                        <span class="st-time">7:45PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, 'Mid Valley Megamall', '10:15PM', '2D')">
                        <span class="st-time">10:15PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                        <span class="st-tag">Last</span>
                    </div>
                    <div class="showtime-card sold-out">
                        <span class="st-time">1:00PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                        <span class="sold-out-label">Sold Out</span>
                    </div>
                </div>
            </div>

            <!-- CINEMA: Kuala Lumpur - Pavilion KL -->
            <div class="cinema-block" data-region="klang-valley">
                <div class="cinema-header">
                    <div class="cinema-name-wrap">
                        <button class="fav-btn" onclick="toggleFav(this)" title="Add to favourites">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                            </svg>
                        </button>
                        <span class="cinema-name">Kuala Lumpur - Pavilion KL</span>
                    </div>
                    <button class="cinema-toggle" onclick="toggleCinema(this)" title="Collapse">&#8722;</button>
                </div>
                <div class="showtime-grid">
                    <div class="showtime-card" onclick="selectShowtime(this, 'Pavilion KL', '12:30PM', 'IMAX')">
                        <span class="st-time">12:30PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">IMAX</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, 'Pavilion KL', '4:00PM', 'IMAX')">
                        <span class="st-time">4:00PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">IMAX</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, 'Pavilion KL', '8:30PM', 'DOLBY')">
                        <span class="st-time">8:30PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">DOLBY</span>
                    </div>
                </div>
            </div>

            <!-- CINEMA: Petaling Jaya - 1 Utama -->
            <div class="cinema-block" data-region="klang-valley">
                <div class="cinema-header">
                    <div class="cinema-name-wrap">
                        <button class="fav-btn" onclick="toggleFav(this)" title="Add to favourites">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                            </svg>
                        </button>
                        <span class="cinema-name">Petaling Jaya - 1 Utama</span>
                    </div>
                    <button class="cinema-toggle" onclick="toggleCinema(this)" title="Collapse">&#8722;</button>
                </div>
                <div class="showtime-grid">
                    <div class="showtime-card" onclick="selectShowtime(this, '1 Utama', '2:00PM', '2D')">
                        <span class="st-time">2:00PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, '1 Utama', '5:30PM', '3D')">
                        <span class="st-time">5:30PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">3D</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, '1 Utama', '9:00PM', '2D')">
                        <span class="st-time">9:00PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                </div>
            </div>

            <!-- CINEMA: Penang - Gurney Paragon -->
            <div class="cinema-block" data-region="northern">
                <div class="cinema-header">
                    <div class="cinema-name-wrap">
                        <button class="fav-btn" onclick="toggleFav(this)" title="Add to favourites">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                            </svg>
                        </button>
                        <span class="cinema-name">Penang - Gurney Paragon</span>
                    </div>
                    <button class="cinema-toggle" onclick="toggleCinema(this)" title="Collapse">&#8722;</button>
                </div>
                <div class="showtime-grid">
                    <div class="showtime-card" onclick="selectShowtime(this, 'Gurney Paragon', '1:30PM', '2D')">
                        <span class="st-time">1:30PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, 'Gurney Paragon', '6:45PM', '2D')">
                        <span class="st-time">6:45PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                </div>
            </div>

            <!-- CINEMA: Johor Bahru - AEON Tebrau City -->
            <div class="cinema-block" data-region="southern">
                <div class="cinema-header">
                    <div class="cinema-name-wrap">
                        <button class="fav-btn" onclick="toggleFav(this)" title="Add to favourites">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                            </svg>
                        </button>
                        <span class="cinema-name">Johor Bahru - AEON Tebrau City</span>
                    </div>
                    <button class="cinema-toggle" onclick="toggleCinema(this)" title="Collapse">&#8722;</button>
                </div>
                <div class="showtime-grid">
                    <div class="showtime-card" onclick="selectShowtime(this, 'AEON Tebrau City', '11:00AM', '2D')">
                        <span class="st-time">11:00AM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, 'AEON Tebrau City', '3:30PM', '2D')">
                        <span class="st-time">3:30PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, 'AEON Tebrau City', '8:00PM', '2D')">
                        <span class="st-time">8:00PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                </div>
            </div>

            <!-- CINEMA: Kuantan - East Coast Mall -->
            <div class="cinema-block" data-region="east-coast">
                <div class="cinema-header">
                    <div class="cinema-name-wrap">
                        <button class="fav-btn" onclick="toggleFav(this)" title="Add to favourites">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                            </svg>
                        </button>
                        <span class="cinema-name">Kuantan - East Coast Mall</span>
                    </div>
                    <button class="cinema-toggle" onclick="toggleCinema(this)" title="Collapse">&#8722;</button>
                </div>
                <div class="showtime-grid">
                    <div class="showtime-card" onclick="selectShowtime(this, 'East Coast Mall', '2:15PM', '2D')">
                        <span class="st-time">2:15PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, 'East Coast Mall', '7:00PM', '2D')">
                        <span class="st-time">7:00PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                </div>
            </div>

            <!-- CINEMA: Kota Kinabalu - IMAGO Mall -->
            <div class="cinema-block" data-region="east-malaysia sabah">
                <div class="cinema-header">
                    <div class="cinema-name-wrap">
                        <button class="fav-btn active" onclick="toggleFav(this)" title="Remove from favourites">
                            <svg viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                            </svg>
                        </button>
                        <span class="cinema-name">Kota Kinabalu - IMAGO Mall</span>
                    </div>
                    <button class="cinema-toggle" onclick="toggleCinema(this)" title="Collapse">&#8722;</button>
                </div>
                <div class="showtime-grid">
                    <div class="showtime-card" onclick="selectShowtime(this, 'IMAGO Mall KK', '7:00PM', '2D')">
                        <span class="st-time">7:00PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, 'IMAGO Mall KK', '9:30PM', '2D')">
                        <span class="st-time">9:30PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                        <span class="st-tag">Last</span>
                    </div>
                </div>
            </div>

            <!-- CINEMA: Kuching - Spring Mall -->
            <div class="cinema-block" data-region="east-malaysia sarawak">
                <div class="cinema-header">
                    <div class="cinema-name-wrap">
                        <button class="fav-btn" onclick="toggleFav(this)" title="Add to favourites">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                            </svg>
                        </button>
                        <span class="cinema-name">Kuching - Spring Mall</span>
                    </div>
                    <button class="cinema-toggle" onclick="toggleCinema(this)" title="Collapse">&#8722;</button>
                </div>
                <div class="showtime-grid">
                    <div class="showtime-card" onclick="selectShowtime(this, 'Spring Mall Kuching', '4:30PM', '2D')">
                        <span class="st-time">4:30PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                    <div class="showtime-card" onclick="selectShowtime(this, 'Spring Mall Kuching', '8:15PM', '2D')">
                        <span class="st-time">8:15PM</span>
                        <div class="st-divider"></div>
                        <span class="st-format">2D</span>
                    </div>
                </div>
            </div>

        </div><%-- end #cinemaList --%>

        <%-- Bottom padding so sticky bar doesn't cover last item --%>
        <div style="height: 80px;"></div>

    </div><%-- end .schedule-container --%>

</main>

<%-- ── STICKY PROCEED BAR ────────────────────────────────────── --%>
<div class="proceed-bar" id="proceedBar">
    <div class="proceed-inner">
        <div class="proceed-selection-info">
            <div class="proceed-movie" id="proceedTitle">DUNE: PART TWO</div>
            <div class="proceed-detail" id="proceedDetail">Select a date and showtime to continue</div>
        </div>
        <button class="proceed-btn" id="proceedBtn" disabled
                onclick="location.href='booking.jsp'">
            SELECT SEATS →
        </button>
    </div>
</div>

<script>
(function () {

    /* ── State ──────────────────────────────────────────────────── */
    var state = {
        date:     '2026-05-05',
        dateLabel:'TUE 05 May',
        exp:      '2D',
        cinema:   null,
        time:     null
    };

    /* ── DATE selection ─────────────────────────────────────────── */
    document.getElementById('dateStrip').addEventListener('click', function (e) {
        var btn = e.target.closest('.date-btn');
        if (!btn) return;

        document.querySelectorAll('.date-btn').forEach(function (b) { b.classList.remove('active'); });
        btn.classList.add('active');

        state.date      = btn.dataset.date;
        state.dateLabel = btn.querySelector('.day-label').textContent + ' '
                        + btn.querySelector('.day-num').textContent + ' '
                        + btn.querySelector('.month-label').textContent;

        /* Reset showtime on date change */
        clearShowtime();
    });

    /* ── EXPERIENCE selection ───────────────────────────────────── */
    document.getElementById('experienceStrip').addEventListener('click', function (e) {
        var btn = e.target.closest('.exp-btn');
        if (!btn) return;

        document.querySelectorAll('.exp-btn').forEach(function (b) { b.classList.remove('active'); });
        btn.classList.add('active');
        state.exp = btn.dataset.exp;

        clearShowtime();
    });

    /* ── SHOWTIME selection (called from onclick) ────────────────── */
    window.selectShowtime = function (card, cinema, time, format) {
        /* Deselect all */
        document.querySelectorAll('.showtime-card.active').forEach(function (c) {
            c.classList.remove('active');
        });

        card.classList.add('active');
        state.cinema = cinema;
        state.time   = time;

        updateProceedBar();
    };

    function clearShowtime() {
        document.querySelectorAll('.showtime-card.active').forEach(function (c) {
            c.classList.remove('active');
        });
        state.cinema = null;
        state.time   = null;
        updateProceedBar();
    }

    function updateProceedBar() {
        var btn    = document.getElementById('proceedBtn');
        var detail = document.getElementById('proceedDetail');

        if (state.cinema && state.time) {
            detail.innerHTML = state.dateLabel + ' &nbsp;|&nbsp; <span>'
                + state.time + '</span> &nbsp;|&nbsp; '
                + state.cinema + ' &nbsp;|&nbsp; <span>' + state.exp + '</span>';
            btn.disabled = false;
        } else {
            detail.textContent = 'Select a date and showtime to continue';
            btn.disabled = true;
        }
    }

    /* ── CINEMA collapse / expand ───────────────────────────────── */
    window.toggleCinema = function (toggleBtn) {
        var block = toggleBtn.closest('.cinema-block');
        var collapsed = block.classList.toggle('collapsed');
        toggleBtn.innerHTML = collapsed ? '&#43;' : '&#8722;';
        toggleBtn.title     = collapsed ? 'Expand' : 'Collapse';
    };

    /* ── FAVOURITE heart toggle ─────────────────────────────────── */
    window.toggleFav = function (btn) {
        var isActive = btn.classList.toggle('active');
        var svg = btn.querySelector('svg');
        svg.setAttribute('fill', isActive ? 'currentColor' : 'none');
    };

    /* ── REGION filter dropdown ─────────────────────────────────── */
    window.filterByRegion = function (region) {
        var blocks = document.querySelectorAll('.cinema-block');
        blocks.forEach(function (block) {
            if (region === 'all') {
                block.style.display = '';
            } else {
                var blockRegions = (block.dataset.region || '').split(' ');
                block.style.display = blockRegions.indexOf(region) !== -1 ? '' : 'none';
            }
        });

        /* Clear any selected showtime if its cinema is now hidden */
        if (state.cinema) {
            var activeCard = document.querySelector('.showtime-card.active');
            if (activeCard) {
                var parentBlock = activeCard.closest('.cinema-block');
                if (parentBlock && parentBlock.style.display === 'none') {
                    clearShowtime();
                }
            }
        }
    };

})();
</script>

<%@ include file="footer.jsp" %>
