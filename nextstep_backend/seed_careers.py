"""
seed_careers.py
───────────────
Seeds career_domains + careers tables into AWS RDS PostgreSQL.

Usage:
    pip install psycopg2-binary python-slugify
    export DB_URL="postgresql://user:pass@your-rds-endpoint:5432/nextstep"
    python seed_careers.py
"""

import os
import re
import uuid
import psycopg2
from psycopg2.extras import execute_values
from slugify import slugify

def load_env():
    env_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env")
    if os.path.exists(env_path):
        with open(env_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                if "=" in line:
                    k, v = line.split("=", 1)
                    k = k.strip()
                    v = v.strip()
                    if (v.startswith('"') and v.endswith('"')) or (v.startswith("'") and v.endswith("'")):
                        v = v[1:-1]
                    if k not in os.environ:
                        os.environ[k] = v

load_env()

# Dynamically construct database URL from .env or fallback
DB_URL = os.environ.get("DB_URL")
if not DB_URL:
    db_host = os.environ.get("DB_HOST", "localhost")
    db_port = os.environ.get("DB_PORT", "5432")
    db_name = os.environ.get("DB_NAME", "postgres")
    db_user = os.environ.get("DB_USER", "postgres")
    db_password = os.environ.get("DB_PASSWORD", "password")
    db_sslmode = os.environ.get("DB_SSLMODE", "disable")
    db_sslrootcert = os.environ.get("DB_SSLROOTCERT")
    
    pass_part = f":{db_password}" if db_password else ""
    DB_URL = f"postgresql://{db_user}{pass_part}@{db_host}:{db_port}/{db_name}"
    
    params = []
    if db_sslmode and db_sslmode != "disable":
        params.append(f"sslmode={db_sslmode}")
        if db_sslrootcert:
            cert_path = db_sslrootcert
            if not os.path.isabs(cert_path):
                cert_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), cert_path)
            params.append(f"sslrootcert={cert_path}")
    if params:
        DB_URL += "?" + "&".join(params)

# ──────────────────────────────────────────────────────────────────────────────
# 1. Domain seed data  (25 domains from the database doc)
# ──────────────────────────────────────────────────────────────────────────────
DOMAINS = [
    # (slug, name, short_name, india_relevance, growth_forecast_2035, entry_path_summary, display_order)
    ("technology-software",     "Technology & Software Engineering",      "Technology",       "very_high", "strong",      "B.Tech / BCA / Self-taught / Bootcamps",                    1),
    ("ai-data-science",         "Artificial Intelligence & Data Science", "AI & Data",        "very_high", "very_strong", "B.Tech / M.Tech / Data Science Certifications / MOOCs",     2),
    ("cybersecurity",           "Cybersecurity & Information Security",   "Cybersecurity",    "high",      "strong",      "B.Tech / CEH / CISSP / CompTIA Certifications",             3),
    ("design-visual-arts",      "Design & Visual Arts",                   "Design",           "high",      "strong",      "NID / Design Diplomas / Self-taught / Figma / Adobe",       4),
    ("architecture-urban",      "Architecture, Interior Design & Urban",  "Architecture",     "high",      "moderate",    "B.Arch / Interior Design Diploma / M.Plan",                 5),
    ("healthcare-medicine",     "Healthcare & Medicine",                  "Healthcare",       "very_high", "very_strong", "MBBS / BAMS / Nursing / Allied Health Diplomas",            6),
    ("allied-health-nursing",   "Allied Health, Nursing & Therapy",       "Allied Health",    "high",      "strong",      "B.Sc Nursing / Allied Health Diplomas / BPT",              7),
    ("mental-health",           "Mental Health & Psychology",             "Mental Health",    "high",      "very_strong", "BA/MA Psychology / M.Phil Clinical Psychology / RCI",      8),
    ("biotech-pharma",          "Biotechnology, Pharma & Life Sciences",  "Biotech",          "very_high", "very_strong", "B.Sc / M.Sc Biotech / Pharma / Genetics / Bioinformatics", 9),
    ("space-aerospace",         "Space & Aerospace",                      "Space",            "high",      "strong",      "B.Tech Aerospace / Physics / ISRO internships",            10),
    ("engineering-mech-elec",   "Engineering (Mechanical, Electrical, Robotics)", "Engineering", "very_high", "strong",  "B.Tech (Mech/EE/Robotics)",                               11),
    ("civil-environmental",     "Civil & Environmental Engineering",      "Civil Engg",       "very_high", "moderate",    "B.Tech Civil / Environmental Science",                     12),
    ("climate-clean-energy",    "Climate Change & Clean Energy",          "Climate & Energy", "high",      "very_strong", "B.Tech Energy / Environmental Science / Renewable PG",     13),
    ("film-media",              "Film, Media & Broadcasting",             "Film & Media",     "very_high", "strong",      "FTII / Symbiosis / Self-taught / Portfolio",               14),
    ("gaming-animation",        "Gaming & Animation",                     "Gaming",           "high",      "very_strong", "Game Design programs / Self-taught / Arena Multimedia",    15),
    ("music-performing-arts",   "Music & Performing Arts",                "Music & Arts",     "high",      "moderate",    "Music colleges / Self-taught / Online platforms",          16),
    ("content-journalism",      "Content Creation & Journalism",          "Content & Media",  "very_high", "strong",      "BA Mass Comm / Journalism / Self-built online presence",   17),
    ("law-legal",               "Law & Legal Services",                   "Law",              "very_high", "strong",      "5-year BA LLB / 3-year LLB after graduation",              18),
    ("business-finance",        "Business, Finance & Entrepreneurship",   "Business",         "very_high", "strong",      "BBA / MBA / CA / CFA",                                     19),
    ("public-policy",           "Public Policy & Civil Services",         "Public Policy",    "very_high", "moderate",    "UPSC / State PCS / Political Science / Public Admin",      20),
    ("education-edtech",        "Education & EdTech",                     "Education",        "very_high", "strong",      "B.Ed / MA Education / EdTech product roles",              21),
    ("sports-fitness",          "Sports, Fitness & Esports",              "Sports",           "high",      "strong",      "Sports Science / Coaching degrees / Performance academies", 22),
    ("agriculture-food",        "Agriculture, Food & Environment",        "Agriculture",      "very_high", "strong",      "B.Sc Agriculture / Food Technology / AgTech programs",    23),
    ("emerging-future",         "Emerging & Future Careers (2030–2035)",  "Future Careers",   "high",      "very_strong", "Interdisciplinary / Research / Emerging programs",         24),
    ("skilled-trades",          "Skilled Trades & Vocational",            "Skilled Trades",   "very_high", "strong",      "ITI / Polytechnic / Vocational Diplomas",                  25),
]

