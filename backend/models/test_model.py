from bson import ObjectId
from pymongo import MongoClient

# Initialize MongoDB client and database
client = MongoClient("mongodb://localhost:27017/")
db = client["course_app"]

# Collections for storing user registration, tests, and purchases
registration_collection = db["registration"]
tests_collection = db["tests"]
purchases_collection = db["purchases"]

# Function to get user ID from registration by mobile number
def get_user_id_by_mobile(mobile_number):
    print(f"Searching for user with mobile number: {mobile_number}")  # Debugging line
    user = registration_collection.find_one({"mobile_number": mobile_number}, {"_id": 0, "user_id": 1})
    
    # Print the user to check the result
    if user:
        print(f"User found: {user}")  # Debugging line
    else:
        print(f"No user found with mobile number: {mobile_number}")  # Debugging line
    
    # Return the user_id if found, otherwise return None
    return user["user_id"] if user else None

# Function to get purchased tests for a specific user ID
def get_purchased_tests(mobile_number):
    print(f"Fetching purchased tests for mobile number: {mobile_number}")  # Debugging line
    
    # Step 1: Get the user ID from the registration collection based on mobile number
    user_id = get_user_id_by_mobile(mobile_number)
    
    if not user_id:
        print("❌ User not found")  # Debugging line
        return {"message": "❌ User not found with this mobile number"}
    
    # Step 2: Retrieve the user's purchased tests based on user_id from the purchases collection
    user_purchases = purchases_collection.find_one({"user_id": user_id}, {"_id": 0, "tests": 1})
    
    if not user_purchases or not user_purchases.get("tests"):
        print("❌ No purchased tests found")  # Debugging line
        return {"message": "❌ No purchased tests found"}
    
    # Step 3: Convert the test IDs to ObjectId if they're not already in ObjectId format
    test_ids = [ObjectId(test_id) if not isinstance(test_id, ObjectId) else test_id for test_id in user_purchases["tests"]]
    
    # Step 4: Fetch the details of the purchased tests from the tests collection
    purchased_tests = list(
        tests_collection.find(
            {"_id": {"$in": test_ids}}  # Query using the list of ObjectIds
        )
    )
    
    # Step 5: Convert ObjectId to string and format the test details
    for test in purchased_tests:
        test["_id"] = str(test["_id"])  # Convert ObjectId to string
    
    return purchased_tests

# Sample usage: Replace with actual mobile number
mobile_number = "1234567890"  # Modify this to the actual mobile number
purchased_tests = get_purchased_tests(mobile_number)

# Print the fetched purchased tests
if isinstance(purchased_tests, list):  # If it's a list of tests
    for test in purchased_tests:
        print(test)
else:  # If it's an error message
    print(purchased_tests["message"])
