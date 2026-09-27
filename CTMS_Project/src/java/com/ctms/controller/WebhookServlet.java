package com.ctms.controller;

import com.ctms.dao.PaymentDAO;
import com.ctms.service.PaymentService;
import com.ctms.util.ConnectionDB;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.stripe.model.Event;
import com.stripe.model.PaymentIntent;
import com.stripe.net.Webhook;
import java.nio.charset.StandardCharsets;

public class WebhookServlet extends HttpServlet {

    private static final String ENDPOINT_SECRET = "whsec_5f23520dcb333a5673bf23edfa2d6715a7623310c06b3c352a3ccabbf932afc5";
    private ConnectionDB connectionDB;
    private PaymentDAO paymentDAO;
    private PaymentService paymentService;

    public void init() {
        connectionDB = new ConnectionDB();
        paymentDAO = new PaymentDAO(connectionDB.getConnection());
        paymentService = new PaymentService(paymentDAO);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String payload = new String(request.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
        String sigHeader = request.getHeader("Stripe-Signature");

        try {
            Event event = Webhook.constructEvent(payload, sigHeader, ENDPOINT_SECRET);

            System.out.println("Received event: " + event.getType());

            switch (event.getType()) {
                case "payment_intent.succeeded":
                case "payment_intent.payment_failed":
                    if (event.getDataObjectDeserializer().getObject().isPresent()) {
                        PaymentIntent intent = (PaymentIntent) event.getDataObjectDeserializer()
                                .getObject()
                                .get();
                        String paymentId = intent.getId();

                        if (event.getType().equals("payment_intent.succeeded")) {
                            paymentService.markPaymentSucceeded(paymentId);
                            System.out.println("Payment succeeded: " + paymentId);
                        } else {
                            paymentService.markPaymentFailed(paymentId);
                            System.out.println("Payment failed: " + paymentId);
                        }
                    }
                    break;

                default:
                    System.out.println("Ignored event: " + event.getType());
                    break;
            }

            response.setStatus(200);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(400);
        }
    }

}
