from pymongo import MongoClient
from bson import ObjectId
import re

class ParentModel:
    def __init__(self, db):
        """Initialize ParentModel with database collections."""
        self.collection = db.parents_students  # Parent-Student Link Collection
        self.registration_collection = db.registration  # Users Collection (Parents & Students)

    def is_valid_mobile(self, mobile):
        """Validate mobile number format (10-digit)."""
        return bool(re.fullmatch(r"^\d{10}$", mobile))

    def get_parent_by_mobile(self, parent_mobile):
        """Fetch parent details from the registration collection."""
        if not self.is_valid_mobile(parent_mobile):
            return None

        return self.registration_collection.find_one(
            {"mobile_number": parent_mobile, "role": {"$regex": "^parent$", "$options": "i"}},
            {"_id": 1, "full_name": 1, "mobile_number": 1}
        )

    def get_student_by_mobile(self, student_mobile):
        """Fetch student details from the registration collection."""
        if not self.is_valid_mobile(student_mobile):
            return None

        return self.registration_collection.find_one(
            {"mobile_number": student_mobile, "role": {"$regex": "^student$", "$options": "i"}},
            {"_id": 1, "full_name": 1, "mobile_number": 1}
        )

    def link_student(self, parent_mobile, student_mobile):
        """Links a student to a parent while ensuring data integrity."""
        if not self.is_valid_mobile(parent_mobile) or not self.is_valid_mobile(student_mobile):
            return {"error": "❌ Invalid mobile number format"}

        parent = self.get_parent_by_mobile(parent_mobile)
        if not parent:
            return {"error": "❌ Parent not found"}

        student = self.get_student_by_mobile(student_mobile)
        if not student:
            return {"error": "❌ Student not found"}

        parent_id = str(parent["_id"])
        student_data = {
            "_id": str(student["_id"]),  # Ensure the student ID is a string
            "full_name": student.get("full_name", "Unknown"),
            "mobile_number": student.get("mobile_number", "N/A")
        }

        # Remove student from any existing parent before linking
        self.collection.update_many(
            {"linked_students.mobile_number": student_mobile},
            {"$pull": {"linked_students": {"mobile_number": student_mobile}}}
        )

        # Ensure parent entry exists
        parent_entry = self.collection.find_one({"parent_id": parent_id})

        if not parent_entry:
            # Create new parent entry
            self.collection.insert_one({
                "parent_id": parent_id,
                "parent_details": {
                    "_id": parent_id,
                    "full_name": parent.get("full_name", "Unknown"),
                    "mobile_number": parent_mobile
                },
                "linked_students": [student_data]
            })
        else:
            # Prevent duplicate student entries
            if any(s["mobile_number"] == student_mobile for s in parent_entry.get("linked_students", [])):
                return {"error": "❌ Student is already linked to this parent"}

            # Add student to `linked_students`
            self.collection.update_one(
                {"parent_id": parent_id},
                {"$addToSet": {"linked_students": student_data}}
            )

        return {"message": "✅ Student linked successfully"}

    def unlink_student(self, parent_mobile, student_mobile):
        """Unlinks a student from a parent."""
        if not self.is_valid_mobile(parent_mobile) or not self.is_valid_mobile(student_mobile):
            return {"error": "❌ Invalid mobile number format"}

        parent = self.get_parent_by_mobile(parent_mobile)
        if not parent:
            return {"error": "❌ Parent not found"}

        parent_id = str(parent["_id"])

        # Check if the student exists under the parent
        parent_entry = self.collection.find_one(
            {"parent_id": parent_id, "linked_students.mobile_number": student_mobile},
            {"linked_students": 1}
        )

        if not parent_entry:
            return {"error": "❌ Student is not linked to this parent"}

        # Remove student from parent's linked_students list
        self.collection.update_one(
            {"parent_id": parent_id},
            {"$pull": {"linked_students": {"mobile_number": student_mobile}}}
        )

        # If parent has no more linked students, remove the parent entry
        updated_parent_entry = self.collection.find_one({"parent_id": parent_id}, {"linked_students": 1})

        if not updated_parent_entry or not updated_parent_entry.get("linked_students"):
            self.collection.delete_one({"parent_id": parent_id})

        return {"message": "✅ Student unlinked successfully"}

    def get_linked_students(self, parent_mobile):
        """Retrieve all linked students for a parent using parent's mobile number."""
        if not self.is_valid_mobile(parent_mobile):
            return {"error": "❌ Invalid mobile number format"}

        parent = self.get_parent_by_mobile(parent_mobile)
        if not parent:
            return {"error": "❌ Parent not found"}

        parent_id = str(parent["_id"])

        parent_entry = self.collection.find_one({"parent_id": parent_id}, {"linked_students": 1})

        if not parent_entry or "linked_students" not in parent_entry or not parent_entry["linked_students"]:
            return {"error": "⚠️ No linked students found"}

        linked_students = []
        for student in parent_entry["linked_students"]:
            student_details = self.registration_collection.find_one(
                {"mobile_number": student["mobile_number"], "role": {"$regex": "^student$", "$options": "i"}},
                {"_id": 1, "full_name": 1, "mobile_number": 1}
            )

            if student_details:
                linked_students.append({
                    "user_id": str(student_details["_id"]),  # Ensure user_id is included
                    "full_name": student_details["full_name"],
                    "mobile_number": student_details["mobile_number"]
                })

        return {"linked_students": linked_students} if linked_students else {"error": "⚠️ No linked students found"}
