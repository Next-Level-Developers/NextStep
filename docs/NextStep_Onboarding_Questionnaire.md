# NextStep — Onboarding Questionnaire
### Interest & Skills Profiler for Career Discovery

> **Version:** 1.0  
> **Purpose:** Onboarding interest profiler to map students to the 6 core dimensions — Creative (C), Analytical (A), Social (S), Technical (T), Entrepreneurial (E), Physical (P) — and generate a personalised career match from the 300+ career database.  
> **Target Users:** School students (Grade 8–12) & College students (Year 1–2)  
> **Estimated Time:** 5–8 minutes  
> **Design Principle:** Feels like a conversation, not an exam. No right or wrong answers.

---

## How It Works

Each question maps student responses to one or more interest dimensions. After completion, the app builds a **weighted interest graph** across six dimensions:

| Dimension | Code | What It Measures |
|---|---|---|
| Creative | `C` | Design, expression, art, storytelling, aesthetics |
| Analytical | `A` | Data, research, logic, systems, patterns |
| Social | `S` | People, empathy, communication, leadership |
| Technical | `T` | Engineering, building, making, technology |
| Entrepreneurial | `E` | Business, risk-taking, independence, scale |
| Physical | `P` | Movement, sports, hands-on work, outdoors |

Each answer option carries a **dimension weight** used by the personalization engine to compute scores. The career database is then filtered by matching the student's top 2–3 dimensions.

---

## Section 0 — Student Context (Pre-Profiler Setup)

> These questions personalise the roadmap and are collected before the scenario questions begin. They are **not scored** — they set context.

---

**SC-1. What is your current academic stage?**

- 🏫 Grade 8 or 9 — Still exploring, no stream yet
- 🏫 Grade 10 — Choosing my stream soon
- 📚 Grade 11 or 12 — Science stream
- 📚 Grade 11 or 12 — Commerce stream
- 📚 Grade 11 or 12 — Arts / Humanities stream
- 🎓 College — Year 1 or 2

*[Used to: personalise roadmap timelines and filter career entry path relevance]*

---

**SC-2. Have you already decided what you want to do after school/college?**

- ✅ Yes, I have a clear idea
- 🤔 I have a few options in mind but I'm not sure
- ❓ Not at all — that's why I'm here
- 🔁 I thought I knew, but I want to explore more

*[Used to: adjust tone and depth of career recommendations — exploratory vs. confirming]*

---

**SC-3. How much pressure are you under right now to decide your career?**

- 😤 A lot — family expects a decision soon
- 😐 Some — it comes up occasionally
- 😌 Not much — I have time to figure it out
- 😰 Very high — I feel lost and stressed about it

*[Used to: surface "quick win" actionable paths for high-pressure users; surface broad exploration for low-pressure users]*

---

## Section 1 — What You Do With Free Time

> *These questions reveal natural interests — what you gravitate toward when no one is watching.*

---

**Q1. It's a free Saturday with zero obligations — no school, no family commitments. What are you most likely doing?**

*Pick the one that feels most like you.*

| Option | Dimensions Mapped |
|---|---|
| 🎨 Drawing, designing, making something visual or creative | `C` |
| 💻 Exploring technology — coding, building apps, tinkering with electronics | `T` |
| 📖 Reading, researching, or going deep on something I'm curious about | `A` |
| 🧑‍🤝‍🧑 Spending time with friends, having long conversations, or helping someone | `S` |
| 🏃 Playing sport, going outdoors, working out, or doing something physical | `P` |
| 💡 Planning a project, thinking about a business idea, or organising something | `E` |

---

**Q2. When you watch YouTube or scroll through content, what kind of videos do you keep coming back to?**

*Pick up to 2.*

