import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/screens/profile_view.dart';
import 'package:flutter_application_1/screens/workout_detail.dart';
import 'package:flutter_application_1/screens/workout_plans.dart';
import 'dart:convert';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  List<dynamic> _apiExercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/exercises?muscle=biceps'),
        headers: {'X-Api-Key': '3huzm+WQcZu6SntAV5C3kw==Q3TtPmnNiaJ6aoMU'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _apiExercises = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading exercises: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 
          ? _buildHomeWithApiContent()
          : _currentIndex == 1
              ? WorkoutPlans()
              : ProfileView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color(0xFF40D876),
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildHomeWithApiContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/image3.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          // Header with user profile
          Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
            child: Consumer<UserData>(
              builder: (context, userData, child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Hey,",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userData.name,
                        style: const TextStyle(
                          fontSize: 32,
                          color: Color(0xFF40D876),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileView()),
                    ),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          width: 3,
                          color: const Color(0xFF40D876),
                        ),
                        image: DecorationImage(
                          image: AssetImage(userData.profileImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // Exercises List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF40D876),
                    ),
                  )
                : _apiExercises.isEmpty
                    ? const Center(
                        child: Text(
                          "No exercises found",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _apiExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = _apiExercises[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            color: Colors.white.withOpacity(0.8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: const Icon(
                                Icons.fitness_center,
                                color: Color(0xFF40D876),
                              ),
                              title: Text(
                                exercise['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Muscle: ${exercise['muscle']}'),
                                  Text('Type: ${exercise['type']}'),
                                  Text('Equipment: ${exercise['equipment']}'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutDetail(
                                      workoutId: index.toString(),
                                      workoutName: exercise['name'],
                                      imageUrl: "assets/images/default_exercise.png",
                                      description: exercise['instructions'] ?? 'No instructions available',
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}