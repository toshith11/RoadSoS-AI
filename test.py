import joblib

# load trained model
model = joblib.load("model/road_sos_model.pkl")

while True:
    text = input("\nEnter accident description: ")
    
    prediction = model.predict([text])[0]
    
    print("👉 Severity:", prediction)