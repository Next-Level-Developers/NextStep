from rest_framework.permissions import BasePermission


class IsStudent(BasePermission):
    def has_permission(self, request, view):
        user = request.user
        return bool(user and user.is_authenticated and user.user_type == "student")


class IsCounsellor(BasePermission):
    def has_permission(self, request, view):
        user = request.user
        return bool(user and user.is_authenticated and user.user_type == "counsellor")


class IsSchoolAdmin(BasePermission):
    def has_permission(self, request, view):
        user = request.user
        return bool(user and user.is_authenticated and user.user_type == "school_admin")
