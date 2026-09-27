# ISSUE-001: SQL built by string concatenation
Severity: high · Category: security · Confidence: 90%
Location: `app/main.py:7`
Suggested timeline: 2026-10-12 → 2026-10-23

## Summary
`get_user` builds its query by concatenating the caller's `uid` into the SQL string.

## Why it happens
The query at `app/main.py:7` uses `+` instead of a bound parameter, so input is treated as SQL.

## Impact
Any caller who controls `uid` can read or alter data.

## Guidance to solve
1. Replace the concatenation with a parameterised query.
2. Validate `uid` as an integer at the boundary.

## How to verify
Add a test passing `"1 OR 1=1"` and assert it returns no extra rows.