| Option | Dimensions Mapped |
|---|---|
| 🎬 Behind-the-scenes of films, animation, design, or art | `C` |
| 🔬 Science experiments, tech reviews, or "how things work" | `T` `A` |
| 📊 Finance, startups, business stories, or investing | `E` `A` |
| 🤸 Sports highlights, fitness routines, or outdoor adventures | `P` |
| 🧠 Documentaries about people, society, psychology, or history | `S` `A` |
| 🎮 Game walkthroughs, programming tutorials, or gadget builds | `T` `C` |
| 🌍 Climate, environment, social justice, or news | `A` `S` |
| 🎤 Music, performance, storytelling, or personal vlogs | `C` `S` |

---

**Q3. Imagine you have one month of holidays with a small budget. Which project would excite you the most?**

| Option | Dimensions Mapped |
|---|---|
| 🖌️ Creating a short film, comic strip, or illustrated story | `C` |
| 🤖 Building a working gadget, app, or automation for something at home | `T` |
| 🔍 Researching a topic deeply and writing a detailed report or blog | `A` |
| 🧑‍🏫 Teaching or tutoring younger kids in your neighbourhood | `S` |
| 🏕️ Organising a trip or sports event with friends | `P` `E` |
| 💼 Starting a small side hustle — selling something, creating a service | `E` |

---

## Section 2 — How You Think & Solve Problems

> *These questions reveal your cognitive style — not your intelligence. There is no "smart" answer.*

---

**Q4. You notice that the canteen at your school wastes a lot of food every day. What's your first instinct?**

| Option | Dimensions Mapped |
|---|---|
| 📐 Design a better menu or ordering system so less food is prepared unnecessarily | `C` `A` |
| 💻 Build a digital system that tracks orders and predicts demand | `T` `A` |
| 📢 Start a campaign, talk to the canteen staff, rally students to change behaviour | `S` `E` |
| 📊 Collect data on what food gets wasted, analyse patterns, and present findings | `A` |
| 🤝 Organise a system to donate leftover food to nearby shelters or students in need | `S` `E` |
| ♻️ Research how other schools globally solved the same problem and adapt the best solution | `A` `S` |

---

**Q5. Your school is organising a science fair. Which project would you most want to work on?**

| Option | Dimensions Mapped |
|---|---|
| 🌱 A model of a renewable energy system that actually generates power | `T` `A` |
| 🎨 An infographic installation visualising how the human brain processes emotions | `C` `A` |
| 🤖 A robot that can help differently-abled students navigate the school | `T` `S` |
| 📉 A data study comparing how students' sleep patterns affect academic performance | `A` |
| 🌍 An interview-based documentary about local farmers affected by climate change | `S` `C` |
| 🏗️ A scaled physical model of a better-designed school building with green features | `C` `T` |

---

**Q6. You're given a big, unstructured problem with no clear answer. How do you usually approach it?**

| Option | Dimensions Mapped |
|---|---|
| 🗂️ I break it into small parts, list everything I need to understand, then research each | `A` |
| ✏️ I sketch ideas, make diagrams, or draw out what the solution might look like | `C` |
| 💬 I talk it through with someone — bouncing ideas helps me think clearly | `S` |
| 🔧 I jump in and start experimenting — trial and error works better for me than planning | `T` `P` |
| 📋 I create a plan, assign steps, and think about resources and timeline | `E` |
| 🔎 I look for someone who has already solved a similar problem and learn from them | `A` `S` |

---

**Q7. You discover a new app has a terrible onboarding experience — most users drop off in the first 30 seconds. What do you want to do?**

| Option | Dimensions Mapped |
|---|---|
| 🧑‍🎨 Redesign the visual flow and make it feel more intuitive and inviting | `C` |
| 🧑‍💻 Fix the technical bugs and optimise the loading speed | `T` |
| 📋 Interview users to understand exactly where and why they're dropping off | `S` `A` |
| 📊 Analyse the drop-off data to find the exact screen where it happens | `A` |
| 💡 Reimagine the whole product strategy — maybe the problem is bigger than the onboarding | `E` |
| ✍️ Rewrite all the in-app text to be clearer and more friendly | `C` `S` |

---

## Section 3 — What Kind of Work Energises You

> *These questions reveal your work style and the type of environment where you'll thrive.*

---

**Q8. Which of these would feel like "a great day at work" for you?**

