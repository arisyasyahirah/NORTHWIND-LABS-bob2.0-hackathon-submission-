# Welcome to Northwind Labs, Alex Tan
Role: Backend Engineer · Level: junior · Manager: Priya Menon · Buddy: Daniel Wong · Start: 2026-10-05 · End: 2027-01-03

## Why we exist
Northwind Labs makes field-service logistics simple enough that a **two-person team** can run it from a phone. Customers value speed of setup and clear, honest tooling.

> Fictional company used for the sample pack. Every fact here comes from the handbook.

## What you own
- The backend/API service and its data models (`app/main.py:1`).
- Database seed data and migrations.
- Review teammates' PRs within one working day.

## Timeline
| Phase | Start | End | Goal |
|---|---|---|---|
| 1 | 2026-10-05 | 2026-10-11 | Setup and comprehension |
| 2 | 2026-10-12 | 2026-11-03 | First contributions |
| 3 | 2026-11-04 | 2026-12-03 | Ownership |
| 4 | 2026-12-04 | 2027-01-03 | Independence |

## Architecture at a glance
A small Python service exposes user lookups over an SQLite database. One request flows from `main()` to `get_user()` and back (`app/main.py:11`).

### Why it's built this way
Unknown — ask your buddy.

## Run it first
1. Create a virtualenv and run `python context/scripts/install_deps.py <repo> `.
2. Start the app and confirm it prints a query.

```
python app/main.py
```

## Issues we found
| ID | Title | Severity | Timeline |
|---|---|---|---|
| ISSUE-001 | SQL built by string concatenation | high | 2026-10-12 → 2026-10-23 |

Full detail for every issue is in the **context folder**, one file each, with guidance to solve.

## Starter tasks
1. **Quick win** (by 2026-10-09): print a friendlier message in `main()`.
2. **Collaborative** (by 2026-10-16): agree the test approach for `get_user` with Daniel.
3. **Real slice** (by 2026-10-23): fix ISSUE-001 and add the test.

## People to meet
| Name | Role | Ask them for | How to reach |
|---|---|---|---|
| Priya Menon | Manager | Expectations and priorities | priya.menon@example.com |
| Daniel Wong | Buddy | Day-to-day code questions | daniel.wong@example.com |

## Sources
- `app/main.py`, `requirements.txt`, company handbook.
