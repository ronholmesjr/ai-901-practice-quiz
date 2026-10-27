#!/bin/bash
#
# ai-901-jeopardy.sh — Microsoft AI-901 practice quiz, Jeopardy style
#
# Multiple choice (A/B/C/D), like the real exam. Before each question,
# wager $100-$500. Correct answers win the wager, wrong answers lose it.
# Every answer comes with a one-line explanation, and the end screen
# reviews everything you missed.
#
# Categories match the current AI-901 blueprint (skills measured as of
# April 15, 2026):
#   concepts  Identify AI concepts and capabilities        (40-45%)
#   foundry   Implement AI solutions using Microsoft Foundry (55-60%)
#   mixed     both, weighted about 40/60 like the exam
#
# Usage:
#   ./ai-901-jeopardy.sh                    # asks category + how many
#   ./ai-901-jeopardy.sh foundry            # Foundry questions only
#   ./ai-901-jeopardy.sh mixed 20           # 20 mixed questions
#   ./ai-901-jeopardy.sh concepts all       # every Concepts question
#   QUIZ_SEED=7 ./ai-901-jeopardy.sh        # same question order every
#                                           # time (same quiz for the
#                                           # whole class)
#
# Practice questions are original, written from Microsoft's published
# AI-901 skills outline -- they are NOT copies of real exam questions.

# ------------------------------------------------------------------
# Question bank. One line per question:
#   domain|question|option A|option B|option C|option D|correct #|why
# - domain is "concepts" or "foundry"
# - correct # is 1-4, counting the options as written here
#   (the script shuffles the option order when it asks)
# - use \n inside a question for a line break (code snippets)
# - keep the | separators intact when adding your own questions
# ------------------------------------------------------------------
QUESTIONS=(
# --- Concepts: Identify AI concepts and capabilities ---
"concepts|A hiring tool consistently rates equally qualified candidates from one group lower than another group. Which responsible AI principle is being violated?|Reliability and safety|Fairness|Transparency|Inclusiveness|2|Fairness means the system treats all people equitably and avoids bias in its outcomes."
"concepts|A team stress-tests its AI system with unexpected and malformed inputs to make sure it keeps working safely. Which responsible AI principle are they checking?|Privacy and security|Accountability|Reliability and safety|Transparency|3|Reliability and safety means the system performs reliably and safely, even with unexpected inputs."
"concepts|Users want to understand how an AI system reached its decision. Which responsible AI principle covers making the system understandable?|Transparency|Fairness|Inclusiveness|Privacy and security|1|Transparency means users can understand how the system works and how it makes decisions."
"concepts|An app adds voice control and screen-reader support so people of all abilities can use its AI features. Which responsible AI principle is this?|Reliability and safety|Transparency|Privacy and security|Inclusiveness|4|Inclusiveness means AI systems should empower and work for people of all abilities."
"concepts|Customer data used by an AI app must be protected from unauthorized access. Which responsible AI principle covers this?|Privacy and security|Fairness|Accountability|Transparency|1|Privacy and security means personal data used by the system stays protected."
"concepts|How does a large language model produce its response?|It looks up answers stored in a database|It translates the prompt word by word|It predicts the most likely next token, one token at a time|It follows a fixed script written by developers|3|Generative AI models build responses by predicting the next token from patterns learned in training."
"concepts|Which model setting controls how random or creative the responses are?|Max tokens|Temperature|Deployment name|API version|2|Higher temperature means more varied, creative output; lower means more focused and predictable."
"concepts|Which setting limits how long the model's response can be?|Temperature|Max tokens|System prompt|Region|2|Max tokens caps the length of the generated response."
"concepts|You need key phrases, named entities, and sentiment from thousands of product reviews. Which AI workload is this?|Computer vision|Speech synthesis|Text analysis|Image generation|3|Finding key phrases, entities, and sentiment in written text is text analysis (NLP)."
"concepts|Which text analysis technique finds people, places, and organizations mentioned in a document?|Sentiment analysis|Keyword extraction|Summarization|Entity recognition|4|Entity recognition detects named entities such as people, places, and organizations."
"concepts|A warehouse app must locate every box in a photo and mark where each one is. Which vision capability does it need?|Image classification|Object detection|OCR|Image generation|2|Object detection finds individual objects in an image and marks their locations."
# --- Foundry: Implement AI solutions by using Microsoft Foundry ---
"foundry|You just deployed a model in the Microsoft Foundry portal. What is the quickest way to try it out before writing any code?|Write a Python client|Use the model's chat playground in the portal|Call the REST API from the command line|Create an agent first|2|The portal playground lets you chat with a deployed model right away, no code needed."
"foundry|What is the job of a system prompt?|Store the chat history|Set the model's behavior and rules for the conversation|Deploy the model|Hold the API key|2|The system prompt sets the assistant's role, tone, and rules for the whole conversation."
"foundry|In this Python code, what does the model value refer to?\n\nresponse = client.chat.completions.create(\n    model='sales-gpt',\n    messages=[{'role': 'user', 'content': 'Hello'}]\n)|The public name of the base model|Your model deployment name in Foundry|Your Azure subscription ID|The region the model runs in|2|Chat clients pass your deployment name as the model value, not the base model name."
"foundry|Which part of this request sets the assistant's overall behavior?\nmessages=[\n  {'role': 'system', 'content': 'You are a support assistant.'},\n  {'role': 'user', 'content': 'Reset my password'}\n]|The user message|The temperature setting|The system message|The deployment name|3|The system message carries the standing instructions; the user message is just the current request."
"foundry|When your app calls a chat model, what carries the conversation so far?|The endpoint|The messages array of roles and content|The API key|The model name|2|Each request sends the conversation as an array of messages, each with a role and content."
"foundry|In a Foundry SDK client, what does the endpoint identify?|The address of your Foundry project or resource|The model to run|The signed-in user's location|The billing account|1|The endpoint is where your Foundry resource lives; the deployment name says which model to run there."
"foundry|Which pair must a client app supply to call a deployed model?|Endpoint and deployment name|Username and password|Resource group and region|Subscription ID and invoice number|1|The client needs the endpoint (where) and the deployment name (which model), plus a credential to sign in."
"foundry|Which best describes a single-agent solution in Microsoft Foundry?|A second copy of a model for backup|A model configured with instructions and tools to handle a task|A load balancer for model traffic|A type of model deployment|2|An agent combines a model with instructions and tools so it can carry out a task."
"foundry|Which prompt is most likely to get a useful answer from a support bot?|Write something about orders|You are a support agent. Answer using the order status provided, in one short paragraph.|Answer the question|Be an AI and help|2|Effective prompts give the model a role, the material to use, and a clear output shape."
"foundry|Your app must listen to spoken questions and answer out loud. Which pairing does it need?|OCR and image generation|Speech-to-text and text-to-speech|Translation and summarization|Search and indexing|2|Azure Speech in Foundry Tools covers both directions: recognizing speech and synthesizing it."
"foundry|You need structured fields such as totals, dates, and vendor names pulled from thousands of invoices. Which Foundry tool is built for that?|Azure Speech|Azure AI Search|Content Understanding|Translator|3|Content Understanding extracts structured information from documents and forms."
"foundry|Which inputs can Content Understanding extract information from?|Documents only|Spreadsheets only|Documents, images, audio, and video|Source code only|3|Content Understanding is multimodal: it extracts information from documents, images, audio, and video."
"foundry|A user sends a photo and asks, 'What is wrong with this machine?' Which capability handles that in a prompt?|A multimodal model that accepts text and images|A text-only model|OCR alone|A translation model|1|Multimodal models can interpret visual input included in a prompt alongside text."
"foundry|Marketing wants product images created from text descriptions. Which capability do they need?|Image classification|Object detection|OCR|An image-generation model|4|Image-generation models create new visual outputs from a text prompt."
)

