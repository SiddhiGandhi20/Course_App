from pymongo import MongoClient
import gridfs

class Config:
    MONGO_URI = "mongodb://localhost:27017/course_app"

# Connect to MongoDB
client = MongoClient(Config.MONGO_URI)
db = client.course_app

# GridFS for storing PDFs
fs = gridfs.GridFS(db)  # ✅ Fix: Define GridFS instance
