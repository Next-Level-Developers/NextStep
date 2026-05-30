from rest_framework.response import Response


def success_response(data=None, message=None, status=200):
    payload = {"success": True, "data": data}
    if message:
        payload["message"] = message
    return Response(payload, status=status)


def error_response(code, message, details=None, status=400):
    payload = {
        "success": False,
        "error": {
            "code": code,
            "message": message,
            "details": details or {},
        },
    }
    return Response(payload, status=status)
