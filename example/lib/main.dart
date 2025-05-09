import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as image_lib;
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String? fileName;
  List<Filter> filters = presetFiltersList;
  final picker = ImagePicker();
  File? imageFile;

  Future getImage(context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      fileName = basename(imageFile!.path);
      var image = image_lib.decodeImage(await imageFile!.readAsBytes())!;
      image = image_lib.copyResize(image, width: 600);
      Map? imagefile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => PhotoFilterSelector(
                title: Text("Photo Filter Example"),
                image: image,
                filters: presetFiltersList,
                filename: fileName ?? '',
                loader: Center(child: CircularProgressIndicator()),
                fit: BoxFit.contain,
              ),
        ),
      );

      if (imagefile != null && imagefile.containsKey('image_filtered')) {
        setState(() {
          imageFile = imagefile['image_filtered'];
        });
        if (kDebugMode) {
          print(imageFile!.path);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Filter Example')),
      body: Center(child: Container(child: imageFile == null ? const Center(child: Text('No image selected.')) : Image.file(File(imageFile!.path)))),
      floatingActionButton: FloatingActionButton(onPressed: () => getImage(context), tooltip: 'Pick Image', child: const Icon(Icons.add_a_photo)),
    );
  }
}
