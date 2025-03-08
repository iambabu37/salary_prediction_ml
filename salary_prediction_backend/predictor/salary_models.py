import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.impute import SimpleImputer
from sklearn.metrics import mean_squared_error
import joblib

# Define important features for salary prediction
important_features = [
    'max_salary', 'min_salary', 'pay_period', 'location'  # Add relevant features here
]

def train_salary_model(file_name, model_file='salary_model.pkl', column_order_file='column_order.pkl'):
    # Load the dataset
    print("Loading dataset...")
    data = pd.read_csv(file_name)

    # Drop rows with missing target variable (med_salary)
    data = data.dropna(subset=['med_salary'])

    # Separate features (X) and target (y)
    y = data['med_salary']
    X = data[important_features]

    # Convert categorical variables to numerical using one-hot encoding
    X = pd.get_dummies(X, drop_first=True)

    # Save the column order for consistent predictions later
    column_order = X.columns.tolist()
    joblib.dump(column_order, column_order_file)
    print(f"Column order saved to {column_order_file}")

    # Impute missing values in features
    imputer = SimpleImputer(strategy='mean')
    X = imputer.fit_transform(X)

    # Split the dataset into training and testing sets
    print("Splitting data into training and testing sets...")
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Train the model on the training set
    print("Training the model...")
    model = LinearRegression()
    model.fit(X_train, y_train)

    # Evaluate the model on the test set
    print("Evaluating the model...")
    predictions = model.predict(X_test)
    mse = mean_squared_error(y_test, predictions)
    print(f"Mean Squared Error: {mse}")

    # Save the trained model to a file
    joblib.dump(model, model_file)
    print(f"Model saved as {model_file}")

# Run the function to train and save the model
if __name__ == "__main__":
    file_name = "postings.csv"  # Replace with your actual dataset file path
    train_salary_model(file_name)
