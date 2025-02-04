<h1 align="center">Food Allergen Detection</h1>

<h3 align="center">Leveraging CNN for allergen detection in food to protect the consumers. 📱</h3>

---

## 📌 Project Overview
For my final year undergraduate project, I developed a **Food Allergen Detection** mobile application designed to help individuals, specifically those with food allergies, identify potential allergens in food items. This app leverages **Convolutional Neural Networks (CNN)**, to analyze food images and detect allergens in real-time. Users can simply capture/upload a food image to receive instant insights about possible allergens, empowering them to make informed and safe dietary choices. This project aims to improve food awareness, accessibility, and safety for individuals with dietary restrictions.

🔹 **Key Features:**
- Capture or upload food images for allergen detection in **real-time**
- User-friendly **Flutter-based** interface
- Machine Learning model for efficient prediction

🚀 **Technologies Used:**
- **Frontend:** Flutter (Dart)
- **Backend:** Flask (Python)
- **Machine Learning:** CNN (TensorFlow/Keras)

---

## 📱 Application Screenshots

<p align="center">
  <img src="./FAD Screenshots/Main Interface.png" alt="Main Page" width="300" height="600">
  <img src="./FAD Screenshots/Upload Image Predict.png" alt="Upload Image" width="300" height="600">
  <img src="./FAD Screenshots/Real-time prediction using camera.png" alt="Real-time Detection" width="300" height="600">
</p>

---

## 🎬 App Demo

Feel free to watch the app demonstration by clicking 👉<a href="https://drive.google.com/file/d/1LfWz18sNSftN4lrHOACaU-CJPvDKuOcW/view?usp=sharing"> here </a>

---

## 🔬 Prediction Output

The application analyzes food images and provides **four key outputs**:

- 📝 **Description:** Clear, human-readable explanation of the detected food item.
- 📌 **Predicted Class:** Identified food category (e.g., egg, pizza, milk).
- ⚠️ **Allergen:** Specific allergenic component present (e.g., Ovomucoid, Lactose, Histamine).
- ✅ **Detection Status:** Alert message indicating whether an allergen is detected.

<p align="center">
  <img src="./FAD Screenshots/Outputs.png" alt="Detection Results" width="300" height="600">
  <img src="./FAD Screenshots/No allergen detected.png" alt="No Allergen Detected" width="300" height="600">
</p>

---

## 📊 Academic Poster

<p align="center">
  <img src="./FAD Screenshots/2146510_Poster.png" alt="Academic Poster" width="1000">
</p>

---

## 🖥️ UML Diagrams

<table>
  <tr>
    <td align="center">
      <img src="./FAD Screenshots/Use Case Diagram FAD.jpg" alt="Use Case Diagram" width="500">
      <br><b>Use Case Diagram</b>
      <p align="justify">
        The Use Case Diagram illustrates user interactions with the application. Users can **capture or upload a food image**, analyze allergens, and receive instant results.
      </p>
    </td>
    <td align="center">
      <img src="./FAD Screenshots/FAD Activity Diagram.jpg" alt="Activity Diagram" width="500">
      <br><b>Activity Diagram</b>
      <p align="justify">
        The Activity Diagram showcases the workflow of the app, from launching and image input to AI processing and allergen detection.
      </p>
    </td>
  </tr>
</table>

---

## 🛠️ Installation & Setup

### 1️⃣ Clone the Repository
```bash
   git clone https://github.com/ShakyaJU/Food_Allergen_Detection.git
```

### 2️⃣ Set Up the Virtual Environment
```bash
   cd assets
   python -m venv venv
   venv\Scripts\activate  # Windows
```

### 3️⃣ Start the Backend
```bash
   python main.py
```
🔹 If required or asked, install dependencies:
```bash
    pip install <necessary_package_name>
```

### 4️⃣ Connect Your Mobile Device
- Enable **USB Debugging**
- Connect your phone via **USB cable**

### 5️⃣ Update API Service
- Run the following to get your **IPv4 Address**:
```bash
   ipconfig   # For Windows
```
- Replace the API URL in **api_service.dart** from flutter project:
```dart
   http://<Your-IPv4-Address>:8000
```

### 6️⃣ Install Dependencies
```bash
   flutter pub get
```

### 7️⃣ Run the App 🚀
```bash
   flutter run
```

---

## 📂 Project Structure

<pre>
Food-Allergen-Detection/
├── assets/                         # Backend files (Python, ML models, etc.)
│   ├── images/                     # Images of the trained model test output.
│   ├── venv/                       # Virtual environment for Python dependencies
│   ├── model/                      # Folder for machine learning models
│   │   ├── final_model_after_additional_training.keras  # Trained Model (273MB) available here👉 <a href="https://drive.google.com/file/d/1UfszdRCSBm7__OJUBeO5fEK0dMaapdnV/view?usp=sharing">Download</a>
│   │   ├── class_indices.json      # Class-to-index mapping for predictions
│   │   ├── class_allergen_map.json # Mapping of classes to allergen info
│   ├── main.py                     # Python backend entry point (Flask API)
│   ├── routes.py                   # API routes (for prediction and home endpoints)
│   ├── model_utils.py              # Utility functions for loading model, preprocessing, etc.
│
├── frontend/                       # Flutter app
│   ├── lib/
│   │   ├── main.dart               # Main Flutter app
│   │   ├── screens/
│   │   │   ├── home_screen.dart    # Home page (Main interface of the app)
│   │   │   ├── upload_screen.dart  # Image upload screen for uploading and processing food images
│   │   │   ├── camera_screen.dart  # Screen for capturing and processing food images in real-time
│   │   ├── services/
│   │   │   ├── api_service.dart    # API service for communicating with backend
│   ├── assets/                     # UI assets
└── pubspec.yaml                    # Flutter project configuration file
</pre>

---

## 📜 Thesis Report 📑
For an in-depth understanding of the **research, methodology, AI model, implementation and literature findings**, check out my full thesis report:
👉 **[Thesis Report](https://drive.google.com/file/d/1ySyLzoq-AHXGrASVhDfHyeHaIzmRi5i2/view?usp=sharing)**

---

## 🎯 Future Enhancements
✅ **Improve model accuracy** using more datasets 📈  
✅ **Multi-language support** for diverse & broader accessibility 🌍  
 
---

## ⭐ Like This Project?
Give it a ⭐ **[Star](https://github.com/ShakyaJU/Food_Allergen_Detection)** on GitHub and contribute! 🚀
