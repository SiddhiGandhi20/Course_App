from config import db

class User:
    collection = db.registration  # Collection name
    
    @staticmethod
    def create_user(full_name, mobile_number, role):
        user_data = {
            "full_name": full_name,
            "mobile_number": mobile_number,
            "role": role
        }
        return User.collection.insert_one(user_data).inserted_id

    @staticmethod
    def get_user_by_mobile(mobile_number):
        return User.collection.find_one({"mobile_number": mobile_number})
