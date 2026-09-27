<%@ page import="com.ctms.dto.*, java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CTMS-Movie-Showtime</title>
    </head>
    <body>

        <%
            MovieDTO movie = (MovieDTO) request.getAttribute("movie");
            ArrayList<DateTimeDTO> availableDates = (ArrayList<DateTimeDTO>) request.getAttribute("availableDates");
            String selectedDate = (String) request.getAttribute("selectedDate");

            // Servlet already sends a grouped map — just cast it directly
            Map<String, List<ShowtimeDTO>> showtimesByCinema
                    = (Map<String, List<ShowtimeDTO>>) request.getAttribute("showtimesByCinema");

            if (movie == null || availableDates == null || showtimesByCinema == null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }
        %>

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

                         src="<%=movie.getFomrattedPoster()%>"
                         alt="<%=movie.getTitle()%>">


                    <div class="movie-hero-info">
                        <%-- Replace static text with ${movie.title}, ${movie.genre} etc. --%>
                        <div class="movie-hero-title"><%=movie.getTitle()%></div>
                        <div class="movie-hero-meta">
                            <span><%= movie.getGenere() != null ? movie.getGenere() : "N/A"%></span>
                            <span class="meta-sep"></span>
                            <span><%= movie.getFormattedDuration() != null ? movie.getFormattedDuration() : movie.getDuration() + " min"%></span>
                            <%-- <span class="meta-sep"></span>
                            <span><%= movie.getLanguage() != null ? movie.getLanguage() : "ENG" %></span> --%>
                            <span class="meta-sep"></span>
                            <div class="movie-hero-age" data-age="<%= movie.getRating() != null ? movie.getRating() : "PG-13"%>">
                                <%= movie.getRating() != null ? movie.getRating() : "PG-13"%>

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
                        <% for (DateTimeDTO date : availableDates) {
                                String dateValue = date.getShowDate().toString();
                                String isActive = dateValue.equals(selectedDate) ? "active" : "";
                        %>
                        <button class="date-btn <%= isActive%>" data-date="<%= dateValue%>">
                            <span class="day-label"><%= date.getShortDayName()%></span>
                            <span class="day-num"><%= date.getShowDate().toLocalDate().getDayOfMonth()%></span>
                            <span class="month-label"><%= date.getShowDate().toLocalDate().getMonth().toString().substring(0, 3)%></span>
                        </button>
                        <% } %>

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
                        <%
                            // Loop through each cinema branch from the map
                            for (Map.Entry<String, List<ShowtimeDTO>> entry : showtimesByCinema.entrySet()) {
                                String branch = entry.getKey();
                                List<ShowtimeDTO> showtimes = entry.getValue();

                                // Filter showtimes by selected date if needed
                                List<ShowtimeDTO> filteredShowtimes = new ArrayList<>();
                                if (selectedDate != null && !selectedDate.isEmpty()) {
                                    for (ShowtimeDTO st : showtimes) {
                                        if (st.getShowDate().toString().equals(selectedDate)) {
                                            filteredShowtimes.add(st);
                                        }
                                    }
                                } else {
                                    filteredShowtimes = showtimes;
                                }

                                if (filteredShowtimes.isEmpty()) {
                                    continue;
                                }

                                // Determine region based on branch name
                                String regionClass = "east-coast"; // Default for East Coast
                                if (branch.contains("Kuala Terengganu") || branch.contains("Kemaman") || branch.contains("Dungun")) {
                                    regionClass = "east-coast terengganu";
                                } else if (branch.contains("Kuantan")) {
                                    regionClass = "east-coast pahang";
                                } else if (branch.contains("Kota Bharu")) {
                                    regionClass = "east-coast kelantan";
                                }
                        %>
                        <div class="cinema-block" data-region="<%= regionClass%>">
                            <div class="cinema-header">
                                <div class="cinema-name-wrap">
                                    <button class="fav-btn" onclick="toggleFav(this)" title="Add to favourites">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                                        </svg>
                                    </button>
                                    <span class="cinema-name"><%= branch%></span>
                                </div>
                                <button class="cinema-toggle" onclick="toggleCinema(this)" title="Collapse">&#8722;</button>
                            </div>
                            <div class="showtime-grid">
                                <% for (ShowtimeDTO showtime : filteredShowtimes) {
                                        String timeStr = showtime.getShowStartTime().toString();
                                        String formattedTime = timeStr.substring(0, 5); // "HH:MM"

                                        String soldOutClass = showtime.isSoldOut() ? "sold-out" : "";
                                        String lastShowTag = showtime.isLastShow() ? "<span class='st-tag'>Last</span>" : "";
                                %>
                                <div class="showtime-card <%= soldOutClass%>" 
                                     onclick="<%= !showtime.isSoldOut() ? "selectShowtime(this, '" + branch + "', '" + formattedTime + "', '" + showtime.getHallType() + "', '" + showtime.getShowtimeId()+ "')" : ""%>">
                                    <span class="st-time"><%= formattedTime%></span>
                                    <div class="st-divider"></div>
                                    <span class="st-format"><%= showtime.getHallType()%></span>
                                    <%= lastShowTag%>
                                    <% if (showtime.isSoldOut()) { %>
                                    <span class="sold-out-label">Sold Out</span>
                                    <% } %>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        <% }%>
                    </div><%-- end #cinemaList --%>

                    <%-- Bottom padding so sticky bar doesn't cover last item --%>
                    <div style="height: 80px;"></div>

                </div><%-- end .schedule-container --%>

        </main>

        <%-- STICKY PROCEED BAR --%>
        <div class="proceed-bar" id="proceedBar">
            <div class="proceed-inner">
                <div class="proceed-selection-info">
                    <div class="proceed-movie" id="proceedTitle"><%= movie.getTitle()%></div>
                    <div class="proceed-detail" id="proceedDetail">Select a date and showtime to continue</div>
                </div>
                <button class="proceed-btn" id="proceedBtn" disabled>
                    SELECT SEATS →
                </button>
            </div>
        </div>

        <script>
                                    (function () {
                                        var state = {
                                            date: '<%= selectedDate != null ? selectedDate : ""%>',
                                            dateLabel: '',
                                            exp: 'all', // Change default to 'all' instead of '2D'
                                            cinema: null,
                                            time: null,
                                            showtimeId: null
                                        };

                                        // Update date label function
                                        function updateDateLabel() {
                                            var activeBtn = document.querySelector('.date-btn.active');
                                            if (activeBtn) {
                                                state.dateLabel = activeBtn.querySelector('.day-label').textContent + ' '
                                                        + activeBtn.querySelector('.day-num').textContent + ' '
                                                        + activeBtn.querySelector('.month-label').textContent;
                                            }
                                        }
                                        updateDateLabel();

                                        // DATE selection
                                        document.getElementById('dateStrip').addEventListener('click', function (e) {
                                            var btn = e.target.closest('.date-btn');
                                            if (!btn)
                                                return;

                                            document.querySelectorAll('.date-btn').forEach(function (b) {
                                                b.classList.remove('active');
                                            });
                                            btn.classList.add('active');

                                            state.date = btn.dataset.date;
                                            updateDateLabel();

                                            // Reload page with new date
                                            var form = document.createElement('form');
                                            form.method = 'GET';
                                            form.action = 'BookingScheduleServlet';
                                            var movieIdInput = document.createElement('input');
                                            movieIdInput.type = 'hidden';
                                            movieIdInput.name = 'movieId';
                                            movieIdInput.value = '<%= movie != null ? movie.getId() : ""%>';
                                            var dateInput = document.createElement('input');
                                            dateInput.type = 'hidden';
                                            dateInput.name = 'date';
                                            dateInput.value = state.date;
                                            form.appendChild(movieIdInput);
                                            form.appendChild(dateInput);
                                            document.body.appendChild(form);
                                            form.submit();
                                        });

                                        // EXPERIENCE selection - FIXED VERSION
                                        document.getElementById('experienceStrip').addEventListener('click', function (e) {
                                            var btn = e.target.closest('.exp-btn');
                                            if (!btn)
                                                return;

                                            document.querySelectorAll('.exp-btn').forEach(function (b) {
                                                b.classList.remove('active');
                                            });
                                            btn.classList.add('active');

                                            var selectedExp = btn.dataset.exp;
                                            state.exp = selectedExp;

                                            console.log("Filtering by experience: " + selectedExp);

                                            // Filter showtime cards by format
                                            var visibleCount = 0;
                                            document.querySelectorAll('.showtime-card').forEach(function (card) {
                                                var formatSpan = card.querySelector('.st-format');
                                                if (formatSpan) {
                                                    var cardFormat = formatSpan.textContent.trim();
                                                    console.log("Card format: " + cardFormat + ", Selected: " + selectedExp);

                                                    if (selectedExp === 'all' || cardFormat === selectedExp) {
                                                        card.style.display = 'flex'; // or 'block' or '' depending on your CSS
                                                        visibleCount++;
                                                    } else {
                                                        card.style.display = 'none';
                                                    }
                                                } else {
                                                    card.style.display = 'flex';
                                                    visibleCount++;
                                                }
                                            });

                                            console.log("Visible showtimes after filter: " + visibleCount);

                                            // Also filter cinema blocks that have no visible showtimes
                                            document.querySelectorAll('.cinema-block').forEach(function (block) {
                                                var visibleCards = block.querySelectorAll('.showtime-card[style*="flex"], .showtime-card:not([style*="none"])');
                                                if (visibleCards.length === 0) {
                                                    block.style.display = 'none';
                                                } else {
                                                    block.style.display = '';
                                                }
                                            });

                                            clearShowtime();
                                        });

                                        window.selectShowtime = function (card, cinema, time, format, showtimeId) {
                                            if (card.classList.contains('sold-out'))
                                                return;

                                            document.querySelectorAll('.showtime-card.active').forEach(function (c) {
                                                c.classList.remove('active');
                                            });

                                            card.classList.add('active');
                                            state.cinema = cinema;
                                            state.time = time;
                                            state.showtimeId = showtimeId;

                                            updateProceedBar();
                                        };

                                        function clearShowtime() {
                                            document.querySelectorAll('.showtime-card.active').forEach(function (c) {
                                                c.classList.remove('active');
                                            });
                                            state.cinema = null;
                                            state.time = null;
                                            updateProceedBar();
                                        }

                                        function updateProceedBar() {
                                            var btn = document.getElementById('proceedBtn');
                                            var detail = document.getElementById('proceedDetail');

                                            if (state.cinema && state.time) {
                                                detail.innerHTML = state.dateLabel + ' &nbsp;|&nbsp; <span>'
                                                        + state.time + '</span> &nbsp;|&nbsp; '
                                                        + state.cinema + ' &nbsp;|&nbsp; <span>' + state.exp + '</span>';
                                                btn.disabled = false;
                                                btn.onclick = function () {
                                                    window.location.href = 'booking.jsp?movieId=<%= movie != null ? movie.getId() : ""%>&showtimeId=' + state.showtimeId;
                                                };
                                            } else {
                                                detail.textContent = 'Select a date and showtime to continue';
                                                btn.disabled = true;
                                            }
                                        }

                                        window.toggleCinema = function (toggleBtn) {
                                            var block = toggleBtn.closest('.cinema-block');
                                            var collapsed = block.classList.toggle('collapsed');
                                            toggleBtn.innerHTML = collapsed ? '&#43;' : '&#8722;';
                                            toggleBtn.title = collapsed ? 'Expand' : 'Collapse';
                                        };

                                        window.toggleFav = function (btn) {
                                            var isActive = btn.classList.toggle('active');
                                            var svg = btn.querySelector('svg');
                                            svg.setAttribute('fill', isActive ? 'currentColor' : 'none');
                                        };

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

                                        // Initialize - show all showtimes initially
                                        console.log("Initializing page, showing all showtimes");
                                    })();
        </script>

        <%@ include file="footer.jsp" %>
    </body>
</html>