| Option | Dimensions Mapped |
|---|---|
| 💡 You came up with a creative idea that people genuinely loved | `C` |
| 🧩 You solved a complex technical or analytical problem no one else could figure out | `T` `A` |
| 🤝 You helped someone through a really hard moment and they felt supported | `S` |
| 🏆 You convinced a room full of people to back your idea | `E` `S` |
| 🌲 You spent the day working outdoors or with your hands, and built something real | `P` `T` |
| 🔬 You discovered a new insight through research that nobody had noticed before | `A` |

---

**Q9. Which work environment sounds the most appealing to you?**

| Option | Dimensions Mapped |
|---|---|
| 🖥️ A focused desk with a big screen — deep work, code, data, or design | `T` `A` `C` |
| 🏃 In the field — visiting places, meeting people, doing things on-site | `P` `S` |
| 🗣️ A collaborative open space — brainstorming, meetings, working with people | `S` `E` |
| 🔬 A lab or workshop — experiments, prototypes, and physical building | `T` `P` |
| 🌐 Fully remote, from anywhere — autonomy and flexibility | `E` |
| 🎨 A studio — music, art, film, design, or performance | `C` |

---

**Q10. When working in a group, which role do you naturally gravitate toward?**

| Option | Dimensions Mapped |
|---|---|
| 🎯 The one who comes up with the big idea and keeps the vision clear | `C` `E` |
| 🔧 The one who figures out how to actually make it work technically | `T` |
| 📣 The one who communicates the idea to others and brings everyone together | `S` `E` |
| 📊 The one who does the research, checks facts, and makes sure decisions are data-backed | `A` |
| 🤗 The one who keeps the team morale high and resolves conflicts when they arise | `S` |
| 🏃 The one who just gets things done — execution over talk | `P` `T` |

---

## Section 4 — What Matters to You

> *These questions surface your values and the kind of impact you want your work to have.*

---

**Q11. You're 30 years old, successful in your career. Which of these feels most satisfying?**

| Option | Dimensions Mapped |
|---|---|
| 🎨 People experience your creative work — art, design, film, games — and it moves them | `C` |
| 🧬 You contributed to a scientific breakthrough that could save or improve many lives | `A` `T` |
| 🏢 You built a business that employs hundreds of people and solves a real problem | `E` |
| 🏫 You helped shape the next generation — through teaching, mentoring, or public service | `S` |
| 🌍 You worked on solving a massive societal problem — climate, inequality, healthcare | `S` `A` |
| 🏆 You're at the top of your field — globally recognised for your technical mastery | `T` `A` |

---

**Q12. Which of these problems makes you most angry when you read about it?**

| Option | Dimensions Mapped |
|---|---|
| 🌡️ Climate change and environmental destruction | `A` `T` `S` |
| 🧠 The lack of mental health support for young people | `S` `A` |
| 📡 The digital divide — millions of people without internet or technology access | `T` `S` |
| 🎨 The world is full of ugly, poorly designed experiences — bad apps, bad spaces | `C` |
| 💸 Financial inequality — a few people own most of the world's wealth | `E` `A` |
| 🤖 AI and automation threatening jobs without anyone preparing for it | `T` `A` |

---

**Q13. What motivates you most in the long run?**

| Option | Dimensions Mapped |
|---|---|
| 💰 Financial freedom — the ability to live without money being a constant worry | `E` |
| 🌟 Recognition — being respected and known for your work | `C` `E` |
| 🛠️ Mastery — becoming one of the best in the world at something | `T` `A` |
| 🌍 Impact — knowing your work genuinely made the world better | `S` `A` |
| 🧘 Balance — a fulfilling career that also gives you time for your personal life | `P` `S` |
| 🔬 Discovery — the thrill of exploring unknown territory and learning new things | `A` `C` |

---

## Section 5 — Situational Scenarios

> *These are the most important questions. Pick the answer that feels most naturally like you — not what sounds impressive.*

---

**Q14. You're watching the news. A city flood has displaced 10,000 families. Which of these responses most matches how you'd want to help?**

