import 'package:flutter/material.dart';
import 'post/new_post_screen.dart'; // Navigate to after tapping start

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: Text("Start"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPostScreen()),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}