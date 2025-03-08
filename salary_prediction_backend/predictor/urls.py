from django.urls import path
from .views import SalaryPrediction

urlpatterns = [
    path('predict/', SalaryPrediction.as_view(), name='salary-predict'),
]
