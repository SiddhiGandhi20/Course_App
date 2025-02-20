from flask import Blueprint, request, jsonify
from models.user_model import User

user_routes = Blueprint('user_routes', __name__)

@user_routes.route('/register', methods=['POST'])
def register():
    data = request.json
    full_name = data.get('full_name')
    mobile_number = data.get('mobile_number')
    role = data.get('role')

    if not full_name or not mobile_number or not role:
        return jsonify({"error": "All fields are required"}), 400

    if User.get_user_by_mobile(mobile_number):
        return jsonify({"error": "Mobile number already registered"}), 409

    user_id = User.create_user(full_name, mobile_number, role)
    return jsonify({"message": "User registered successfully", "user_id": str(user_id)}), 201
