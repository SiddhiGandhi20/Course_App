from pymongo import MongoClient

class Config:
    MONGO_URI = "mongodb://localhost:27017/course_app"  # Update if needed

# Connect to MongoDB
client = MongoClient(Config.MONGO_URI)
db = client.course_app