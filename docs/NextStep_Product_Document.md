# NextStep — Product Document
### Career Discovery Platform for School & College Students

> **Version:** 1.0 — Ideation Phase  
> **Target Users:** School students (Grade 8–12) and College students (Year 1–2)  
> **Core Mission:** Help every student discover the right career early — based on their interests, not just the careers they already know about.

---

## Table of Contents

1. [Problem Statement](#1-problem-statement)
2. [Vision & Mission](#2-vision--mission)
3. [Target Users](#3-target-users)
4. [Core Insight](#4-core-insight)
5. [User Journey](#5-user-journey)
6. [Features](#6-features)
7. [Career Universe](#7-career-universe)
8. [Personalization Engine](#8-personalization-engine)
9. [Future Relevance System](#9-future-relevance-system)
10. [Roadmap Module](#10-roadmap-module)
11. [Real People Stories](#11-real-people-stories)
12. [Parent & Counsellor View](#12-parent--counsellor-view)
13. [Product Differentiators](#13-product-differentiators)
14. [MVP Scope](#14-mvp-scope)
15. [Questions to Validate](#15-questions-to-validate)
16. [Business Model](#16-business-model)
17. [Tech Stack Considerations](#17-tech-stack-considerations)
18. [Risks & Mitigation](#18-risks--mitigation)

---

## 1. Problem Statement

Most students in India — and globally — grow up knowing only 5 to 6 career options: Engineering, Medicine, Law, Teaching, Banking, and maybe Business. This is not because other careers don't exist. It's because no one showed them.

The consequences are severe:

- Students with a passion for space end up doing Computer Engineering because they didn't know Aerospace Engineering, Astrophysics, or Space Systems Design were accessible paths.
- Students who love games spend years in an accounting degree because "Game Designer" never appeared as an option.
- Students who are naturally empathetic and love helping people default to Medicine without knowing about Psychology, UX Research, Social Work, or Public Health.
- Students pick careers based on what their parents did, what their friends chose, or what sounds impressive — not what actually fits them.

The result: millions of young people in the wrong careers by age 25, with little guidance on how to correct course.

**NextStep exists to fix this.**

---

## 2. Vision & Mission

**Vision**  
A world where every student finds their right career before they're locked into the wrong one.

**Mission**  
To give every school and college student in India a personalized, honest, and complete map of their career possibilities — based on who they actually are.

---

## 3. Target Users

### Primary: School Students (Grade 8–10)
- Age: 13–16 years
- Stage: Still forming interests, no stream selected yet
- Pain point: No awareness of career options beyond the obvious few
- Goal: Broad exploration, low pressure, early awareness
- Behaviour: Short attention spans, mobile-first, respond to visuals and stories

### Secondary: School Students (Grade 11–12)
- Age: 16–18 years
- Stage: Stream selected (Science/Commerce/Arts), preparing for entrance exams
- Pain point: Committed to a stream but unsure of specific career within it
- Goal: Find the best career within (or just outside) their current stream
- Behaviour: Research-oriented, higher urgency, parental pressure is high

### Tertiary: College Students (Year 1–2)
- Age: 18–21 years
- Stage: Already in a degree program, may want to pivot or specialise
- Pain point: Realising the degree they chose may not match their interests
- Goal: Pivot planning, specialisation clarity, internship direction
- Behaviour: Practical, want actionable advice fast, salary-conscious

### Indirect Stakeholder: Parents
- Not the user, but a critical decision-maker in Indian households
- Need: Stability, salary, prestige, and social acceptance of the career
- NextStep must account for parent influence without letting it override student interest

### Indirect Stakeholder: School Counsellors
- Often under-resourced and lack updated career information
- NextStep can become their tool — not a replacement, but an upgrade

---

## 4. Core Insight

The problem is not motivation. Students are motivated. The problem is **visibility**.

Students cannot pursue a career they have never heard of. And even when they hear of it, they cannot evaluate it without:

- Understanding what the work actually looks like day-to-day
- Knowing if the career is viable in India
- Knowing if it will still exist in 10 years
- Having a realistic path from where they are today to that career

NextStep addresses all four of these gaps.

---

## 5. User Journey

The experience is designed to feel like exploration, not examination. Think "choose your own adventure" — not a personality test.

### Step 1 — Spark (Interest Profiling)
The student answers scenario-based questions that feel like conversations, not tests.

Example questions:
- "You have a free Saturday with no obligations. What are you most likely doing?"
- "You're at a school science fair. What project excites you most to work on?"
- "You see a problem in your city — a broken park, traffic chaos, unhygienic food stalls. What do you want to do about it?"
- "A friend is struggling. What's your instinct — fix the problem, understand the feeling, or find who can help?"

The profiler maps responses across six dimensions:
- **Creative** — design, expression, storytelling, aesthetics
- **Analytical** — data, systems, logic, research
- **Social** — people, communication, empathy, leadership
- **Technical** — making, building, engineering, technology
- **Entrepreneurial** — risk-taking, independence, business, scale
- **Physical** — movement, sports, hands-on work, environment

This takes 5–8 minutes. No long forms. No demographic collection upfront.

### Step 2 — Explore (Career Map)
The student sees a personalised map of 10–15 career paths that match their interest profile. These include careers they likely never considered.

For example, a student who shows high Creative + Analytical + Technical scores might see:
- UX Designer
- Game Developer
- Motion Graphics Artist
- Architecture
- Data Visualisation Specialist
- Product Manager
- Urban Planner

Each career is shown as a card with:
- A one-line "what you actually do"
- A relevance score to their interest profile
- Future growth outlook (emoji + one line)
- Salary range (India-specific)

### Step 3 — Validate (Career Deep Dive)
When a student taps a career, they enter the full career profile page:

- What the work looks like on a typical day
- Skills needed (and which ones the student already has)
- Salary range across experience levels
- Future relevance score with reasoning
- Related careers (if they want alternatives)
- Real people stories (professionals who chose this path)
- Path from today: what degree, which skills, what to build

### Step 4 — Plan (Personal Roadmap)
Based on the student's current grade, stream, and target career, the app generates a step-by-step roadmap:

- Which subjects to focus on now
- Skills to learn (with free resources linked)
- Projects or portfolio items to build
- Internships or experiences to target
- First action in the next 30 days

### Step 5 — Track (Progress Over Time)
The app is not a one-time quiz. It grows with the student.

- As they complete roadmap steps, the app tracks progress
- As interests evolve, the profile updates
- Monthly check-ins ask: "Still feeling the same about [career]?"
- The roadmap adjusts accordingly

---

## 6. Features

### 6.1 Interest Profiler

**What it is:** A scenario-based interest discovery engine. Not a quiz. Not an IQ test.

**How it works:**
- 15–20 scenario questions
- Each question maps to one or more of 6 interest dimensions
- Responses build a weighted interest graph
- The graph is used to match against the career database

**Design principles:**
- Questions feel like conversations, not tests
- No right or wrong answers — framed explicitly
- Short sessions (5–8 minutes)
- Can be retaken as interests evolve

**Output:** A multi-dimensional interest profile with scores across Creative, Analytical, Social, Technical, Entrepreneurial, and Physical dimensions.

---

### 6.2 Career Universe

**What it is:** A structured database of 300+ careers across all domains.

**Coverage includes (beyond the obvious):**
- Space & Aerospace: Astrophysicist, Satellite Engineer, Space Policy Analyst, Mission Planner
- Design & Creative: UX Designer, Game Designer, Motion Graphic Artist, Industrial Designer, Fashion Technologist
- Environment & Climate: Climate Scientist, Renewable Energy Engineer, Environmental Lawyer, Sustainability Consultant
- Sports: Sports Analyst, Athletic Coach, Sports Physiotherapist, Sports Journalist, Esports Manager
- Technology (non-coding): Cybersecurity Analyst, AI Ethics Researcher, Product Manager, Data Journalist
- Health (beyond Doctor): Genetic Counsellor, Prosthetist, Public Health Worker, Nutritionist, Hospital Administrator
- Creative Tech: Augmented Reality Developer, Digital Sculptor, Music Technologist, VFX Artist
- Policy & Social: Urban Planner, NGO Program Manager, Policy Researcher, International Relations Analyst
- Law & Finance (non-obvious): Intellectual Property Lawyer, Forensic Accountant, Impact Investor, Actuary

Each career profile contains:
- Role description (plain language, no jargon)
- Typical day summary
- Key skills required
- Salary range (entry, mid, senior — India-specific)
- Educational path (degree, courses, certifications)
- Future relevance score (1–10)
- Growth forecast (% growth by 2035)
- Related careers
- Real people stories (3 per career)
- Free learning resources

---

### 6.3 Future Relevance Score

**What it is:** A data-backed indicator of how viable and growing a career will be by 2030–2035.

**Score components:**
- Automation risk (sourced from McKinsey, Oxford, WEF automation indices)
- India job market growth (NASSCOM, LinkedIn Talent Insights, Naukri data)
- Global demand trend
- Emerging role adjacency (does this career evolve into something new?)

**Display format:**
- A score from 1–10
- A plain-language explanation: "This career is growing because..."
- A "what to watch" note if the role is transforming (not dying)

**Principle:** Honest, not scary. The goal is not to alarm students but to help them choose careers with strong futures — or to understand how to future-proof their choice.

---

### 6.4 Personal Roadmap

**What it is:** A step-by-step, personalised plan from where the student is today to their target career.

**Inputs:**
- Student's current grade and stream
- Their target career (or top 2–3 options)
- Skills they already have (self-reported or inferred from profile)

**Roadmap includes:**
- Immediate actions (next 30 days)
- Subject focus recommendations
- Skills to learn (with free course links from NPTEL, Coursera, YouTube, Khan Academy)
- Projects to build for portfolio
- Internship/volunteer paths
- College/entrance exam targets
- Alternative paths (if Plan A doesn't work)

**Design principle:** Specific enough to act on today. Not generic advice like "work hard and stay curious."

---

### 6.5 Real People Stories

**What it is:** Short profiles (text + optional 60-second video) of real professionals in each career.

**Why it matters:**
- Students can't aspire to what they can't see themselves in
- IIT/IIM success stories feel unreachable to most students
- Stories from people in Tier 2/3 cities make it feel achievable

**Format per story:**
- Name, city, current role
- What they studied (and whether it was the "expected" path)
- One moment that confirmed this was the right career
- One thing they wish they had known at 16
- What they do on a typical Tuesday

**Curation principle:** Diversity in geography, gender, background, and educational institution. Not only toppers and metro city graduates.

---

### 6.6 Career Comparison Tool

**What it is:** Side-by-side comparison of 2–3 careers across key dimensions.

**Comparison dimensions:**
- Salary range
- Skills overlap (how many skills the student already has)
- Future relevance score
- Work style (desk/field/remote/creative/structured)
- Time to first job (from current grade)
- Difficulty of entry path

Useful for students who have narrowed down to 2–3 options and need help making a final decision.

---

### 6.7 Saved & Bookmarked Careers

Students can bookmark careers to return to later. The app tracks:
- Careers explored
- Time spent on each career profile
- Roadmap steps completed

This data improves recommendations over time and gives the student a record of their exploration.

---

### 6.8 Progress Tracker

**What it is:** A simple dashboard showing the student's career exploration and skill-building progress.

**Includes:**
- Interest profile summary
- Top 3 matched careers
- Roadmap completion % for their target career
- Skills built so far
- Next recommended action

---

## 7. Career Universe

### Domain Coverage

| Domain | Example Careers |
|---|---|
| Space & Aerospace | Astrophysicist, Satellite Engineer, Space Policy Analyst, Mission Controller |
| Design & UX | UX Designer, Product Designer, Industrial Designer, Motion Graphics Artist |
| Environment | Climate Scientist, Renewable Energy Engineer, Environmental Lawyer |
| Sports & Fitness | Sports Analyst, Athletic Coach, Sports Physiotherapist, Esports Manager |
| Health (beyond Doctor) | Genetic Counsellor, Public Health Worker, Hospital Administrator, Nutritionist |
| Technology | AI Researcher, Cybersecurity Analyst, Data Journalist, Cloud Architect |
| Creative Tech | Game Developer, AR/VR Developer, VFX Artist, Music Technologist |
| Policy & Social | Urban Planner, Policy Researcher, NGO Program Manager, IAS/IFS |
| Law & Finance | IP Lawyer, Forensic Accountant, Actuary, Impact Investor |
| Education | Instructional Designer, EdTech Product Manager, Child Psychologist |
| Media & Communication | Podcast Producer, Science Communicator, Brand Strategist |
| Agriculture & Food | Food Technologist, Agri-entrepreneur, Food Safety Specialist |

---

## 8. Personalization Engine

### How Personalization Works

NextStep builds a student's profile across three layers:

**Layer 1 — Interest Dimensions (from profiler)**
Scores across: Creative, Analytical, Social, Technical, Entrepreneurial, Physical

**Layer 2 — Context Data (self-reported)**
- Current grade and stream
- City/region
- Academic strengths and weaknesses
- Extracurricular activities

**Layer 3 — Behavioural Data (inferred over time)**
- Which careers they explore most
- Time spent on each profile
- Roadmap steps completed
- Check-in responses over time

### Matching Logic
Each career in the database has weighted interest dimension scores. The matching algorithm:
1. Calculates cosine similarity between student profile and career profiles
2. Applies context filters (stream relevance, geography, educational path feasibility)
3. Ranks and surfaces top 10–15 matches
4. Updates rankings as the student's behavioural data accumulates

### Personalization Gets Sharper Over Time
- Week 1: Based on profiler responses
- Month 1: Refined by which careers the student explores
- Month 3: Adjusted by roadmap activity and check-in answers
- Year 1: Highly personalised based on demonstrated interest and progress

---

## 9. Future Relevance System

### Data Sources
- World Economic Forum Future of Jobs Report
- NASSCOM India Tech Talent Report
- LinkedIn Economic Graph data
- McKinsey Global Institute automation risk indices
- Oxford Future of Employment study
- Ministry of Labour & Employment (India) job growth data

### Score Calculation

Each career receives a composite score (1–10) based on:

| Factor | Weight |
|---|---|
| India job market growth (3-year trend) | 30% |
| Global demand growth forecast (to 2035) | 25% |
| Automation risk (inverted) | 25% |
| Emerging adjacency (new roles this career evolves into) | 20% |

### Score Interpretation

| Score | Label | Meaning |
|---|---|---|
| 8–10 | High growth | Strong demand, low automation risk, expanding globally |
| 6–7 | Stable & evolving | Solid career, some transformation expected |
| 4–5 | Transitioning | Role is changing significantly — here's how to future-proof it |
| 1–3 | High automation risk | Honest flag — but with adjacent career suggestions |

**Design principle:** No score without an explanation. Students always see the reasoning, not just a number.

---

## 10. Roadmap Module

### Roadmap Structure

Each personalized roadmap has four time horizons:

**Immediate (0–3 months)**
- Specific subjects to focus on
- One skill to start learning (with a free resource)
- One project idea to start

**Short-term (3–12 months)**
- Courses or certifications to complete
- Competitions, clubs, or volunteering to join
- Portfolio item to build

**Medium-term (1–3 years)**
- Degree/college targets
- Internship path
- Professional community to join

**Long-term (3–5 years)**
- Entry-level job targets
- Skills to have by graduation
- Alternative paths if primary plan changes

### Roadmap Resources
All learning resources linked are free or low-cost, prioritising:
- NPTEL (IIT courses, free)
- Khan Academy
- Coursera (audit mode)
- YouTube channels (curated per career)
- Government schemes (PMKVY, Skill India, etc.)

---

## 11. Real People Stories

### Content Format

Each story follows a consistent structure:

```
Name: [First name only, or full name if consented]
City: [Tier 1/2/3 city]
Role: [Current job title]
Studied: [Degree, college]

"In one sentence, what do you do?"

"What did you want to be at age 16?"

"What changed?"

"What does a typical Tuesday look like?"

"What do you wish someone had told you at 16?"
```

### Sourcing Strategy
- Partnerships with LinkedIn India
- Outreach through college alumni networks
- Partnerships with professional communities (NASSCOM, CII, etc.)
- User-generated stories (vetted) as the platform scales

### Diversity Targets
- 50% women across all career stories
- 40% from Tier 2/3 cities
- 30% from non-conventional educational paths (diploma, self-taught, career switchers)
- Representation across Hindi belt, South India, Northeast, and other regions

---

## 12. Parent & Counsellor View

### Parent View (Shared with Permission)
Students can share their NextStep profile with parents. The parent view:
- Shows top 3 matched careers
- Emphasises salary range and future growth (in parent-friendly language)
- Shows the roadmap: "Here's exactly what your child needs to do to reach this career"
- Includes a "talk to a counsellor" CTA for families who want human guidance

**Design principle:** Bridge the gap between student interest and parent concern without dismissing either.

### Counsellor Dashboard
School counsellors who register can:
- View anonymised class-level career interest data
- See which careers are most popular among their students
- Use NextStep career profiles in their sessions
- Export student roadmaps (with student consent) for parent-teacher meetings

---

## 13. Product Differentiators

### What Makes NextStep Different

| Dimension | Other Career Apps | NextStep |
|---|---|---|
| Career coverage | 20–30 standard careers | 300+ including uncommon careers |
| Context | Global / US-centric | India-first data and pathways |
| Format | Quiz / aptitude test | Scenario-based interest exploration |
| Future signal | None | Future relevance score with reasoning |
| Real people | None or aspirational | Relatable professionals from Tier 2/3 cities |
| Roadmap | Generic advice | Specific, actionable, resource-linked |
| Personalization | One-time result | Evolves over months as interests develop |
| Parent bridge | Ignored | Dedicated parent-friendly view |

### Core Moat
The real moat is data. Over time, NextStep will know:
- How students' interests evolve over their school years
- Which interest profiles lead to which career satisfaction outcomes
- Which roadmap steps actually correlate with career entry success

This longitudinal data becomes extremely valuable and nearly impossible for a new entrant to replicate.

---

## 14. MVP Scope

### What to Build First (First 2 Months)

**Must Have (MVP)**
- Interest profiler (15 questions, 6 dimensions)
- Career database (50 careers to start, structured profiles)
- Career match display (top 10 matched careers with cards)
- Career detail page (role description, salary, skills, future score)
- Basic roadmap (static, per career, for 3 grade levels)

**Nice to Have (V1.1)**
- Real people stories (10 careers to start)
- Career comparison tool
- Progress tracker
- Parent share feature

**Later (V2)**
- Full 300+ career database
- Dynamic roadmaps (personalised to student grade/stream)
- Counsellor dashboard
- Check-in system and evolving profiles

### MVP Success Metrics
- 1,000 students complete the interest profiler
- 40% of users explore 3 or more career profiles
- 20% of users return within 7 days
- NPS score above 40
- At least 5 "I didn't know this career existed" moments documented per week (qualitative)

---

## 15. Questions to Validate

These are the critical assumptions NextStep is making that must be tested early:

**Assumption 1:** Students are surprised and engaged by the career recommendations they see.
*Test: Does the profiler surface at least 2 careers the student had never considered?*

**Assumption 2:** Students trust the future relevance score.
*Test: Do students find the score credible and useful in their decision-making?*

**Assumption 3:** The roadmap is specific enough to act on.
*Test: Can a student identify a clear first action within 5 minutes of reading their roadmap?*

**Assumption 4:** Parents are a supportive stakeholder, not a blocker.
*Test: Do students share their NextStep profile with parents? What is the parent response?*

**Assumption 5:** The interest profiler questions are engaging, not test-like.
*Test: What is the drop-off rate during the profiler? Target: below 20%.*

**Assumption 6:** India-specific salary and job market data increases trust.
*Test: Do students rate India-specific data as more useful than generic global data?*

---

## 16. Business Model

### Revenue Streams

**B2C — Freemium**
- Free: Interest profiler, career exploration, top 5 career matches, basic roadmap
- Premium (₹299/month or ₹1,499/year): Full career matches, detailed roadmaps, real people stories, career comparison, progress tracker, parent share

**B2B — School Partnerships**
- Schools pay per student (₹150–300/student/year)
- Includes counsellor dashboard, class-level reports, integration with school career counselling
- Target: Private schools and coaching institutes first

**B2B2C — Coaching Institutes**
- JEE/NEET/CLAT coaching centres integrate NextStep for students who are deciding streams
- White-label version possible

**B2B — College Placement Cells**
- Colleges pay for NextStep to help students in Year 1–2 find direction and begin early career development

### Pricing Philosophy
- Individual student access should be affordable (below ₹500/month)
- School partnerships create sustainable B2B revenue
- Free tier must be genuinely useful (not crippled) to build word-of-mouth

---

## 17. Tech Stack Considerations

### Recommended Stack

**Mobile App (primary surface):**
- React Native (single codebase for Android + iOS)
- Android-first given Indian student demographics

**Backend:**
- Node.js + Express or Python + FastAPI
- PostgreSQL for user profiles, career database
- Redis for session management and caching

**AI / Personalization:**
- Interest-to-career matching: Cosine similarity on interest vectors (can start rule-based, move to ML)
- Future relevance scoring: Weighted formula with external data ingestion pipeline
- Roadmap generation: Template-based initially, AI-generated as data accumulates

**Content Management:**
- Headless CMS (Contentful or Strapi) for career profiles and stories
- Enables non-technical team to update career data without engineering

**Analytics:**
- Mixpanel or PostHog for product analytics
- Track: profiler completion rate, career page depth, return rate, roadmap engagement

### Data Privacy
- Minimum data collection — only what is needed for personalisation
- Parental consent required for users under 16
- No selling of student data, ever
- Compliance with India's Digital Personal Data Protection Act (DPDP Act 2023)

---

## 18. Risks & Mitigation

| Risk | Impact | Mitigation |
|---|---|---|
| Interest profiler gives inaccurate matches | High — destroys trust | Extensive user testing before launch; allow profile retakes |
| Career database becomes outdated | Medium — erodes credibility | Quarterly data refresh process; community flagging of outdated info |
| Future relevance scores feel arbitrary | High — students dismiss them | Always show reasoning behind score; cite sources |
| Parents reject recommendations | High — kills adoption | Parent-friendly view; include salary and stability data prominently |
| Low retention after first visit | High — product fails | Build in re-engagement: roadmap milestones, monthly check-ins, progress notifications |
| Competition from large edtech players | Medium — market risk | Focus on depth of career discovery (not test prep); moat is the data and India-specific content |
| Student data privacy concerns | High — legal and trust risk | Privacy-first architecture from day one; clear consent flows; DPDP compliance |

---

## Appendix A — Example Career Profile

### Career: UX Designer

**What you actually do:**  
You design how apps, websites, and digital products feel to use. You talk to users to understand their problems, create wireframes and prototypes, and work with engineers and product managers to bring your designs to life.

**Typical Tuesday:**  
Morning: Review feedback from user interviews conducted last week. Afternoon: Sketch wireframes for a new onboarding flow. Evening: Review with the engineering team and adjust based on technical constraints.

**Skills needed:**  
- Empathy and user research
- Visual design basics
- Wireframing tools (Figma)
- Communication and storytelling
- Analytical thinking

**Salary range (India):**  
- Entry level: ₹4–8 LPA
- Mid level (3–5 years): ₹12–22 LPA
- Senior level: ₹25–45 LPA

**Future relevance score: 8/10**  
Demand for UX designers in India is growing 35% year-on-year driven by the rapid expansion of digital products. AI tools will automate some visual tasks but the core of understanding human behaviour — empathy, research, insight — cannot be automated.

**Educational path:**  
- Any degree works (Design, Engineering, Psychology, or Arts are common entry points)
- Build a portfolio of 3–5 projects
- Key certifications: Google UX Design Certificate (Coursera), Interaction Design Foundation

**Real person:**  
*Shreya, 27, Pune — UX Designer at a fintech startup*  
"I studied Commerce. Everyone told me to do CA. Then I discovered UX through a random YouTube video. I did one free course, built two personal projects, and got my first job at 22. No design degree. The only thing that mattered was my portfolio."

---

## Appendix B — Sample Interest Profiler Questions

**Q1.** It's a free Saturday. No obligations. What are you most likely doing?
- Building or making something with your hands
- Reading, writing, or creating something
- Watching a documentary or researching something that interests you
- Spending time with friends or helping someone out
- Planning something or organising a project
- Being outdoors, playing sport, or doing something physical

**Q2.** Your school is organising a science fair. Which project excites you most?
- Designing a better school bag ergonomically
- Creating an app that solves a local problem
- Writing a report on climate change with real data
- Interviewing local residents about air quality and presenting findings
- Building a working model of a renewable energy source
- Organising the entire fair's schedule and logistics

**Q3.** You read about a city problem: heavy traffic near a school makes it dangerous for kids. What's your instinct?
- Design a better road layout or signage
- Build an app that alerts parents about peak danger times
- Research how other cities solved the same problem
- Talk to parents and students to understand exactly how it affects them
- Start a petition and get local media attention
- Figure out the cost of different solutions and which is most feasible

**Q4.** Which of these feels most like "a great day at work" to you?
- You solved a hard technical problem no one else could crack
- You created something beautiful that people reacted to emotionally
- You helped someone work through a difficult situation
- You organised chaos into a clear, working system
- You convinced people to support your idea
- You discovered something new that no one had studied before

---

*Document version 1.0 — NextStep Ideation Phase*  
*Created for internal product planning and stakeholder communication*
