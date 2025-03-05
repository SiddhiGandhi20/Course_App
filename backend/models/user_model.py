from config import db
from bson import ObjectId

class User:
    collection = db.registration  # Collection name
    
    @staticmethod
    def create_user(full_name, mobile_number, role):
        user_data = {
            "full_name": full_name,
            "mobile_number": mobile_number,
            "role": role,
            "is_deleted": False  # New users are active
        }
        return User.collection.insert_one(user_data).inserted_id

    @staticmethod
    def get_user_by_mobile(mobile_number):
        return User.collection.find_one({"mobile_number": mobile_number})

    @staticmethod
    def update_user(mobile_number, update_data):
        return User.collection.update_one(
            {"mobile_number": mobile_number},
            {"$set": update_data}
        )

    @staticmethod
    def restore_user(mobile_number, full_name, role):
        return User.collection.update_one(
            {"mobile_number": mobile_number},
            {"$set": {"full_name": full_name, "role": role, "is_deleted": False}}
        )
