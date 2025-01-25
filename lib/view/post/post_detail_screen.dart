import 'dart:io';
import 'dart:developer' as developer;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:post/view/home_screen.dart';

import '../utils/utils.dart';

class PostDetailsScreen extends StatefulWidget {
  final List<XFile> images;// Paths of the selected images

  PostDetailsScreen({required this.images});

  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  var latitude, longitude, nostotoken = '';
  final TextEditingController _captionController = TextEditingController();
  int _currentPage = 0;
  String _currentAddress = "Current Address"; // Default text for the address

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
    Utils.latitude = position.latitude;
    Utils.longitude = position.longitude;
    developer.log('latitude :: ${position.latitude}');
    developer.log("longitude :: ${position.longitude}");
    _getAddress();
  }

  Future<void> _getAddress() async {
    try {
      if (latitude != null && longitude != null) {
        List<Placemark> placemarks = await GeocodingPlatform.instance
            !.placemarkFromCoordinates(latitude!, longitude!);
        Placemark place = placemarks[0];
        String currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        setState(() {
          _currentAddress = currentAddress; // Update the current address
        });
Utils.currentAddress = currentAddress;
        Utils.loaction = place.country!;
        developer.log(currentAddress);
      } else {
        print('Latitude or longitude is null');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Details"),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                child: PageView.builder(
                  itemCount: widget.images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(widget.images[index].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.images.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.purple
                            : Colors.grey,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  hintText: "Write a caption...",
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              // Location Tagging
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.purple),

                title: _currentAddress.isEmpty
               ? TextButton(onPressed: () { getLocation(); },
               child: Text("Add Location"))
               : Text(_currentAddress), // Show current address
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () async {
                  // When tapped, show the current location as selected address
                  String? selectedAddress = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select Address'),
                        content: Text('Current address: $_currentAddress'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(_currentAddress); // Return the current address
                            },
                            child: Text('Select'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(null); // Close the dialog without selection
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );

                  if (selectedAddress != null) {
                    setState(() {
                      _currentAddress = selectedAddress; // Update the address
                    });
                  }
                },
              ),
              Divider(),
              // Tag People
              ListTile(
                leading: Icon(Icons.person_add, color: Colors.purple),
                title: Text("Tag People"),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  print("Tag People tapped");
                },
              ),
              Divider(),
              // Add Music
              ListTile(
                leading: Icon(Icons.music_note, color: Colors.purple),
                title: Text("Add Music"),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  print("Add Music tapped");
                },
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(images: widget.images, caption: _captionController.text,)));
                }, child: Text("Share")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
