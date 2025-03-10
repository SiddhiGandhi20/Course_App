import os

from flask import Flask, send_from_directory
from flask_pymongo import PyMongo
from flask_cors import CORS
from routes.user_routes import user_routes
from routes.course_routes import course_bp
from routes.batch_routes import batch_bp
from routes.test_routes import test_routes 
from routes.student_routes import student_routes
from routes.parents_routes import parent_routes # Import test routes

from config import Config




app = Flask(__name__)

# Load configuration
app.config.from_object(Config)

# Initialize MongoDB
mongo = PyMongo(app)

# Enable CORS for all routes
CORS(app)
# socketio = SocketIO(app, cors_allowed_origins="*")


# Register Blueprints
app.register_blueprint(user_routes, url_prefix='/api')
app.register_blueprint(course_bp, url_prefix='/api')
app.register_blueprint(batch_bp, url_prefix="/api")
app.register_blueprint(test_routes, url_prefix='/api')
app.register_blueprint(student_routes,url_prefix="/api")
app.register_blueprint(parent_routes,url_prefix="/api")




# Upload folder path
UPLOAD_FOLDER = "uploads"
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ensure the uploads folder exists
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/uploads/<path:filename>')
def serve_uploaded_file(filename):
    """Serves uploaded files via HTTP."""
    return send_from_directory(UPLOAD_FOLDER, filename)

# def get_ip_address():
#     """Gets the dynamic local IP address of the machine."""
#     hostname = socket.gethostname()
#     return socket.gethostbyname(hostname)

if __name__ == '__main__':
    # local_ip = get_ip_address()
    # print(f"Server running at: http://{local_ip}:5000")
    app.run(debug=True, host='0.0.0.0', port=5000)