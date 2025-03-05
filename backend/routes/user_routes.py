from flask import Blueprint, request, jsonify
from models.user_model import User

user_routes = Blueprint('user_routes', __name__)
@user_routes.route('/register', methods=['POST'])
def register():
    try:
        data = request.json
        full_name = data.get('full_name')
        mobile_number = data.get('mobile_number')
        role = data.get('role')

        if not full_name or not mobile_number or not role:
            return jsonify({"error": "All fields are required"}), 400

        existing_user = User.get_user_by_mobile(mobile_number)

        if existing_user:
            if existing_user.get("is_deleted", False):  
                User.restore_user(mobile_number, full_name, role)
                return jsonify({"message": "User re-registered successfully", "user_id": str(existing_user["_id"])}), 200
            return jsonify({"error": "Mobile number already registered"}), 409

        user_id = User.create_user(full_name, mobile_number, role)

        # ✅ Debugging print statements
        print("✅ User registered:", user_id)

        return jsonify({"message": "User registered successfully", "user_id": str(user_id)}), 201

    except Exception as e:
        print("❌ Server Error:", str(e))
        return jsonify({"error": "Internal server error"}), 500
