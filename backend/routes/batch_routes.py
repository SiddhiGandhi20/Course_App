from flask import Blueprint, request, jsonify
from models.batch_model import add_batch, get_all_batches, get_batch_by_id, update_batch, delete_batch

batch_bp = Blueprint("batch_bp", __name__)

# Add a new batch
@batch_bp.route("/batches", methods=["POST"])
def create_batch():
    data = request.json
    required_fields = ["title", "instructor", "timing", "date", "category", "price"]

    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    batch_id = add_batch(data)
    return jsonify({"message": "Batch added successfully", "batch_id": batch_id}), 201


# Get all batches
@batch_bp.route("/batches", methods=["GET"])
def fetch_batches():
    batches = get_all_batches()
    return jsonify(batches), 200


# Get a single batch by ID
@batch_bp.route("/batches/<batch_id>", methods=["GET"])
def fetch_batch(batch_id):
    batch = get_batch_by_id(batch_id)
    if batch:
        return jsonify(batch), 200
    return jsonify({"error": "Batch not found"}), 404


# Update a batch by ID
@batch_bp.route("/batches/<batch_id>", methods=["PUT"])
def modify_batch(batch_id):
    update_data = request.json
    updated_batch = update_batch(batch_id, update_data)
    if updated_batch:
        return jsonify({"message": "Batch updated successfully", "batch": updated_batch}), 200
    return jsonify({"error": "Batch not found or no changes made"}), 404


# Delete a batch by ID
@batch_bp.route("/batches/<batch_id>", methods=["DELETE"])
def remove_batch(batch_id):
    if delete_batch(batch_id):
        return jsonify({"message": "Batch deleted successfully"}), 200
    return jsonify({"error": "Batch not found"}), 404
