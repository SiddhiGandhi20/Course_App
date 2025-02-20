import os
import socket
from flask import Blueprint, request, jsonify
from werkzeug.utils import secure_filename
from models.course_model import add_course, get_all_courses, get_course_by_id, update_course, delete_course
from config import db  # ✅ Import `db` from `config.py`

course_bp = Blueprint('courses', __name__)  # ✅ Use `course_bp` consistently

# Get the local IP address dynamically
def get_local_ip():
    hostname = socket.gethostname()
    return socket.gethostbyname(hostname)

LOCAL_IP = get_local_ip()
BASE_URL = f"http://{LOCAL_IP}:5000/uploads"

# File upload configuration
UPLOAD_FOLDER = "uploads"
IMAGE_FOLDER = os.path.join(UPLOAD_FOLDER, "images")
VIDEO_FOLDER = os.path.join(UPLOAD_FOLDER, "videos")
DOCUMENT_FOLDER = os.path.join(UPLOAD_FOLDER, "documents")

# Ensure directories exist
os.makedirs(IMAGE_FOLDER, exist_ok=True)
os.makedirs(VIDEO_FOLDER, exist_ok=True)
os.makedirs(DOCUMENT_FOLDER, exist_ok=True)

ALLOWED_IMAGE_EXTENSIONS = {"png", "jpg", "jpeg", "gif"}
ALLOWED_VIDEO_EXTENSIONS = {"mp4", "avi", "mov"}
ALLOWED_DOCUMENT_EXTENSIONS = {"pdf", "docx", "txt"}

def allowed_file(filename, allowed_extensions):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in allowed_extensions

@course_bp.route('/courses', methods=['POST'])
def create_course():
    """API endpoint to add a new course with file uploads"""
    data = request.form.to_dict()
    files = request.files

    # Validate required fields
    required_fields = ["title", "instructor", "description", "category", "language", "duration", "price", "is_private", "has_certificate", "is_online", "rating", "timing", "date"]
    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"Missing required field: {field}"}), 400

    # Process image upload
    image_url = None
    if 'image' in files and allowed_file(files['image'].filename, ALLOWED_IMAGE_EXTENSIONS):
        image = files['image']
        filename = secure_filename(image.filename)
        image_path = os.path.join(IMAGE_FOLDER, filename)
        image.save(image_path)
        image_url = f"{BASE_URL}/images/{filename}"

    # Process video uploads
    video_urls = []
    if 'videos' in files:
        for video in request.files.getlist('videos'):
            if allowed_file(video.filename, ALLOWED_VIDEO_EXTENSIONS):
                filename = secure_filename(video.filename)
                video_path = os.path.join(VIDEO_FOLDER, filename)
                video.save(video_path)
                video_urls.append(f"{BASE_URL}/videos/{filename}")

    # Process document uploads
    notes_urls = []
    if 'documents' in files:
        for doc in request.files.getlist('documents'):
            if allowed_file(doc.filename, ALLOWED_DOCUMENT_EXTENSIONS):
                filename = secure_filename(doc.filename)
                doc_path = os.path.join(DOCUMENT_FOLDER, filename)
                doc.save(doc_path)
                notes_urls.append(f"{BASE_URL}/documents/{filename}")

    # Prepare course data
    course_data = {
        'title': data['title'],
        'instructor': data['instructor'],
        'description': data['description'],
        'category': data['category'],
        'language': data['language'],
        'duration': data['duration'],
        'price': float(data['price']),
        'is_private': data['is_private'].lower() == 'true',
        'has_certificate': data['has_certificate'].lower() == 'true',
        'is_online': data['is_online'].lower() == 'true',
        'rating': float(data['rating']),
        'tags': data.get('tags', '').split(',') if 'tags' in data else [],
        'image_path': image_url,
        'video_paths': video_urls,
        'notes_paths': notes_urls,
        'learning_points': data.get('learning_points', '').split(',') if 'learning_points' in data else [],
        'timing': data['timing'],
        'date': data['date']
    }

    course_id = add_course(course_data)  # ✅ Use correct function call
    return jsonify({'message': 'Course added successfully!', 'course_id': course_id}), 201

@course_bp.route('/courses', methods=['GET'])
def fetch_courses():
    """API endpoint to get all courses"""
    courses = get_all_courses()  # ✅ Use correct function call
    return jsonify(courses), 200

@course_bp.route('/courses/<string:course_id>', methods=['GET'])
def fetch_course_by_id(course_id):
    """API endpoint to get a course by ID"""
    course = get_course_by_id(course_id)  # ✅ Use correct function call
    if not course:
        return jsonify({'error': 'Course not found'}), 404
    return jsonify(course), 200

@course_bp.route('/courses/<string:course_id>', methods=['PUT'])
def modify_course(course_id):
    """API endpoint to update a course by ID"""
    data = request.json
    if not data:
        return jsonify({'error': 'Missing update data'}), 400

    updated = update_course(course_id, data)  # ✅ Use correct function call
    if not updated:
        return jsonify({'error': 'Course not found'}), 404
    return jsonify({'message': 'Course updated successfully!'}), 200

@course_bp.route('/courses/<string:course_id>', methods=['DELETE'])
def remove_course(course_id):
    """API endpoint to delete a course by ID"""
    success = delete_course(course_id)  # ✅ Use correct function call
    if not success:
        return jsonify({'error': 'Course not found'}), 404
    return jsonify({'message': 'Course deleted successfully!'}), 200

# Serve uploaded files
@course_bp.route('/uploads/<path:filename>')
def serve_uploads(filename):
    """Serves uploaded files via HTTP"""
    return send_from_directory(UPLOAD_FOLDER, filename)
