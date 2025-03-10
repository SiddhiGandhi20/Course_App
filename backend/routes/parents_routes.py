from flask import Blueprint, request, jsonify
from config import db
from models.parents_model import ParentModel  # Import ParentModel

# Create Blueprint
parent_routes = Blueprint("parent_routes", __name__)
parent_model = ParentModel(db)  # Initialize ParentModel

@parent_routes.route("/parent/link-student", methods=["POST"])
def link_student():
    """API to link a student to a parent."""
    data = request.json
    parent_mobile = data.get("parent_mobile")
    student_mobile = data.get("student_mobile")

    if not parent_mobile or not student_mobile:
        return jsonify({"error": "❌ Parent and Student Mobile Numbers are required"}), 400

    result = parent_model.link_student(parent_mobile, student_mobile)
    return jsonify(result), 200 if "message" in result else 400

@parent_routes.route("/parent/unlink-student", methods=["POST"])
def unlink_student():
    """API to unlink a student from a parent."""
    data = request.json
    parent_mobile = data.get("parent_mobile")
    student_mobile = data.get("student_mobile")

    if not parent_mobile or not student_mobile:
        return jsonify({"error": "❌ Parent and Student Mobile Numbers are required"}), 400

    result = parent_model.unlink_student(parent_mobile, student_mobile)
    return jsonify(result), 200 if "message" in result else 400

@parent_routes.route("/parent/get-linked-students/<parent_mobile>", methods=["GET"])
def get_linked_students(parent_mobile):
    """API to get all linked students for a parent."""
    result = parent_model.get_linked_students(parent_mobile)

    if "error" in result:
        return jsonify({"error": result["error"]}), 400  # Bad Request for invalid inputs

    return jsonify({"linked_students": result.get("linked_students", [])}), 200  # Always return a list
