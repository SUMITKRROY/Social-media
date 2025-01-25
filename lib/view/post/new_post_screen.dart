import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:post/view/post/post_detail_screen.dart';

import 'effect_screen.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  File? _image;
  final imagePicker = ImagePicker();
  var selfiImgBase64 = '';
  String? selectedValue;
  List<String> items = ['Resent', 'Image', 'Video'];
  List<XFile> galleryImages = [];
  List<AssetEntity> _galleryImages = [];
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _imgFromGallery();
    //_fetchGalleryImages();
  }
  Future<void> _fetchGalleryImages() async {
    // Request permissions
    final permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      // Fetch gallery images
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      if (albums.isNotEmpty) {
        List<AssetEntity> images = await albums[0].getAssetListRange(
          start: 0,
          end: 100, // Fetch up to 100 images
        );
        setState(() {
          _galleryImages = images;
          _loading = false;
        });
      }
    } else {
      print("permission $permission");
      //PhotoManager.openSetting();
    }
  }

  Future<bool> _handleCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
    return status.isGranted;
  }

  Future<bool> _handleGalleryPermission() async {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      await Permission.photos.request();
    }
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("New Post"),
        actions: [
          TextButton(
            onPressed: () {
              if (galleryImages.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailsScreen(
                      images: galleryImages,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("No image selected!")),
                );
              }
            },
            child: Text("Next", style: TextStyle(color: Colors.white)),
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _imgFromCamera();
                    },
                    child: const SizedBox(
                      width: 60,
                      child: Wrap(
                        children: [
                          SizedBox(
                              width: 50,
                              child: Icon(Icons.camera_alt_outlined)),
                          Text('Camera')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: () {
                      if (galleryImages.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EffectScreen(images: galleryImages),
                          ),
                        );
                      }
                    },
                    child: SizedBox(
                      width: 70,
                      child: Wrap(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Icon(Icons.auto_awesome),
                          ),
                          const Text('Effect')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          SizedBox(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                'Resent',
                style: TextStyle(color: Colors.black),
              ),
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              isExpanded: false,

              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
            ),
          ),
          IconButton(onPressed: (){
            _imgFromGallery();
          }, icon: Icon(Icons.file_copy))
        ],
      ),

            // Display the gallery images in a grid
            Expanded(
              child: galleryImages.isNotEmpty
                  ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: galleryImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _image = File(galleryImages[index].path);
                      });
                    },
                    child: Image.file(
                      File(galleryImages[index].path),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              )
                  : Center(child: Text("No images selected")),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // Handle Post action
              },
              child: Text("Post", style: TextStyle(color: Colors.purple)),
            ),
            TextButton(
              onPressed: () {
                // Handle Reel action
              },
              child: Text("Reel", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  _imgFromCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        // Add the camera image to the galleryImages list
        galleryImages.add(XFile(image.path));

        // Convert the camera image to Base64 if needed
        final bytes = File(image.path).readAsBytesSync();
        selfiImgBase64 = base64Encode(bytes);
      });
    }
  }

  _imgFromGallery() async {
    // Get the gallery images
    final pickedFiles = await imagePicker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        // Add the selected gallery images to the galleryImages list
        galleryImages.addAll(pickedFiles);
      });
    }
  }



}
