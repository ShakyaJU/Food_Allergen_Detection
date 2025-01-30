<h1 align="center">Food Allergen Detection</h1>

<h3 style="text-align: justify;"> For my final year undergraduate project, I have developed a Food Allergen Detection mobile application to help individuals, specifically those with food allergies, identify potential allergens in food items. Through extensive research on food allergies and allergenic ingredients, I explored how technology can enhance food safety. This app leverages Convolutional Neural Networks (CNN), a deep learning approach for image processing, to analyze food images and detect allergens in real-time. Users can simply capture/upload a food image to receive instant insights about possible allergens, empowering them to make informed and safe dietary choices. This project aims to improve food awareness, accessibility, and safety for individuals with dietary restrictions.</h3>

## Application Screenshots:

<p align="center">
  <img src="./FAD Screenshots/Main Interface.png" alt="Main Page" width="300" height="600">
  <img src="./FAD Screenshots/Upload Image Predict.png" alt="Select Permissions" width="300" height="600">
  <img src="./FAD Screenshots/Real-time prediction using camera.png" alt="Using Camera" width="300" height="600">
  </p>

## Food Allergen Prediction:
The application analyzes food images and provides four key outputs: 
- **Description**:  A clear, human-readable explanation of the predicted food item.
- **Predicted Class**: The identified food category (e.g., egg, pizza, milk).
- **Allergen**: The specific allergenic component present in the food (e.g., Ovomucoid, Lactose, Histamine).
- **Detection Status**: A alert message indicating whether an allergen has been detected or not.

<p align="center">
  <img src="./FAD Screenshots/Outputs.png" alt="Main Page" width="300" height="600">
  <img src="./FAD Screenshots/No allergen detected.png" alt="Select Permissions" width="300" height="600">

## Academic Poster  

<p align="center">
  <img src="./FAD Screenshots/2146510_Poster.png" alt="Academic Poster" width="1000">
</p>

## Instructions for Setting Up and Running the Food Allergen Detection Application:

Follow these steps to set up and run the Food Allergen Detection mobile application:

1. Clone the repository:

 ```bash
   git clone https://github.com/ShakyaJU/Food_Allergen_Detection.git
  ```

2. Set up the Virtual Environment
   -Open Android Studio terminal
   -Navigate to the assets directory
 ```bash
   cd assets
 ```
   -Create and activate a vertual environment
```bash
   python -m venv venv
```
```bash
   venv\Scripts\activate
```
3. Start the Backend
   
 ```bash
   python main.py
  ```
  -If this is your first installation, you will be prompted to install necessary libraries. Install the required packages using command:
 ```bash
  pip install <necessary_package_name>
   ```
   -Once all packages are installed, re-run the backend with python main.py command.

4. Prepare your mobile device
   -Connect your mobile device to your computer using a USB data cable.
   -Enable USB Debugging on your mobile device.

5. Update the API URL on apiservice.dart file
    -Open command prompt (CMD) on your computer.
    -Run the following command to get your local IP address with command: ipconfig
    -Copy the IPv4 address.
    -Open the api_service.dart file in the project and replace the API URL with:
  ```bash
   [ipconfig](http://<Your-IPv4-Address>:8000)
   ```
   -Replace <Your-IPv4-Address> with the copied IPv4 address.

6. Install Dependencies:
 ```bash
   flutter pub get
 ```
7. Run the App:
 ```bash
   flutter run
   ```


## Requirements:

1. Flutter SDK 3.13.9
2. Dart SDK 3.1.5


## Project Structure:

<pre>
│Food-Allergen-Detection/
├── assets/                        # Folder for "backend-related" files (Python, model files, etc.)
│   ├── images/                    # Images of the testing outputs of the trained model.
│   ├── venv/                      # Virtual environment for Python dependencies
│   ├── model/                     # Folder for machine learning models
│   │   ├── final_model_after_additional_training.keras # Trained model------------> Trained Model (273MB)👉<a href="https://drive.google.com/file/d/1UfszdRCSBm7__OJUBeO5fEK0dMaapdnV/view?usp=sharing"> Download </a>
│   │   ├── class_indices.json     # Class-to-index mapping for predictions
│   │   ├── class_allergen_map.json # Mapping of classes to allergen info
│   ├── main.py                    # Python backend entry point (Flask API)
│   ├── routes.py                  # API routes (for prediction and home endpoints)
│   ├── model_utils.py             # Utility functions for loading model, preprocessing, etc.
│
├── frontend/                      # Folder for frontend-related files (Flutter app)
│   ├── lib/
│   │   ├── main.dart              # Main entry point for the Flutter app
│   │   ├── screens/
│   │   │   ├── home_screen.dart   # Main interface of the app
│   │   │   ├── upload_screen.dart # Screen for uploading and processing food images
│   │   │   ├── camera_screen.dart # Screen for capturing and processing food images in real-time
│   │   ├── services/
│   │   │   ├── api_service.dart   # API service for communicating with backend
│   ├── assets/                    # Flutter assets such as images and fonts
└── pubspec.yaml                   # Flutter project configuration file
</pre>


## Thesis Report
P.S. For a detailed and comprehensive overview of my thesis and the entire project—including research, methodology, implementation, model training, and literature findings, please access the full report by clicking this link:👉<a href="https://drive.google.com/file/d/1ySyLzoq-AHXGrASVhDfHyeHaIzmRi5i2/view?usp=sharing"> View Thesis Report </a>



