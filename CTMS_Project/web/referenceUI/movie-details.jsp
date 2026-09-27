<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<%--
    WIRING NOTE:
    In production, load movie data from DB using the ?id= parameter, e.g.:
        <%
            int movieId = Integer.parseInt(request.getParameter("id"));
            Movie movie = MovieDAO.getById(movieId);
        %>
    Then replace the static values below with ${movie.title}, ${movie.genre}, etc.
    The YouTube embed ID should come from movie.trailerYoutubeId.
--%>

<link rel="stylesheet" href="css/movie-detail.css">

<main class="page-offset detail-page">

    <%-- ── BREADCRUMB ─────────────────────────────────────────── --%>
    <nav class="detail-breadcrumb">
        <a href="index.jsp">Home</a>
        <span class="bc-sep">›</span>
        <a href="movieList.jsp">Now Playing</a>
        <span class="bc-sep">›</span>
        <span class="bc-current">The Devil Wears Prada 2</span>
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
                 src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 280 420'%3E%3Crect width='280' height='420' fill='%231a1a2e'/%3E%3Ctext x='140' y='210' text-anchor='middle' fill='%236b6358' font-size='10'%3EPOSTER%3C/text%3E%3C/svg%3E"
                 alt="The Devil Wears Prada 2 Poster">
        </div>

        <%-- RIGHT: Movie info --%>
        <div class="detail-info-col">

            <%-- Title + classification badge --%>
            <div class="detail-title-row">
                <div class="detail-age-badge" data-age="13">13</div>
                <h1 class="detail-title">The Devil Wears Prada 2</h1>
            </div>

            <%-- Metadata grid: 2 columns, 3 rows --%>
            <div class="detail-meta-grid">

                <div class="detail-meta-row">
                    <%-- Calendar icon --%>
                    <svg class="detail-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>
                    </svg>
                    Release Date:&nbsp;<span class="detail-meta-label">30 April 2026</span>
                </div>

                <div class="detail-meta-row">
                    <%-- Speech bubble icon --%>
                    <svg class="detail-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                    </svg>
                    Spoken Language:&nbsp;<span class="detail-meta-label">ENG</span>
                </div>

                <div class="detail-meta-row">
                    <%-- Clock icon --%>
                    <svg class="detail-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>
                    </svg>
                    Running Time:&nbsp;<span class="detail-meta-label">2 hr 0 min</span>
                </div>

                <div class="detail-meta-row">
                    <%-- Subtitles icon --%>
                    <svg class="detail-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <rect x="2" y="5" width="20" height="14" rx="2"/><path d="M7 15h4M13 15h4M7 11h10"/>
                    </svg>
                    Subtitles:&nbsp;<span class="detail-meta-label">BM / CHI</span>
                </div>

                <div class="detail-meta-row">
                    <%-- Tag icon --%>
                    <svg class="detail-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7.01" y2="7"/>
                    </svg>
                    Genre:&nbsp;<span class="detail-meta-label">Comedy</span>
                </div>

                <div class="detail-meta-row">
                    <%-- Classification icon --%>
                    <svg class="detail-meta-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <rect x="2" y="3" width="20" height="14" rx="2"/><path d="M8 21h8M12 17v4"/>
                    </svg>
                    Classification:&nbsp;<span class="detail-meta-label">13</span>
                </div>

            </div>

            <%-- Director --%>
            <div class="detail-section">
                <div class="detail-section-label">Director</div>
                <div class="detail-section-body">David Frankel</div>
            </div>

            <%-- Cast --%>
            <div class="detail-section">
                <div class="detail-section-label">Cast</div>
                <div class="detail-section-body">
                    Meryl Streep, Anne Hathaway, Emily Blunt, Sydney Sweeney,
                    Lucy Liu, Kenneth Branagh, Stanley Tucci
                </div>
            </div>

            <%-- Synopsis --%>
            <div class="detail-section">
                <div class="detail-section-label">Synopsis</div>
                <div class="detail-section-body">
                    Follows Miranda Priestly's struggle against Emily Charlton, her former assistant turned
                    rival executive, as they compete for advertising revenue amidst declining print media
                    while Miranda nears retirement.
                </div>
            </div>

        </div><%-- end detail-info-col --%>
    </div><%-- end detail-main --%>

    <%-- ── DIVIDER ─────────────────────────────────────────────── --%>
    <div class="detail-divider"></div>

    <%-- ── TRAILER SECTION ────────────────────────────────────── --%>
    <div class="detail-trailer-section">
        <div class="detail-trailer-heading">Trailer</div>

        <%--
            Replace the YouTube embed ID (dQw4w9WgXcQ) with the real trailer ID,
            e.g. the ID from: https://www.youtube.com/watch?v=TRAILER_ID_HERE
            In production: src="https://www.youtube.com/embed/${movie.trailerYoutubeId}?..."
        --%>
        <div class="trailer-embed-wrap">
            <iframe
                src="https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0&modestbranding=1&color=red"
                title="The Devil Wears Prada 2 — Official Trailer"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen>
            </iframe>
        </div>
    </div>

    <%-- ── DIVIDER ─────────────────────────────────────────────── --%>
    <div class="detail-divider"></div>

    <%-- ── FAQ SECTION ─────────────────────────────────────────── --%>
    <div class="detail-faq-section">
        <div class="detail-faq-heading">FAQs about The Devil Wears Prada 2 at GSC Cinema</div>

        <div class="faq-item">
            <div class="faq-question" onclick="toggleFaq(this)">
                When does The Devil Wears Prada 2 release in Malaysia?
            </div>
            <div class="faq-answer">
                The Devil Wears Prada 2 is scheduled for release on 30 April 2026 across all GSC Cinemas nationwide.
            </div>
        </div>

        <div class="faq-item">
            <div class="faq-question" onclick="toggleFaq(this)">
                What is the classification of The Devil Wears Prada 2?
            </div>
            <div class="faq-answer">
                The film is classified as 13 by the Film Censorship Board of Malaysia (LPF), meaning it is suitable for audiences aged 13 and above.
            </div>
        </div>

        <div class="faq-item">
            <div class="faq-question" onclick="toggleFaq(this)">
                What languages is The Devil Wears Prada 2 available in?
            </div>
            <div class="faq-answer">
                The film is in English (ENG) with subtitles available in Bahasa Malaysia (BM) and Chinese (CHI).
            </div>
        </div>

        <div class="faq-item">
            <div class="faq-question" onclick="toggleFaq(this)">
                How long is The Devil Wears Prada 2?
            </div>
            <div class="faq-answer">
                The running time is 2 hours 0 minutes, excluding advertisements and trailers before the main feature.
            </div>
        </div>

        <div class="faq-item">
            <div class="faq-question" onclick="toggleFaq(this)">
                Can I book tickets online at GSC?
            </div>
            <div class="faq-answer">
                Yes. You can book tickets online through this website by clicking the BUY TICKETS NOW button below, selecting your preferred date, cinema, and showtime, then proceeding to seat selection and payment.
            </div>
        </div>

    </div><%-- end faq --%>

    <%-- Bottom padding so sticky bar doesn't cover content --%>
    <div style="height:80px;"></div>

</main>

<%-- ── STICKY BUY TICKETS BAR ──────────────────────────────────── --%>
<div class="detail-buy-bar">
    <div class="detail-buy-inner">
        <div class="detail-buy-info">
            <div class="detail-buy-title">THE DEVIL WEARS PRADA 2</div>
            <div class="detail-buy-sub">Select your cinema and showtime to proceed</div>
        </div>
        <button class="detail-buy-btn" onclick="location.href='booking-schedule.jsp'">
            BUY TICKETS NOW
        </button>
    </div>
</div>

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

<%@ include file="footer.jsp" %>
