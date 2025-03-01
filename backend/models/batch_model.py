from bson.objectid import ObjectId
from config import db  # ✅ Import the initialized PyMongo instance

def get_batches_collection():
    """Returns the MongoDB collection for batches"""
    return db["batches"]  # ✅ Use `db.db` to access the collection

def add_batch(data):
    """ Adds a new batch to MongoDB """
    batch = {
        'title': data['title'],
        'instructor': data['instructor'],
        'timing': data['timing'],
        'date': data['date'],
        'category': data['category'],
        'price': data['price']
    }
    batch_id = get_batches_collection().insert_one(batch).inserted_id
    return str(batch_id)

def get_all_batches():
    """ Retrieves all batches from MongoDB """
    batches = list(get_batches_collection().find())
    for batch in batches:
        batch['_id'] = str(batch['_id'])  # Convert ObjectId to string
    return batches

def get_batch_by_id(batch_id):
    """ Finds a batch by its ID """
    batch = get_batches_collection().find_one({'_id': ObjectId(batch_id)})
    if batch:
        batch['_id'] = str(batch['_id'])
    return batch

def update_batch(batch_id, update_data):
    """ Updates a batch by its ID """
    updated_batch = get_batches_collection().find_one_and_update(
        {'_id': ObjectId(batch_id)},
        {'$set': update_data},
        return_document=True
    )
    if updated_batch:
        updated_batch['_id'] = str(updated_batch['_id'])
    return updated_batch

def delete_batch(batch_id):
    """ Deletes a batch by its ID """
    result = get_batches_collection().delete_one({'_id': ObjectId(batch_id)})
    return result.deleted_count > 0
