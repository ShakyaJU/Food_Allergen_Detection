import 'dart:convert';// For JSON encoding and decoding.
import 'package:http/http.dart' as http;//Making HTTP request.
///Service class for interacting with the backend API.
class ApiService {
  final String _baseUrl = 'http://192.168.0.105:8000/api'; //Base URL for backend server.
                                                           //Replaced with actual server address
  ///Method to send prediction request to the backend API.
  Future<Map<String, dynamic>> predictImage(Map<String, dynamic> payload) async {
    try {
      // Sending a POST request to the '/predict' endpoint of the API.
      final response = await http.post(
        Uri.parse('$_baseUrl/predict'),//Constructs full URI for endpoint.
        headers: {'Content-Type': 'application/json'},//Sets content type to JSON.
        body: json.encode(payload), // Converts payload map to JSON string
      );
      if (response.statusCode == 200) { //Checks if response status code indicates success (HTTP 200).
        return json.decode(response.body); // Return the parsed response as a map
      } else {
        throw Exception('Failed to make prediction'); //Throws exception for non-successful responses.
      }
    } catch (e) { //Catch and throw exceptions that occur during the API call.
      throw Exception('Error during API call: $e');
    }
  }
}
