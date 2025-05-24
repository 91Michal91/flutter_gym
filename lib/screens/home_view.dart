import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/screens/profile_view.dart';
import 'package:flutter_application_1/screens/workout_detail.dart';
import 'package:flutter_application_1/screens/workout_plans.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    WorkoutPlans(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
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
}

class HomeContent extends StatelessWidget {
  final List<Category> catego = [
    Category(
      id: '1',
      imagUrl: "assets/images/emily.png",
      name: "Yoga exercises",
      description: "Relaxing yoga flow for all levels",
    ),
    Category(
      id: '2',
      imagUrl: "assets/images/sule.png",
      name: "Strength Training",
      description: "Build muscle with these exercises",
    ),
    Category(
      id: '3',
      imagUrl: "assets/images/alexsandra.png",
      name: "Cardio Blast",
      description: "High intensity cardio workout",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/image3.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Hey,",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userData.name,
                        style: TextStyle(
                          fontSize: 32,
                          color: Color(0xFF40D876),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileView(),
                        ),
                      );
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(
                          width: 3,
                          color: Color(0xFF40D876),
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
            // ... rest of your existing HomeView content ...
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: ListView.builder(
                  itemCount: catego.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutDetail(
                              workoutId: catego[index].id,
                              workoutName: catego[index].name,
                              imageUrl: catego[index].imagUrl,
                              description: catego[index].description,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            Container(
                              height: 172,
                              width: 141,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(catego[index].imagUrl),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              catego[index].name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Category {
  final String id;
  final String imagUrl;
  final String name;
  final String description;

  Category({
    required this.id,
    required this.imagUrl,
    required this.name,
    required this.description,
  });
}