import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
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
      imageFile = new File(pickedFile.path);
      fileName = basename(imageFile!.path);
      var image = imageLib.decodeImage(await imageFile!.readAsBytes())!;
      image = imageLib.copyResize(image, width: 600);
      Map? imagefile = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new PhotoFilterSelector(
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
        print(imageFile!.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Filter Example'),
      ),
      body: Center(
        child: Container(
          child: imageFile == null
              ? const Center(
                  child: Text('No image selected.'),
                )
              : Image.file(new File(imageFile!.path)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getImage(context),
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