| Option | Dimensions Mapped |
|---|---|
| 🗺️ Design a better early warning and evacuation system so this never happens again | `C` `T` `A` |
| 📊 Analyse the disaster data to understand what failed and write a report for policymakers | `A` |
| 🤝 Organise a relief camp, coordinate volunteers, and make sure people get what they need | `S` `E` |
| 🏗️ Help rebuild — physically working on infrastructure, shelters, and essential services | `T` `P` |
| 📢 Use your platform to raise awareness and donations for affected families | `C` `S` |
| 🔬 Research climate-resilient urban planning models that could prevent this in the future | `A` `T` |

---

**Q15. A friend comes to you struggling — they failed a big exam, their parents are upset, and they feel like a failure. What's your instinct?**

| Option | Dimensions Mapped |
|---|---|
| 💬 Sit with them, listen fully, and make sure they feel heard before saying anything | `S` |
| 📋 Help them figure out exactly what went wrong and build a better study plan | `A` |
| 🎨 Distract them with something fun and creative — help them get out of their head | `C` |
| 🤔 Ask questions to help them think through it themselves — coach them through it | `S` `A` |
| 💪 Remind them of all their strengths and encourage them to get back up quickly | `S` `E` |
| 🛠️ Suggest a concrete next action — contact the teacher, retake the exam, use a resource | `T` `E` |

---

**Q16. You have the chance to start a project of your choice with full support. Which one do you pick?**

| Option | Dimensions Mapped |
|---|---|
| 📱 Build an app that solves a problem you've personally experienced | `T` `E` |
| 🎥 Create a documentary or short film about something you care deeply about | `C` `S` |
| 🔬 Run a research experiment to test a hypothesis you've always been curious about | `A` `T` |
| 🏫 Design and run a workshop to teach younger students a skill you love | `S` `C` |
| 🌿 Launch a community initiative that addresses a local environmental issue | `S` `E` |
| 📐 Design a physical product — something you can hold, use, and show people | `C` `T` |

---

**Q17. You're at a party and someone asks, "So what are you into?" Which of these comes out of your mouth first?**

| Option | Dimensions Mapped |
|---|---|
| 🎨 "I love making things — design, art, videos, whatever I can get creative with" | `C` |
| 💻 "I'm really into tech — I like understanding how things are built" | `T` |
| 🔢 "I like thinking about systems and data — understanding how things actually work" | `A` |
| 🧑‍🤝‍🧑 "I love being around people — I'm a bit obsessed with understanding what makes them tick" | `S` |
| 💼 "I'm thinking about starting something — I want to build my own thing one day" | `E` |
| ⚽ "I'm really into sport / fitness / being active — it's a big part of my life" | `P` |

---

**Q18. Your school gives every student a 20-minute slot to present to the whole school. What do you present?**

| Option | Dimensions Mapped |
|---|---|
| 🎨 A creative project — an artwork, a short film, a performance, or a design piece | `C` |
| 🔬 A science or data experiment I ran myself — with real findings | `A` `T` |
| 📢 A talk about a cause I care about — something the school needs to hear | `S` `E` |
| 💡 A business idea or startup pitch with a prototype or plan | `E` `T` |
| 🌍 A documentary or interview series — stories of real people doing interesting things | `C` `S` |
| 🤔 A thought experiment or philosophical question — something that challenges how we think | `A` `C` |

---

## Section 6 — Subjects & Skills Snapshot

> *This section is quick. It helps identify subject alignment and self-assessed skills to further personalise career matching.*

---

**Q19. Which subjects have you genuinely enjoyed (not just been good at, but actually liked)?**

*Pick all that apply.*

| Option | Dimensions Mapped |
|---|---|
| 📐 Mathematics | `A` `T` |
| 🔬 Physics | `T` `A` |
| 🧫 Biology / Life Sciences | `A` `S` |
| ⚗️ Chemistry | `T` `A` |
| 💻 Computer Science / IT | `T` `A` |
| 📝 English / Literature / Languages | `C` `S` |
| 🎨 Art / Design / Craft | `C` |
| 🌍 History / Geography / Social Studies | `S` `A` |
| 📊 Economics / Business Studies / Accounts | `E` `A` |
| 🏃 Physical Education | `P` |
| 🎵 Music / Performing Arts | `C` `P` |
| 🧠 Psychology / Sociology (if available) | `S` `A` |

