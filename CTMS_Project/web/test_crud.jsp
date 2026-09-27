<%-- 
    Document   : test_crud
    Created on : Apr 27, 2026, 11:50:07 PM
    Author     : Kishor Mohan
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%!
    // ⚠️ Change these to your Supabase credentials
    private static final String URL = "jdbc:postgresql://db.spobivcidctnoosrllqm.supabase.co:5432/postgres?sslmode=require"; //Chnage this
    private static final String USER = "postgres";//Change this
    private static final String PASS = "Tingismine#1";//Change 

    Connection getConn() throws Exception {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
%>
<html>
    <head>
        <title>CRUD Test</title>
        <style>
            body {
                font-family: Arial;
                padding: 20px;
            }
            .ok  {
                color: green;
                font-weight: bold;
            }
            .err {
                color: red;
                font-weight: bold;
            }
            table {
                border-collapse: collapse;
                margin-top: 10px;
            }
            td, th {
                border: 1px solid #ccc;
                padding: 8px 12px;
            }
            th {
                background: #eee;
            }
            h3 {
                margin-top: 30px;
            }
        </style>
    </head>
    <body>
        <h2>🔧 Supabase CRUD Test</h2>

        <%
        // ─────────────────────────────────────────
        // 1. TEST CONNECTION
        // ─────────────────────────────────────────
        %>
        <h3>1️⃣ Connection Test</h3>
        <%
        try (Connection conn = getConn()) {
            out.println("<p class='ok'>✅ Connected to Supabase successfully!</p>");
        } catch (Exception e) {
            out.println("<p class='err'>❌ Connection failed: " + e.getMessage() + "</p>");
        }

        // ─────────────────────────────────────────
        // 2. CREATE - Insert a test record
        // ─────────────────────────────────────────
        %>
        <h3>2️⃣ CREATE Test (Insert)</h3>
        <%
        try (Connection conn = getConn()) {
            // Delete first in case it already exists from previous test run
            PreparedStatement del = conn.prepareStatement("DELETE FROM cinema WHERE cinema_id = 'TEST1'");
            del.executeUpdate();

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO cinema (cinema_id, cinema_name, branch, addr1, addr2, poscode, cinema_ph_number) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, "TEST1");
            ps.setString(2, "Test Cinema");
            ps.setString(3, "Test Branch");
            ps.setString(4, "123 Test Street");
            ps.setString(5, "Test Area");
            ps.setInt(6, 99999);
            ps.setString(7, "01-1234567");
            int rows = ps.executeUpdate();
            out.println("<p class='ok'>✅ INSERT success! Rows affected: " + rows + "</p>");
        } catch (Exception e) {
            out.println("<p class='err'>❌ INSERT failed: " + e.getMessage() + "</p>");
        }

        // ─────────────────────────────────────────
        // 3. READ - Show all cinemas
        // ─────────────────────────────────────────
        %>
        <h3>3️⃣ READ Test (Select)</h3>
        <%
        try (Connection conn = getConn()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM cinema");
            ResultSet rs = ps.executeQuery();
            out.println("<table><tr><th>ID</th><th>Name</th><th>Branch</th><th>Address</th><th>Postcode</th><th>Phone</th></tr>");
            int count = 0;
            while (rs.next()) {
                count++;
                out.println("<tr>");
                out.println("<td>" + rs.getString("cinema_id")       + "</td>");
                out.println("<td>" + rs.getString("cinema_name")     + "</td>");
                out.println("<td>" + rs.getString("branch")          + "</td>");
                out.println("<td>" + rs.getString("addr1")           + "</td>");
                out.println("<td>" + rs.getInt   ("poscode")         + "</td>");
                out.println("<td>" + rs.getString("cinema_ph_number")+ "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            out.println("<p class='ok'>✅ SELECT success! Total rows: " + count + "</p>");
        } catch (Exception e) {
            out.println("<p class='err'>❌ SELECT failed: " + e.getMessage() + "</p>");
        }

        // ─────────────────────────────────────────
        // 4. UPDATE - Update the test record
        // ─────────────────────────────────────────
        %>
        <h3>4️⃣ UPDATE Test</h3>
        <%
        try (Connection conn = getConn()) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE cinema SET cinema_name=?, branch=? WHERE cinema_id=?"
            );
            ps.setString(1, "Updated Cinema Name");
            ps.setString(2, "Updated Branch");
            ps.setString(3, "TEST1");
            int rows = ps.executeUpdate();
            out.println("<p class='ok'>✅ UPDATE success! Rows affected: " + rows + "</p>");

            // Show updated record
            PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM cinema WHERE cinema_id = 'TEST1'");
            ResultSet rs = ps2.executeQuery();
            if (rs.next()) {
                out.println("<p>Updated record → Name: <b>" + rs.getString("cinema_name") +
                            "</b> | Branch: <b>" + rs.getString("branch") + "</b></p>");
            }
        } catch (Exception e) {
            out.println("<p class='err'>❌ UPDATE failed: " + e.getMessage() + "</p>");
        }

        // ─────────────────────────────────────────
        // 5. DELETE - Remove the test record
        // ─────────────────────────────────────────
        %>
        <h3>5️⃣ DELETE Test</h3>
        <%
        try (Connection conn = getConn()) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM cinema WHERE cinema_id = ?");
            ps.setString(1, "TEST1");
            int rows = ps.executeUpdate();
            out.println("<p class='ok'>✅ DELETE success! Rows affected: " + rows + "</p>");
            out.println("<p>Test record <b>TEST1</b> has been removed from the database.</p>");
        } catch (Exception e) {
            out.println("<p class='err'>❌ DELETE failed: " + e.getMessage() + "</p>");
        }
        %>

        <hr>
        <p><b>✅ If all 5 steps show green — your Supabase CRUD is working!</b></p>

    </body>
</html>

