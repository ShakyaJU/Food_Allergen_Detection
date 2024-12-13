
import json
import numpy as np
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
from PIL import Image

def load_trained_model(model_path='final_model_after_additional_training.keras'):
    """Load and return the trained model."""
    return load_model(model_path)

def load_class_indices(class_indices_path='class_indices.json'):
    """Load class indices from a JSON file."""
    with open(class_indices_path, 'r') as f:
        class_indices = json.load(f)
    return class_indices

def load_allergen_info(allergen_info_path='class_allergen_map.json'):
    """Load allergen information from a JSON file."""
    with open(allergen_info_path, 'r') as f:
        allergen_info = json.load(f)
    return allergen_info

def preprocess_image(img, target_size=(416, 416)):
    """Resize, convert image to array, and normalize."""
    img = img.resize(target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = img_array / 255.0
    return img_array

def predict_image(model, img_array, indices_class):
    """Predict the class of the image and return predictions with labels."""
    predictions = model.predict(img_array)
    predicted_class_index = np.argmax(predictions, axis=1)[0]
    predicted_class_label = indices_class[predicted_class_index]
    
    # Create a list of tuples with class names and their respective confidence percentages
    predictions_with_labels = [
        (indices_class[i], f"{pred * 100:.2f}%") 
        for i, pred in enumerate(predictions[0])
    ]
    
    return predicted_class_label, predictions_with_labels

