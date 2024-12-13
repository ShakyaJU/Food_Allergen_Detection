import 'dart:convert'; // For encoding/decoding base64 and JSON data.
import 'dart:io'; // For file-related operations.
import 'package:flutter/material.dart'; // Flutter framework for UI design
import 'package:camera/camera.dart'; // Camera package for capturing images.
import 'package:google_fonts/google_fonts.dart'; // For custom fonts.
import 'package:image/image.dart' as img; // For image processing purpose.
import '../services/api_service.dart'; // Import ApiService for backend communication.

/// Camera screen to capture images from the camera and sent them for prediction.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController; //Controller to manage the camera.
  bool _isCameraInitialized = false; // Tracks whether the camera is initialized or not.
  bool _isProcessing = false; // Indicates if the prediction is in progress.
  String? _prediction; // Stores prediction results.
  String? _allergen; // Stores allergen information from predictions.
  final ApiService _apiService = ApiService(); // Initialize the API service

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Initialize the camera when the screen loads.

  }

  // **********Function to initialize camera***********
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras(); // Retrieve available camera
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0], // Use available camera
          ResolutionPreset.medium, //Set resolution for camera preview.
        );
        await _cameraController.initialize(); // Initialize the camera
        setState(() {
          _isCameraInitialized = true; // Mark camera as initialized.
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar( //Shows snackbar if no cameras available
          const SnackBar(content: Text("No cameras found!")),
        );
      }
    } catch (e) { //Handles initialization error.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error initializing camera: $e")),
      );
    }
  }

  /// Capture image using the camera and sends it to the backend for prediction.
  Future<void> _captureAndPredict() async {
    if (_isProcessing) return; // Prevent multiple predictions simultaneously

    setState(() {
      _isProcessing = true; // Mark prediction as in progress.

    });

    try {
      // Capture an image
      final image = await _cameraController.takePicture();
      final imageBytes = await image.readAsBytes(); // Get the image bytes

      // Optionally process the image (e.g., resize) using the `image` package
      final decodedImage = img.decodeImage(imageBytes);

      if (decodedImage != null) {
        // Encode the image to base64 string.
        final base64Image = base64Encode(imageBytes);

        // Create a data URL like 'data:image/jpeg;base64,...'
        final dataUrl = 'data:image/jpeg;base64,$base64Image';

        // Send the base64-encoded image to the Flask API for prediction
        final response = await _apiService.predictImage({
          "image": dataUrl, // Send the data URL string as the image payload
        });

        // Update the UI with the response
        setState(() {
          _prediction = '''
            Description: ${response['description']}
            Predicted Class: ${response['prediction']}
            Allergen: ${response['allergen']}
          ''';
          _allergen = response['allergen']; // Save allergen information.
        });
      } else { //If image processing fails, update the UI.
        setState(() {
          _prediction = "Failed to process the image.";
        });
      }
    } catch (e) { // Handle prediction errors.
      setState(() {
        _prediction = "Error during prediction: $e";
      });
    } finally {
      setState(() {
        _isProcessing = false; //Reset the processing flag.
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose(); // Dispose the camera controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; // Get screen size for responsive layout.
    return Scaffold(
      body: SafeArea(
        child:Container( // Ensures UI alligns system YI areas like notches.
          height: size.height, //screen height
          width: size.width,// screen width
          decoration: const BoxDecoration(
              color: Colors.lightGreen  // Background Colour
          ),
          padding: const EdgeInsets.all(20.0), // Adds padding to the container
        child: _isCameraInitialized
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,  //Center align content.
          children: [
            Text("Real Time Camera", //Screen title
              textAlign: TextAlign.center,
              style: GoogleFonts.actor(
                  textStyle: const TextStyle(fontSize: 50.0, //Font size.
                    fontWeight: FontWeight.bold,)
              ),),
            SizedBox(
              height: 100, // Add verticle spacing.
            ),
            AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio, // Match camera's aspect ratio.
              child: CameraPreview(_cameraController), // Camera preview shows it in live feed.
            ),
            const SizedBox(height: 20), // Add vertical spacing.
            if (_prediction != null) // Display prediction results if available.
              Padding(
                padding: const EdgeInsets.all(16.0), // adds padding around text.
                child: Text(
                  _prediction!, // Display prediction text.
                  style: const TextStyle(
                    fontSize: 16, // Font siez for prediction text.
                    fontWeight: FontWeight.bold, // Font style.
                  ),
                  textAlign: TextAlign.center, // Center align text.
                ),
              ),
            // Display the allergen information if available.
            if (_allergen != null)
            Text(
              'Allergen Detected: $_allergen',
              style: const TextStyle(
                fontSize: 16, // Font size for allergen text
                color: Colors.red, // Red color emphasis.
                fontWeight: FontWeight.bold, //font style.
              ),
            ),
            ElevatedButton(  //Capture and predict button.
              style:  ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300] // Button Colour
              ),
              onPressed: _isProcessing ? null : _captureAndPredict, // Disables the button if processing.
              child: _isProcessing
                  ? const CircularProgressIndicator( // Loading sign
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,  //Shows the loading sign if processing.
                ),
              )
                  :   Text('Capture and Predict',
                style: GoogleFonts.actor(fontSize: 20.0, //Font size
                fontWeight: FontWeight.bold,color: Colors.black87), //Font style and color.
              ),
            ),
            const SizedBox(height: 20), //Add vertical spacing.

          ],

        )
            : const CircularProgressIndicator(), // shows loading spinner if camera is not initialized.
      ),
      ),
    );
  }
}
