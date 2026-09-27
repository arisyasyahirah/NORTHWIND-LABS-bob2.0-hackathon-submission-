# CTMS Project — Tech Stack

## Runtime / Library versions

| Runtime/Library | Version | Purpose | Source |
|---|---|---|---|
| Java (JDK) | Unknown — ask your buddy | Application runtime | — |
| Jakarta EE (web app) | 6.1 | Web application specification (Servlets, JSP) | `web/WEB-INF/web.xml` |
| Servlet container | Tomcat (or compatible Jakarta EE container) | Hosts the WAR; inferred from web.xml / context.xml | `web/META-INF/context.xml` |
| Apache Ant | (system install) | Build system; compiles and packages the WAR | `build.xml`, `nbproject/build-impl.xml` |
| PostgreSQL JDBC driver | 42.7.10 | Active database driver — connects to Supabase-hosted PostgreSQL | postgresql-42.7.10.jar |
| MySQL JDBC driver | 9.6.0 | MySQL driver — **present but not actively used** (legacy or mistake; PostgreSQL is used instead) | mysql-connector-j-9.6.0.jar |
| Stripe Java SDK | 32.1.0 | Payment processing | stripe-java-32.1.0.jar |
| OkHttp | 5.3.2 | HTTP client (used by Stripe SDK or webhooks) | okhttp-5.3.2.jar |
| Okio | 3.17.0 | I/O library (OkHttp dependency) | okio-3.17.0.jar |
| Google Gson | 2.14.0 | JSON parsing | gson-2.14.0.jar |
| JSTL (Jakarta EE 3 impl) | 3.0.1 | JSP Standard Tag Library — active implementation | jakarta.servlet.jsp.jstl-3.0.1.jar |
| JSTL API (Jakarta EE 3) | 3.0.0 | JSTL API | jakarta.servlet.jsp.jstl-api-3.0.0.jar |
| JSTL (classic) | 1.2 | Older JSTL implementation — **likely redundant** alongside Jakarta JSTL 3 | jstl-1.2.jar |

> **Database note:** The active database connection is PostgreSQL (Supabase-hosted).
> See [`src/java/com/ctms/util/ConnectionDB.java`](../../../../../src/java/com/ctms/util/ConnectionDB.java) for JDBC URL and credentials setup.

> **Frontend note:** UI is JSPs with custom CSS (`web/master-style.css`). No Node.js, npm, or JavaScript framework is used.

> **Testing note:** No test framework JARs (JUnit, Mockito, etc.) are present. There is no automated test suite.

---

## How to build and run

### Prerequisites

- Java JDK installed (version unknown — ask your buddy)
- [Apache Ant](https://ant.apache.org/) installed and on your `PATH`
- A running PostgreSQL instance (Supabase credentials configured in ConnectionDB.java)
- Tomcat (or a compatible Jakarta EE 6.1 container) installed

### Build

```bash
# From the project root (where build.xml lives)
ant clean
ant jar
# or simply:
ant
```

Ant compiles the sources and packages everything into a WAR file (typically under `dist/`).

### Deploy

Copy the generated WAR to your Tomcat `webapps/` directory:

```bash
cp dist/CTMS_Project.war $CATALINA_HOME/webapps/SAD_Project.war
```

> The WAR is deployed under the context path **`/SAD_Project`** as declared in `web/META-INF/context.xml`.

### Access

Once Tomcat starts, the application is available at:

```
http://localhost:8080/SAD_Project/
```

---

## Helper script

A dependency-check helper is included at [`scripts/install_deps.py`](scripts/install_deps.py).
This script checks for missing pip/npm dependencies in a given repo path and optionally installs them.
It is not required for this Java/Ant project (no Python or npm dependencies are declared), but is
provided as a general-purpose onboarding utility.

```bash
# Check only (no installs):
python scripts/install_deps.py <repo_path> --check

# Check and install:
python scripts/install_deps.py <repo_path>
```
