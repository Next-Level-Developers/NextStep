"""
Parent share view router.

GET /api/v1/share/profile/{share_token}/
"""

from fastapi import APIRouter

router = APIRouter()


@router.get("/profile/{share_token}/")
async def get_shared_profile(share_token: str):
    """Read-only student profile for parents. No auth required — token is the credential."""
    # In production: look up share_token in DB, verify not expired, return student data
    if not share_token.startswith("nxt_share_"):
        return {
            "success": False,
            "error": {"code": "SHARE_TOKEN_INVALID", "message": "Invalid or expired share token."},
        }

    # Placeholder response
    return {
        "success": True,
        "data": {
            "student_first_name": "Student",
            "academic_stage": "Grade 11 Science",
            "profiler_completed": True,
            "top_matched_careers": [],
            "roadmap_summary": None,
            "counsellor_cta": {
                "text": "Want to discuss this with a counsellor?",
                "url": "https://nextstep.app/counsellors",
            },
        },
    }
