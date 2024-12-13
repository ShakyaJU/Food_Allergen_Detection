import 'package:flutter/material.dart';//Importing the flutter package for UI components.
import 'screens/home_screen.dart';//Imports HomeScreen from the screens directory.
//Entry point of the flutter application.
void main() {
  runApp(const FoodAllergenApp());//Runs the app.
}
//The main app widget defining the overall structure and theme.
class FoodAllergenApp extends StatelessWidget {
  const FoodAllergenApp({super.key}); //Constructor for app with a constant key.

  @override
  Widget build(BuildContext context) {
    return MaterialApp( //Builds a MaterialApp which serves as the foundation for app.
      debugShowCheckedModeBanner: false,//Disables the debug banner in the top right corner.
      title: 'Food Allergen Detection',//Title of the app.
      theme: ThemeData(primarySwatch: Colors.blueGrey),//Defines app color theme.
      home: const HomeScreen(),//Sets HomeScreen widget as default landing page.
    );
  }
}
