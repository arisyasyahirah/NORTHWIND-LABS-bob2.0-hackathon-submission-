# ISSUE-002: Hardcoded Stripe API Key and Webhook Secret

Severity: critical
Category: security
Location: `src/java/com/ctms/service/PaymentService.java:19`, `src/java/com/ctms/controller/WebhookServlet.java:19`
Suggested timeline: 2026-10-12 → 2026-10-19

## Summary

The Stripe secret key and webhook signing secret are hardcoded as string literals directly in PaymentService.java at line 19 and WebhookServlet.java at line 19 respectively. **Do not copy, log, or share these values** — the files and line numbers are the only reference needed. Both values are compiled into the deployed WAR and are visible to anyone with repository or artifact access.

## Why it happens

The keys are assigned directly as string literals in field declarations or constructors rather than being read from environment variables or a secrets manager. No secret-injection pattern (e.g., System.getenv, a properties file loaded at startup, or a vault client) is present anywhere in the payment or webhook code paths.

## Impact

- **Stripe secret key exposure** allows an attacker to make arbitrary charges, issue refunds, create customers, and access the full Stripe account via the API.
- **Webhook signing secret exposure** allows an attacker to forge Stripe webhook events (e.g., fabricate a payment_intent.succeeded event), potentially granting access without a real payment.
- Both keys cannot be rotated without a code change and redeployment.
- If the repository is ever public or leaked, all historical commits containing these values are permanently compromised and must be treated as such even after removal.

## Guidance to solve

1. **Remove both literals** from source immediately.
2. Load the Stripe secret key at runtime: `System.getenv("STRIPE_SECRET_KEY")`.
3. Load the webhook secret at runtime: `System.getenv("STRIPE_WEBHOOK_SECRET")`.
4. **Rotate both keys immediately** in the Stripe dashboard — treat current values as compromised.
5. Add `STRIPE_SECRET_KEY` and `STRIPE_WEBHOOK_SECRET` (without values) to .env.example.
6. Ensure `.gitignore` prevents any `.env` file containing real values from being committed.
7. Consider using Stripe's restricted keys for production to limit the blast radius of future leaks.

## How to verify

- `grep -r "sk_" src/` returns no matches.
- `grep -r "whsec_" src/` returns no matches.
- The application processes a Stripe test payment successfully using only environment-variable-supplied keys.
- Webhook signature verification passes with the environment-supplied secret.

## Related

- ISSUE-001: Hardcoded Database Credentials in Source Code (same root pattern)
- ISSUE-009: Customer Password Exposed in Session / Model Object (broader secrets hygiene)
