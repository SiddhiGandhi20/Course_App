from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["course_app"]

# Collection for storing tests
tests_collection = db["tests"]

# Collection for storing user purchases
purchases_collection = db["purchases"]

# Function to create a test with images, documents & category
def create_test(title, description, price, category, images=None, documents=None):
    test = {
        "title": title,
        "description": description,
        "price": price,
        "category": category,  # 🆕 Added category
        "images": images if images else [],
        "documents": documents if documents else [],
    }
    tests_collection.insert_one(test)

# Uncomment to add test data with sample images and documents
# create_test("Math Test", "Basic Algebra Questions", 100, "5th Class", ["uploads/math1.jpg"], ["uploads/algebra.pdf"])
# create_test("Science Test", "Physics and Chemistry", 150, "6th Class", ["uploads/science1.jpg"], ["uploads/physics.pdf"])
