import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/user_model.dart';

class WorkoutDetail extends StatelessWidget {
  final String workoutId;
  final String workoutName;
  final String imageUrl;
  final String description;

  const WorkoutDetail({
    super.key,
    required this.workoutId,
    required this.workoutName,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutName),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              // Add to favorites functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workoutName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF40D876),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40, 
                          vertical: 16,
                        ),
                      ),
                      onPressed: () {
                        userData.addWorkoutToHistory(workoutId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Workout started!')),
                        );
                      },
                      child: const Text(
                        'Start Workout',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}