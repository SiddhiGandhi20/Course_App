from pymongo import MongoClient
from bson import ObjectId

class ParentModel:
    def __init__(self, db):
        self.collection = db.parents  # Parent collection

    def link_student(self, parent_id, student_id):
        """Link a student to a parent."""
        parent = self.collection.find_one({"_id": ObjectId(parent_id)})

        if parent:
            # Add student ID if not already linked
            if student_id not in parent.get("linked_students", []):
                self.collection.update_one(
                    {"_id": ObjectId(parent_id)},
                    {"$push": {"linked_students": student_id}}
                )
            return {"message": "Student linked successfully"}
        else:
            # Create a new parent document
            self.collection.insert_one({
                "_id": ObjectId(parent_id),
                "linked_students": [student_id]
            })
            return {"message": "Parent created and student linked successfully"}

    def get_linked_students(self, parent_id):
        """Retrieve all linked students for a parent."""
        parent = self.collection.find_one({"_id": ObjectId(parent_id)}, {"linked_students": 1})

        if not parent:
            return []

        return parent.get("linked_students", [])
