from bson.objectid import ObjectId
from config import db  # ✅ Import the initialized PyMongo instance

def get_courses_collection():
    """Returns the MongoDB collection for courses"""
    return db["courses"]  # ✅ FIXED: Use `db.db` instead of `db`

def add_course(data):
    """ Adds a new course to MongoDB """
    course = {
        'title': data['title'],
        'instructor': data['instructor'],
        'description': data['description'],
        'category': data['category'],
        'language': data['language'],
        'duration': data['duration'],
        'price': data['price'],
        'is_private': data['is_private'],
        'has_certificate': data['has_certificate'],
        'is_online': data['is_online'],
        'rating': data['rating'],
        'tags': data['tags'],
        'image_path': data.get('image_path'),
        'video_paths': data.get('video_paths', []),
        'notes_paths': data.get('notes_paths', []),
        'learning_points': data['learning_points'],
        'timing': data['timing'],
        'date': data['date']
    }
    course_id = get_courses_collection().insert_one(course).inserted_id
    return str(course_id)

def get_all_courses():
    """ Retrieves all courses from MongoDB """
    courses = list(get_courses_collection().find())
    for course in courses:
        course['_id'] = str(course['_id'])
    return courses

def get_course_by_id(course_id):
    """ Finds a course by its ID """
    course = get_courses_collection().find_one({'_id': ObjectId(course_id)})
    if course:
        course['_id'] = str(course['_id'])
    return course

def update_course(course_id, update_data):
    """ Updates a course by its ID """
    updated_course = get_courses_collection().find_one_and_update(
        {'_id': ObjectId(course_id)},
        {'$set': update_data},
        return_document=True
    )
    if updated_course:
        updated_course['_id'] = str(updated_course['_id'])
    return updated_course

def delete_course(course_id):
    """ Deletes a course by its ID """
    result = get_courses_collection().delete_one({'_id': ObjectId(course_id)})
    return result.deleted_count > 0
