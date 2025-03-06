from flask import Blueprint, jsonify
from bson import ObjectId  # Import ObjectId to handle MongoDB _id
from config import db  # Import database connection

student_routes = Blueprint("student_routes", __name__)

# Fetch all students
@student_routes.route("/students", methods=["GET"])
def get_students():
    students = list(db.registration.find({}, {"_id": 1, "name": 1}))  # Include `_id`
    for student in students:
        student["_id"] = str(student["_id"])  # Convert ObjectId to string
    return jsonify({"students": students})

# Fetch student by _id
@student_routes.route("/student/<user_id>", methods=["GET"])
def get_student(user_id):
    try:
        student = db.registration.find_one({"_id": ObjectId(user_id)}, {"_id": 0})  # Convert to ObjectId
        if student:
            return jsonify({"student": student})
        return jsonify({"error": "Student not found"}), 404
    except Exception:
        return jsonify({"error": "Invalid ID format"}), 400  # Handle invalid ObjectId format
