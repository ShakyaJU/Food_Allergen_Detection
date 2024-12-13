
import os
os.environ['PYTHONUTF8'] = '1'

import json
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras import layers, models, Input
from tensorflow.keras.applications import ResNet50V2
from tensorflow.keras.callbacks import ReduceLROnPlateau, EarlyStopping, ModelCheckpoint
from tensorflow.keras.utils import Sequence
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import pandas as pd
import numpy as np
from PIL import Image

# Define the correct class indices
class_indices = {
    'egg': 0, 'whole_egg_boiled': 1, 'milk': 2, 'icecream': 3, 'cheese': 4,
    'milk_based_beverage': 5, 'chocolate': 6, 'non_milk_based_beverage': 7,
    'cooked_meat': 8, 'raw_meat': 9, 'alcohol': 10, 'alcohol_glass': 11,
    'spinach': 12, 'avocado': 13, 'eggplant': 14, 'blueberry': 15,
    'blackberry': 16, 'strawberry': 17, 'pineapple': 18, 'capsicum': 19,
    'mushroom': 20, 'dates': 21, 'almond': 22, 'pistachio': 23, 'tomato': 24,
    'roti': 25, 'pasta': 26, 'bread': 27, 'bread_loaf': 28, 'pizza': 29
}

# Function to load annotations
def load_annotations(annotation_file):
    annotations = pd.read_csv(annotation_file)
    annotations['class'] = annotations['class'].apply(lambda x: x.strip().lower().replace(' ', '_'))
    return annotations.to_dict('records')

# Load annotations
train_annotations = load_annotations('../dataset/train/_annotations.csv')
test_annotations = load_annotations('../dataset/test/_annotations.csv')
valid_annotations = load_annotations('../dataset/valid/_annotations.csv')

# Custom Data Generator
class CustomDataGenerator(Sequence):
    def __init__(self, annotations, image_dir, batch_size, augment=False, class_indices=None):
        self.annotations = annotations
        self.image_dir = image_dir
        self.batch_size = batch_size
        self.augment = augment
        self.class_indices = class_indices
        self.n_classes = len(class_indices)

        self.datagen = ImageDataGenerator(
            rotation_range=20,
            width_shift_range=0.2,
            height_shift_range=0.2,
            shear_range=0.15,  # Horizontal shear
            zoom_range=0.2,
            horizontal_flip=True,
            fill_mode='nearest'
        ) if self.augment else None

    def __len__(self):
        return int(np.ceil(len(self.annotations) / self.batch_size))

    def __getitem__(self, index):
        batch_annotations = self.annotations[index * self.batch_size:(index + 1) * self.batch_size]
        images = []
        labels = []
        for annotation in batch_annotations:
            image_path = os.path.join(self.image_dir, annotation['filename'])
            image = Image.open(image_path).convert('RGB')
            image = image.resize((416, 416))
            image = np.array(image) / 255.0
            images.append(image)
            labels.append(self.class_indices[annotation['class']])
        images = np.array(images)
        labels = tf.keras.utils.to_categorical(labels, num_classes=self.n_classes)

        if self.augment:
            augmented_data = self.datagen.flow(images, labels, batch_size=self.batch_size)
            images, labels = next(augmented_data)

            # Additional rotations
            for i in range(images.shape[0]):
                if np.random.rand() < 0.25:
                    images[i] = np.rot90(images[i], 1)
                elif np.random.rand() < 0.25:
                    images[i] = np.rot90(images[i], 2)
                elif np.random.rand() < 0.25:
                    images[i] = np.rot90(images[i], 3)

        return images, labels

    def on_epoch_end(self):
        np.random.shuffle(self.annotations)

# Paths
train_dir = '../dataset/train'
valid_dir = '../dataset/valid'
test_dir = '../dataset/test'

# Create custom data generators
batch_size = 32  # Increased batch size to manage memory
train_generator = CustomDataGenerator(train_annotations, train_dir, batch_size, augment=True, class_indices=class_indices)
valid_generator = CustomDataGenerator(valid_annotations, valid_dir, batch_size, class_indices=class_indices)
test_generator = CustomDataGenerator(test_annotations, test_dir, batch_size, class_indices=class_indices)

# Print some information
print(f"Number of training samples: {len(train_generator.annotations)}")
print(f"Number of validation samples: {len(valid_generator.annotations)}")
print(f"Number of test samples: {len(test_generator.annotations)}")
print(f"Number of classes: {train_generator.n_classes}")
print(f"Class indices: {train_generator.class_indices}")

# Define the model using ResNet50V2 architecture with pre-trained weights
base_model = ResNet50V2(weights='imagenet', include_top=False, input_shape=(416, 416, 3))

# Since we're training from scratch, we can make the entire model trainable
base_model.trainable = True

inputs = Input(shape=(416, 416, 3))
x = base_model(inputs)
x = layers.GlobalAveragePooling2D()(x)
x = layers.Dense(128, activation='relu')(x)
x = layers.BatchNormalization()(x)
x = layers.Dropout(0.5)(x)
outputs = layers.Dense(train_generator.n_classes, activation='softmax')(x)

model = models.Model(inputs=inputs, outputs=outputs)

# Use a lower learning rate since we're training from scratch
optimizer = tf.keras.optimizers.Adam(learning_rate=0.0001)

# Compile the model
model.compile(optimizer=optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

# Add callbacks
reduce_lr = ReduceLROnPlateau(monitor='val_loss', factor=0.2, patience=3, min_lr=0.00001)
early_stopping = EarlyStopping(monitor='val_loss', patience=10, restore_best_weights=True)
model_checkpoint = ModelCheckpoint('/kaggle/working/food_allergen_model_epoch_{epoch:02d}_val_acc_{val_accuracy:.2f}.keras',
                                   save_best_only=True,
                                   monitor='val_accuracy',
                                   mode='max')

# Train the model
try:
    history = model.fit(
        train_generator,
        epochs=20,  # Keep max epochs to 20
        validation_data=valid_generator,
        callbacks=[reduce_lr, early_stopping, model_checkpoint]
    )

    # Evaluate the model
    test_loss, test_acc = model.evaluate(test_generator)
    print(f"Test accuracy: {test_acc}")

    # Save the final model
    model.save('final_model_after_additional_training.keras')

    # Save the class indices
    with open('class_indices.json', 'w') as f:
        json.dump(train_generator.class_indices, f)

    # Plot training history
    plt.figure(figsize=(12, 4))
    plt.subplot(1, 2, 1)
    plt.plot(history.history['accuracy'], label='Training Accuracy')
    plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
    plt.title('Model Accuracy')
    plt.xlabel('Epoch')
    plt.ylabel('Accuracy')
    plt.legend()

    plt.subplot(1, 2, 2)
    plt.plot(history.history['loss'], label='Training Loss')
    plt.plot(history.history['val_loss'], label='Validation Loss')
    plt.title('Model Loss')
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.legend()

    plt.tight_layout()
    plt.show()

except Exception as e:
    print(f"An error occurred during training: {e}")
