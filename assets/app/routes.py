#Gives Api end point
import base64
from io import BytesIO
from flask import request, jsonify
from PIL import Image
from . import model_utils

# Load the model, class indices, and allergen info
model = model_utils.load_trained_model()
class_indices = model_utils.load_class_indices()
indices_class = {v: k for k, v in class_indices.items()}
allergen_info = model_utils.load_allergen_info()

def register_routes(app):
    @app.route('/')
    def home():
        return jsonify({'message': 'Welcome to the Food Allergen Detection API'})

    @app.route('/api/predict', methods=['POST'])
    def predict():
        data = request.get_json()
        image_data = data['image']
        
        try:
            # Decode the image data
            image_data = image_data.split(',')[1]
            image_data = base64.b64decode(image_data)
            
            # Open and preprocess the image
            img = Image.open(BytesIO(image_data))
            img_array = model_utils.preprocess_image(img)
            
            # Predict the class and confidence
            predicted_class_label, predictions_with_labels = model_utils.predict_image(model, img_array, indices_class)
            
            # Calculate the highest confidence percentage
            max_confidence = max([float(conf.strip('%')) for _, conf in predictions_with_labels])
            
            if max_confidence < 35:
                response = {
                    'prediction': 'Food allergens not detected',
                    'allergen': '0',
                    'description': '0',
                    'confidence': predictions_with_labels
                }
            else:
                allergen = allergen_info[predicted_class_label]['allergen']
                description = allergen_info[predicted_class_label]['description']
                response = {
                    'prediction': predicted_class_label,
                    'allergen': allergen,
                    'description': description,
                    'confidence': predictions_with_labels
                }
            
            return jsonify(response)
        
        except Exception as e:
            return jsonify({'error': f'Image processing error: {str(e)}'}), 400

