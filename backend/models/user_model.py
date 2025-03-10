from config import db
from bson import ObjectId

class User:
    collection = db.registration  # Collection name

    @staticmethod
    def create_user(full_name, mobile_number, role):
        """ Create a new user """
        user_data = {
            "full_name": full_name,
            "mobile_number": mobile_number,
            "role": role,
            "is_deleted": False  # New users are active
        }
        result = User.collection.insert_one(user_data)
        return str(result.inserted_id)  # Convert to string for consistency

    @staticmethod
    def get_user_by_mobile(mobile_number):
        """ Get user by mobile number (only active users) """
        user = User.collection.find_one({"mobile_number": mobile_number, "is_deleted": False})
        return User._format_user(user)

    @staticmethod
    def get_user_by_id(user_id):
        """ Fetch user details by user ID """
        try:
            user = User.collection.find_one({"_id": ObjectId(user_id), "is_deleted": False})
            return User._format_user(user)
        except Exception as e:
            print("❌ Error fetching user by ID:", e)
            return None

    @staticmethod
    def update_user(user_id, full_name=None, mobile_number=None, role=None):
        """ Update user details by user ID """
        try:
            update_data = {}
            if full_name:
                update_data["full_name"] = full_name
            if mobile_number:
                update_data["mobile_number"] = mobile_number
            if role:
                update_data["role"] = role

            if not update_data:
                return False  # No updates provided

            result = User.collection.update_one(
                {"_id": ObjectId(user_id), "is_deleted": False},
                {"$set": update_data}
            )
            return result.modified_count > 0
        except Exception as e:
            print("❌ Error updating user:", e)
            return False

    @staticmethod
    def restore_user(mobile_number, full_name, role):
        """ Restore a soft-deleted user """
        try:
            result = User.collection.update_one(
                {"mobile_number": mobile_number, "is_deleted": True},  # Only restore if deleted
                {"$set": {"full_name": full_name, "role": role, "is_deleted": False}}
            )
            if result.modified_count > 0:
                restored_user = User.get_user_by_mobile(mobile_number)
                return restored_user["_id"] if restored_user else None
            return None
        except Exception as e:
            print("❌ Error restoring user:", e)
            return None

    @staticmethod
    def delete_user(user_id):
        """ Soft delete user by ID """
        try:
            result = User.collection.update_one(
                {"_id": ObjectId(user_id), "is_deleted": False},  # Prevent double delete
                {"$set": {"is_deleted": True}}
            )
            return result.modified_count > 0
        except Exception as e:
            print("❌ Error deleting user:", e)
            return False

    @staticmethod
    def _format_user(user):
        """ Convert `_id` field to string and return formatted user """
        if user:
            user["_id"] = str(user["_id"])
        return user
