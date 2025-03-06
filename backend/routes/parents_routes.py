from flask import Blueprint, request, jsonify
from config import db
from bson import ObjectId

parent_routes = Blueprint("parent_routes", __name__)

# Link a student to the parent's account
from flask import Blueprint, request, jsonify
from config import db
from bson import ObjectId

parent_routes = Blueprint("parent_routes", __name__)

# Link a student to the parent's account
from flask import Blueprint, request, jsonify
from config import db
from bson import ObjectId

parent_routes = Blueprint("parent_routes", __name__)

# Link a student to the parent's account
from flask import Blueprint, request, jsonify
from config import db
from bson import ObjectId

parent_routes = Blueprint("parent_routes", __name__)

# Link a student (store only student IDs)
@parent_routes.route("/parent/link-student", methods=["POST"])
def link_student():
    data = request.json
    student_id = data.get("student_id")

    # Validate input
    if not student_id:
        return jsonify({"error": "Student ID is required"}), 400

    try:
        student_obj_id = ObjectId(student_id)
    except Exception:
        return jsonify({"error": "Invalid Student ID"}), 400

    # Fetch student details from the students collection
    student = db.registration.find_one({"_id": student_obj_id}, {"full_name": 1, "mobile_number": 1})

    if not student:
        return jsonify({"error": "Student not found"}), 404

    # Store linked student details in the database
    db.linked_students.update_one(
        {"student_id": student_obj_id},
        {"$set": {
            "student_id": student_obj_id,
            "full_name": student.get("full_name", "N/A"),
            "mobile_number": student.get("mobile_number", "N/A"),
        }},
        upsert=True
    )

    return jsonify({"message": "Student linked successfully!"}), 200
