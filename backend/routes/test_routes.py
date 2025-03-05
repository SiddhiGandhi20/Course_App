from flask import Blueprint, jsonify, request
from bson import ObjectId
from models.test_model import tests_collection, purchases_collection

test_routes = Blueprint("test_routes", __name__)

# 🚀 Fetch all tests with unlock status
@test_routes.route('/get-tests/<user_id>', methods=['GET'])
def get_tests(user_id):
    user_purchases = purchases_collection.find_one({"user_id": user_id}) or {"tests": []}
    unlocked_tests = set(user_purchases.get("tests", []))

    tests = list(tests_collection.find({}, {"_id": 1, "title": 1, "description": 1, "price": 1}))

    for test in tests:
        test["_id"] = str(test["_id"])  # Convert ObjectId to string
        test["isUnlocked"] = test["_id"] in unlocked_tests

    return jsonify(tests), 200

# 🚀 Handle test payment and unlock access
@test_routes.route('/pay-test', methods=['POST'])
def pay_test():
    data = request.json
    test_id = data.get("testId")
    user_id = data.get("userId")

    if not test_id or not user_id:
        return jsonify({"message": "Missing testId or userId"}), 400

    # Simulating successful payment (Replace with Stripe/Razorpay integration)
    payment_success = True

    if payment_success:
        purchases_collection.update_one(
            {"user_id": user_id},
            {"$addToSet": {"tests": test_id}},
            upsert=True
        )
        return jsonify({"message": "Test Unlocked"}), 200

    return jsonify({"message": "Payment Failed"}), 400

# 🚀 Add a new test
@test_routes.route('/add-test', methods=['POST'])
def add_test():
    data = request.json
    title = data.get("title")
    description = data.get("description")
    price = data.get("price")

    if not title or not description or not price:
        return jsonify({"message": "Missing required fields"}), 400

    test = {
        "title": title,
        "description": description,
        "price": price
    }

    tests_collection.insert_one(test)
    return jsonify({"message": "Test added successfully!"}), 201
