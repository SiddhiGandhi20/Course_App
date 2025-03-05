from flask import Blueprint, jsonify, request, send_from_directory
from bson import ObjectId
from werkzeug.utils import secure_filename
import os
from models.test_model import tests_collection, purchases_collection

test_routes = Blueprint("test_routes", __name__)

UPLOAD_FOLDER = "uploads/tests/"
IMAGE_FOLDER = os.path.join(UPLOAD_FOLDER, "images/")
DOCUMENT_FOLDER = os.path.join(UPLOAD_FOLDER, "documents/")
os.makedirs(IMAGE_FOLDER, exist_ok=True)
os.makedirs(DOCUMENT_FOLDER, exist_ok=True)

# 🚀 Fetch all tests with unlock status
@test_routes.route('/get-tests/<user_id>', methods=['GET'])
def get_tests(user_id):
    user_purchases = purchases_collection.find_one({"user_id": user_id}) or {"tests": []}
    unlocked_tests = set(user_purchases.get("tests", []))

    tests = list(tests_collection.find({}, {"_id": 1, "title": 1, "description": 1, "price": 1, "images": 1, "documents": 1}))

    for test in tests:
        test["_id"] = str(test["_id"])  # Convert ObjectId to string
        test["isUnlocked"] = test["_id"] in unlocked_tests
        test["images"] = [request.host_url + "uploads/tests/images/" + img for img in test.get("images", [])]
        test["documents"] = [request.host_url + "uploads/tests/documents/" + doc for doc in test.get("documents", [])]

    return jsonify(tests), 200

# 🚀 Fetch a single test by ID
@test_routes.route('/get-test/<test_id>', methods=['GET'])
def get_test(test_id):
    test = tests_collection.find_one({"_id": ObjectId(test_id)})
    if not test:
        return jsonify({"message": "Test not found"}), 404

    test["_id"] = str(test["_id"])
    test["images"] = [request.host_url + "uploads/tests/images/" + img for img in test.get("images", [])]
    test["documents"] = [request.host_url + "uploads/tests/documents/" + doc for doc in test.get("documents", [])]

    return jsonify(test), 200

# 🚀 Add a new test with images & documents
@test_routes.route('/add-test', methods=['POST'])
def add_test():
    title = request.form.get("title")
    description = request.form.get("description")
    price = request.form.get("price")

    if not title or not description or not price:
        return jsonify({"message": "Missing required fields"}), 400

    image_filenames = []
    document_filenames = []

    if "images" in request.files:
        images = request.files.getlist("images")
        for image in images:
            filename = secure_filename(image.filename)
            image_path = os.path.join(IMAGE_FOLDER, filename)
            image.save(image_path)
            image_filenames.append(filename)

    if "documents" in request.files:
        documents = request.files.getlist("documents")
        for document in documents:
            filename = secure_filename(document.filename)
            doc_path = os.path.join(DOCUMENT_FOLDER, filename)
            document.save(doc_path)
            document_filenames.append(filename)

    test = {
        "title": title,
        "description": description,
        "price": price,
        "images": image_filenames,
        "documents": document_filenames,
    }

    result = tests_collection.insert_one(test)
    return jsonify({"message": "Test added successfully!", "test_id": str(result.inserted_id)}), 201

# 🚀 Update a test
@test_routes.route('/update-test/<test_id>', methods=['PUT'])
def update_test(test_id):
    data = request.form
    test = tests_collection.find_one({"_id": ObjectId(test_id)})

    if not test:
        return jsonify({"message": "Test not found"}), 404

    update_data = {}
    if "title" in data:
        update_data["title"] = data["title"]
    if "description" in data:
        update_data["description"] = data["description"]
    if "price" in data:
        update_data["price"] = data["price"]

    tests_collection.update_one({"_id": ObjectId(test_id)}, {"$set": update_data})
    return jsonify({"message": "Test updated successfully!"}), 200

# 🚀 Delete a test
@test_routes.route('/delete-test/<test_id>', methods=['DELETE'])
def delete_test(test_id):
    test = tests_collection.find_one({"_id": ObjectId(test_id)})

    if not test:
        return jsonify({"message": "Test not found"}), 404

    # Delete images
    for image in test.get("images", []):
        image_path = os.path.join(IMAGE_FOLDER, image)
        if os.path.exists(image_path):
            os.remove(image_path)

    # Delete documents
    for doc in test.get("documents", []):
        doc_path = os.path.join(DOCUMENT_FOLDER, doc)
        if os.path.exists(doc_path):
            os.remove(doc_path)

    tests_collection.delete_one({"_id": ObjectId(test_id)})
    return jsonify({"message": "Test deleted successfully!"}), 200

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

# 🚀 Serve Images
@test_routes.route('/uploads/tests/images/<filename>')
def get_image(filename):
    return send_from_directory(IMAGE_FOLDER, filename)

# 🚀 Serve Documents
@test_routes.route('/uploads/tests/documents/<filename>')
def get_document(filename):
    return send_from_directory(DOCUMENT_FOLDER, filename)

