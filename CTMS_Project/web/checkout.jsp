<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <script src="https://js.stripe.com/v3/"></script>
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
            width: 360px;
        }

        h2 { font-size: 1.3rem; margin-bottom: 1.5rem; }

        label { display: block; font-size: 0.9rem; color: #555; margin-bottom: 0.4rem; }

        #card-element {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 0.65rem;
            margin-bottom: 1rem;
        }

        #error-message {
            color: #e74c3c;
            font-size: 0.85rem;
            margin-bottom: 1rem;
            min-height: 1.2rem;
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
        button:disabled { background: #aaa; cursor: not-allowed; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Pay Now</h2>

        <label>Card Details</label>
        <div id="card-element"></div>

        <div id="error-message"></div>

        <button id="payBtn">Pay</button>
    </div>

    <script>
        const stripe = Stripe("pk_test_51TQoFsAwHHpZf59mDlSNAgx5f7RPUMp3WebXIJpjLR2mbgSIcEHAmA5ruySv3UMOKdnsCAlFhdqxEJyI8pJbE8KX00IzIWx7gj");
        const clientSecret = "<%= request.getAttribute("clientSecret") %>";
        const elements = stripe.elements();
        const cardElement = elements.create("card");
        cardElement.mount("#card-element");

        const payBtn = document.getElementById("payBtn");
        const errorDiv = document.getElementById("error-message");

        payBtn.addEventListener("click", async () => {
            payBtn.disabled = true;
            payBtn.textContent = "Processing...";
            errorDiv.textContent = "";

            const result = await stripe.confirmCardPayment(clientSecret, {
                payment_method: { card: cardElement }
            });

            if (result.error) {
                errorDiv.textContent = result.error.message;
                payBtn.disabled = false;
                payBtn.textContent = "Pay";
            } else if (result.paymentIntent.status === "succeeded") {
                payBtn.textContent = "Payment Successful!";
            }
        });
    </script>
</body>
</html>
