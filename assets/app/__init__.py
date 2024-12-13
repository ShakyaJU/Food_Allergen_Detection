
from flask import Flask
from flask_cors import CORS

def create_app():
    app = Flask(__name__)
    
    # Allow CORS for the specific origin
    CORS(app, origins='*')

    # Import and register routes after the app is created to avoid circular imports
    with app.app_context():
        from .routes import register_routes
        register_routes(app)

    return app

