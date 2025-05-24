import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'dart:async';

class WorkoutDetail extends StatefulWidget {
  final String workoutId;
  final String workoutName;
  final String imageUrl;
  final String description;
  final String workoutType;

  const WorkoutDetail({
    super.key,
    required this.workoutId,
    required this.workoutName,
    required this.imageUrl,
    required this.description,
    required this.workoutType,
  });

  @override
  State<WorkoutDetail> createState() => _WorkoutDetailState();
}

class _WorkoutDetailState extends State<WorkoutDetail> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isWorkoutActive = false;
  late int _secondsRemaining;
  late Timer _timer;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = _getInitialDuration();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
  }

  int _getInitialDuration() {
    switch (widget.workoutType.toLowerCase()) {
      case 'strength':
        return 45 * 60; // 45 minutes in seconds
      case 'cardio':
        return 20 * 60; // 20 minutes in seconds
      case 'yoga':
      default:
        return 30 * 60; // 30 minutes in seconds
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startWorkout() {
    final userData = Provider.of<UserData>(context, listen: false);
    userData.addWorkoutToHistory(widget.workoutId);

    setState(() {
      _isWorkoutActive = true;
      _secondsRemaining = _getInitialDuration();
    });

    _controller.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          _isWorkoutActive = false;
          _controller.stop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.workoutName} completed! Great job!'),
              backgroundColor: Colors.green[400],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      });
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalDuration = _getInitialDuration();
    final progress = _isWorkoutActive ? 1.0 - (_secondsRemaining / totalDuration) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutName),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: 'workout-${widget.workoutId}',
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: widget.imageUrl.startsWith('http')
                              ? NetworkImage(widget.imageUrl)
                              : AssetImage(widget.imageUrl) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.workoutName,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(
                            widget.workoutType.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: const Color(0xFF40D876),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.black87,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              'Duration: ${_formatDuration(totalDuration)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildWorkoutControls(progress, totalDuration),
        ],
      ),
    );
  }

  Widget _buildWorkoutControls(double progress, int totalDuration) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          if (_isWorkoutActive)
            Column(
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF40D876),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _formatDuration(_secondsRemaining),
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  color: const Color(0xFF40D876),
                  minHeight: 10,
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    _timer.cancel();
                    setState(() => _isWorkoutActive = false);
                    _controller.stop();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text('Cancel Workout'),
                ),
              ],
            )
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF40D876),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              onPressed: _startWorkout,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Start Workout',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}