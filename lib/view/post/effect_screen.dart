import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post/view/post/post_detail_screen.dart';

class EffectScreen extends StatefulWidget {
  final List<XFile> images;

  EffectScreen({required this.images});

  @override
  _EffectScreenState createState() => _EffectScreenState();
}

class _EffectScreenState extends State<EffectScreen> {
  PageController _pageController = PageController();
  int selectedFilterIndex = 0;
  int currentImageIndex = 0; // Track the current image index
  File? _image;


  final List<Map<String, dynamic>> filters = [
    {'name': 'Original', 'color': Colors.transparent}, // Original
    {'name': 'Red Tint', 'color': Colors.red.withOpacity(0.2)},
    {'name': 'Green Tint', 'color': Colors.green.withOpacity(0.2)},
    {'name': 'Blue Tint', 'color': Colors.blue.withOpacity(0.2)},
    {'name': 'Yellow Tint', 'color': Colors.yellow.withOpacity(0.2)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply Effects"),
        actions: [
          IconButton(
              onPressed: () {
                // _imgFromGallery();
              },
              icon: Icon(Icons.insert_photo_outlined))
        ],
      ),
      body: Column(
        children: [
          // Full-screen image display
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.2), width: 3), // Add border
                borderRadius: BorderRadius.circular(12.r), // Rounded corners
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() {
                    selectedFilterIndex = 0; // Reset filter when image changes
                    currentImageIndex = index; // Update current image index
                  });
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showFullScreenImage(context);
                    },
                    child: Stack(
                      children: [
                        Image.file(
                          File(widget.images[index].path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        if (filters[selectedFilterIndex]['color'] != Colors.transparent)
                          Container(
                            color: filters[selectedFilterIndex]['color'],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          // Image size indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
                  (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 5),
                height: 8,
                width: currentImageIndex == index ? 16 : 8, // Highlight current image
                decoration: BoxDecoration(
                  color: currentImageIndex == index ? Colors.purple : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          // Filter selection
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(filters.length, (index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilterIndex = index;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: filters[index]['color'] == Colors.transparent
                          ? Colors.grey // Original image placeholder
                          : filters[index]['color'],
                      radius: 30.r,
                      child: selectedFilterIndex == index
                          ? Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    filters[index]['name'],
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: 20),
          // Next button
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                if (widget.images.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailsScreen(
                        images: widget.images,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No image selected!")),
                  );
                }
              },
              child: Text("Next"),
            ),
          ),
        ],
      ),
    );
  }


  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(
          imagePath: widget.images[currentImageIndex].path,
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(

          onTap: () {
            Navigator.pop(context);

        },
        child: Center(
          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }
}
