from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["course_app"]

# Collection for storing tests
tests_collection = db["tests"]

# Collection for storing user purchases
purchases_collection = db["purchases"]

# Function to create a test with images & documents
def create_test(title, description, price, images=None, documents=None):
    test = {
        "title": title,
        "description": description,
        "price": price,
        "images": images if images else [],  # Store image paths
        "documents": documents if documents else [],  # Store document paths
    }
    tests_collection.insert_one(test)

# Uncomment to add test data with sample images and documents
# create_test("Math Test", "Basic Algebra Questions", 100, ["uploads/math1.jpg"], ["uploads/algebra.pdf"])
# create_test("Science Test", "Physics and Chemistry", 150, ["uploads/science1.jpg"], ["uploads/physics.pdf"])