---

**Q20. Which of these skills feels most natural to you right now?**

*Pick your top 3.*

| Option | Dimensions Mapped |
|---|---|
| ✍️ Writing or storytelling | `C` `S` |
| 🗣️ Public speaking or persuading people | `S` `E` |
| 🔢 Working with numbers, spreadsheets, or data | `A` `T` |
| 🎨 Drawing, designing, or visual thinking | `C` |
| 🤝 Listening and empathising with people | `S` |
| 🔧 Fixing, building, or assembling physical things | `T` `P` |
| 💻 Coding, technology, or figuring out software | `T` |
| 📋 Planning, organising, and project managing | `E` `A` |
| 🎤 Performing — acting, singing, dancing, presenting | `C` `P` |
| 🔍 Researching and synthesising complex information | `A` |

---

## Section 7 — Career Awareness Check

> *This section isn't scored — it helps the app understand how much students already know, and surfaces career blind spots.*

---

**Q21. How many of these careers have you heard of before?**

*Select all you recognise:*

- UX Designer
- Aerospace Engineer
- Penetration Tester (Ethical Hacker)
- Genomic Counselor
- Urban Planner
- Esports Coach
- Climate Change Analyst
- Robotics Engineer
- Forensic Psychologist
- Marine Biologist
- Prompt Engineer
- Sports Physiotherapist

*[Used to: calibrate novelty of career recommendations — if student recognises most, surface more obscure matches]*

---

**Q22. When you think about careers, which of these best describes your current mental model?**

| Option | Action |
|---|---|
| 🔒 I think there are maybe 10–15 real career options | Prioritise discovery mode — show widest range |
| 🤔 I know there are many careers but I can only think of 20–30 | Show deep-domain exploration |
| 🌍 I know there's a huge range and I want to explore all of it | Open full career universe |
| 🎯 I already know the field I want — I just need to find my specific path within it | Switch to pathway-narrowing mode |

---

## Section 8 — Final Signal Questions

> *These two closing questions provide high-signal direction for the recommendation engine.*

---

**Q23. If you had to choose, would you rather:**

| Option | Dimensions Mapped |
|---|---|
| 🔨 Build things (products, systems, tools, structures) | `T` `C` |
| 🔬 Understand things (research, study, analyse, discover) | `A` |
| 🤝 Help people (support, teach, heal, guide) | `S` |
| 🚀 Lead things (start, grow, manage, change) | `E` |
| 🌿 Protect things (environment, rights, health, culture) | `S` `A` |
| 🎭 Express things (create, perform, design, tell stories) | `C` `P` |

---

**Q24. One last one. Read this description and pick the one that most excites you:**

| Option | Top Career Cluster |
|---|---|
| 💻 "You wake up and spend your day building digital systems, training AI models, or solving engineering problems." | Technology, AI, Engineering |
| 🎬 "You spend your day in a studio — directing, designing, writing, or bringing creative ideas to life." | Design, Film, Animation, Music |
| 🧬 "You work in a lab or hospital — researching diseases, developing drugs, or helping patients." | Healthcare, Biotech, Life Sciences |
| 📊 "You sit in a room full of data and your job is to find the patterns nobody else can see." | Data, Finance, Research, Policy |
| 🌍 "You're in the field, in government offices, or in classrooms — working on how society functions." | Law, Policy, Education, Social Impact |
| 🚀 "You're building your own thing — a startup, a platform, a movement, a brand." | Entrepreneurship, Marketing, Business |
| ♻️ "You work outdoors or in research institutions trying to fix the planet." | Environment, Climate, Agriculture |
| 🏟️ "Your work is physical — sport, performance, hands-on craftsmanship." | Sports, Performing Arts, Skilled Trades |

