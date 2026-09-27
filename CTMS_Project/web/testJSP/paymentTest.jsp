<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Payment Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background: #f5f5f5;
        }

        .card {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            width: 320px;
        }

        h1 { font-size: 1.3rem; margin-bottom: 1.5rem; }

        label { display: block; margin-bottom: 0.3rem; font-size: 0.9rem; color: #555; }

        input {
            width: 100%;
            padding: 0.6rem;
            margin-bottom: 1rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 0.7rem;
            background: #635bff;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
        }

        button:hover { background: #4b44cc; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Payment Test</h1>
        <form action="${pageContext.request.contextPath}/PaymentServlet" method="post">
            <label>Amount</label>
            <input type="number" name="amount" step="1" min="2" placeholder="e.g. 50" required>

            <label>Currency</label>
            <input type="text" name="currency" placeholder="e.g. MYR" required>

            <button type="submit">Pay</button>
        </form>
    </div>
</body>
</html>
