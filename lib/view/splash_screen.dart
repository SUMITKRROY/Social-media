import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:post/view/start_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigater();
  }

  Future<void> _navigater() async {
    await Future.delayed(Duration(seconds: 3));
    // User is logged in, navigate to NewsRoom
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StartScreen()),
    );
  }
  // Future<void> _checkPermissionsAndNavigate() async {
  //   // List of required permissions based on the functionality of your app
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.camera, // Camera permission
  //     Permission.photos, // iOS gallery (Photos)
  //     Permission.storage, // Android gallery (Storage)
  //     Permission.location, // Location permission
  //   ].request();
  //
  //
  //   if (deniedPermissions.isEmpty) {
  //     // All required permissions are granted, navigate to MainScreen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => MainScreen()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Icon(
              Icons.photo_camera,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              "Photo Sharing App",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Center(
        child: Text("Welcome to the Photo Sharing App!"),
      ),
    );
  }
}
