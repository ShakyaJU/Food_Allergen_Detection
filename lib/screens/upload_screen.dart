import 'dart:convert'; // For encoding and decoding JSON and base64 data.
import 'dart:io'; // For file operations
import 'package:flutter/material.dart'; //Flutter framework for ui.
import 'package:google_fonts/google_fonts.dart'; // For using Google fonts.
import 'package:image_picker/image_picker.dart';//For picking images from gallery or camera.
import '../services/api_service.dart'; // Custom API service for backend communication.
import 'package:image/image.dart' as img; // FOr Image processing.

///A Stateful widget for the Upload Screen.
class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image; // Stores the selected image file.
  bool _isProcessing = false; // Indicates if prediction is in progress.
  String? _prediction; // Stores prediction result text.
  String? _allergen; // Stores detected allergen information.
  final ApiService _apiService =
      ApiService(); // API service for backend communication

  /// Function to pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Stores the selected image.
        _prediction = null; // Reset prediction when a new image is selected
        _allergen = null; // Reset allergen information
      });
    }
  }

  /// Function to predict the allergen from the uploaded image
  Future<void> _predictImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar( // Shows a snackbar if no image was selected.
        const SnackBar(content: Text("Please select an image first!")),
      );
      return;
    }

    setState(() {
      _isProcessing = true; // Indicate that processing has started.
    });

    try {
      final imageBytes = await _image!.readAsBytes(); // Read image bytes
      final decodedImage = img.decodeImage(imageBytes); // Decode the image.

      if (decodedImage != null) {
        // Converts the image to base64 string.
        final base64Image = base64Encode(imageBytes);
        final dataUrl = 'data:image/jpeg;base64,$base64Image';

        // Call the API service to predict the image.
        final response = await _apiService.predictImage({
          "image": dataUrl, // Sends the base64 image in the request payload
        });
        // Updates the UI with the prediction results.
        setState(() {
          _prediction = '''
       Description: ${response['description']}
       Predicted Class: ${response['prediction']}
       Allergen: ${response['allergen']}
          ''';
          _allergen = response['allergen']; // Stores allergen info
        });
      } else {
        //Handles failure to process the image.
        setState(() {
          _prediction = "Failed to process the image.";
        });
      }
    } catch (e) {
      //Handles the error during prediction.
      setState(() {
        _prediction = "Error during prediction: $e";
      });
    } finally {
      setState(() {
        _isProcessing = false; // Resets the processing indicator.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; // Get the screen size for responsive design.
    return Scaffold(
      body: SafeArea( //Ensures that the content stays within safe areas like notches.
        child: Container(
          height: size.height, //set container height to full screen.
          width: size.width,//container width to full screen.
          decoration:
              const BoxDecoration(color: Colors.lightGreen // Background Colour
                  ),
          padding: const EdgeInsets.all(20.0), //Adds padding around the content.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, //Center align content.
            children: [
              //Title of screen
              Text(
                "Upload Image",
                textAlign: TextAlign.center,
                style: GoogleFonts.actor(
                    textStyle: const TextStyle(
                  fontSize: 50.0, //Font size for title.
                  fontWeight: FontWeight.bold, //Font style.
                )),
              ),
              const SizedBox(height: 30,), //Adds vertical spacing.

              // Display the selected image if available.
              if (_image != null)
                AspectRatio(
                  aspectRatio: 1.0, // Maintains the aspect ratio.
                  child: Image.file(
                    _image!,   // Displays the selected image.
                    fit: BoxFit.cover, //Ensures that the image fits the container.
                  ),
                ),
              const SizedBox(
                height: 20, // Adds vertical spacing.
              ),

              // Shows prediction results if available.
              if (_prediction != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _prediction!, // Displays the prediction text.
                        style: const TextStyle(
                          fontSize: 16, //prediction text font size.
                          fontWeight: FontWeight.bold, //font style
                        ),
                        textAlign: TextAlign.center, //Center align text.
                      ),
                      // Display allergen information if available.
                      if (_allergen != null)
                        Text(
                          'Allergen Detected: $_allergen',
                          style: const TextStyle(
                            fontSize: 16, //font size
                            color: Colors.red,//red text
                            fontWeight: FontWeight.bold, //font style.
                          ),
                        ),
                    ],
                  ),
                ),
              // *************** Buttons for prediction and image selection**************
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center-align buttons.
                children: [
                  SizedBox(
                    width: 140, //button width
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _predictImage, // Disable if processing
                      child: _isProcessing
                          ? const CircularProgressIndicator( // Shows loading indicator if processing.
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'Predict',
                              style: GoogleFonts.actor(
                                  textStyle: const TextStyle(
                                      fontSize: 18.0, //font size
                                      fontWeight: FontWeight.bold, //font style
                                      color: Colors.black87)),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 40, // Add horizontal spacing.
                  ),
                  SizedBox(
                    width: 140, //Button width
                    child: ElevatedButton(
                      onPressed: _pickImage, // Opens the image picker when tapped/clicked.
                      child: Text('Select Image',
                          style: GoogleFonts.actor(
                              textStyle: const TextStyle(
                                  fontSize: 18.0, //font size
                                  fontWeight: FontWeight.bold, //font style
                                  color: Colors.black87))),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20), // Adds a vertical spacing.

              // Select image button
            ],
          ),
        ),
      ),
    );
  }
}