# ──────────────────────────────────────────────────────────────────────────────
# 2. Career seed data  (all 305 careers, mapped to domain slugs)
# ──────────────────────────────────────────────────────────────────────────────
# fmt: (name, domain_slug, tags[], india_viability, future_score, is_emerging)
CAREERS_RAW = [
    # ── Technology & Software Engineering ─────────────────────────────────────
    ("Software Engineer",                  "technology-software",   ["T","A"],       "very_high", 9,  False),
    ("Frontend Developer",                 "technology-software",   ["T","C"],       "very_high", 8,  False),
    ("Backend Developer",                  "technology-software",   ["T","A"],       "very_high", 9,  False),
    ("Full Stack Developer",               "technology-software",   ["T","A"],       "very_high", 9,  False),
    ("Mobile App Developer",               "technology-software",   ["T","C"],       "very_high", 8,  False),
    ("DevOps Engineer",                    "technology-software",   ["T","A"],       "high",      9,  False),
    ("Cloud Engineer",                     "technology-software",   ["T","A"],       "high",      9,  False),
    ("Cloud Solutions Architect",          "technology-software",   ["T","A","E"],   "high",      9,  False),
    ("Embedded Systems Engineer",          "technology-software",   ["T","A"],       "high",      8,  False),
    ("Systems Programmer",                 "technology-software",   ["T","A"],       "high",      7,  False),
    ("Database Administrator",             "technology-software",   ["T","A"],       "high",      7,  False),
    ("QA / Automation Tester",             "technology-software",   ["T","A"],       "high",      7,  False),
    ("Technical Product Manager",          "technology-software",   ["T","E","S"],   "very_high", 9,  False),
    ("Site Reliability Engineer",          "technology-software",   ["T","A"],       "high",      8,  False),
    ("Network Engineer",                   "technology-software",   ["T","A"],       "high",      7,  False),
    ("IT Consultant",                      "technology-software",   ["T","E","S"],   "high",      7,  False),
    ("Solutions Architect",                "technology-software",   ["T","A","E"],   "high",      8,  False),
    ("Technical Writer",                   "technology-software",   ["C","T","A"],   "medium",    7,  False),
    ("Developer Relations Engineer",       "technology-software",   ["T","S","C"],   "medium",    7,  False),
    ("Computer Hardware Engineer",         "technology-software",   ["T","A"],       "medium",    7,  False),
    ("Scrum Master / Agile Coach",         "technology-software",   ["S","T","E"],   "high",      7,  False),
    ("Chief Technology Officer",           "technology-software",   ["T","E","S"],   "high",      8,  False),

    # ── AI & Data Science ─────────────────────────────────────────────────────
    ("AI Engineer",                        "ai-data-science",       ["T","A"],       "very_high", 10, False),
    ("Machine Learning Engineer",          "ai-data-science",       ["T","A"],       "very_high", 10, False),
    ("Data Scientist",                     "ai-data-science",       ["A","T"],       "very_high", 9,  False),
    ("Data Analyst",                       "ai-data-science",       ["A","T"],       "very_high", 8,  False),
    ("Data Engineer",                      "ai-data-science",       ["T","A"],       "very_high", 9,  False),
    ("Deep Learning Specialist",           "ai-data-science",       ["T","A"],       "high",      9,  False),
    ("Computer Vision Engineer",           "ai-data-science",       ["T","A"],       "high",      9,  False),
    ("NLP Engineer",                       "ai-data-science",       ["T","A","C"],   "high",      9,  False),
    ("AI Research Scientist",              "ai-data-science",       ["A","T"],       "high",      9,  False),
    ("AI Ethics Officer",                  "ai-data-science",       ["A","S","T"],   "emerging",  8,  True),
    ("Prompt Engineer",                    "ai-data-science",       ["T","C","A"],   "emerging",  7,  True),
    ("MLOps Engineer",                     "ai-data-science",       ["T","A"],       "high",      9,  False),
    ("Business Intelligence Analyst",      "ai-data-science",       ["A","T","E"],   "very_high", 8,  False),
    ("Data Visualisation Specialist",      "ai-data-science",       ["A","C","T"],   "high",      8,  False),
    ("Quantitative Analyst",               "ai-data-science",       ["A","T"],       "high",      8,  False),
    ("Decision Scientist",                 "ai-data-science",       ["A","T","E"],   "emerging",  8,  True),
    ("Conversational UX Designer",         "ai-data-science",       ["C","T","A"],   "emerging",  8,  True),
    ("Chief Data Officer",                 "ai-data-science",       ["A","E","S"],   "high",      8,  False),
    ("AI Product Manager",                 "ai-data-science",       ["T","E","S"],   "high",      9,  False),
    ("RPA Developer",                      "ai-data-science",       ["T","A"],       "high",      8,  False),

    # ── Cybersecurity ─────────────────────────────────────────────────────────
    ("Cybersecurity Engineer",             "cybersecurity",         ["T","A"],       "very_high", 10, False),
    ("Information Security Analyst",       "cybersecurity",         ["T","A"],       "very_high", 9,  False),
    ("Penetration Tester",                 "cybersecurity",         ["T","A"],       "high",      9,  False),
    ("Digital Forensics Examiner",         "cybersecurity",         ["T","A"],       "high",      8,  False),
    ("Cloud Security Engineer",            "cybersecurity",         ["T","A"],       "high",      9,  False),
    ("SOC Analyst",                        "cybersecurity",         ["T","A"],       "high",      8,  False),
    ("Threat Intelligence Analyst",        "cybersecurity",         ["T","A"],       "high",      8,  False),
    ("Cryptographer",                      "cybersecurity",         ["T","A"],       "medium",    8,  False),
    ("Security Architect",                 "cybersecurity",         ["T","A","E"],   "high",      9,  False),
    ("DevSecOps Engineer",                 "cybersecurity",         ["T","A"],       "high",      9,  False),
    ("CISO",                               "cybersecurity",         ["T","E","S"],   "high",      8,  False),
    ("Privacy Engineer",                   "cybersecurity",         ["T","A","S"],   "emerging",  8,  True),
    ("Cybersecurity Consultant",           "cybersecurity",         ["T","E","S"],   "high",      9,  False),

    # ── Design & Visual Arts ──────────────────────────────────────────────────
    ("UX Designer",                        "design-visual-arts",    ["C","A","S"],   "very_high", 9,  False),
    ("UI Designer",                        "design-visual-arts",    ["C","T"],       "very_high", 8,  False),
    ("Product Designer",                   "design-visual-arts",    ["C","T","A"],   "very_high", 9,  False),
    ("Graphic Designer",                   "design-visual-arts",    ["C"],           "very_high", 7,  False),
    ("Brand Designer",                     "design-visual-arts",    ["C","E"],       "high",      7,  False),
    ("Motion Graphics Designer",           "design-visual-arts",    ["C","T"],       "high",      8,  False),
    ("UX Writer",                          "design-visual-arts",    ["C","A","S"],   "emerging",  8,  True),
    ("Illustration / Concept Artist",      "design-visual-arts",    ["C"],           "high",      7,  False),
    ("Infographic Designer",               "design-visual-arts",    ["C","A"],       "high",      7,  False),
    ("Industrial Designer",                "design-visual-arts",    ["C","T"],       "medium",    7,  False),
    ("Fashion Designer",                   "design-visual-arts",    ["C"],           "high",      7,  False),
    ("Packaging Designer",                 "design-visual-arts",    ["C","T"],       "medium",    6,  False),
    ("Design Researcher",                  "design-visual-arts",    ["C","A","S"],   "emerging",  8,  True),
    ("Design Strategist",                  "design-visual-arts",    ["C","A","E"],   "emerging",  8,  True),
    ("Typographer",                        "design-visual-arts",    ["C","T"],       "medium",    6,  False),
    ("Storyboard Artist",                  "design-visual-arts",    ["C","T"],       "high",      7,  False),
    ("Character Designer",                 "design-visual-arts",    ["C","T"],       "high",      8,  False),

    # ── Architecture & Urban Planning ─────────────────────────────────────────
    ("Architect",                          "architecture-urban",    ["C","T","A"],   "very_high", 7,  False),
    ("Landscape Architect",                "architecture-urban",    ["C","T"],       "medium",    7,  False),
    ("Interior Designer",                  "architecture-urban",    ["C","T"],       "high",      7,  False),
    ("Urban Planner",                      "architecture-urban",    ["A","S","T"],   "high",      8,  False),
    ("Sustainable Architecture Specialist","architecture-urban",    ["C","T","A"],   "emerging",  8,  True),
    ("Architectural Visualizer",           "architecture-urban",    ["C","T"],       "high",      7,  False),
    ("BIM Specialist",                     "architecture-urban",    ["T","A"],       "emerging",  8,  True),
    ("Set Designer",                       "architecture-urban",    ["C","T"],       "medium",    6,  False),
    ("Parametric Design Specialist",       "architecture-urban",    ["C","T","A"],   "emerging",  8,  True),

    # ── Healthcare & Medicine ─────────────────────────────────────────────────
    ("General Physician",                  "healthcare-medicine",   ["S","A"],       "very_high", 8,  False),
    ("Cardiologist",                       "healthcare-medicine",   ["S","A","T"],   "very_high", 8,  False),
    ("Neurologist",                        "healthcare-medicine",   ["S","A","T"],   "very_high", 8,  False),
    ("Pediatrician",                       "healthcare-medicine",   ["S","A"],       "very_high", 8,  False),
    ("Dermatologist",                      "healthcare-medicine",   ["S","A"],       "very_high", 8,  False),
    ("Oncologist",                         "healthcare-medicine",   ["S","A","T"],   "very_high", 8,  False),
    ("Orthopedic Surgeon",                 "healthcare-medicine",   ["S","T"],       "very_high", 7,  False),
    ("Anesthesiologist",                   "healthcare-medicine",   ["T","A","S"],   "high",      8,  False),
    ("Emergency Medicine Physician",       "healthcare-medicine",   ["S","T","P"],   "high",      8,  False),
    ("Radiologist",                        "healthcare-medicine",   ["A","T"],       "high",      7,  False),
    ("Psychiatrist",                       "healthcare-medicine",   ["S","A"],       "high",      9,  False),
    ("Palliative Care Physician",          "healthcare-medicine",   ["S","A"],       "high",      8,  False),
    ("Sports Medicine Physician",          "healthcare-medicine",   ["S","P","T"],   "emerging",  8,  True),
    ("Ayurveda Doctor",                    "healthcare-medicine",   ["S","A"],       "high",      7,  False),
    ("Homeopathy Doctor",                  "healthcare-medicine",   ["S","A"],       "medium",    6,  False),
    ("Chief Medical Officer",              "healthcare-medicine",   ["S","E","A"],   "high",      7,  False),

    # ── Allied Health, Nursing & Therapy ─────────────────────────────────────
    ("Registered Nurse",                   "allied-health-nursing", ["S","T"],       "very_high", 8,  False),
    ("Physiotherapist",                    "allied-health-nursing", ["S","P","T"],   "very_high", 8,  False),
    ("Occupational Therapist",             "allied-health-nursing", ["S","T"],       "high",      8,  False),
    ("Speech-Language Pathologist",        "allied-health-nursing", ["S","A"],       "high",      8,  False),
    ("Audiologist",                        "allied-health-nursing", ["S","A","T"],   "high",      7,  False),
    ("Radiologic Technologist",            "allied-health-nursing", ["T","A"],       "high",      7,  False),
    ("Prosthetist / Orthotist",            "allied-health-nursing", ["T","S"],       "medium",    7,  False),
    ("Paramedic / EMT",                    "allied-health-nursing", ["S","P","T"],   "high",      7,  False),
    ("Dentist",                            "allied-health-nursing", ["T","S"],       "very_high", 7,  False),
    ("Medical Laboratory Technician",      "allied-health-nursing", ["T","A"],       "high",      7,  False),
    ("Optometrist",                        "allied-health-nursing", ["S","T","A"],   "high",      7,  False),
    ("Nutritionist / Dietitian",           "allied-health-nursing", ["S","A"],       "high",      8,  False),
    ("Public Health Nurse",                "allied-health-nursing", ["S","A"],       "high",      8,  False),

    # ── Mental Health & Psychology ────────────────────────────────────────────
    ("Clinical Psychologist",              "mental-health",         ["S","A"],       "high",      9,  False),
    ("Counseling Psychologist",            "mental-health",         ["S","A"],       "high",      9,  False),
    ("Child & Adolescent Psychologist",    "mental-health",         ["S","A"],       "high",      9,  False),
    ("School Counselor",                   "mental-health",         ["S","A"],       "high",      8,  False),
    ("Career Counselor",                   "mental-health",         ["S","A","E"],   "high",      8,  False),
    ("Forensic Psychologist",              "mental-health",         ["S","A"],       "emerging",  7,  False),
    ("Organizational Psychologist",        "mental-health",         ["S","A","E"],   "emerging",  8,  True),
    ("Art / Music / Drama Therapist",      "mental-health",         ["C","S"],       "emerging",  7,  False),
    ("Mental Health Counselor",            "mental-health",         ["S","A"],       "high",      9,  False),
    ("Behavior Analyst",                   "mental-health",         ["S","A","T"],   "emerging",  8,  False),
    ("Life Coach / Executive Coach",       "mental-health",         ["S","E"],       "medium",    6,  False),

    # ── Biotech, Pharma & Life Sciences ──────────────────────────────────────
    ("Biomedical Engineer",                "biotech-pharma",        ["T","A"],       "high",      9,  False),
    ("Genetic Engineer",                   "biotech-pharma",        ["T","A"],       "high",      9,  False),
    ("Bioinformatician",                   "biotech-pharma",        ["T","A"],       "high",      9,  False),
    ("Clinical Research Associate",        "biotech-pharma",        ["A","S","T"],   "very_high", 8,  False),
    ("Molecular Biologist",                "biotech-pharma",        ["T","A"],       "high",      8,  False),
    ("Pharmacologist",                     "biotech-pharma",        ["T","A"],       "high",      8,  False),
    ("Regulatory Affairs Specialist",      "biotech-pharma",        ["A","T","E"],   "high",      8,  False),
    ("Medical Science Liaison",            "biotech-pharma",        ["S","A","T"],   "high",      8,  False),
    ("Embryologist",                       "biotech-pharma",        ["T","A"],       "emerging",  8,  False),
    ("Medical Writer",                     "biotech-pharma",        ["C","A"],       "high",      8,  False),
    ("Toxicologist",                       "biotech-pharma",        ["A","T"],       "medium",    7,  False),
    ("Genomic Counselor",                  "biotech-pharma",        ["S","A"],       "emerging",  9,  True),
    ("Computational Biologist",            "biotech-pharma",        ["T","A"],       "high",      9,  False),
    ("Biostatistician",                    "biotech-pharma",        ["A","T"],       "high",      8,  False),

    # ── Space & Aerospace ─────────────────────────────────────────────────────
    ("Aerospace Engineer",                 "space-aerospace",       ["T","A"],       "high",      9,  False),
    ("Aeronautical Engineer",              "space-aerospace",       ["T","A"],       "high",      8,  False),
    ("Satellite Systems Engineer",         "space-aerospace",       ["T","A"],       "high",      9,  False),
    ("Astrophysicist",                     "space-aerospace",       ["A","T"],       "medium",    8,  False),
    ("Space Mission Designer",             "space-aerospace",       ["T","A","C"],   "emerging",  9,  True),
    ("Space Policy Analyst",               "space-aerospace",       ["A","S"],       "emerging",  8,  True),
    ("Astrobiologist",                     "space-aerospace",       ["A","T"],       "emerging",  8,  True),
    ("Space Lawyer",                       "space-aerospace",       ["A","S"],       "emerging",  8,  True),
    ("Rocket Propulsion Engineer",         "space-aerospace",       ["T","A"],       "emerging",  9,  True),
    ("Planetary Scientist",                "space-aerospace",       ["A","T"],       "medium",    8,  False),
    ("Space Weather Forecaster",           "space-aerospace",       ["A","T"],       "emerging",  8,  True),
    ("Commercial Spaceflight Systems Eng", "space-aerospace",       ["T","A"],       "emerging",  9,  True),

    # ── Engineering (Mech / Elec / Robotics) ─────────────────────────────────
    ("Mechanical Engineer",                "engineering-mech-elec", ["T","A"],       "very_high", 7,  False),
    ("Electrical Engineer",                "engineering-mech-elec", ["T","A"],       "very_high", 7,  False),
    ("Robotics Engineer",                  "engineering-mech-elec", ["T","A"],       "high",      9,  False),
    ("Automation Engineer",                "engineering-mech-elec", ["T","A"],       "high",      9,  False),
    ("Mechatronics Engineer",              "engineering-mech-elec", ["T","A"],       "high",      8,  False),
    ("Control Systems Engineer",           "engineering-mech-elec", ["T","A"],       "high",      8,  False),
    ("Semiconductor Engineer",             "engineering-mech-elec", ["T","A"],       "emerging",  9,  True),
    ("Automotive Engineer",                "engineering-mech-elec", ["T","A"],       "high",      7,  False),
    ("Power Systems Engineer",             "engineering-mech-elec", ["T","A"],       "high",      8,  False),
    ("Manufacturing Engineer",             "engineering-mech-elec", ["T","A"],       "high",      7,  False),
    ("Human Factors Engineer",             "engineering-mech-elec", ["T","S","A"],   "emerging",  7,  False),
    ("EV Engineer",                        "engineering-mech-elec", ["T","A"],       "very_high", 9,  True),

    # ── Civil & Environmental Engineering ────────────────────────────────────
    ("Civil Engineer",                     "civil-environmental",   ["T","A"],       "very_high", 7,  False),
    ("Structural Engineer",                "civil-environmental",   ["T","A"],       "very_high", 7,  False),
    ("Transportation Engineer",            "civil-environmental",   ["T","A"],       "high",      7,  False),
    ("Environmental Engineer",             "civil-environmental",   ["T","A","S"],   "high",      8,  False),
    ("Water Resources Engineer",           "civil-environmental",   ["T","A"],       "high",      8,  False),
    ("Construction Manager",               "civil-environmental",   ["T","E","S"],   "very_high", 7,  False),
    ("BIM Coordinator",                    "civil-environmental",   ["T","A"],       "emerging",  8,  True),
    ("Geotechnical Engineer",              "civil-environmental",   ["T","A"],       "high",      7,  False),
    ("Surveyor",                           "civil-environmental",   ["T","A"],       "high",      6,  False),

    # ── Climate Change & Clean Energy ─────────────────────────────────────────
    ("Climate Change Analyst",             "climate-clean-energy",  ["A","T","S"],   "high",      9,  False),
    ("Sustainability Analyst",             "climate-clean-energy",  ["A","S","T"],   "high",      9,  False),
    ("Chief Sustainability Officer",       "climate-clean-energy",  ["E","S","A"],   "emerging",  8,  True),
    ("Renewable Energy Engineer",          "climate-clean-energy",  ["T","A"],       "very_high", 9,  False),
    ("Solar Energy Systems Engineer",      "climate-clean-energy",  ["T","A"],       "very_high", 9,  False),
    ("Wind Energy Engineer",               "climate-clean-energy",  ["T","A"],       "high",      8,  False),
    ("Carbon Accounting Specialist",       "climate-clean-energy",  ["A","T"],       "emerging",  8,  True),
    ("Environmental Lawyer",               "climate-clean-energy",  ["S","A"],       "emerging",  8,  False),
    ("Conservation Biologist",             "climate-clean-energy",  ["A","T","S"],   "medium",    7,  False),
    ("Ecologist",                          "climate-clean-energy",  ["A","T"],       "medium",    7,  False),
    ("EV Charging Infrastructure Planner", "climate-clean-energy",  ["T","A","E"],   "emerging",  9,  True),
    ("Green Building Consultant",          "climate-clean-energy",  ["T","A"],       "emerging",  8,  True),
    ("Energy Auditor",                     "climate-clean-energy",  ["T","A"],       "high",      8,  False),

    # ── Film, Media & Broadcasting ────────────────────────────────────────────
    ("Film Director",                      "film-media",            ["C","S","E"],   "very_high", 7,  False),
    ("Screenwriter",                       "film-media",            ["C","A"],       "very_high", 7,  False),
    ("Cinematographer",                    "film-media",            ["C","T"],       "high",      7,  False),
    ("Film Producer",                      "film-media",            ["E","S","C"],   "very_high", 7,  False),
    ("Film Editor",                        "film-media",            ["C","T","A"],   "very_high", 7,  False),
    ("Sound Designer",                     "film-media",            ["C","T"],       "high",      7,  False),
    ("VFX Supervisor",                     "film-media",            ["C","T","A"],   "very_high", 8,  False),
    ("Colorist",                           "film-media",            ["C","T"],       "high",      7,  False),
    ("Podcast Producer",                   "film-media",            ["C","S","E"],   "high",      8,  False),
    ("Broadcast Journalist",               "film-media",            ["C","S"],       "high",      6,  False),
    ("Documentary Filmmaker",              "film-media",            ["C","A","S"],   "high",      7,  False),

    # ── Gaming & Animation ────────────────────────────────────────────────────
    ("Game Developer",                     "gaming-animation",      ["T","C"],       "high",      9,  False),
    ("Game Designer",                      "gaming-animation",      ["C","T","A"],   "high",      9,  False),
    ("3D Animator",                        "gaming-animation",      ["C","T"],       "very_high", 8,  False),
    ("VFX Artist",                         "gaming-animation",      ["C","T"],       "very_high", 8,  False),
    ("Character Rigger",                   "gaming-animation",      ["C","T"],       "high",      7,  False),
    ("Technical Artist",                   "gaming-animation",      ["T","C"],       "high",      8,  False),
    ("Esports Athlete",                    "gaming-animation",      ["P","T"],       "emerging",  7,  False),
    ("Esports Coach / Analyst",            "gaming-animation",      ["A","S","P"],   "emerging",  7,  True),
    ("Esports Manager",                    "gaming-animation",      ["E","S"],       "emerging",  7,  True),
    ("Game Monetization Manager",          "gaming-animation",      ["E","A","T"],   "emerging",  8,  True),
    ("Motion Capture Performer",           "gaming-animation",      ["P","C"],       "emerging",  7,  False),

    # ── Music & Performing Arts ───────────────────────────────────────────────
    ("Musician / Vocalist",                "music-performing-arts", ["C","P"],       "high",      6,  False),
    ("Music Producer",                     "music-performing-arts", ["C","T"],       "high",      7,  False),
    ("Sound Engineer",                     "music-performing-arts", ["T","C"],       "high",      7,  False),
    ("Choreographer",                      "music-performing-arts", ["C","P","S"],   "high",      6,  False),
    ("Theater Director",                   "music-performing-arts", ["C","S"],       "medium",    6,  False),
    ("Actor / Voice-over Artist",          "music-performing-arts", ["C","S"],       "high",      6,  False),
    ("Film Composer",                      "music-performing-arts", ["C","T"],       "high",      7,  False),
    ("Stage Manager",                      "music-performing-arts", ["S","T","E"],   "medium",    6,  False),

    # ── Content Creation & Journalism ─────────────────────────────────────────
    ("Content Creator",                    "content-journalism",    ["C","E"],       "very_high", 8,  False),
    ("Journalist / Investigative Reporter","content-journalism",    ["S","A","C"],   "very_high", 7,  False),
    ("Social Media Strategist",            "content-journalism",    ["C","E","S"],   "very_high", 8,  False),
    ("Copywriter / Content Writer",        "content-journalism",    ["C","A"],       "very_high", 7,  False),
    ("Science Communicator",               "content-journalism",    ["C","A","S"],   "emerging",  8,  True),
    ("Data Journalist",                    "content-journalism",    ["A","C"],       "emerging",  8,  True),
    ("SEO Specialist",                     "content-journalism",    ["A","T","E"],   "high",      7,  False),
    ("Newsletter Writer",                  "content-journalism",    ["C","E"],       "emerging",  7,  False),
    ("Photo Journalist",                   "content-journalism",    ["C","S"],       "high",      6,  False),
    ("Editor / Managing Editor",           "content-journalism",    ["C","A","S"],   "high",      7,  False),

    # ── Law & Legal Services ─────────────────────────────────────────────────
    ("Corporate Lawyer",                   "law-legal",             ["A","S","E"],   "very_high", 8,  False),
    ("Criminal Defense Lawyer",            "law-legal",             ["S","A"],       "very_high", 7,  False),
    ("Intellectual Property Lawyer",       "law-legal",             ["A","T","S"],   "high",      8,  False),
    ("Environmental Lawyer",               "law-legal",             ["S","A"],       "emerging",  8,  False),
    ("Cyber Lawyer",                       "law-legal",             ["T","A","S"],   "emerging",  9,  True),
    ("Human Rights Lawyer",                "law-legal",             ["S","A"],       "high",      7,  False),
    ("Tax Lawyer",                         "law-legal",             ["A","E"],       "very_high", 7,  False),
    ("Mediator / Arbitrator",              "law-legal",             ["S","A"],       "high",      7,  False),
    ("In-house Legal Counsel",             "law-legal",             ["A","S","E"],   "very_high", 8,  False),
    ("Forensic Accountant",                "law-legal",             ["A","T"],       "high",      7,  False),

    # ── Business, Finance & Entrepreneurship ─────────────────────────────────
    ("Entrepreneur / Startup Founder",     "business-finance",      ["E","S","A"],   "very_high", 9,  False),
    ("Product Manager",                    "business-finance",      ["E","T","S"],   "very_high", 9,  False),
    ("Investment Analyst",                 "business-finance",      ["A","E"],       "high",      8,  False),
    ("Venture Capitalist",                 "business-finance",      ["E","A","S"],   "high",      8,  False),
    ("Financial Planner / Wealth Manager", "business-finance",      ["A","E","S"],   "high",      7,  False),
    ("Actuary",                            "business-finance",      ["A","T"],       "high",      8,  False),
    ("Management Consultant",              "business-finance",      ["A","S","E"],   "very_high", 8,  False),
    ("Chartered Accountant",               "business-finance",      ["A","E"],       "very_high", 7,  False),
    ("Forensic Accountant (Business)",     "business-finance",      ["A","T"],       "high",      7,  False),
    ("Impact Investor",                    "business-finance",      ["E","A","S"],   "emerging",  8,  True),
    ("Marketing Manager",                  "business-finance",      ["E","S","C"],   "very_high", 7,  False),
    ("Growth Marketer",                    "business-finance",      ["A","E","T"],   "very_high", 8,  False),

    # ── Public Policy & Civil Services ────────────────────────────────────────
    ("IAS Officer",                        "public-policy",         ["S","A","E"],   "very_high", 7,  False),
    ("IPS Officer",                        "public-policy",         ["S","P","A"],   "very_high", 7,  False),
    ("IFS Officer",                        "public-policy",         ["S","A"],       "high",      7,  False),
    ("Policy Researcher / Analyst",        "public-policy",         ["A","S"],       "high",      8,  False),
    ("Diplomat / Consular Officer",        "public-policy",         ["S","A"],       "high",      7,  False),
    ("Urban Policy Specialist",            "public-policy",         ["A","S","T"],   "emerging",  8,  False),
    ("Intelligence Analyst",               "public-policy",         ["A","T"],       "high",      7,  False),
    ("Political Strategist",               "public-policy",         ["S","A","E"],   "medium",    6,  False),
    ("NGO Program Manager",                "public-policy",         ["S","E","A"],   "high",      7,  False),
    ("Social Worker",                      "public-policy",         ["S","A"],       "high",      7,  False),
    ("Child Protection Specialist",        "public-policy",         ["S","A"],       "high",      7,  False),

    # ── Education & EdTech ────────────────────────────────────────────────────
    ("School Teacher",                     "education-edtech",      ["S","C","A"],   "very_high", 7,  False),
    ("University Professor",               "education-edtech",      ["A","C","S"],   "very_high", 7,  False),
    ("EdTech Product Manager",             "education-edtech",      ["T","E","S"],   "very_high", 9,  False),
    ("Instructional Designer",             "education-edtech",      ["C","A","T"],   "high",      8,  False),
    ("Curriculum Developer",               "education-edtech",      ["C","A","S"],   "high",      8,  False),
    ("Educational Consultant",             "education-edtech",      ["S","A","E"],   "high",      7,  False),
    ("School Counselor (Ed)",              "education-edtech",      ["S","A"],       "high",      8,  False),
    ("Child Psychologist (Ed)",            "education-edtech",      ["S","A"],       "high",      9,  False),
    ("Special Education Teacher",          "education-edtech",      ["S","T","A"],   "high",      8,  False),
    ("Online Tutor / Education Creator",   "education-edtech",      ["C","S","E"],   "very_high", 8,  False),

    # ── Sports, Fitness & Esports ─────────────────────────────────────────────
    ("Professional Athlete",               "sports-fitness",        ["P"],           "high",      7,  False),
    ("Sports Coach",                       "sports-fitness",        ["S","P","A"],   "high",      7,  False),
    ("Sports Physiotherapist",             "sports-fitness",        ["S","P","T"],   "high",      8,  False),
    ("Sports Analyst / Statistician",      "sports-fitness",        ["A","T","P"],   "emerging",  8,  True),
    ("Athletic Trainer / Strength Coach",  "sports-fitness",        ["P","S","T"],   "high",      8,  False),
    ("Sports Journalist / Commentator",    "sports-fitness",        ["C","S","P"],   "high",      7,  False),
    ("Sports Manager / Agent",             "sports-fitness",        ["E","S"],       "emerging",  7,  False),
    ("Personal Fitness Trainer",           "sports-fitness",        ["P","S"],       "very_high", 7,  False),
    ("Yoga Teacher / Wellness Coach",      "sports-fitness",        ["P","S"],       "high",      7,  False),
    ("Esports Athlete / Coach",            "sports-fitness",        ["P","T","A"],   "emerging",  7,  True),

    # ── Agriculture, Food & Environment ──────────────────────────────────────
    ("Agronomist",                         "agriculture-food",      ["T","A"],       "very_high", 8,  False),
    ("Agricultural Engineer",              "agriculture-food",      ["T","A"],       "high",      8,  False),
    ("Food Scientist / Technologist",      "agriculture-food",      ["T","A"],       "high",      8,  False),
    ("Precision Agriculture Specialist",   "agriculture-food",      ["T","A"],       "emerging",  9,  True),
    ("AgTech Developer",                   "agriculture-food",      ["T","A","E"],   "emerging",  9,  True),
    ("Veterinarian",                       "agriculture-food",      ["S","T","A"],   "very_high", 7,  False),
    ("Soil Scientist",                     "agriculture-food",      ["T","A"],       "high",      7,  False),
    ("Nutritionist (Agri)",                "agriculture-food",      ["S","A"],       "high",      8,  False),
    ("Food Safety Inspector",              "agriculture-food",      ["T","A","S"],   "high",      7,  False),
    ("Horticulturist",                     "agriculture-food",      ["T","P"],       "high",      7,  False),
    ("Marine Biologist",                   "agriculture-food",      ["A","T","P"],   "medium",    7,  False),

    # ── Emerging / Future Careers ─────────────────────────────────────────────
    ("AI Ethics Researcher",               "emerging-future",       ["A","S","T"],   "emerging",  9,  True),
    ("Brain-Computer Interface Designer",  "emerging-future",       ["T","A","C"],   "emerging",  9,  True),
    ("Synthetic Biology Engineer",         "emerging-future",       ["T","A"],       "emerging",  9,  True),
    ("Metaverse Architect / Designer",     "emerging-future",       ["C","T"],       "emerging",  8,  True),
    ("Deepfake Forensic Analyst",          "emerging-future",       ["T","A"],       "emerging",  8,  True),
    ("Autonomous Vehicle Engineer",        "emerging-future",       ["T","A"],       "emerging",  9,  True),
    ("Digital Currency / FinTech Strategist","emerging-future",     ["E","A","T"],   "emerging",  8,  True),
    ("Climate Engineer",                   "emerging-future",       ["T","A","S"],   "emerging",  9,  True),
    ("Human-Robot Interaction Designer",   "emerging-future",       ["C","T","S"],   "emerging",  9,  True),
    ("Bioprinted Organ Quality Specialist","emerging-future",       ["T","A"],       "emerging",  9,  True),
    ("Space Habitat Designer",             "emerging-future",       ["C","T","A"],   "emerging",  8,  True),
    ("Carbon Offset Verifier",             "emerging-future",       ["A","T","S"],   "emerging",  8,  True),
    ("Algorithmic Bias Auditor",           "emerging-future",       ["A","S","T"],   "emerging",  9,  True),
    ("Personalized Microbiome Dietician",  "emerging-future",       ["A","S","T"],   "emerging",  8,  True),
    ("Quantum Computing Engineer",         "emerging-future",       ["T","A"],       "emerging",  10, True),

    # ── Skilled Trades & Vocational ───────────────────────────────────────────
    ("Electrician",                        "skilled-trades",        ["T","P"],       "very_high", 7,  False),
    ("Plumber / Pipefitter",               "skilled-trades",        ["T","P"],       "very_high", 6,  False),
    ("CNC Machine Operator",               "skilled-trades",        ["T","P"],       "high",      7,  False),
    ("Automotive Mechanic / EV Technician","skilled-trades",        ["T","P"],       "very_high", 8,  False),
    ("HVAC Technician",                    "skilled-trades",        ["T","P"],       "high",      7,  False),
    ("Welder",                             "skilled-trades",        ["T","P"],       "high",      6,  False),
    ("Aircraft Mechanic / Avionics Tech",  "skilled-trades",        ["T","P","A"],   "high",      7,  False),
    ("3D Printing Technician",             "skilled-trades",        ["T","P"],       "emerging",  8,  True),
    ("Medical Equipment Calibration Tech", "skilled-trades",        ["T","A"],       "high",      7,  False),
    ("Industrial Robot Maintenance Tech",  "skilled-trades",        ["T","P","A"],   "emerging",  8,  True),
]


