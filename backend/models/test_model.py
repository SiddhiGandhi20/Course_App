from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["course_app"]

# Collection for storing tests
tests_collection = db["tests"]

# Collection for storing user purchases
purchases_collection = db["purchases"]

# Function to create a test (for initial setup)
def create_test(title, description, price):
    test = {
        "title": title,
        "description": description,
        "price": price,
    }
    tests_collection.insert_one(test)

# Uncomment to add some test data
# create_test("Math Test", "Basic Algebra Questions", 100)
# create_test("Science Test", "Physics and Chemistry", 150)
