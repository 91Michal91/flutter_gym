import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/workout_detail.dart';

class WorkoutPlans extends StatelessWidget {
  static const List<Map<String, dynamic>> workouts = [
    {
      'id': '1',
      'name': 'Morning Yoga Flow',
      'image': 'assets/images/emily.png',
      'description': 'A gentle 30-minute yoga sequence to start your day with energy and focus.',
      'duration': '30 min',
      'level': 'Beginner',
      'type': 'yoga', // Added workout type
    },
    {
      'id': '2',
      'name': 'Full Body Strength',
      'image': 'assets/images/sule.png',
      'description': 'Build strength with this comprehensive full-body workout using bodyweight exercises.',
      'duration': '45 min',
      'level': 'Intermediate',
      'type': 'strength', // Added workout type
    },
    {
      'id': '3',
      'name': 'HIIT Cardio Blast',
      'image': 'assets/images/alexsandra.png',
      'description': 'High-intensity interval training to boost your metabolism and burn calories.',
      'duration': '20 min',
      'level': 'Advanced',
      'type': 'cardio', // Added workout type
    },
  ];

  const WorkoutPlans({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plans'),
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(workout['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(workout['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('${workout['duration']} • ${workout['level']}'),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutDetail(
                      workoutId: workout['id'],
                      workoutName: workout['name'],
                      imageUrl: workout['image'],
                      description: workout['description'],
                      workoutType: workout['type'], // Added workout type parameter
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}