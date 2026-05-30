"""
Roadmap generator — template-based roadmap step generation.

In production, this would load templates from a database or JSON file
based on (career_slug, academic_stage).
"""


def generate_template_steps(career_name: str, career_slug: str, academic_stage: str) -> list[dict]:
    """
    Generate a list of roadmap steps for a given career and academic stage.

    Returns a list of dicts with keys:
    step_order, category, title, description, timeframe, resource_url, resource_label, is_premium
    """
    # Default template steps (placeholder — to be replaced with real templates)
    steps = [
        {
            "step_order": 1,
            "category": "first_30_days",
            "title": f"Research what a {career_name} does day-to-day",
            "description": "Read articles, watch YouTube videos, and talk to people in this field.",
            "timeframe": "30 days",
            "resource_url": None,
            "resource_label": None,
            "is_premium": False,
        },
        {
            "step_order": 2,
            "category": "skill_to_learn",
            "title": f"Learn the foundational skills for {career_name}",
            "description": "Start with free online courses to build core skills.",
            "timeframe": "60 days",
            "resource_url": None,
            "resource_label": None,
            "is_premium": False,
        },
        {
            "step_order": 3,
            "category": "project_to_build",
            "title": "Build your first project or portfolio piece",
            "description": "Apply what you've learned by creating something tangible.",
            "timeframe": "90 days",
            "resource_url": None,
            "resource_label": None,
            "is_premium": False,
        },
        {
            "step_order": 4,
            "category": "subject_focus",
            "title": "Focus on relevant school subjects",
            "description": f"Identify which school subjects are most relevant for {career_name}.",
            "timeframe": "Ongoing",
            "resource_url": None,
            "resource_label": None,
            "is_premium": False,
        },
        {
            "step_order": 5,
            "category": "certification",
            "title": "Explore relevant certifications or online courses",
            "description": "Look into industry-recognized certifications.",
            "timeframe": "6 months",
            "resource_url": None,
            "resource_label": None,
            "is_premium": True,
        },
        {
            "step_order": 6,
            "category": "college_target",
            "title": "Research colleges and degree programs",
            "description": f"Find the best degree paths for {career_name} in India.",
            "timeframe": "Before applications",
            "resource_url": None,
            "resource_label": None,
            "is_premium": True,
        },
    ]

    return steps
