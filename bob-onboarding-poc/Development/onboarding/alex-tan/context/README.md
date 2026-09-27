# Start here, Alex

You received these files. Do them in this order (roughly 30 minutes):

1. northwind-labs-onboarding-alex-tan.pdf: your onboarding pack. Read this first (about 20 minutes): the company, your role, the codebase, your first tasks and your first week.
2. northwind-labs-onboarding-alex-tan-tour.mp4: a short narrated video tour of the codebase, with captions. Watch it after the PDF and before you open the code.
3. northwind-labs-onboarding-alex-tan-context.zip: the context for Bob IDE (your personal AI assistant for this codebase). Do not read it by hand: load it into Bob with the steps below.

## Set up Bob IDE with this folder

1. Install Bob IDE from https://bob.ibm.com/download and sign in. Your account is arranged on day 1: see "Day-1 accounts & access" in the PDF.
2. Create a folder called onboarding-workspace. Unzip the context zip into it (Windows: right-click, Extract All) so you have onboarding-workspace/context/.
3. Get the code: run: git clone https://github.com/arisyasyahirah/NORTHWIND-LABS.git — or open that URL in a browser, click the green Code button, and choose Download ZIP. Either way, put the CTMS_Project folder inside onboarding-workspace/ so you have onboarding-workspace/CTMS_Project/. If you cannot access the repo, ask Daniel Wong.
4. In Bob IDE choose File, Open Folder and pick onboarding-workspace/CTMS_Project. If Bob asks whether you trust the authors, choose Yes.
5. Copy context/AGENTS.md up one level to onboarding-workspace/AGENTS.md. Bob loads an AGENTS.md at the workspace root into every new conversation automatically; inside context/ it would not be loaded.
6. Open Bob's chat (Ctrl+Alt+B on Windows, Option+Cmd+B on Mac, or the Bob icon), start a new conversation with the plus sign, and send: Read @/context/README.md and help me finish the setup.
7. If you get stuck at any point, Daniel Wong (buddy) or Priya Menon (manager) is your first point of contact for setup problems.

To install the project's dependencies, ask Bob to run this (it only reads the manifest and installs, no sudo):

```
python context/scripts/install_deps.py <path to your clone> --check
```

Drop --check to install for real. On Windows use py instead of python if python is not found.

## How to work with Bob here

- Ask mode is read-only: use it to explore. Agent mode can change files and run commands, always asking first: approve only what you understand, and keep auto-approve off while you learn.
- Point Bob at files with @, for example @/context/architecture.md. Avoid mentioning whole folders: it is slower and costs more.
- Good first questions: Walk me through the code tour in @/context/architecture.md. Which issue should I start with, and why? What do I need to know before I touch the data layer?
- Bob only knows what is in these files. Where they say "Unknown — ask your buddy", ask Daniel Wong. Never paste passwords or keys into a chat.

## What is in this folder

- AGENTS.md: the instructions Bob reads first: who you are, the rules, where things are
- architecture.md: how the system is built, one request end to end, and the code tour
- company.md: what the company does and how it works
- issues/INDEX.md: the known problems, one line each
- issues/ISSUE-NNN-*.md (10 files): one known problem each, with evidence, guidance to solve it and how to verify it
- role.md: your role and what success looks like in 30 days
- scripts/install_deps.py: installs the project's declared dependencies (no sudo)
- tech-stack.md: what the project needs installed, and why
- timeline.md: your dates, starter tasks and week-1 checkpoints
