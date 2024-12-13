import 'package:flutter/material.dart'; //Flutter framework for building UI.
import 'package:google_fonts/google_fonts.dart'; //Google fonts in the app.
import 'upload_screen.dart'; //Importing the Upload Screen for navigation.
import 'camera_screen.dart'; //Importing the Camera Screen for navigation.
import 'package:google_fonts/google_fonts.dart';

///A Stateless widget that serves as the home screen of the application.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; //Fetching the screen size for responsive design.
    return Scaffold(
      body: SafeArea(
        //Ensures content is displayed within safe area of screen.
        child: Container(
          height: size.height,//Full height of the screen.
          width: size.width,//Full width of the screen.
          decoration:
              const BoxDecoration(color: Colors.lightGreen // Background Colour
                  ),
          padding: const EdgeInsets.all(20.0),// Adds padding around the content.
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,// Center-aligns content horizontally.
            children: [
              Text(
                "Food Allergen Detection", // Title of the app.
                textAlign: TextAlign.center,
                style: GoogleFonts.actor(
                    textStyle: const TextStyle(
                  fontSize: 50.0, // Title font size.
                  fontWeight: FontWeight.bold, // Font style
                )),
              ),
              Container( //Spacer for adding vertical space.
                height: 200,
              ),
              //    Button for uploading an image.
              SizedBox(
                width: 220, // Button width.
                height: 50, //Button height.
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push( // Navigates to the Upload Screen when clicked.
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadScreen(),
                      )
                      ,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300] // Button Colour
                  ),
                  child: Text(
                    'Upload Image',
                    style: GoogleFonts.actor(
                        textStyle: const TextStyle(
                            fontSize: 20.0, // Font size
                            fontWeight: FontWeight.bold, //Font style
                            color: Colors.black87)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20, //Space between the buttons.
              ),
              SizedBox(         //Button for using the real-time camera feature.
                width: 220,// button width.
                height: 50,// button height.
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300] // Button Colour
                      ),
                  onPressed: () {
                    Navigator.push( //Navigates to the Camera Screen when clicked/tapped.
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CameraScreen()),
                    );
                  },
                  child: Text(
                    'Use Real-Time Camera',
                    style: GoogleFonts.actor(
                        textStyle: const TextStyle(
                            fontSize: 20.0, //Font size of button.
                            fontWeight: FontWeight.bold, //font style
                            color: Colors.black87)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