# ──────────────────────────────────────────────────────────────────────────────
# 3. One-liner map  (brief description for every career)
# ──────────────────────────────────────────────────────────────────────────────
ONE_LINERS = {
    "Software Engineer":                  "You build the apps and systems people use every day through code.",
    "Frontend Developer":                 "You craft the visual, interactive side of websites and apps users see.",
    "Backend Developer":                  "You power the server logic and databases that make apps work behind the scenes.",
    "Full Stack Developer":               "You work across both frontend and backend to ship complete web products.",
    "Mobile App Developer":               "You build apps for Android and iOS phones and tablets.",
    "DevOps Engineer":                    "You bridge development and operations to ship software faster and more reliably.",
    "Cloud Engineer":                     "You design and manage computing infrastructure on platforms like AWS and Azure.",
    "Cloud Solutions Architect":          "You design large-scale cloud systems that are secure, scalable, and cost-effective.",
    "Embedded Systems Engineer":          "You program the tiny computers inside hardware like medical devices and cars.",
    "Systems Programmer":                 "You write low-level software that talks directly to hardware and operating systems.",
    "Database Administrator":             "You keep databases fast, secure, and always available for applications.",
    "QA / Automation Tester":             "You find bugs and build automated tests so software ships without breaking.",
    "Technical Product Manager":          "You guide tech products from idea to launch by bridging business and engineering.",
    "Site Reliability Engineer":          "You keep large-scale systems running reliably and recover them when they fail.",
    "Network Engineer":                   "You design and maintain the networks that connect computers and devices.",
    "IT Consultant":                      "You advise businesses on how to use technology to solve their problems.",
    "Solutions Architect":                "You design end-to-end technical solutions that meet a client's business goals.",
    "Technical Writer":                   "You make complex technology easy to understand through clear documentation.",
    "Developer Relations Engineer":       "You help developers succeed with a product by building community and resources.",
    "Computer Hardware Engineer":         "You design the physical chips and circuits that power computers.",
    "Scrum Master / Agile Coach":         "You help teams work efficiently using agile frameworks like Scrum.",
    "Chief Technology Officer":           "You set a company's entire technology vision and lead its engineering teams.",
    "AI Engineer":                        "You build AI-powered systems and integrate machine learning into products.",
    "Machine Learning Engineer":          "You design and deploy models that learn patterns from data to make predictions.",
    "Data Scientist":                     "You analyse large datasets to uncover insights that drive business decisions.",
    "Data Analyst":                       "You clean and interpret data to answer specific business questions.",
    "Data Engineer":                      "You build the pipelines and infrastructure that move and store data reliably.",
    "Deep Learning Specialist":           "You build neural networks that mimic the brain to solve complex AI problems.",
    "Computer Vision Engineer":           "You teach machines to interpret and understand images and video.",
    "NLP Engineer":                       "You build systems that understand, generate, and translate human language.",
    "AI Research Scientist":              "You conduct original research to advance the frontiers of artificial intelligence.",
    "AI Ethics Officer":                  "You ensure AI systems are fair, transparent, and safe for everyone.",
    "Prompt Engineer":                    "You design the instructions that guide AI language models to produce useful outputs.",
    "MLOps Engineer":                     "You automate the deployment and monitoring of machine learning models at scale.",
    "Business Intelligence Analyst":      "You turn raw business data into dashboards and reports that drive decisions.",
    "Data Visualisation Specialist":      "You design charts and interactive visuals that make data easy to understand.",
    "Quantitative Analyst":               "You use maths and statistics to build models for financial markets.",
    "Decision Scientist":                 "You apply AI and behavioural science to help organisations make better choices.",
    "Conversational UX Designer":         "You design how people interact with AI assistants and chatbots.",
    "Chief Data Officer":                 "You lead an organisation's entire data strategy and governance.",
    "AI Product Manager":                 "You define the vision and roadmap for AI-powered products.",
    "RPA Developer":                      "You build software robots that automate repetitive business tasks.",
    "Cybersecurity Engineer":             "You build systems and defences that protect organisations from digital attacks.",
    "Information Security Analyst":       "You monitor networks and systems to detect and respond to security threats.",
    "Penetration Tester":                 "You legally hack into systems to find vulnerabilities before attackers do.",
    "Digital Forensics Examiner":         "You investigate cybercrimes by recovering and analysing digital evidence.",
    "Cloud Security Engineer":            "You secure cloud infrastructure so data and services stay protected.",
    "SOC Analyst":                        "You monitor security alerts 24/7 and respond to threats in real time.",
    "Threat Intelligence Analyst":        "You study hacker tactics and predict cyber threats before they strike.",
    "Cryptographer":                      "You design the mathematical techniques that keep digital communication secure.",
    "Security Architect":                 "You design an organisation's entire security infrastructure and strategy.",
    "DevSecOps Engineer":                 "You embed security practices into every stage of software development.",
    "CISO":                               "You lead an organisation's entire information security strategy and team.",
    "Privacy Engineer":                   "You build systems that protect user data and comply with privacy laws.",
    "Cybersecurity Consultant":           "You advise businesses on how to protect themselves from digital threats.",
    "UX Designer":                        "You design how apps and websites feel to use, making them intuitive and enjoyable.",
    "UI Designer":                        "You craft the visual elements — buttons, colours, layouts — users interact with.",
    "Product Designer":                   "You own the end-to-end design of a digital product, from research to launch.",
    "Graphic Designer":                   "You create visual content — logos, posters, layouts — that communicate ideas.",
    "Brand Designer":                     "You build the visual identity that makes a company recognisable and memorable.",
    "Motion Graphics Designer":           "You create animated visuals for ads, films, and digital content.",
    "UX Writer":                          "You write the words inside apps and websites that guide users to their goals.",
    "Illustration / Concept Artist":      "You create hand-drawn or digital art for books, games, films, and brands.",
    "Infographic Designer":               "You turn complex information into clear, visual stories people can grasp instantly.",
    "Industrial Designer":                "You design the look and feel of physical products like furniture and gadgets.",
    "Fashion Designer":                   "You create clothing and accessories that shape how people express themselves.",
    "Packaging Designer":                 "You design the box or wrapper that makes a product stand out on the shelf.",
    "Design Researcher":                  "You study how people behave to help designers create products that truly fit their needs.",
    "Design Strategist":                  "You use design thinking to solve complex business and social challenges.",
    "Typographer":                        "You choose and arrange fonts to make text both beautiful and easy to read.",
    "Storyboard Artist":                  "You draw frame-by-frame plans for films, ads, and animations before shooting begins.",
    "Character Designer":                 "You create the look, personality, and visual style of characters for games and films.",
    "Architect":                          "You design buildings that are safe, beautiful, and built to last.",
    "Landscape Architect":                "You design outdoor spaces — parks, campuses, streetscapes — for people and nature.",
    "Interior Designer":                  "You plan and style the insides of homes, offices, and commercial spaces.",
    "Urban Planner":                      "You shape how cities grow — roads, housing, parks — to improve life for everyone.",
    "Sustainable Architecture Specialist":"You design buildings that use less energy and have a smaller impact on the planet.",
    "Architectural Visualizer":           "You create photorealistic 3D images of buildings before they are constructed.",
    "BIM Specialist":                     "You use 3D digital models to plan, design, and manage building projects.",
    "Set Designer":                       "You create the physical worlds audiences see on stage and on screen.",
    "Parametric Design Specialist":       "You use algorithms to generate complex architectural forms a human couldn't draw by hand.",
    "General Physician":                  "You diagnose and treat a wide range of illnesses as a patient's first doctor.",
    "Cardiologist":                       "You diagnose and treat heart and blood vessel diseases.",
    "Neurologist":                        "You diagnose and treat disorders of the brain and nervous system.",
    "Pediatrician":                       "You provide medical care for children from birth through adolescence.",
    "Dermatologist":                      "You diagnose and treat skin, hair, and nail conditions.",
    "Oncologist":                         "You diagnose and treat cancer, guiding patients through their treatment journey.",
    "Orthopedic Surgeon":                 "You repair bones, joints, and muscles through surgery and rehabilitation.",
    "Anesthesiologist":                   "You keep patients safe and pain-free during surgical procedures.",
    "Emergency Medicine Physician":       "You provide immediate care for life-threatening injuries and illnesses.",
    "Radiologist":                        "You read X-rays, MRIs, and scans to diagnose diseases.",
    "Psychiatrist":                       "You diagnose and treat mental illnesses using both therapy and medication.",
    "Palliative Care Physician":          "You improve the quality of life for patients with serious, long-term illness.",
    "Sports Medicine Physician":          "You treat injuries and help athletes recover and perform at their best.",
    "Ayurveda Doctor":                    "You treat patients using India's ancient system of herbal and lifestyle medicine.",
    "Homeopathy Doctor":                  "You use homeopathic remedies to treat patients holistically.",
    "Chief Medical Officer":              "You lead the clinical strategy and medical governance of a hospital or health system.",
    "Registered Nurse":                   "You provide and coordinate patient care in hospitals and clinics.",
    "Physiotherapist":                    "You help patients recover movement and manage pain after injury or illness.",
    "Occupational Therapist":             "You help people regain the ability to perform daily tasks after illness or injury.",
    "Speech-Language Pathologist":        "You diagnose and treat communication and swallowing disorders.",
    "Audiologist":                        "You assess and treat hearing loss and balance disorders.",
    "Radiologic Technologist":            "You operate imaging equipment to capture X-rays, CT scans, and MRIs.",
    "Prosthetist / Orthotist":            "You design and fit artificial limbs and supportive devices for patients.",
    "Paramedic / EMT":                    "You provide life-saving emergency care in the field before hospital arrival.",
    "Dentist":                            "You diagnose and treat problems with teeth, gums, and oral health.",
    "Medical Laboratory Technician":      "You run lab tests on blood and tissue samples that help doctors diagnose disease.",
    "Optometrist":                        "You examine eyes, prescribe glasses, and detect eye diseases.",
    "Nutritionist / Dietitian":           "You help people improve their health through personalised food and diet plans.",
    "Public Health Nurse":                "You work in communities to prevent disease and promote health.",
    "Clinical Psychologist":              "You assess and treat mental health disorders using evidence-based therapy.",
    "Counseling Psychologist":            "You help people overcome personal challenges and improve their mental wellbeing.",
    "Child & Adolescent Psychologist":    "You support the mental health and emotional development of young people.",
    "School Counselor":                   "You guide students through academic, social, and career challenges at school.",
    "Career Counselor":                   "You help people discover their strengths and find fulfilling career paths.",
    "Forensic Psychologist":              "You apply psychological knowledge to legal cases and criminal investigations.",
    "Organizational Psychologist":        "You improve workplace culture, performance, and employee wellbeing.",
    "Art / Music / Drama Therapist":      "You use creative arts to help people process trauma and improve mental health.",
    "Mental Health Counselor":            "You provide talk therapy and emotional support to people facing life challenges.",
    "Behavior Analyst":                   "You design interventions to improve behaviour in children and adults with developmental needs.",
    "Life Coach / Executive Coach":       "You help people set goals and achieve them in life and work.",
    "Biomedical Engineer":                "You design medical devices and equipment that save and improve lives.",
    "Genetic Engineer":                   "You modify genes to develop cures, better crops, and new biotechnologies.",
    "Bioinformatician":                   "You use software and data analysis to understand biological systems and genomes.",
    "Clinical Research Associate":        "You oversee drug trials to ensure they follow protocols and produce reliable data.",
    "Molecular Biologist":                "You study how DNA, RNA, and proteins work to understand life at a cellular level.",
    "Pharmacologist":                     "You study how drugs interact with the body to develop safer and more effective medicines.",
    "Regulatory Affairs Specialist":      "You ensure medicines and devices meet all legal requirements before they reach patients.",
    "Medical Science Liaison":            "You bridge pharmaceutical companies and healthcare professionals with scientific knowledge.",
    "Embryologist":                       "You work with eggs, sperm, and embryos to support IVF and fertility treatments.",
    "Medical Writer":                     "You write clinical documents, research papers, and health content for medical audiences.",
    "Toxicologist":                       "You study how substances harm living organisms and set safe exposure limits.",
    "Genomic Counselor":                  "You help patients understand genetic test results and their health implications.",
    "Computational Biologist":            "You use computer models to simulate and understand complex biological processes.",
    "Biostatistician":                    "You design and analyse clinical trial data to test whether treatments work.",
    "Aerospace Engineer":                 "You design aircraft, rockets, and spacecraft that push the limits of flight.",
    "Aeronautical Engineer":              "You design and improve aircraft that fly within the Earth's atmosphere.",
    "Satellite Systems Engineer":         "You design the satellites that power GPS, weather forecasting, and communications.",
    "Astrophysicist":                     "You study stars, galaxies, and the fundamental forces that shape the universe.",
    "Space Mission Designer":             "You plan the entire journey of a spacecraft from launch to its destination.",
    "Space Policy Analyst":               "You shape the laws and agreements that govern human activities in outer space.",
    "Astrobiologist":                     "You search for signs of life beyond Earth in extreme environments and distant worlds.",
    "Space Lawyer":                       "You handle legal issues around satellite ownership, space tourism, and space mining.",
    "Rocket Propulsion Engineer":         "You design the engines that launch rockets and spacecraft into orbit.",
    "Planetary Scientist":                "You study planets, moons, and other bodies in our solar system.",
    "Space Weather Forecaster":           "You predict solar storms that can disrupt satellites, power grids, and communications.",
    "Commercial Spaceflight Systems Eng": "You design the systems for private rocket companies like those launching tourists.",
    "Mechanical Engineer":                "You design and build machines and mechanical systems used in every industry.",
    "Electrical Engineer":                "You design electrical systems, from power grids to the circuits in your phone.",
    "Robotics Engineer":                  "You build robots that automate tasks in factories, hospitals, and homes.",
    "Automation Engineer":                "You design systems that reduce human effort by automating industrial processes.",
    "Mechatronics Engineer":              "You combine mechanics, electronics, and computing to build smart machines.",
    "Control Systems Engineer":           "You design the feedback systems that keep machines and processes running accurately.",
    "Semiconductor Engineer":             "You design the microchips that power every electronic device.",
    "Automotive Engineer":                "You design and improve the vehicles — from engines to interiors — that we drive.",
    "Power Systems Engineer":             "You design the systems that generate, transmit, and distribute electricity.",
    "Manufacturing Engineer":             "You optimise how products are made in factories to improve quality and reduce cost.",
    "Human Factors Engineer":             "You design systems and tools that fit human behaviour and reduce errors.",
    "EV Engineer":                        "You design and develop electric vehicles and their battery and charging systems.",
    "Civil Engineer":                     "You design and oversee the infrastructure that holds cities together — roads, bridges, dams.",
    "Structural Engineer":                "You ensure buildings and structures are safe, stable, and can withstand loads.",
    "Transportation Engineer":            "You design road and transit systems that move people efficiently and safely.",
    "Environmental Engineer":             "You solve pollution, waste, and water problems using engineering solutions.",
    "Water Resources Engineer":           "You manage water supply, flood control, and irrigation systems.",
    "Construction Manager":               "You oversee building projects from foundations to final handover.",
    "BIM Coordinator":                    "You manage the 3D digital model of a construction project to keep all teams aligned.",
    "Geotechnical Engineer":              "You study soil and rock to ensure buildings and structures are built on solid ground.",
    "Surveyor":                           "You measure and map land to establish boundaries and support construction projects.",
    "Climate Change Analyst":             "You study climate data to assess risks and guide organisations toward sustainable decisions.",
    "Sustainability Analyst":             "You help organisations reduce their environmental impact and meet sustainability goals.",
    "Chief Sustainability Officer":       "You lead an organisation's strategy to become environmentally and socially responsible.",
    "Renewable Energy Engineer":          "You design systems that generate power from the sun, wind, and water.",
    "Solar Energy Systems Engineer":      "You design and install the solar panels and grids that generate clean electricity.",
    "Wind Energy Engineer":               "You design wind turbines and the systems that turn wind into electricity.",
    "Carbon Accounting Specialist":       "You measure and report an organisation's greenhouse gas emissions accurately.",
    "Environmental Lawyer":               "You use law to protect natural environments and hold polluters accountable.",
    "Conservation Biologist":             "You study and protect endangered species and the ecosystems they depend on.",
    "Ecologist":                          "You study how living organisms interact with each other and their environment.",
    "EV Charging Infrastructure Planner": "You plan the networks of charging stations that will power India's electric vehicle future.",
    "Green Building Consultant":          "You help construction projects meet sustainability standards and use less energy.",
    "Energy Auditor":                     "You assess how much energy buildings and factories use and find ways to cut waste.",
    "Film Director":                      "You lead the creative vision of a film, guiding actors and crew to tell a story.",
    "Screenwriter":                       "You write the scripts — dialogue, scenes, and story — that films and shows are built on.",
    "Cinematographer":                    "You decide how a film looks by controlling the camera, lighting, and framing.",
    "Film Producer":                      "You bring a film together by managing its budget, team, and everything needed to shoot it.",
    "Film Editor":                        "You shape the final film in post-production by assembling footage into a compelling story.",
    "Sound Designer":                     "You create the entire sonic world of a film — effects, ambience, and music layers.",
    "VFX Supervisor":                     "You lead the team that creates digital visual effects for films and streaming shows.",
    "Colorist":                           "You adjust the colour of a film's footage in post-production to create a visual mood.",
    "Podcast Producer":                   "You produce audio shows — editing, scripting, and growing a podcast audience.",
    "Broadcast Journalist":               "You deliver news on TV or radio, combining strong research with on-camera presence.",
    "Documentary Filmmaker":              "You tell real-world stories through the lens of a camera to inform and inspire.",
    "Game Developer":                     "You write the code that makes video games run, from physics to gameplay systems.",
    "Game Designer":                      "You design the rules, levels, and experiences that make games fun and engaging.",
    "3D Animator":                        "You bring characters and worlds to life through frame-by-frame 3D animation.",
    "VFX Artist":                         "You create digital effects that blend seamlessly with real footage in films and games.",
    "Character Rigger":                   "You build the digital skeleton inside 3D characters so animators can move them.",
    "Technical Artist":                   "You bridge art and engineering in games, optimising visuals without sacrificing performance.",
    "Esports Athlete":                    "You compete professionally in video game tournaments for cash and sponsorships.",
    "Esports Coach / Analyst":            "You train and analyse esports teams to improve strategy and performance.",
    "Esports Manager":                    "You run the business side of an esports team — contracts, sponsorships, and schedules.",
    "Game Monetization Manager":          "You design how a game makes money through in-app purchases and subscriptions.",
    "Motion Capture Performer":           "You wear sensors and act out movements that are recorded as animation data for games and films.",
    "Musician / Vocalist":                "You perform and record original music for audiences and on streaming platforms.",
    "Music Producer":                     "You shape the sound of a song by arranging, recording, and mixing all the elements.",
    "Sound Engineer":                     "You record, mix, and master audio for music, films, and live events.",
    "Choreographer":                      "You create and direct dance routines for performances, films, and music videos.",
    "Theater Director":                   "You lead a team of actors and designers to bring a stage production to life.",
    "Actor / Voice-over Artist":          "You perform characters on stage, screen, or in audio to entertain audiences.",
    "Film Composer":                      "You write original music that emotionally drives the story in films and shows.",
    "Stage Manager":                      "You coordinate every moving part of a live theatrical production to keep it running.",
    "Content Creator":                    "You create videos, reels, or posts for online platforms and build your own audience.",
    "Journalist / Investigative Reporter":"You research and report the news stories that keep the public informed.",
    "Social Media Strategist":            "You plan and execute a brand's social media presence to grow audiences and drive results.",
    "Copywriter / Content Writer":        "You write compelling text for websites, ads, and articles that inform and persuade.",
    "Science Communicator":               "You make complex scientific ideas accessible and exciting to a general audience.",
    "Data Journalist":                    "You use data and visualisations to report stories that numbers alone can tell.",
    "SEO Specialist":                     "You optimise websites so they rank higher in Google and attract organic visitors.",
    "Newsletter Writer":                  "You build a direct relationship with readers through a regular email publication.",
    "Photo Journalist":                   "You capture news events through powerful photographs that speak for themselves.",
    "Editor / Managing Editor":           "You oversee the quality, accuracy, and direction of content in a publication.",
    "Corporate Lawyer":                   "You advise companies on deals, contracts, and business law.",
    "Criminal Defense Lawyer":            "You represent people accused of crimes and ensure they get a fair trial.",
    "Intellectual Property Lawyer":       "You protect inventions, brands, and creative works from being stolen or misused.",
    "Cyber Lawyer":                       "You handle legal issues around hacking, data breaches, and digital rights.",
    "Human Rights Lawyer":                "You fight for the rights of people who have been treated unjustly.",
    "Tax Lawyer":                         "You help individuals and businesses navigate tax law and resolve disputes.",
    "Mediator / Arbitrator":              "You help disputing parties reach agreements without going to court.",
    "In-house Legal Counsel":             "You provide ongoing legal advice directly to a company from within its team.",
    "Forensic Accountant":                "You investigate financial crimes by tracing money trails through complex accounts.",
    "Entrepreneur / Startup Founder":     "You build a new business from scratch, taking risks to create something of value.",
    "Product Manager":                    "You decide what to build, why, and when — guiding a product from idea to launch.",
    "Investment Analyst":                 "You research companies and assets to help investors decide where to put their money.",
    "Venture Capitalist":                 "You invest in early-stage startups and help them grow into successful companies.",
    "Financial Planner / Wealth Manager": "You help individuals and families build and protect their long-term wealth.",
    "Actuary":                            "You use maths and statistics to assess financial risk for insurance and pensions.",
    "Management Consultant":              "You help organisations solve strategic problems and become more effective.",
    "Chartered Accountant":               "You manage and audit financial records, taxes, and reporting for businesses.",
    "Forensic Accountant (Business)":     "You investigate financial fraud and disputes in business and legal contexts.",
    "Impact Investor":                    "You fund businesses that generate positive social or environmental outcomes alongside profit.",
    "Marketing Manager":                  "You plan and execute campaigns that attract customers and build a brand.",
    "Growth Marketer":                    "You run data-driven experiments to rapidly grow a product's user base.",
    "IAS Officer":                        "You lead district administration and implement government policy across India.",
    "IPS Officer":                        "You lead law enforcement and maintain public safety as part of the Indian Police Service.",
    "IFS Officer":                        "You represent India abroad as a diplomat in the Indian Foreign Service.",
    "Policy Researcher / Analyst":        "You study existing policies and propose evidence-based recommendations for better governance.",
    "Diplomat / Consular Officer":        "You advance India's interests and assist citizens in foreign countries.",
    "Urban Policy Specialist":            "You design policies that tackle housing, transport, and services in growing cities.",
    "Intelligence Analyst":               "You analyse information from multiple sources to support national security decisions.",
    "Political Strategist":               "You plan election campaigns and communications strategies for political parties.",
    "NGO Program Manager":                "You run development programmes that address social issues in communities.",
    "Social Worker":                      "You support vulnerable individuals and families to improve their quality of life.",
    "Child Protection Specialist":        "You investigate abuse, support survivors, and work to keep children safe.",
    "School Teacher":                     "You educate students, build their knowledge, and support their growth every day.",
    "University Professor":               "You teach degree-level students and conduct original research in your field.",
    "EdTech Product Manager":             "You build digital learning products that make education better and more accessible.",
    "Instructional Designer":             "You design online and offline learning experiences that actually help people learn.",
    "Curriculum Developer":               "You design the content and structure of educational programmes.",
    "Educational Consultant":             "You advise schools, colleges, and governments on improving education quality.",
    "School Counselor (Ed)":              "You support students' academic, social, and emotional wellbeing in school.",
    "Child Psychologist (Ed)":            "You assess and support the mental health and development of children.",
    "Special Education Teacher":          "You teach and support students with learning disabilities and developmental needs.",
    "Online Tutor / Education Creator":   "You teach students or build educational content online for platforms like YouTube.",
    "Professional Athlete":               "You compete at the highest level in your sport as your primary career.",
    "Sports Coach":                       "You train athletes to improve their skill, fitness, and competitive performance.",
    "Sports Physiotherapist":             "You treat injuries and build recovery programmes specifically for athletes.",
    "Sports Analyst / Statistician":      "You use data to analyse player and team performance and drive strategic decisions.",
    "Athletic Trainer / Strength Coach":  "You design training programmes that build athletes' strength, speed, and endurance.",
    "Sports Journalist / Commentator":    "You report on and commentate sporting events for media platforms.",
    "Sports Manager / Agent":             "You manage an athlete's career, contracts, and public image.",
    "Personal Fitness Trainer":           "You design and deliver exercise programmes to help clients reach their fitness goals.",
    "Yoga Teacher / Wellness Coach":      "You guide students through yoga practice and help them build a healthier lifestyle.",
    "Esports Athlete / Coach":            "You compete or coach in professional video game competitions.",
    "Agronomist":                         "You advise farmers on how to grow crops more productively and sustainably.",
    "Agricultural Engineer":              "You design machines, irrigation systems, and facilities that improve farming.",
    "Food Scientist / Technologist":      "You develop new food products and ensure they are safe, nutritious, and delicious.",
    "Precision Agriculture Specialist":   "You use drones, sensors, and data to help farmers grow more with fewer resources.",
    "AgTech Developer":                   "You build the software and hardware tools that modernise farming in India.",
    "Veterinarian":                       "You diagnose and treat illnesses in animals, from pets to farm livestock.",
    "Soil Scientist":                     "You study soil health to improve agricultural productivity and land management.",
    "Nutritionist (Agri)":                "You advise on diet and food science to improve human and animal health.",
    "Food Safety Inspector":              "You inspect food production to ensure it meets safety standards.",
    "Horticulturist":                     "You cultivate fruits, vegetables, and ornamental plants for agriculture and landscaping.",
    "Marine Biologist":                   "You study ocean ecosystems and the creatures that live in them.",
    "AI Ethics Researcher":               "You study how to make AI systems fair, safe, and accountable for society.",
    "Brain-Computer Interface Designer":  "You design devices that connect the human brain directly to computers.",
    "Synthetic Biology Engineer":         "You engineer new life forms and biological systems for medicine and industry.",
    "Metaverse Architect / Designer":     "You design virtual worlds and immersive digital spaces people live and work in.",
    "Deepfake Forensic Analyst":          "You detect AI-generated fake videos and images to combat misinformation.",
    "Autonomous Vehicle Engineer":        "You build the AI and systems that allow self-driving cars to navigate safely.",
    "Digital Currency / FinTech Strategist":"You shape the strategy for blockchain, digital payments, and financial technology.",
    "Climate Engineer":                   "You develop large-scale technologies to remove carbon or manage the Earth's temperature.",
    "Human-Robot Interaction Designer":   "You design how humans and robots work together intuitively and safely.",
    "Bioprinted Organ Quality Specialist":"You oversee the quality and safety of human organs grown in labs for transplant.",
    "Space Habitat Designer":             "You design the living and working spaces humans will inhabit beyond Earth.",
    "Carbon Offset Verifier":             "You verify that carbon credits represent real, measurable reductions in emissions.",
    "Algorithmic Bias Auditor":           "You audit AI systems to find and fix discrimination baked into their decisions.",
    "Personalized Microbiome Dietician":  "You design diets tailored to a person's unique gut microbiome for optimal health.",
    "Quantum Computing Engineer":         "You build quantum computers that solve problems classical computers never could.",
    "Electrician":                        "You install and maintain the electrical systems in homes, offices, and factories.",
    "Plumber / Pipefitter":               "You install and repair the water, gas, and drainage systems in buildings.",
    "CNC Machine Operator":               "You operate computer-controlled machines that cut and shape metal and plastic parts.",
    "Automotive Mechanic / EV Technician":"You diagnose and repair petrol and electric vehicles to keep them running safely.",
    "HVAC Technician":                    "You install and maintain air conditioning, heating, and ventilation systems.",
    "Welder":                             "You join metal parts together using heat — essential in construction and manufacturing.",
    "Aircraft Mechanic / Avionics Tech":  "You inspect and repair aircraft systems to ensure flights are safe.",
    "3D Printing Technician":             "You operate 3D printers to manufacture custom parts for industry and healthcare.",
    "Medical Equipment Calibration Tech": "You ensure that hospital diagnostic equipment measures accurately and safely.",
    "Industrial Robot Maintenance Tech":  "You keep factory robots running by diagnosing faults and performing repairs.",
}


