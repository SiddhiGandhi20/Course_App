from flask import Blueprint, request, jsonify
from models.user_model import User

user_routes = Blueprint('user_routes', __name__)

# 📌 1️⃣ Register a new user
@user_routes.route('/register', methods=['POST'])
def register():
    try:
        data = request.json
        full_name = data.get('full_name')
        mobile_number = data.get('mobile_number')
        role = data.get('role')

        if not all([full_name, mobile_number, role]):
            return jsonify({"error": "All fields are required"}), 400

        existing_user = User.get_user_by_mobile(mobile_number)

        if existing_user:
            if existing_user.get("is_deleted", False):  
                User.restore_user(mobile_number, full_name, role)
                restored_user = User.get_user_by_mobile(mobile_number)
                return jsonify({
                    "message": "User re-registered successfully",
                    "user_id": str(restored_user["_id"])
                }), 200
            return jsonify({"error": "Mobile number already registered"}), 409

        user_id = User.create_user(full_name, mobile_number, role)

        print("✅ User registered:", user_id)

        return jsonify({
            "message": "User registered successfully",
            "user_id": str(user_id)
        }), 201

    except Exception as e:
        print("❌ Server Error:", str(e))
        return jsonify({"error": "Internal server error"}), 500


# 📌 2️⃣ Get user details by user_id
@user_routes.route('/register/<user_id>', methods=['GET'])
def get_user(user_id):
    try:
        user = User.get_user_by_id(user_id)

        if not user:
            return jsonify({"error": "User not found"}), 404

        return jsonify({
            "user_id": str(user["_id"]),
            "full_name": user["full_name"],
            "mobile_number": user["mobile_number"],
            "role": user["role"]
        }), 200

    except Exception as e:
        print("❌ Error fetching user:", str(e))
        return jsonify({"error": "Internal server error"}), 500


# 📌 3️⃣ NEW: Get user details by mobile number
@user_routes.route('/register/mobile/<mobile_number>', methods=['GET'])
def get_user_by_mobile(mobile_number):
    try:
        user = User.get_user_by_mobile(mobile_number)

        if not user:
            return jsonify({"error": "User not found"}), 404

        return jsonify({
            "user_id": str(user["_id"]),
            "full_name": user["full_name"],
            "mobile_number": user["mobile_number"],
            # "role": user["role"]
        }), 200

    except Exception as e:
        print("❌ Error fetching user by mobile:", str(e))
        return jsonify({"error": "Internal server error"}), 500


# 📌 4️⃣ Update user details
@user_routes.route('/register/update/<user_id>', methods=['PUT'])
def update_user(user_id):
    try:
        data = request.json
        full_name = data.get('full_name')
        mobile_number = data.get('mobile_number')
        role = data.get('role')

        updated = User.update_user(user_id, full_name, mobile_number, role)

        if updated:
            return jsonify({"message": "User updated successfully"}), 200
        return jsonify({"error": "User not found"}), 404

    except Exception as e:
        print("❌ Error updating user:", str(e))
        return jsonify({"error": "Internal server error"}), 500


# 📌 5️⃣ Delete a user
@user_routes.route('/register/delete/<user_id>', methods=['DELETE'])
def delete_user(user_id):
    try:
        deleted = User.delete_user(user_id)

        if deleted:
            return jsonify({"message": "User deleted successfully"}), 200
        return jsonify({"error": "User not found"}), 404

    except Exception as e:
        print("❌ Error deleting user:", str(e))
        return jsonify({"error": "Internal server error"}), 500
