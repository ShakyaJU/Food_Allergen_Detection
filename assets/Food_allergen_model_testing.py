import json
import os
import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow.keras.models import load_model
from PIL import Image
import matplotlib.pyplot as plt
# Load the trained model
model_path = 'final_model_after_additional_training.keras'
model = load_model(model_path)

# Load the class indices
class_indices_path = 'class_indices.json'
with open(class_indices_path, 'r') as f:
    class_indices = json.load(f)

# Reverse the class indices dictionary to map index to class label
indices_class = {v: k for k, v in class_indices.items()}

# Load annotations
def load_annotations(annotation_file):
    annotations = pd.read_csv(annotation_file)
    annotations['class'] = annotations['class'].apply(lambda x: x.strip().lower().replace(' ', '_'))
    return annotations.to_dict('records')

# Paths
test_dir = '../dataset/test'
test_annotations = load_annotations(os.path.join(test_dir, '_annotations.csv'))

# Define your custom data generator
class CustomDataGenerator(tf.keras.utils.Sequence):
    def __init__(self, annotations, image_dir, batch_size, class_indices=None):
        self.annotations = annotations
        self.image_dir = image_dir
        self.batch_size = batch_size
        self.class_indices = class_indices
        self.n_classes = len(class_indices)
        print(f"Initialized generator with {len(self.annotations)} annotations")

    def __len__(self):
        return int(np.ceil(len(self.annotations) / self.batch_size))

    def __getitem__(self, index):
        batch_annotations = self.annotations[index * self.batch_size:(index + 1) * self.batch_size]
        print(f"Processing batch {index} with {len(batch_annotations)} annotations")
        images = []
        labels = []
        for annotation in batch_annotations:
            image_path = os.path.join(self.image_dir, annotation['filename'])
            print(f"Attempting to load image: {image_path}")
            try:
                image = Image.open(image_path).convert('RGB')
                image = image.resize((416, 416))
                image = np.array(image) / 255.0
                if image.shape == (416, 416, 3):
                    images.append(image)
                    labels.append(self.class_indices[annotation['class']])
                else:
                    print(f"Warning: Image shape {image.shape} is not (416, 416, 3)")
            except Exception as e:
                print(f"Error loading image {image_path}: {e}")
        
        print(f"Successfully loaded {len(images)} images out of {len(batch_annotations)} annotations")
        if len(images) == 0:
            print("Warning: No valid images in this batch")
            return np.array([]), np.array([])
        
        images = np.array(images)
        labels = tf.keras.utils.to_categorical(labels, num_classes=self.n_classes)
        return images, labels

    def on_epoch_end(self):
        np.random.shuffle(self.annotations)

# Create data generator
batch_size = 32
test_generator = CustomDataGenerator(test_annotations, test_dir, batch_size, class_indices=class_indices)

# Define the evaluation step
@tf.function
def valid_step(images, labels):
    predictions = model(images, training=False)
    loss = tf.keras.losses.categorical_crossentropy(labels, predictions)
    return loss, predictions

# Evaluate the model on the test dataset
test_losses = []
test_accuracies = []
true_labels = []
predicted_labels = []

for i in range(len(test_generator)):
    images, labels = test_generator[i]
    if images.shape[0] == 0:
        print(f"Warning: Empty batch encountered in batch {i}.")
        continue
    
    test_loss, test_predictions = valid_step(images, labels)
    test_losses.append(tf.reduce_mean(test_loss).numpy())
    test_accuracies.append(tf.reduce_mean(tf.keras.metrics.categorical_accuracy(labels, test_predictions)).numpy())
    
    true_labels.extend(np.argmax(labels, axis=1))
    predicted_labels.extend(np.argmax(test_predictions, axis=1))

# Calculate overall metrics
overall_loss = np.mean(test_losses)
overall_accuracy = np.mean(test_accuracies)

# Create confusion matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(true_labels, predicted_labels)

# Visualizations
plt.figure(figsize=(20, 10))

# Plot loss
plt.figure(figsize=(10, 5))
plt.plot(test_losses)
plt.title('Test Loss per Batch')
plt.xlabel('Batch')
plt.ylabel('Loss')
plt.savefig('test_loss.png')
plt.close()

# Plot accuracy
plt.figure(figsize=(10, 5))
plt.plot(test_accuracies)
plt.title('Test Accuracy per Batch')
plt.xlabel('Batch')
plt.ylabel('Accuracy')
plt.savefig('test_accuracy.png')
plt.close()

# Plot confusion matrix
plt.figure(figsize=(12, 10))
plt.imshow(cm, interpolation='nearest', cmap=plt.cm.Blues)
plt.title('Confusion Matrix')
plt.colorbar()
tick_marks = np.arange(len(class_indices))
plt.xticks(tick_marks, class_indices.keys(), rotation=90)
plt.yticks(tick_marks, class_indices.keys())
plt.xlabel('Predicted Label')
plt.ylabel('True Label')
plt.tight_layout()
plt.savefig('confusion_matrix.png')
plt.close()

# Plot overall metrics
plt.figure(figsize=(8, 6))
plt.bar(['Loss', 'Accuracy'], [overall_loss, overall_accuracy])
plt.title('Overall Metrics')
plt.ylim(0, 1)
plt.savefig('overall_metrics.png')
plt.close()

# Print overall metrics
print(f'Overall Test Loss: {overall_loss}')
print(f'Overall Test Accuracy: {overall_accuracy}')

# Print classification report
from sklearn.metrics import classification_report
print("\nClassification Report:")
print(classification_report(true_labels, predicted_labels, target_names=list(class_indices.keys())))
