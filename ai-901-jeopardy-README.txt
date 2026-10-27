ai-901-jeopardy.sh — Microsoft AI-901 practice quiz, Jeopardy style
====================================================================

25 multiple-choice questions (A/B/C/D), like the real exam. Before
each question you wager $100, $200, $300, $400, or $500. Get it
right, you win the wager; get it wrong, you lose it. Every answer
comes with a one-line explanation, and the end screen reviews
everything you missed — study those.

Categories match the current AI-901 blueprint:
  Concepts  Identify AI concepts and capabilities (40-45% of exam)
  Foundry   Implement AI solutions using Microsoft Foundry (55-60%)
  Mixed     both, weighted about 40/60 like the exam

The questions are original practice questions written from
Microsoft's published AI-901 skills outline — not real exam
questions.

HOW TO RUN
----------
1. Put the file in a folder on your machine.
2. Open a terminal in that folder and run once:
       chmod +x ai-901-jeopardy.sh
3. Start the quiz:
       ./ai-901-jeopardy.sh
   Pick a category up front:
       ./ai-901-jeopardy.sh foundry
       ./ai-901-jeopardy.sh concepts all
   Add a count for a set length:
       ./ai-901-jeopardy.sh mixed 20

ON WINDOWS
----------
This needs bash. If you have Ubuntu under WSL, open the Ubuntu
terminal, cd to where the file is (your Downloads looks like
/mnt/c/Users/YOURNAME/Downloads), then chmod and run as above.
Do NOT edit the file in Notepad — it saves Windows line endings
that break bash scripts. Edit with nano inside the Ubuntu
terminal instead.

SAME QUESTIONS FOR THE WHOLE CLASS
----------------------------------
Set a seed and everyone gets the same question and option order:
       QUIZ_SEED=7 ./ai-901-jeopardy.sh

ADD YOUR OWN QUESTIONS
----------------------
Every line starting with # is a comment — reword those freely.
Question lines look like:
  "domain|question|option A|option B|option C|option D|correct #|why"
The correct # is 1-4 counting the options as written (the script
shuffles them when it asks). Keep the | separators intact, and
leave line 1 (#!/bin/bash) alone.
