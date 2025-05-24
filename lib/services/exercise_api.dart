import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseAPI {
  static const _baseUrl = 'api.api-ninjas.com';
  static const _apiKey = 'YOUR_API_KEY'; // Replace with your key

  static Future<List<dynamic>> fetchExercises({String? muscle}) async {
    final query = {'muscle': muscle};
    final uri = Uri.https(_baseUrl, '/v1/exercises', query);
    
    final response = await http.get(uri, headers: {
      'X-Api-Key': _apiKey,
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load exercises: ${response.statusCode}');
    }
  }
}