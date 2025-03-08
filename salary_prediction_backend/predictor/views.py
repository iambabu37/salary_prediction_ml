import joblib
import pandas as pd
import numpy as np
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

class SalaryPrediction(APIView):
    
    def post(self, request):
        try:
            # Get input data from request body
            max_salary = request.data.get('max_salary')
            min_salary = request.data.get('min_salary')
            pay_period = request.data.get('pay_period')
            location = request.data.get('location')

            if None in [max_salary, min_salary, pay_period, location]:
                return Response({'error': 'Missing required fields'}, status=status.HTTP_400_BAD_REQUEST)

            # Load the trained model and column order
            model = joblib.load('predictor/salary_model.pkl')
            column_order = joblib.load('predictor/column_order.pkl')

            # Prepare input data for prediction as a DataFrame
            input_data = pd.DataFrame([[max_salary, min_salary, pay_period, location]], 
                                       columns=['max_salary', 'min_salary', 'pay_period', 'location'])

            # Convert categorical variables to numerical using one-hot encoding (same as during training)
            input_data = pd.get_dummies(input_data, drop_first=True)

            # Align columns with training data (add missing columns as 0)
            input_data = input_data.reindex(columns=column_order, fill_value=0)

            # Convert to NumPy array for prediction
            input_data = np.array(input_data)

            # Make prediction using the trained model
            predicted_salary = model.predict(input_data)[0]

            return Response({'predicted_salary': predicted_salary}, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