---

## Scoring & Dimension Mapping Logic

### How Scores Are Computed

After all questions are answered, the engine tallies the dimension weights and normalises them into a **score out of 100** for each of the 6 dimensions.

```
Final Score per Dimension = (Sum of all weights mapped to that dimension across all answers) / (Maximum possible weight for that dimension) × 100
```

### Output Profile Example

A student who repeatedly chooses options tagged `C`, `A`, and `T` will generate a profile like:

```json
{
  "student_id": "s_001",
  "profile": {
    "Creative": 82,
    "Analytical": 74,
    "Technical": 68,
    "Social": 41,
    "Entrepreneurial": 35,
    "Physical": 12
  },
  "top_dimensions": ["C", "A", "T"],
  "recommended_career_clusters": [
    "Design & Visual Arts",
    "Gaming & Animation",
    "AI & Data Science",
    "Architecture & Urban Planning",
    "Film, Media & Broadcasting"
  ]
}
```

### Career Matching Rule

The career database is filtered by matching the student's **top 2 dimensions** against career tags. Careers are ranked by:

1. Full tag overlap (all 3 career tags match the top 3 student dimensions) → highest priority
2. Partial overlap (2 of 3 career tags match) → medium priority
3. Single tag overlap with a very high future score (≥8/10) → surfaced as "You might not have considered this"

---

## Onboarding UX Notes

| Note | Detail |
|---|---|
| **Progress indicator** | Show a simple progress bar. Students should always know they're 60% done, not feel like it's endless. |
| **Tone** | Warm, curious, non-judgemental. Phrases like "There's no right answer" and "Go with your gut" should appear. |
| **Skip option** | Allow students to skip any question. Mark skipped questions as neutral — do not penalise. |
| **Retake** | The profiler should be retakeable at any time. Label it: "Redo your profile — interests change and that's normal." |
| **No demographic data upfront** | Do not ask name, gender, location, or school until after the profiler is complete and the student sees value. |
| **Mobile-first** | All questions must work on a 375px screen. Use large tap targets. Avoid multi-column tables in UI render. |
| **Accessibility** | Avoid colour-only signalling. Use icons + text labels for all options. |
| **Section breaks** | Show a brief transitional message between sections. Example: *"Nice — next up, we want to know how you think and solve problems."* |
| **Completion reward** | After Q24, show a brief animated transition: "Building your profile…" before revealing career matches. Creates anticipation. |

---

## Post-Profiler: What the Student Sees Next

After completing all questions, the student is immediately taken to their **Career Map** — a personalised grid of 10–15 careers surfaced from the 300+ database that match their interest profile.

Each career card shows:
- Role name + one-liner description
- Match score (e.g. "87% match to your profile")
- Future relevance score (e.g. ⭐ 9/10)
- Domain tag (e.g. "Design & Visual Arts")

The student can then tap any career to enter the **Career Deep Dive** — the full profile page with salary data, roadmap, real stories, and more.

---

## Appendix — Quick Reference: Questions by Dimension

| Dimension | Primary Questions | Supporting Questions |
|---|---|---|
| Creative `C` | Q1, Q3, Q16, Q18, Q24 | Q2, Q5, Q8, Q17, Q20 |
| Analytical `A` | Q4, Q5, Q6, Q12, Q19 | Q7, Q11, Q13, Q15, Q23 |
| Social `S` | Q10, Q15, Q22, Q23 | Q2, Q4, Q9, Q11, Q12 |
| Technical `T` | Q5, Q7, Q16, Q19 | Q1, Q3, Q6, Q8, Q9 |
| Entrepreneurial `E` | Q11, Q13, Q16, Q18 | Q4, Q9, Q10, Q17 |
| Physical `P` | Q1, Q2, Q9, Q21 | Q10, Q19, Q20, Q24 |

---

*NextStep Onboarding Questionnaire v1.0*  
*Aligned with: NextStep_Product_Document.md v1.0 & NextStep_Careers_Database.md v1.0*  
*For internal use — product design, engineering, and content team*