# ------------------------------------------------------------------
# Pick a category (arg 1, or ask)
# ------------------------------------------------------------------
category="${1:-}"
if [[ "$category" != "concepts" && "$category" != "foundry" && "$category" != "mixed" ]]; then
    echo "AI-901 Jeopardy -- pick a category:"
    echo "  1) Concepts  (Identify AI concepts and capabilities)"
    echo "  2) Foundry   (Implement AI solutions by using Microsoft Foundry)"
    echo "  3) Mixed     (both, weighted like the exam)"
    read -rp "Category (1, 2, or 3) [3]: " cat_choice
    case "${cat_choice:-3}" in
        1) category="concepts" ;;
        2) category="foundry" ;;
        *) category="mixed" ;;
    esac
fi

# Keep only the questions in the chosen category.
filtered=()
for entry in "${QUESTIONS[@]}"; do
    if [[ "$category" == "mixed" || "${entry%%|*}" == "$category" ]]; then
        filtered+=("$entry")
    fi
done
bank_size=${#filtered[@]}

# ------------------------------------------------------------------
# How many questions? (arg 2, or ask)
# ------------------------------------------------------------------
if [[ -n "${2:-}" ]]; then
    choice="$2"
else
    read -rp "How many questions? (10, 20, or 'all') [10]: " choice
    choice="${choice:-10}"
fi

if [[ "$choice" == "all" ]]; then
    num_questions=$bank_size
elif [[ "$choice" =~ ^[0-9]+$ ]] && (( choice > 0 )); then
    num_questions=$choice
    (( num_questions > bank_size )) && num_questions=$bank_size
else
    echo "Hmm, '$choice' isn't a number -- going with 10."
    num_questions=10
    (( num_questions > bank_size )) && num_questions=$bank_size
fi

# Fixed seed = same question and option order every run.
[[ -n "${QUIZ_SEED:-}" ]] && RANDOM="$QUIZ_SEED"

# ------------------------------------------------------------------
# Shuffle the question order (Fisher-Yates shuffle)
# ------------------------------------------------------------------
order=($(seq 0 $((bank_size - 1))))
for (( i = bank_size - 1; i > 0; i-- )); do
    j=$(( RANDOM % (i + 1) ))
    tmp=${order[i]}; order[i]=${order[j]}; order[j]=$tmp
done

# ------------------------------------------------------------------
# Ask the questions -- Jeopardy style!
# Wager $100-$500 on each question before you answer.
# Correct: you win the wager. Wrong: you lose it.
# ------------------------------------------------------------------
score=0
asked=0
correct=0
missed=()
letters=(A B C D)

for (( n = 0; n < num_questions; n++ )); do
    entry="${filtered[${order[n]}]}"
    IFS='|' read -r qdomain qtext o1 o2 o3 o4 qcorrect qexpl <<< "$entry"
    opts=("$o1" "$o2" "$o3" "$o4")
    correct_text="${opts[$((qcorrect - 1))]}"

    echo
    echo "Question $((asked + 1)) of $num_questions ($qdomain):"
    printf '%b\n' "  $qtext"

    # Pick the wager for this question.
    amount=""
    while [[ ! "$amount" =~ ^(100|200|300|400|500)$ ]]; do
        read -rp "  Wager? (100 / 200 / 300 / 400 / 500, or 'q' to quit): " amount
        amount=$(printf '%s' "$amount" | tr '[:upper:]' '[:lower:]' | xargs)
        if [[ "$amount" == "q" ]]; then
            echo "  Quitting early -- come back anytime."
            break 2
        fi
        if [[ ! "$amount" =~ ^(100|200|300|400|500)$ ]]; then
            echo "  Pick one of: 100, 200, 300, 400, 500."
        fi
    done

    # Shuffle the option order so the right letter moves around.
    oidx=(0 1 2 3)
    for (( i = 3; i > 0; i-- )); do
        j=$(( RANDOM % (i + 1) ))
        tmp=${oidx[i]}; oidx[i]=${oidx[j]}; oidx[j]=$tmp
    done
    correct_pos=-1
    for (( k = 0; k < 4; k++ )); do
        echo "    ${letters[k]}) ${opts[${oidx[k]}]}"
        if [[ ${oidx[k]} -eq $((qcorrect - 1)) ]]; then
            correct_pos=$k
        fi
    done
    correct_letter="${letters[$correct_pos]}"

    # Read the letter answer.
    pick=""
    while [[ ! "$pick" =~ ^(a|b|c|d|q)$ ]]; do
        read -rp "  Your answer (A, B, C, or D): " pick
        pick=$(printf '%s' "$pick" | tr '[:upper:]' '[:lower:]' | xargs)
        if [[ "$pick" != "q" && ! "$pick" =~ ^(a|b|c|d)$ ]]; then
            echo "  Pick a letter: A, B, C, or D (or 'q' to quit)."
        fi
    done
    if [[ "$pick" == "q" ]]; then
        echo "  Quitting early -- come back anytime."
        break
    fi
    case "$pick" in
        a) pick_pos=0 ;;
        b) pick_pos=1 ;;
        c) pick_pos=2 ;;
        *) pick_pos=3 ;;
    esac

    asked=$((asked + 1))
    short="${qtext%%\\*}"    # question up to any code snippet, for review
    if [[ $pick_pos -eq $correct_pos ]]; then
        echo "  Correct! +\$$amount"
        score=$((score + amount))
        correct=$((correct + 1))
    else
        echo "  Not quite -- the answer is $correct_letter) $correct_text. -\$$amount"
        score=$((score - amount))
        missed+=("\$$amount -- $short -> $correct_text")
    fi
    echo "  Why: $qexpl"
    echo "  Current score: \$$score"
done

# ------------------------------------------------------------------
# Results
# ------------------------------------------------------------------
echo
echo "==================================="
if (( asked == 0 )); then
    echo "No questions answered. Run it again when you're ready!"
else
    pct=$(( correct * 100 / asked ))
    echo "Final score: \$$score"
    echo "Correct: $correct / $asked  ($pct%)"
    if (( pct == 100 )); then
        echo "Perfect game! Exam-ready."
    elif (( pct >= 70 )); then
        echo "Solid! A little review and you'll hit 100%."
    else
        echo "Good start -- review the ones you missed below."
    fi
    if (( score < 0 )); then
        echo "Ouch -- you owe the bank \$${score#-}. Run it back!"
    fi
    if (( ${#missed[@]} > 0 )); then
        echo
        echo "Review these:"
        for m in "${missed[@]}"; do
            echo "  - $m"
        done
    fi
fi
echo "==================================="
