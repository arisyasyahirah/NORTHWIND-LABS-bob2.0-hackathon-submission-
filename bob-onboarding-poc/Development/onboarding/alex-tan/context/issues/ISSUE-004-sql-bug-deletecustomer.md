# ISSUE-004: SQL Syntax Bug in CustomerDAO.deleteCustomer

Severity: high
Category: bug
Location: `src/java/com/ctms/dao/CustomerDAO.java:105`
Suggested timeline: 2026-10-05 → 2026-10-11

## Summary

The DELETE statement in CustomerDAO.java at line 105 reads `"DELETE FROM TABLE customer WHERE cust_id = ?"`. The keyword `TABLE` is not valid SQL and is rejected by every major database engine. The method therefore always throws a `SQLException` at runtime; because the exception is caught and `false` is returned, the failure is silent from the caller's perspective — the customer record is never actually deleted.

## Why it happens

This is a typo in the SQL string literal. The word `TABLE` was likely copied from a `CREATE TABLE` or `DROP TABLE` statement and was not removed when the `DELETE` template was written.

## Impact

- Deleting a customer account always fails silently. The customer record remains in the database regardless of what the UI reports.
- Any feature or workflow that depends on customer deletion (account cancellation, GDPR erasure requests, test-data cleanup) is completely broken.
- Because the exception is swallowed, the bug produces no visible error in logs unless detailed exception logging is added, making it hard to detect without reading the source.

## Guidance to solve

Change line 105 in CustomerDAO.java from:

```java
"DELETE FROM TABLE customer WHERE cust_id = ?"
```

to:

```java
"DELETE FROM customer WHERE cust_id = ?"
```

No other changes are required. Recompile and redeploy. This is a good first contribution: a single-line fix with a clear, verifiable outcome — an ideal issue for Phase 1 of onboarding.

## How to verify

- Call `CustomerDAO.deleteCustomer(id)` with a valid existing customer ID; the method returns `true`.
- Query the database directly: the row with that ID no longer exists.
- `grep "DELETE FROM TABLE" src/` returns no results.

## Related

- ISSUE-005: No Unit or Integration Tests (a unit test for `deleteCustomer` would have caught this immediately)
- ISSUE-006: Database Connection Per-Request Leak (`CustomerDAO` constructor also opens a connection per instantiation)
