import json
from pathlib import Path


QUESTIONS_PATH = Path(__file__).resolve().parent / "questions.json"


def load_questions():
    if not QUESTIONS_PATH.exists():
        return []
    with QUESTIONS_PATH.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def get_question_map():
    return {question["code"]: question for question in load_questions()}


def get_total_questions():
    return len(load_questions())


def compute_dimension_weights(question, selected_indices):
    totals = {}
    for option in question.get("options", []):
        if option.get("index") in selected_indices:
            for key, value in option.get("dimension_weights", {}).items():
                totals[key] = totals.get(key, 0) + float(value)
    return totals
