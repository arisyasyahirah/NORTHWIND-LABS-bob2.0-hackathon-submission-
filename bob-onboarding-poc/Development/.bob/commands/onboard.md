---
description: Run the full onboarding pipeline (intake, scan, pack, PDF, send)
argument-hint: "[codebase path or @folder] [@instances/<client>/instance.yaml] [@instances/<client>/hires/<name>.yaml]"
---
Activate the `onboarding-pipeline` skill and run the whole pipeline.
Codebase to scan (optional, ask if empty): $1
Instance overlay (optional): $2. Hire prefill (optional): $3.
Start with the intake questions. Do not skip the human approval gate.
