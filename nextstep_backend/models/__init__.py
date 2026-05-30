# Import all models so Alembic and relationship resolution works
from models.user import User, StudentProfile, SchoolOrganisation, SchoolMembership
from models.profiler import ProfilerSession, ProfilerResponse, InterestProfile
from models.career import CareerDomain, CareerCluster, Career
from models.recommendation import CareerRecommendation, CareerView, CareerSave
from models.roadmap import Roadmap, RoadmapStep, RoadmapStepProgress
from models.ai_chat import AIConversation, AIMessage
from models.content import RealPeopleStory, LearningResource
from models.subscription import SubscriptionPlan, SubscriptionTransaction
from models.notification import Notification, CheckInPrompt
from models.analytics import AnalyticsEvent
