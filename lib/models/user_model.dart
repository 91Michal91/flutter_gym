import 'package:flutter/foundation.dart'; 
class UserData with ChangeNotifier {
  String _name = 'Zezo';
  String _email = '';
  String _fitnessLevel = 'Beginner';
  String _profileImage = 'assets/images/emely.jpg';
  List<String> _workoutHistory = [];
  
  String get name => _name;
  String get email => _email;
  String get fitnessLevel => _fitnessLevel;
  String get profileImage => _profileImage;
  List<String> get workoutHistory => _workoutHistory;
  
  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }
  
  void updateFitnessLevel(String level) {
    _fitnessLevel = level;
    notifyListeners();
  }
  
  void updateProfileImage(String imagePath) {
    _profileImage = imagePath;
    notifyListeners();
  }
  
  void addWorkoutToHistory(String workoutId) {
    _workoutHistory.add(workoutId);
    notifyListeners();
  }
}