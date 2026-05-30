"""
Context builder — builds system prompt from student profile for AI conversations.
"""


def build_system_prompt(
    student_name: str | None = None,
    academic_stage: str | None = None,
    top_dimensions: list[str] | None = None,
    saved_careers: list[str] | None = None,
    career_name: str | None = None,
    career_details: dict | None = None,
) -> str:
    """
    Build a system prompt for Claude based on student context.

    For 'general' conversations: injects profile + interests.
    For 'career_specific' conversations: adds full career record.
    """
    parts = [
        "You are NextStep AI, a friendly and knowledgeable career guidance assistant for Indian students.",
        "You speak in a warm, encouraging tone. You use simple language.",
        "You are deeply knowledgeable about careers, education paths, and the Indian job market.",
        "Always be specific to Indian context — mention Indian universities, exams, salary ranges in INR, and Indian companies.",
        "",
    ]

    if student_name:
        parts.append(f"The student's name is {student_name}.")
    if academic_stage:
        parts.append(f"They are currently in: {academic_stage.replace('_', ' ').title()}.")
    if top_dimensions:
        dim_map = {
            "C": "Creative/Artistic",
            "A": "Analytical/Research",
            "T": "Technology/Engineering",
            "S": "Social/Helping",
            "E": "Entrepreneurial/Leadership",
            "P": "Physical/Hands-on",
        }
        dim_names = [dim_map.get(d, d) for d in top_dimensions]
        parts.append(f"Their strongest interest dimensions are: {', '.join(dim_names)}.")
    if saved_careers:
        parts.append(f"They have saved these careers: {', '.join(saved_careers)}.")

    if career_name:
        parts.append(f"\nThis conversation is about the career: {career_name}.")
        if career_details:
            if career_details.get("one_liner"):
                parts.append(f"Career description: {career_details['one_liner']}")
            if career_details.get("skills_needed"):
                parts.append(f"Skills needed: {', '.join(career_details['skills_needed'])}")
            if career_details.get("entry_paths"):
                parts.append(f"Entry paths: {', '.join(career_details['entry_paths'])}")

    parts.append("")
    parts.append("Guidelines:")
    parts.append("- Keep responses under 300 words unless asked for detail.")
    parts.append("- Be encouraging but realistic about career prospects.")
    parts.append("- If unsure, say so — don't make things up.")
    parts.append("- Suggest concrete next steps when appropriate.")

    return "\n".join(parts)
