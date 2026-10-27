# AI-901 Practice Quiz (Jeopardy Style)

A bash Jeopardy-style practice quiz for the Microsoft AI-901 exam, built for
ITSA classmates.

25 multiple-choice questions (A/B/C/D), like the real exam. Before each
question you wager $100, $200, $300, $400, or $500 — get it right and you win
the wager, get it wrong and you lose it. Every answer comes with a one-line
explanation, and the end screen reviews everything you missed.

## Categories

Categories match the current AI-901 blueprint:

- **Concepts** — Identify AI concepts and capabilities (40–45% of the exam)
- **Foundry** — Implement AI solutions using Microsoft Foundry (55–60%)
- **Mixed** — both, weighted about 40/60 like the exam

## How to run

```text
chmod +x ai-901-jeopardy.sh
./ai-901-jeopardy.sh

## Pick a category up front

./ai-901-jeopardy.sh foundry
./ai-901-jeopardy.sh concepts

## Pick to Quiz the whole class

QUIZ_SEED=7 ./ai-901-jeopardy.sh
`
