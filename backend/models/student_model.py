from bson import ObjectId

class StudentModel:
    def __init__(self, db):
        self.students = db.registration  # Student data stored in `registration`
        self.purchases = db.purchases  # Purchased courses stored in `purchase` collection

    def get_student_by_id(self, user_id):
        """
        Fetch student details from `registration` and purchased courses from `purchase` collection.
        """
        try:
            # Fetch student details from `registration`
            student = self.students.find_one(
                {"_id": ObjectId(user_id), "role": "student"},
                {"full_name": 1, "mobile_number": 1}
            )
            if not student:
                return None  # No student found

            # Fetch purchased courses from `purchase` collection
            purchased_courses = list(self.purchases.find(
                {"student_id": ObjectId(user_id)}, {"_id": 0, "course_id": 1, "purchase_date": 1}
            ))

            return {
                "user_id": str(user_id),
                "full_name": student.get("full_name", "N/A"),
                "mobile_number": student.get("mobile_number", "N/A"),
                "purchased_courses": purchased_courses,  # Purchased courses now fetched separately
            }
        except Exception as e:
            print(f"Error fetching student: {e}")
            return None  # Handle invalid ObjectId format gracefully

    def get_all_student_ids(self):
        """
        Fetch all student IDs from `registration` collection where role is 'student'.
        """
        students = self.students.find({"role": "student"}, {"_id": 1})
        return [{"user_id": str(student["_id"])} for student in students]