# ──────────────────────────────────────────────────────────────────────────────
# 4. Seed logic
# ──────────────────────────────────────────────────────────────────────────────
def slugify_name(name: str) -> str:
    return slugify(name, separator="-", max_length=100)


def seed(conn):
    cur = conn.cursor()

    print("=== Seeding career_domains ===")
    domain_id_map = {}  # slug → uuid

    for (slug, name, short_name, india_rel, growth, entry_path, order) in DOMAINS:
        domain_id = str(uuid.uuid4())
        cur.execute(
            """
            INSERT INTO career_domains
                (id, slug, name, short_name, india_relevance, growth_forecast_2035, entry_path_summary, display_order, is_active)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, TRUE)
            ON CONFLICT (slug) DO UPDATE SET
                name = EXCLUDED.name,
                short_name = EXCLUDED.short_name,
                india_relevance = EXCLUDED.india_relevance,
                growth_forecast_2035 = EXCLUDED.growth_forecast_2035,
                entry_path_summary = EXCLUDED.entry_path_summary,
                display_order = EXCLUDED.display_order
            RETURNING id
            """,
            (domain_id, slug, name, short_name, india_rel, growth, entry_path, order),
        )
        row = cur.fetchone()
        domain_id_map[slug] = row[0]
        print(f"  [OK] Domain: {name}")

    print(f"\n=== Seeding {len(CAREERS_RAW)} careers ===")
    inserted = 0
    skipped = 0

    for (career_name, domain_slug, tags, india_viab, future_score, is_emerging) in CAREERS_RAW:
        career_slug = slugify_name(career_name)
        domain_id = domain_id_map.get(domain_slug)
        one_liner = ONE_LINERS.get(career_name, f"A career in {career_name}.")

        if not domain_id:
            print(f"  [WARN] Skipping '{career_name}' - unknown domain slug '{domain_slug}'")
            skipped += 1
            continue

        cur.execute(
            """
            INSERT INTO careers
                (id, slug, name, one_liner, domain_id, dimension_tags,
                 india_viability, future_score, is_emerging, is_active)
            VALUES (%s, %s, %s, %s, %s, %s::VARCHAR(2)[], %s, %s, %s, TRUE)
            ON CONFLICT (slug) DO UPDATE SET
                name            = EXCLUDED.name,
                one_liner       = EXCLUDED.one_liner,
                domain_id       = EXCLUDED.domain_id,
                dimension_tags  = EXCLUDED.dimension_tags,
                india_viability = EXCLUDED.india_viability,
                future_score    = EXCLUDED.future_score,
                is_emerging     = EXCLUDED.is_emerging,
                updated_at      = NOW()
            """,
            (
                str(uuid.uuid4()),
                career_slug,
                career_name,
                one_liner,
                domain_id,
                tags,
                india_viab,
                future_score,
                is_emerging,
            ),
        )
        inserted += 1

    conn.commit()
    cur.close()

    print(f"\n[DONE] {inserted} careers upserted, {skipped} skipped.")


def main():
    print(f"Connecting to: {DB_URL[:40]}...")
    conn = psycopg2.connect(DB_URL)
    try:
        seed(conn)
    finally:
        conn.close()


if __name__ == "__main__":
    main()
